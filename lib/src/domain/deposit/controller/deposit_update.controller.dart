
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit.repository.dart';
import 'package:hanigold_admin/src/config/repository/wallet.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/deposit_request_getOne.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/bank.repository.dart';
import '../../../config/repository/bank_account.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../users/model/balance_item.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../../withdraw/controller/withdraw.controller.dart';
import '../../withdraw/model/bank.model.dart';
import '../../withdraw/model/bank_account.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/bank_account_req.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/predicate.model.dart';

enum PageState{loading,err,empty,list}

class DepositUpdateController extends GetxController{

  final WithdrawController withdrawController=WithdrawController();
  final DepositController depositController=Get.find<DepositController>();
  final DepositRequestGetOneController depositRequestGetOneController=Get.find<DepositRequestGetOneController>();

  final TextEditingController ownerNameController=TextEditingController();
  final TextEditingController accountController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
  final TextEditingController numberController=TextEditingController();
  final TextEditingController cardNumberController=TextEditingController();
  final TextEditingController shebaController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController trackingNumberController=TextEditingController();

  final DepositRepository depositRepository=DepositRepository();
  final BankRepository bankRepository=BankRepository();
  final BankAccountRepository bankAccountRepository=BankAccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();

  final RxList<BankModel> bankList=<BankModel>[].obs;
  final RxList<BankAccountModel> bankAccountList=<BankAccountModel>[].obs;
  WalletModel? walletList;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;

  final RxInt statusId=0.obs;
  var depositId=0.obs;
  var depositRequests=0.obs;
  final Rxn<DepositModel> getOneDeposit = Rxn<DepositModel>();
  var walletWithdrawId=0.obs;


  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  final Rxn<DepositModel> deposit = Rxn<DepositModel>();
  //final Rxn<DepositRequestModel> depositRequests=Rxn<DepositRequestModel>();
  final Rxn<BankAccountModel> selectedBankAccount = Rxn<BankAccountModel>();
  final Rxn<BankModel> selectedBank = Rxn<BankModel>();
  Rx<int> selectedWalletId = Rx<int>(0);
  String? selectedIndex ;
  Rx<int> selectedBankId = Rx<int>(0);
  Rx<String> selectedBankName = Rx<String>("");


  /*changeSelectedBank(String newValue){
    selectedIndex=newValue;
    selectedBankId.value=int.parse(newValue);
    for(int i=0 ;i<bankList.length;i++){
      if(selectedBankId.value==bankList[i].id){
        selectedBankName.value=bankList[i].name ?? "";
      }
    }
    update();
    print(selectedBankName.value);
    print( selectedBankId.value);
  }*/

  /*void changeSelectedBankAccount(BankAccountModel? newValue) {
    selectedBankAccount.value = newValue;
    selectedIndex=selectedBankAccount.value?.bank?.id.toString();
    ownerNameController.text=selectedBankAccount.value!.ownerName.toString();

    selectedBankAccount.value!.number==null ? "" :
    numberController.text=selectedBankAccount.value!.number.toString();

    selectedBankAccount.value!.cardNumber==null ? "" :
    cardNumberController.text=selectedBankAccount.value!.cardNumber.toString();

    selectedBankAccount.value!.sheba==null ? "" :
    shebaController.text=selectedBankAccount.value!.sheba.toString();


    print(selectedBankAccount.value?.bank?.name);
    print(selectedBankAccount.value?.bank?.id);
    print(selectedIndex);
  }*/

  @override
  void onInit() async{
      depositId.value=int.parse(Get.parameters["id"]!);
      print("deposssssssssit : ${depositId.value}");
      await fetchGetOneDeposit(depositId.value);
      if(getOneDeposit.value!=null){
        final deposit=getOneDeposit.value;
        setDepositDetail(deposit!);
        if(deposit.wallet?.account?.id!=null) {
          accountController.text=deposit.wallet?.account?.name ?? "";
          await fetchWallet(deposit.wallet!.account!.id!);
          await getBalanceList(deposit.wallet!.account!.id!);
          /*await getBankAccount(deposit.wallet!.account!.id!);
          await fetchBankAccountList();

          if (deposit.bankAccount != null) {
            var matchingAccount = bankAccountList.firstWhere(
                  (account) => account.id == deposit.bankAccount!.id,
            );
            if (matchingAccount.id != null) {
              selectedBankAccount.value = matchingAccount;
            }
          }*/
        }
      }
    //await fetchBankList();
    super.onInit();
  }

  //لیست بانک ها
  Future<void> fetchBankList() async{
    try{
      state.value=PageState.loading;
      var fetchedBankList=await bankRepository.getBankList();
      bankList.assignAll(fetchedBankList);
      state.value=PageState.list;
      if(bankList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  // مدل آپشن بانک اکانت
  BankAccountReqModel? bankAccountReqModel;
  getBankAccount(int id){
    bankAccountReqModel=BankAccountReqModel(
        bankAccount: OptionsModel(
            orderBy: "BankAccount.Id",
            orderByType: "desc",
            startIndex: 1,
            toIndex: 1000,
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: "AccountId",
                    filterValue: id.toString(),
                    filterType: 4,
                    refTable: "BankAccount"
                )
                ]
            )
            ]
        )
    );
    fetchBankAccountList();
  }


  // لیست بانک اکانت
  Future<void> fetchBankAccountList()async{
    try{
      state.value=PageState.loading;
      var fetchedBankAccountList=await bankAccountRepository.getBankAccountList(bankAccountReqModel!);
      bankAccountList.assignAll(fetchedBankAccountList);
      state.value=PageState.list;
      if(bankAccountList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=e.toString();
    }
  }

  Future<void> fetchWallet(int id)async{
    try{
      isLoading.value=true;
      var fetchedWalletList=await walletRepository.getWalletCurrency(id);
      walletList=fetchedWalletList as WalletModel?;
      if (walletList!=null) {
        selectedWalletId.value = walletList?.id ?? 0;
      }
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
  }

  Future<DepositModel?> fetchGetOneDeposit(int id)async{
    try {
      state.value=PageState.loading;
      var fetchedGetOne = await depositRepository.getOneDeposit(id);

      if (fetchedGetOne != null) {
        setDepositDetail(fetchedGetOne);
        getOneDeposit.value = fetchedGetOne;
        //await fetchBankAccountList();
      }
        state.value=PageState.list;
        state.value=PageState.empty;
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }return null;
  }

  Future<DepositModel?> updateDeposit()async{
    try{
      isLoading.value=true;
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      var response=await depositRepository.updateDeposit(
        walletWithdrawId: walletWithdrawId.value,
        depositId: depositId.value,
          walletId: selectedWalletId.value,
          depositRequestId: depositRequests.value,
          //bankAccountId: selectedBankAccount.value?.id ?? 0,
          amount: double.parse(amountController.text.replaceAll(',', '').toEnglishDigit()),
          accountId: deposit.value?.wallet?.account?.id ?? 0,
          accountName: deposit.value?.wallet?.account?.name ?? "",
          // bankId: selectedBankId.value,
          // bankName: selectedBankName.value,
          // ownerName: ownerNameController.text,
          // number: numberController.text,
          // cardNumber: cardNumberController.text,
          // sheba: shebaController.text,
          date: gregorianDate,
          status: statusId.value,
          trackingNumber: trackingNumberController.text,
      );

      if(response!=null) {
        Get.back();
        Get.snackbar(response.infos?.first.title?? "", response.infos?.first.description ?? "",
            titleText: Text(response.infos?.first.title?? "",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                response.infos?.first.description ?? "", textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        depositRequestGetOneController.fetchGetOneDepositRequest(depositId.value);
        depositController.fetchDepositList();
        balanceList.clear();
      }

      //Get.offNamed('/depositList');
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
    return null;
  }

  void setDepositDetail(DepositModel deposit){
    print(' بانک اکانت:${deposit.bankAccount?.id}');
    print(' اکانت:${deposit.wallet!.account!.id!}');
    walletWithdrawId.value=deposit.walletWithdraw?.id ?? 0;
    depositId.value=deposit.id ?? 0;
    selectedWalletId.value=deposit.wallet?.id ?? 0;
    depositRequests.value=deposit.depositRequest?.id ?? 0;
    amountController.text=deposit.amount.toString().seRagham(separator:  ',') ?? '';
    // ownerNameController.text=deposit.bankAccount?.ownerName ?? '';
    // numberController.text=deposit.bankAccount?.number.toString() ?? '';
    // cardNumberController.text=deposit.bankAccount?.cardNumber.toString() ?? '';
    // shebaController.text=deposit.bankAccount?.sheba.toString() ?? '';
    dateController.text=deposit.date?.toPersianDate(showTime: true,digitType: NumStrLanguage.English) ?? '';
    accountController.text=deposit.wallet?.account?.name ?? '';
    trackingNumberController.text=deposit.trackingNumber ?? '';
    statusId.value=deposit.status ?? 0;

    /*if(deposit.wallet?.account!=null){
      if (deposit.bankAccount != null) {
        final bankAccountMatch = bankAccountList.firstWhereOrNull(
              (b) => b.id == deposit.bankAccount?.id,
        );
        if (bankAccountMatch != null) {
          selectedBankAccount.value = bankAccountMatch;
        }
      }
    }*/
    /*if (deposit.bankAccount?.bank != null) {
      selectedBankId.value = deposit.bankAccount?.bank?.id ?? 0;
      selectedBankName.value = deposit.bankAccount?.bank?.name ?? '';
      selectedIndex = deposit.bankAccount?.bank?.id.toString();
    }else{
      selectedIndex=null;
    }*/
  }

  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    balanceList.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      isLoadingBalance.value=true;
      state.value=PageState.list;
      if(balanceList.isEmpty){
        state.value=PageState.empty;
      }
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

  void clearList(){
    accountController.clear();
    ownerNameController.clear();
    amountController.clear();
    numberController.clear();
    cardNumberController.clear();
    shebaController.clear();
    bankAccountList.clear();
    bankList.clear();
    dateController.clear();
    selectedBankAccount.value=null;

  }

}
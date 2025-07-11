
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/bank.repository.dart';
import '../../../config/repository/bank_account.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../config/repository/wallet.repository.dart';
import '../../../config/repository/withdraw.repository.dart';
import '../../../config/repository/withdraw_getOne.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account.model.dart';
import '../../users/model/balance_item.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../model/bank.model.dart';
import '../model/bank_account.model.dart';
import '../model/bank_account_req.model.dart';
import '../model/filter.model.dart';
import '../model/options.model.dart';
import '../model/predicate.model.dart';

enum PageState{loading,err,empty,list}
class WithdrawUpdateController extends GetxController{

  final WithdrawController withdrawController=Get.find<WithdrawController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController ownerNameController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
  final TextEditingController numberController=TextEditingController();
  final TextEditingController cardNumberController=TextEditingController();
  final TextEditingController shebaController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController dateController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final BankRepository bankRepository=BankRepository();
  final BankAccountRepository bankAccountRepository=BankAccountRepository();
  final WithdrawRepository withdrawRepository=WithdrawRepository();
  final WalletRepository walletRepository=WalletRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final WithdrawGetOneRepository withdrawGetOneRepository=WithdrawGetOneRepository();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<BankModel> bankList=<BankModel>[].obs;
  final List<BankAccountModel> bankAccountList=<BankAccountModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  WalletModel? walletList;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<BankAccountModel> selectedBankAccount = Rxn<BankAccountModel>();
  final Rxn<BankModel> selectedBank = Rxn<BankModel>();
  Rx<int> selectedWalletId = Rx<int>(0);
  String? selectedIndex ;
  Rx<int> selectedBankId = Rx<int>(0);
  Rx<String> selectedBankName = Rx<String>("");
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;

  final RxInt withdrawId=0.obs;
  final RxInt statusId=0.obs;
  final Rxn<WithdrawModel> getOneWithdraw = Rxn<WithdrawModel>();

  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;

    if (newValue != null) {
      //getBankAccount(newValue.id ?? 0);
      fetchWallet(newValue.id ?? 0);
    } else {
      //bankAccountList.clear();
      selectedWalletId.value = 0;
    }
    getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
    debounce?.cancel();
    update();
  }

  changeSelectedBank(String newValue){
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
  }

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

  late WithdrawModel? existingWithdraw;

  @override
  void onInit() async {
    searchController.addListener(onSearchChanged);
    fetchBankList();
    withdrawId.value=int.parse(Get.parameters['id']!);
    await fetchGetOneWithdraw(withdrawId.value);
    if(getOneWithdraw.value!=null){
      existingWithdraw=getOneWithdraw.value;
      setWithdrawDetails(existingWithdraw!);
      if(existingWithdraw?.wallet?.account!=null){
        accountList.add(existingWithdraw!.wallet!.account!);
        searchedAccounts.add(existingWithdraw!.wallet!.account!);
        getBalanceList(existingWithdraw?.wallet?.account?.id ?? 0);
        selectedWalletId.value=existingWithdraw!.wallet!.id!;
      }
    }
    fetchAccountList();
    super.onInit();
  }

  @override
  void onClose() {
    debounce?.cancel();
    searchController.removeListener(onSearchChanged);
    //searchController.dispose();
    super.onClose();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList("");
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);

      state.value = accountList.isEmpty ? PageState.empty : PageState.list;
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  void onSearchChanged(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(seconds: 4), () async {
      await searchAccountList(searchController.text.trim());

    });
  }

  Future<void> searchAccountList(String name) async {
    try {
      isLoading.value = true;
      if (name.length>2) {
        searchedAccounts.assignAll(accountList);
      } else {
        final results = await accountRepository.searchAccountList(name,"");
        searchedAccounts.assignAll(results);
        state.value=PageState.list;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی کاربران');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGetOneWithdraw(int id)async{
    try {
      state.value=PageState.loading;
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      var fetchedGetOne = await withdrawGetOneRepository.getOneWithdraw(id);
      if(fetchedGetOne!=null){
        getOneWithdraw.value = fetchedGetOne;
        selectedAccount.value=getOneWithdraw.value?.wallet?.account;
        state.value=PageState.list;
        //EasyLoading.dismiss();
      }else{
        state.value=PageState.empty;
      }
      /*if(getOneWithdraw.value==null){
        state.value=PageState.empty;
      }*/
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }

  //لیست بانک ها
  Future<void> fetchBankList() async{
    bankList.clear();
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
  /*BankAccountReqModel? bankAccountReqModel;
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
  }*/

  // لیست بانک اکانت
  /*Future<void> fetchBankAccountList()async{
    try{
      bankAccountList.clear();
      state.value=PageState.loading;
      var fetchedBankAccountList=await bankAccountRepository.getBankAccountList(bankAccountReqModel!);
      bankAccountList.assignAll(fetchedBankAccountList);

      if (bankAccountList.isNotEmpty){
        selectedBankAccount.value=bankAccountList.first;
      }

      state.value=PageState.list;

      if(bankAccountList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=e.toString();
    }
  }*/

  Future<void> fetchWallet(int id)async{
    try{
      isLoading.value=true;
      var fetchedWalletList=await walletRepository.getWalletCurrency(id);
      walletList=fetchedWalletList as WalletModel?;
      if (walletList!=null) {
        selectedWalletId.value = walletList?.id ?? 0;
      }
      print("walletList::::${walletList?.id}");
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
  }

  Future<WithdrawModel?> updateWithdraw() async {
    if(withdrawId.value==0){
      return null;
    }
    try{
      isLoading.value = true;
      //String gregorianDate = convertJalaliToGregorian(dateController.text);
      print("walletId updateWithdraw: ${selectedWalletId.value}");
      Gregorian date=existingWithdraw!.requestDate!.toGregorian();
      var response=await withdrawRepository.updateWithdraw(
          withdrawId: withdrawId.value,
          walletId: selectedWalletId.value,
          itemId: walletList?.item?.id ?? 0,
          itemName: walletList?.item?.name ?? '',
          accountId: selectedAccount.value?.id ?? 0,
          accountName: selectedAccount.value?.name ?? "",
          //bankAccountId: selectedBankAccount.value?.id ?? 0,
          bankId: selectedBankId.value,
          bankName: selectedBankName.value,
          ownerName: ownerNameController.text,
          amount: double.parse(amountController.text.replaceAll(',', '').toEnglishDigit()),
          number: numberController.text,
          cardNumber: cardNumberController.text,
          sheba: shebaController.text,
          description: descriptionController.text,
          date: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
          status: statusId.value
      );

      if(response!= null){
        Get.offNamed('/withdrawsList');
        Get.snackbar("موفقیت آمیز","ویرایش با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('ویرایش با موفقیت آنجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        withdrawController.getWithdrawListPager();
        balanceList.clear();
        clearList();
        withdrawController.withdrawList.refresh();
      }
    }catch(e){
      throw ErrorException('خطا در به‌روزرسانی درخواست برداشت: $e');
    }finally {
      isLoading.value = false;
    }
    return null;
  }

  void setWithdrawDetails(WithdrawModel withdraw){
    print(' تاریخ: ${withdraw.requestDate!.toPersianDate(showTime: true, digitType: NumStrLanguage.English)}');
    withdrawId.value=withdraw.id ?? 0;
    ownerNameController.text=withdraw.ownerName ?? '';
    amountController.text=withdraw.amount.toString().seRagham(separator:  ',') ?? '';
    cardNumberController.text=withdraw.cardNumber==null ? "" : withdraw.cardNumber.toString() ?? '';
    numberController.text=withdraw.number==null ? "" : withdraw.number.toString() ?? '';
    shebaController.text=withdraw.sheba==null ? "" : withdraw.sheba.toString() ?? '';
    descriptionController.text=withdraw.description ?? '';
    statusId.value=withdraw.status ?? 0;
    withdraw.confirmDate==null ?
    dateController.text=withdraw.requestDate?.toPersianDate(showTime: true,digitType: NumStrLanguage.English) ?? ''
    : dateController.text=withdraw.requestDate?.toPersianDate(showTime: true,digitType: NumStrLanguage.English) ?? '';
    selectedAccount.value = withdraw.wallet?.account !;

    if (withdraw.bank != null) {
      selectedBankId.value = withdraw.bank!.id!;
      selectedBankName.value = withdraw.bank!.name!;
      selectedIndex = withdraw.bank?.id.toString();
    }

    /*if (withdraw.bankAccount != null) {
      final bankAccountMatch = bankAccountList.firstWhereOrNull(
            (b) => b.id == withdraw.bankAccount?.id,
      );
      if (bankAccountMatch != null) {
        selectedBankAccount.value = bankAccountMatch;
      }
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

    ownerNameController.clear();
    amountController.clear();
    numberController.clear();
    cardNumberController.clear();
    shebaController.clear();
    selectedAccount.value=null;
    selectedBankAccount.value=null;
    bankAccountList.clear();
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }

}
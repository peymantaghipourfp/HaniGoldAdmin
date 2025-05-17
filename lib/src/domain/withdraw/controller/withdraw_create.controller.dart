
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/bank.repository.dart';
import 'package:hanigold_admin/src/config/repository/bank_account.repository.dart';
import 'package:hanigold_admin/src/config/repository/wallet.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account_req.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account.model.dart';
import '../../users/model/balance_item.model.dart';
import '../model/bank_account.model.dart';

enum PageState{loading,err,empty,list}

class WithdrawCreateController extends GetxController{
  //final formKey = GlobalKey<FormState>();

  final WithdrawController withdrawController=Get.find<WithdrawController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController ownerNameController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
  final TextEditingController numberController=TextEditingController();
  final TextEditingController cardNumberController=TextEditingController();
  final TextEditingController shebaController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final BankRepository bankRepository=BankRepository();
  final BankAccountRepository bankAccountRepository=BankAccountRepository();
  final WithdrawRepository withdrawRepository=WithdrawRepository();
  final WalletRepository walletRepository=WalletRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();

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



  void changeSelectedAccount(AccountModel? newValue) {
    //selectedBankAccount.value = null;
    selectedAccount.value = newValue;
    fetchWallet(newValue?.id ?? 0);
    /*if (newValue != null) {
      getBankAccount(newValue.id ?? 0);
      fetchWallet(newValue.id ?? 0);
    } else {
      bankAccountList.clear();
    }*/
    getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
    bankList.clear();
    fetchBankList();
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

  @override
  void onInit() {
    searchController.addListener(onSearchChanged);
    fetchAccountList();
    fetchBankList();
    super.onInit();
  }
  @override
  void onClose() {
    debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList();
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);
      state.value=PageState.list;
      if(accountList.isEmpty){
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
        final results = await accountRepository.searchAccountList(name);
        searchedAccounts.assignAll(results);
        state.value=PageState.list;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی کاربران');
    } finally {
      isLoading.value = false;
    }
  }

  //لیست بانک ها
  Future<void> fetchBankList() async{
    try{
      bankList.clear();
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
      state.value=PageState.loading;
      bankAccountList.clear();
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
  }*/

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

  // درج درخواست
Future<WithdrawModel?> insertWithdraw()async{
    try {
      isLoading.value = true;
      var response = await withdrawRepository.insertWithdraw(
        walletId: selectedWalletId.value,
          itemId: walletList?.item?.id ?? 0,
          itemName: walletList?.item?.name ?? "",
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
        date: DateTime.now().toIso8601String(),
        status: 0,
      );
      //print(response);
      if (response != null) {
        Get.toNamed('/withdrawsList');
        Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        withdrawController.fetchWithdrawList();
        balanceList.clear();
        clearList();
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
    return null;
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
    //selectedBankAccount.value=null;
    bankAccountList.clear();
    bankList.clear();
    descriptionController.clear();
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }

}
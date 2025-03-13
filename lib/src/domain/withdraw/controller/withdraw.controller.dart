

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit_request.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';


enum PageState{loading,err,empty,list}
class WithdrawController extends GetxController{

  final AccountRepository accountRepository=AccountRepository();
  final WithdrawRepository withdrawRepository=WithdrawRepository();
  final DepositRequestRepository depositRequestRepository=DepositRequestRepository();

  final TextEditingController amountController=TextEditingController();
  final TextEditingController requestAmountController=TextEditingController();

  var withdrawList=<WithdrawModel>[].obs;
  var depositRequestList=<DepositRequestModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<AccountModel> filterAccountList=<AccountModel>[].obs;

  var errorMessage=''.obs;
  var isLoading=true.obs;
  RxBool isLoadingDepositRequestList=RxBool(true);
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateDR=Rx<PageState>(PageState.list);
  RxnInt expandedIndex = RxnInt();

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
  }

  void toggleItemExpansion(int index) {
    if (expandedIndex.value==index) {
      expandedIndex.value=null;
    } else {
      expandedIndex.value=index;
    }
  }
  bool isItemExpanded(int index) {
    return expandedIndex.value==index;
  }


  @override
  void onInit() {
    fetchWithdrawList();
    fetchAccountList();
    super.onInit();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList();
      accountList.assignAll(fetchedAccountList);
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

  void filterAccountListFunc(int id){
    filterAccountList.assignAll(accountList.where((account) {
      return id!=account.id;
    },).toList());
  }

  //لیست درخواست های برداشت(withdrawRequest)
  Future<void> fetchWithdrawList()async{

    try{
      state.value=PageState.loading;
      var fetchedWithdrawList=await withdrawRepository.getWithdrawList();
      withdrawList.assignAll(fetchedWithdrawList);
      state.value=PageState.list;
      if(withdrawList.isEmpty){
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

  // آپدیت وضعیت درخواست های برداشت (updateStatusWithdraw)

  Future<WithdrawModel?> updateStatusWithdraw(int withdrawId,int status) async {

    try {
      isLoading.value = true;
      var response = await withdrawRepository.updateStatusWithdraw(
        status: status,
        withdrawId: withdrawId,

      );
      if(response!= null){
        Get.snackbar("موفقیت آمیز","وضعیت درخواست برداشت با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت درخواست برداشت با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchWithdrawList();
      }

    } catch (e) {
      throw ErrorException('خطا در تغییر وضعیت: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }
  // لیست درخواست های واریز(depositRequest)
  Future<void> fetchDepositRequestList(int id)async{

    depositRequestList.clear();
    try{
      isLoadingDepositRequestList.value = true;
      depositRequestList.clear();
      var fetchedDepositRequestList=await depositRequestRepository.getDepositRequest(id);
      depositRequestList.assignAll(fetchedDepositRequestList);
      stateDR.value=PageState.list;
      if(depositRequestList.isEmpty){
        stateDR.value=PageState.empty;
      }
    }
    catch(e){
      stateDR.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoadingDepositRequestList.value=false;
    }
  }

  // درج درخواست های واریز(insert deposit request)
  Future<DepositRequestModel?> insertDepositRequest(int id)async{
    try{
      isLoading.value=true;
      var response=await depositRequestRepository.insertDepositRequest(
        withdrawId: id ,
          accountId: selectedAccount.value?.id ?? 0,
          amount: double.parse(requestAmountController.text.replaceAll(',', '').toEnglishDigit()),
          requestAmount: double.parse(requestAmountController.text.replaceAll(',', '').toEnglishDigit())
      );
      print(response);
      if(response!=null){
        DepositRequestModel depositRequestResponse=DepositRequestModel.fromJson(response);
        Get.back();
        Get.snackbar(depositRequestResponse.infos!.first['title'], depositRequestResponse.infos!.first["description"],
            titleText: Text(depositRequestResponse.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                depositRequestResponse.infos!.first["description"], textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        clearList();
        fetchDepositRequestList(id);
        fetchWithdrawList();
        return depositRequestResponse;
      }
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
    return null;
  }

  void clearList(){
    amountController.clear();
    requestAmountController.clear();
    selectedAccount.value=null;
  }
}
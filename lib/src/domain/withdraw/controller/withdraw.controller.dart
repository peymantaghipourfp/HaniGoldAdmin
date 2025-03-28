

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit_request.repository.dart';
import 'package:hanigold_admin/src/config/repository/reason_rejection.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw_getOne.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_getOne.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection_req.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';


enum PageState{loading,err,empty,list}
class WithdrawController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final AccountRepository accountRepository=AccountRepository();
  final WithdrawRepository withdrawRepository=WithdrawRepository();
  final DepositRequestRepository depositRequestRepository=DepositRequestRepository();
  final ReasonRejectionRepository reasonRejectionRepository=ReasonRejectionRepository();

  final TextEditingController amountController=TextEditingController();
  final TextEditingController requestAmountController=TextEditingController();

  var withdrawList=<WithdrawModel>[].obs;
  var depositRequestList=<DepositRequestModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<AccountModel> filterAccountList=<AccountModel>[].obs;
  final List<ReasonRejectionModel> reasonRejectionList=<ReasonRejectionModel>[].obs;

  var errorMessage=''.obs;
  var isLoading=true.obs;
  RxBool isLoadingDepositRequestList=RxBool(true);
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateDR=Rx<PageState>(PageState.list);
  Rx<PageState> stateRR=Rx<PageState>(PageState.list);
  RxnInt expandedIndex = RxnInt();

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();

  final Rxn<ReasonRejectionModel> selectedReasonRejection = Rxn<ReasonRejectionModel>();

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
    setupScrollListener();
    super.onInit();
  }
  @override void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }
  Future<void> loadMore() async {
    if (hasMore.value && !isLoading.value) {
      currentPage++;
      await fetchWithdrawList();
    }
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
      if (currentPage == 1) {
        withdrawList.clear();
      }
      isLoading.value = true;
      state.value=PageState.loading;
      final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
      final toIndex = currentPage.value * itemsPerPage.value;
      var fetchedWithdrawList=await withdrawRepository.getWithdrawList(
          startIndex: startIndex,
          toIndex: toIndex
      );
      hasMore.value = fetchedWithdrawList.length == itemsPerPage.value;
      if (currentPage.value == 1) {
        withdrawList.assignAll(fetchedWithdrawList);
      } else {
        withdrawList.addAll(fetchedWithdrawList);
      }
      state.value = withdrawList.isEmpty ? PageState.empty : PageState.list;
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

  // مدل آپشن ReasonRejection

  ReasonRejectionReqModel? reasonRejectionReqModel;
  getReasonRejection(String type){
    reasonRejectionList.clear();
    reasonRejectionReqModel=ReasonRejectionReqModel(
        reasonrejection: OptionsModel(
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: "Type",
                    filterValue: type,
                    filterType: 4,
                    refTable: "ReasonRejection"
                )
                ]
            )
            ],
            orderBy: "ReasonRejection.Id",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 10000
        )
    );
    fetchReasonRejectionList();
  }

  // لیست Reason Rejection
  Future<void> fetchReasonRejectionList()async{
    try{
      stateRR.value=PageState.loading;
      var fetchedReasonRejectionList=await reasonRejectionRepository.getReasonRejectionList(reasonRejectionReqModel!);
      reasonRejectionList.addAll(fetchedReasonRejectionList);
      stateRR.value=PageState.list;
      if(reasonRejectionList.isEmpty){
        stateRR.value=PageState.empty;
      }
    }
    catch(e){
      stateRR.value=PageState.err;
      errorMessage.value=e.toString();
    }
  }

  Future<void> showReasonRejectionDialog(String type) async {
    getReasonRejection(type);
    await Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backGroundColor,
        title: Column(
          children: [
            Text('انتخاب دلیل رد',style: AppTextStyle.mediumTitleText,textAlign: TextAlign.center,),
            SizedBox(height: 7,),
            Divider(height: 1,color: AppColor.secondaryColor,)
          ],
        ),
        content: Obx(() {
          if (reasonRejectionList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: reasonRejectionList.map((reason) {
                return Card(
                  color: AppColor.textFieldColor,
                  child: ListTile(
                    title: Text( reason.name ?? '',style: AppTextStyle.bodyTextBold,),
                    onTap: () {
                      selectedReasonRejection.value = reason ;
                      Get.back();
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () {
              selectedReasonRejection.value = null;
              Get.back();
            },
            child: Text('لغو',style: AppTextStyle.bodyText.copyWith(color: AppColor.secondary2Color,fontSize: 16,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }


  // آپدیت وضعیت درخواست های برداشت (updateStatusWithdraw)

  Future<WithdrawModel?> updateStatusWithdraw(int withdrawId,int status,int reasonRejectionId) async {

    try {
      isLoading.value = true;

      var response = await withdrawRepository.updateStatusWithdraw(
        status: status,
        withdrawId: withdrawId,
        reasonRejectionId: status==2 ? reasonRejectionId : null,
      );
      if(response!= null){
        Get.snackbar("موفقیت آمیز","وضعیت درخواست برداشت با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت درخواست برداشت با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        //fetchWithdrawList();
      }

    } catch (e) {
      throw ErrorException('خطا در تغییر وضعیت: $e');
    } finally {
      isLoading.value = false;

    }
    return null;
  }

  // آپدیت وضعیت درخواست های واریز (updateStatusِDepositRequest)
  Future<DepositRequestModel?> updateStatusDepositRequest(int depositRequestId,int status,int reasonRejectionId) async {

    try {
      isLoading.value = true;
      var response = await depositRequestRepository.updateStatusDepositRequest(
        status: status,
        depositRequestId: depositRequestId,
        reasonRejectionId: status==2 ? reasonRejectionId : null,
      );
      if(response!= null){
        Get.snackbar("موفقیت آمیز","وضعیت درخواست واریزی با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت درخواست واریزی با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

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
    selectedReasonRejection.value = null;
  }
}
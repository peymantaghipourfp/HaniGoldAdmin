

import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../users/model/balance_item.model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import '../../users/model/paginated.model.dart';


enum PageState{loading,err,empty,list}
class WithdrawController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();
  ScrollController horizontalScrollController = ScrollController();

  final AccountRepository accountRepository=AccountRepository();
  final WithdrawRepository withdrawRepository=WithdrawRepository();
  final DepositRequestRepository depositRequestRepository=DepositRequestRepository();
  final ReasonRejectionRepository reasonRejectionRepository=ReasonRejectionRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();

  final TextEditingController amountController=TextEditingController();
  final TextEditingController requestAmountController=TextEditingController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  RxList<WithdrawModel> withdrawList = RxList([]);
  var depositRequestList=<DepositRequestModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<AccountModel> filterAccountList=<AccountModel>[].obs;
  final List<ReasonRejectionModel> reasonRejectionList=<ReasonRejectionModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  var errorMessage=''.obs;
  var isLoading=true.obs;
  RxBool isLoadingDepositRequestList=RxBool(true);
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateDR=Rx<PageState>(PageState.list);
  Rx<PageState> stateRR=Rx<PageState>(PageState.list);
  RxnInt expandedIndex = RxnInt();
  var isLoadingBalance=true.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();

  final Rxn<ReasonRejectionModel> selectedReasonRejection = Rxn<ReasonRejectionModel>();

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }
  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    getWithdrawListPager();
  }
  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
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
  void expandAndScrollHorizontal(int index, int withdrawId) {
    final isExpanding = expandedIndex.value != index;

    toggleItemExpansion(index);
    fetchDepositRequestList(withdrawId);

    if (isExpanding) {
      Future.delayed(const Duration(milliseconds: 380), () {
        if (horizontalScrollController.hasClients) {
          horizontalScrollController.animateTo(
            horizontalScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }



  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    if (columnIndex == 1) { // Date column
      withdrawList.sort((a, b) {
        if (a.requestDate == null || b.requestDate == null) return 0;
        return ascending ? a.requestDate!.compareTo(b.requestDate!) : b.requestDate!.compareTo(a.requestDate!);
      });
    }
  }

  @override
  void onInit() {
    getWithdrawListPager();
    fetchAccountList();
    setupScrollListener();
    super.onInit();
  }

  @override void onClose() {
    scrollController.dispose();
    horizontalScrollController.dispose();
    withdrawList.clear();
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
    if (!scrollController.hasClients || hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var fetchedWithdrawList = await withdrawRepository.getWithdrawList(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
          startDate: startDateFilter.value, endDate: endDateFilter.value,
        );
        if (fetchedWithdrawList.isNotEmpty) {
          withdrawList.addAll(fetchedWithdrawList);
          currentPage.value = nextPage;
          hasMore.value = fetchedWithdrawList.length == itemsPerPage.value;

        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false; // توقف بارگذاری بیشتر در صورت خطا
        errorMessage.value = "خطا در دریافت اطلاعات بیشتر: ${e.toString()}";
      } finally {
        isLoading.value = false;
      }
    }
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList("");
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

  void filterAccountListFunc(int id){
    filterAccountList.assignAll(accountList.where((account) {
      return id!=account.id;
    },).toList());
  }

  Future<void> searchAccounts(String name) async {
    try {
      if (name.isEmpty) {
        searchedAccounts.clear();
        return;
      }

      final accounts = await accountRepository.searchAccountList(name,"");
      searchedAccounts.assignAll(accounts);

    } catch (e) {
      setError("خطا در جستجوی کاربران: ${e.toString()}");
    }
  }

  void selectAccount(AccountModel account) {
    currentPage.value = 1;
    selectedAccountId.value = account.id!;
    searchController.text = account.name!;
    Get.back(); // Close search dialog
    getWithdrawListPager();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getWithdrawListPager();
  }

  // //لیست درخواست های برداشت(withdrawRequest)
  // Future<void> fetchWithdrawList()async{
  //   try{
  //       //withdrawList.clear();
  //     isLoading.value = true;
  //     state.value=PageState.loading;
  //       //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
  //     final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
  //     final toIndex = currentPage.value * itemsPerPage.value;
  //     var fetchedWithdrawList=await withdrawRepository.getWithdrawList(
  //         startIndex: startIndex,
  //         toIndex: toIndex,
  //         accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
  //       startDate: startDateFilter.value, endDate: endDateFilter.value,
  //     );
  //     hasMore.value = fetchedWithdrawList.length == itemsPerPage.value;
  //
  //     if (selectedAccountId.value == 0) {
  //       withdrawList.assignAll(fetchedWithdrawList);
  //     }else {
  //       if (currentPage.value == 1) {
  //         withdrawList.assignAll(fetchedWithdrawList);
  //
  //       } else {
  //         withdrawList.addAll(fetchedWithdrawList);
  //
  //       }
  //     }
  //     state.value = withdrawList.isEmpty ? PageState.empty : PageState.list;
  //     //EasyLoading.dismiss();
  //     withdrawList.refresh();
  //     update();
  //   }
  //   catch(e){
  //     state.value=PageState.err;
  //     errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
  //   }finally{
  //     isLoading.value=false;
  //   }
  // }

  // لیست دریافت ها با صفحه بندی
  Future<void> getWithdrawListPager() async {
    print("### getWithdrawListPager ###");
    withdrawList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await withdrawRepository.getWithdrawListPager(
        startIndex: currentPage.value,accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        name: nameFilterController.text,
        toIndex: itemsPerPage.value, startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      isLoading.value=false;
      withdrawList.assignAll(response.withdrawRequests??[]);
      paginated.value=response.paginated;
      state.value=PageState.list;

      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
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
    EasyLoading.show(status: 'لطفا منتظر بمانید');
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
      EasyLoading.dismiss();
      throw ErrorException('خطا در تغییر وضعیت: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;

    }
    return null;
  }

  // آپدیت وضعیت درخواست های واریز (updateStatusِDepositRequest)
  Future<DepositRequestModel?> updateStatusDepositRequest(int depositRequestId,int status,int reasonRejectionId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
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
      EasyLoading.dismiss();
      throw ErrorException('خطا در تغییر وضعیت: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }

  // لیست درخواست های واریز(depositRequest)
  Future<void> fetchDepositRequestList(int id)async{
    depositRequestList.clear();
    try{
      isLoadingDepositRequestList.value = true;
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
  Future<DepositRequestModel?> insertDepositRequest(int id,int walletId)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value=true;
      var response=await depositRequestRepository.insertDepositRequest(
        withdrawId: id ,
          walletId: walletId,
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
        getWithdrawListPager();
        return depositRequestResponse;
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
    return null;
  }

  Future<DepositRequestModel?> updateDepositRequest(int withdrawId,int depositRequestId)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value=true;
      var response=await depositRequestRepository.updateDepositRequest(
          withdrawId: withdrawId ,
          accountId: selectedAccount.value?.id ?? 0,
          amount: double.parse(requestAmountController.text.replaceAll(',', '').toEnglishDigit()),
          requestAmount: double.parse(requestAmountController.text.replaceAll(',', '').toEnglishDigit()),
          depositRequestId: depositRequestId,
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
        fetchDepositRequestList(withdrawId);
        getWithdrawListPager();
        return depositRequestResponse;
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
    return null;
  }

  void setDepositRequestDetail(DepositRequestModel depositRequest)async {
    selectedAccount.value = accountList.firstWhere(
          (account) => account.id == depositRequest.account?.id,
    );
   await getBalanceList(depositRequest.account?.id ?? 0);
    requestAmountController.text = depositRequest.requestAmount?.toString() ?? '';
    print("accountIdddd: ${depositRequest.account?.id}");
  }

  Future<List<dynamic>?> deleteWithdraw(int withdrawId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await withdrawRepository.deleteWithdraw(isDeleted: isDeleted, withdrawId: withdrawId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getWithdrawListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف درخواست برداشت: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;

    }
    return null;
  }

  Future<List<dynamic>?> updateRequestDateWithdraw(int withdrawId)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await withdrawRepository.updateRequestDateWithdraw(withdrawId: withdrawId);
      if(response!= null){
        WithdrawModel updateDateResponse=WithdrawModel.fromJson(response);
        Get.snackbar(updateDateResponse.infos!.first['title'],updateDateResponse.infos!.first["description"],
            titleText: Text(updateDateResponse.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(updateDateResponse.infos!.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getWithdrawListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در آپدیت تاریخ: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }

  Future<List<dynamic>?> deleteDepositRequest(int withdrawId,int depositRequestId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await depositRequestRepository.deleteDepositRequest(isDeleted: isDeleted, depositRequestId: depositRequestId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchDepositRequestList(withdrawId);
        getWithdrawListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف درخواست واریزی: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;

    }
    return null;
  }

  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    balanceList.clear();
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      isLoadingBalance.value=true;
      update();
  }

  void clearList(){
    amountController.clear();
    requestAmountController.clear();
    selectedAccount.value=null;
    selectedReasonRejection.value = null;
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }

  // خروجی اکسل
  Future<void> exportToExcel() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final excel = Excel.createExcel();
      final sheet = excel['برداشت ها'];

      sheet.appendRow([
        TextCellValue('ردیف'),
        TextCellValue('تاریخ'),
        TextCellValue('نام کاربر'),
        TextCellValue('دارنده حساب'),
        TextCellValue('مبلغ کل'),
        TextCellValue('مبلغ مانده'),
        TextCellValue('مبلغ واریز شده'),
        TextCellValue('وضعیت'),
      ]);
      EasyLoading.show(status: 'دریافت فایل اکسل...');
      final allWithdraws = await withdrawRepository.getWithdrawList(
        startIndex: 1,
        toIndex: 100000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      for (var withdraw in allWithdraws) {
        sheet.appendRow([
          TextCellValue(withdraw.rowNum.toString()),
          TextCellValue(withdraw.requestDate?.toPersianDate(twoDigits: true) ?? ''),
          TextCellValue(withdraw.wallet?.account?.name ?? ''),
          TextCellValue("${withdraw.ownerName} (${withdraw.bank?.name})" ?? ''),
          TextCellValue(withdraw.amount?.toString() ?? ''),
          TextCellValue(withdraw.undividedAmount?.toString() ?? ''),
          TextCellValue(withdraw.paidAmount?.toString() ?? ''),
          TextCellValue(getStatusText(withdraw.status ?? 0 )),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception('خطا در دریافت فایل');
      final uint8List = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'withdraws_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
      }else {
        final output = await getDownloadsDirectory();
        final filePath = '${output?.path}/withdraws_${DateTime
            .now()
            .millisecondsSinceEpoch}.xlsx';
        final fileBytes = excel.encode();
        if (fileBytes != null) {
          await File(filePath).writeAsBytes(uint8List);

          await FileSaver.instance.saveFile(
            name: 'withdraws',
            bytes: uint8List,
            ext: 'xlsx',
            mimeType: MimeType.microsoftExcel,
          );
        }
      }
      Get.snackbar('موفق', 'فایل اکسل با موفقیت دریافت شد');
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('خطا', 'خطا در دریافت فایل اکسل: ${e.toString()}');
      print(e.toString());
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'نامشخص';
      case 1:
        return 'تایید شده';
      case 2:
        return 'تایید نشده';
      default:
        return 'نامعتبر';
    }
  }

  // خروجی pdf
  Future<void> exportToPdf() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      final allWithdraws = await withdrawRepository.getWithdrawList(
        startIndex: 1,
        toIndex: 100000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);

      final pdf = pw.Document();

      // افزودن MultiPage برای مدیریت خودکار صفحه‌بندی
      pdf.addPage(
        pw.MultiPage(
          textDirection: pw.TextDirection.rtl,
          maxPages: 2000,
          theme: pw.ThemeData.withFont(base: ttf,fontFallback: [ttf],),
          header: (pw.Context context) => buildHeaderTable(),
          build: (pw.Context context) => [
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: getColumnWidths(),
              children: [
                for (var withdraw in allWithdraws)
                  buildDataRow(withdraw),
              ],
            ),
          ],
          footer: (pw.Context context) => buildPageNumber(context.pageNumber, context.pagesCount),
        ),
      );

      final bytes = await pdf.save();
      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..download = 'withdraws_${DateTime.now().millisecondsSinceEpoch}.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'withdraws.pdf',
        );
      }

      EasyLoading.dismiss();
      Get.snackbar('موفق', 'فایل PDF با موفقیت دریافت شد');
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('خطا', 'خطا در دریافت فایل PDF: ${e.toString()}');
      print(e.toString());
    }
  }

  Map<int, pw.TableColumnWidth> getColumnWidths() {
    return {
      0: pw.FlexColumnWidth(2),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(3),
      3: pw.FlexColumnWidth(3),
      4: pw.FlexColumnWidth(3),
      5: pw.FlexColumnWidth(3),
      6: pw.FlexColumnWidth(2.5),
      7: pw.FlexColumnWidth(1.5),
    };
  }
  // ساخت هدر جدول
  pw.Table buildHeaderTable() {
    return pw.Table(
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(3),
        3: pw.FlexColumnWidth(3),
        4: pw.FlexColumnWidth(3),
        5: pw.FlexColumnWidth(3),
        6: pw.FlexColumnWidth(2.5),
        7: pw.FlexColumnWidth(1.5),
      },
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('وضعیت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مبلغ واریز شده', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مبلغ مانده', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مبلغ کل', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('دارنده ساب', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('نام کاربر', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('تاریخ', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('ردیف', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
          ],
        ),
      ],
    );
  }
  // ساخت سلول‌های داده
  pw.Padding buildDataCell(String text, {bool isCenter = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 8),
        textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.right,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.TableRow buildDataRow(WithdrawModel withdraw) {
    return pw.TableRow(
      children: [
        buildDataCell(getStatusText(withdraw.status ?? 0)),
        buildDataCell(withdraw.paidAmount?.toString().seRagham(separator: ',') ?? ''),
        buildDataCell(withdraw.undividedAmount?.toString().seRagham(separator: ',') ?? ''),
        buildDataCell(withdraw.amount?.toString().seRagham(separator: ',') ?? ''),
        buildDataCell("${withdraw.ownerName} ${withdraw.bank?.name}" ?? ''),
        buildDataCell(withdraw.wallet?.account?.name ?? ''),
        buildDataCell(withdraw.requestDate?.toPersianDate(twoDigits: true) ?? ''),
        buildDataCell(withdraw.rowNum.toString(), isCenter: true),
      ],
    );
  }

  pw.Widget buildPageNumber(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'صفحه ${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }

  void clearFilter() {
    nameFilterController.clear();
    mobileFilterController.clear();
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }


  Future<void> captureRowScreenshot(WithdrawModel withdraw, GlobalKey dataTableKey, Map<int, GlobalKey> rowKeys) async {
    final rowKey = rowKeys[withdraw.id!];
    if (rowKey == null || rowKey.currentContext == null) {
      Get.snackbar('خطا', 'ردیفی برای ثبت پیدا نشد. کلید آماده نیست.');
      return;
    }

    if (dataTableKey.currentContext == null) {
      Get.snackbar('خطا', 'جدولی برای ثبت پیدا نشد. کلید آماده نیست.');
      return;
    }

    try {
      if (!kIsWeb) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar('خطای دسترسی', 'برای ذخیره تصاویر، مجوز ذخیره‌سازی لازم است.');
          return;
        }
      }

      final RenderRepaintBoundary boundary = dataTableKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 1.0);

      final RenderBox tableBox = dataTableKey.currentContext!.findRenderObject() as RenderBox;
      final tablePosition = tableBox.localToGlobal(Offset.zero);
      final tableSize = tableBox.size;

      final RenderBox cellContentBox = rowKey.currentContext!.findRenderObject() as RenderBox;

      RenderObject? tableCellRenderObject = cellContentBox;
      while (tableCellRenderObject != null && tableCellRenderObject.parentData is! TableCellParentData) {
        if (tableCellRenderObject.parent is RenderObject) {
          tableCellRenderObject = tableCellRenderObject.parent as RenderObject;
        } else {
          tableCellRenderObject = null;
          break;
        }
      }

      if (tableCellRenderObject == null || tableCellRenderObject is! RenderBox) {
        Get.snackbar('خطا', 'render object ردیف جدول پیدا نشد.');
        return;
      }

      final RenderBox rowCellBox = tableCellRenderObject;
      final rowCellPosition = rowCellBox.localToGlobal(Offset.zero);
      final rowHeight = rowCellBox.size.height;

      final cropRect = Rect.fromLTWH(0, // Start from the very left of the table
        rowCellPosition.dy - tablePosition.dy,
        tableSize.width,
        rowHeight,
      );

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final paint = Paint();
      canvas.drawImageRect(image, cropRect, Rect.fromLTWH(0, 0, cropRect.width, cropRect.height), paint,);

      final picture = recorder.endRecording();
      final croppedImage = await picture.toImage(cropRect.width.toInt(), cropRect.height.toInt());
      final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        Get.snackbar('خطا', 'دریافت داده‌های تصویر ناموفق بود.');
        return;
      }
      final uint8List = byteData.buffer.asUint8List();

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'row_screenshot_${withdraw.id}.png')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await FileSaver.instance.saveFile(
          name: "row_screenshot_${withdraw.id}",
          bytes: uint8List,
          ext: 'png',
          mimeType: MimeType.png,
        );
      }

      Get.snackbar('موفق', 'تصویر اسکرین شات با موفقیت ذخیره شد.');

    } catch (e) {
      Get.snackbar('خطا', 'ثبت اسکرین شات ناموفق بود: $e');
    }
  }

}
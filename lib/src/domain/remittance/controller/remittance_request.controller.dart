import 'dart:async';
import 'dart:convert';
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
import 'package:hanigold_admin/src/config/repository/remittance.repository.dart';
import 'package:hanigold_admin/src/config/repository/reason_rejection.repository.dart';
import 'package:hanigold_admin/src/config/repository/remittance_request.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/base/base_controller.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance_request.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/socket_remittanceRequest.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection_req.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../users/model/paginated.model.dart';
import 'package:universal_html/html.dart' as html;

enum PageState{loading,err,empty,list}

class RemittanceRequestController extends BaseController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final AccountRepository accountRepository=AccountRepository();
  final RemittanceRequestRepository remittanceRequestRepository=RemittanceRequestRepository();
  final ReasonRejectionRepository reasonRejectionRepository=ReasonRejectionRepository();

  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController nameController=TextEditingController();

  RxList<RemittanceRequestModel> remittanceRequestList =<RemittanceRequestModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<ReasonRejectionModel> reasonRejectionList=<ReasonRejectionModel>[].obs;
  PaginatedModel? paginated;
  var errorMessage=''.obs;
  var isLoading=false.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateRR=Rx<PageState>(PageState.list);
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;

  final Rxn<ReasonRejectionModel> selectedReasonRejection = Rxn<ReasonRejectionModel>();

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;

  StreamSubscription? socketSubscription;

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  void isChangePage(int index){
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value=index*10;
    getRemittanceRequestListPager();
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    if (columnIndex == 1) { // Date column
      remittanceRequestList.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return ascending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!);
      });
    }else if (columnIndex == 3) { // Name column
      remittanceRequestList.sort((a, b) {
        final aNameDescription = a.description ?? '';
        final bNameDescription = b.description ?? '';
        return ascending ? aNameDescription.compareTo(bNameDescription) : bNameDescription.compareTo(aNameDescription);
      });
    }else if (columnIndex == 4) { // Name column
      remittanceRequestList.sort((a, b) {
        final aNameToDescription = a.toDescription ?? '';
        final bNameToDescription = b.toDescription ?? '';
        return ascending ? aNameToDescription.compareTo(bNameToDescription) : bNameToDescription.compareTo(aNameToDescription);
      });
    }
  }

  @override
  void onInit() {
    socketSubscription?.cancel();
    _listenToSocket();
    fetchAccountList();
    setupScrollListener();
    getRemittanceRequestListPager();
    super.onInit();
  }

  @override void onClose() {
    socketSubscription?.cancel();
    scrollController.dispose();
    remittanceRequestList.clear();
    super.onClose();
  }

  void _listenToSocket() {
    socketSubscription?.cancel();
    socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'remittanceRequest') {
            final socketRemittanceRequest = SocketRemittanceRequestModel.fromJson(data);

            getRemittanceRequestListPager();
          }
        } catch (e) {
          Get.log('Error processing socket message in RemittanceRequestController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in RemittanceRequestController: $error');
    });
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
        var response = await remittanceRequestRepository.getRemittanceRequestListPager(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
          startDate: startDateFilter.value,
          endDate: endDateFilter.value,
          name: nameController.text
        );
        if (response.remittanceRequests?.isNotEmpty == true) {
          remittanceRequestList.addAll(response.remittanceRequests ?? []);
          currentPage.value = nextPage;
          hasMore.value = response.remittanceRequests!.length == itemsPerPage.value;
        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false;
        errorMessage.value = "خطا در دریافت اطلاعات بیشتر: ${e.toString()}";
      } finally {
        isLoading.value = false;
      }
    }
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{

      var fetchedAccountList=await accountRepository.getAccountList("");
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);

      if(accountList.isEmpty){
        print("No accounts found");
      } else {
        print("Loaded ${accountList.length} accounts");
      }
    }
    catch(e){
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
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
    getRemittanceRequestListPager();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getRemittanceRequestListPager();
  }

  // لیست حواله‌های درخواستی با صفحه بندی
  Future<void> getRemittanceRequestListPager() async {
    print("### getRemittanceListStatusPager ###");
    remittanceRequestList.clear();
    try {
      state.value=PageState.loading;
      var response = await remittanceRequestRepository.getRemittanceRequestListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
        name: nameController.text,
      );
      remittanceRequestList.assignAll(response.remittanceRequests ?? []);
      paginated=response.paginated;
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

  // آپدیت وضعیت حواله‌ها (updateStatusRemittance)
  Future<RemittanceModel?> updateStatusRemittanceRequest(int remittanceRequestId,int status,int reasonRejectionId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoading.value = true;

      var response = await remittanceRequestRepository.updateStatusRemittanceRequest(
        status: status,
        remittanceRequestId: remittanceRequestId,
        reasonRejectionId: status==2 ? reasonRejectionId : null,
      );
      if(response != null){
        Get.snackbar("موفقیت آمیز","وضعیت حواله با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت حواله با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getRemittanceRequestListPager();
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

  Future<List<dynamic>?> deleteRemittanceRequest(int remittanceRequestId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await remittanceRequestRepository.deleteRemittanceRequest(isDeleted: isDeleted, remittanceRequestId: remittanceRequestId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getRemittanceRequestListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف حواله: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }

  void clearList(){
    selectedReasonRejection.value = null;
  }

  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }

  void clearFilter() {
    nameController.clear();
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }

}
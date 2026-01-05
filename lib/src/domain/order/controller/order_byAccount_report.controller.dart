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
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/config/repository/remittance.repository.dart';
import 'package:hanigold_admin/src/config/repository/reason_rejection.repository.dart';
import 'package:hanigold_admin/src/config/repository/remittance_request.repository.dart';
import 'package:hanigold_admin/src/config/repository/transfer_wallet.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/order/model/order_byAccount_report.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance_request.model.dart';
import 'package:hanigold_admin/src/domain/transferWallet/model/transfer_wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection_req.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:printing/printing.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../users/model/paginated.model.dart';
import 'package:universal_html/html.dart' as html;

enum PageState{loading,err,empty,list}

class OrderByAccountReportController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 25.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerMobile = ScrollController();

  final AccountRepository accountRepository=AccountRepository();
  final OrderRepository orderRepository=OrderRepository();

  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController nameController=TextEditingController();

  RxList<OrderByAccountReportModel> orderByAccountReportList =<OrderByAccountReportModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  PaginatedModel? paginated;
  var errorMessage=''.obs;
  var isLoading=false.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateRR=Rx<PageState>(PageState.list);
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;


  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;

  RxString currentOrderBy = "InnerQuery.reportDate".obs;
  RxString currentOrderByType = "DESC".obs;

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  void isChangePage(int index){
    currentPage.value=(index*25-25)+1;
    itemsPerPage.value=index*25;
    getOrderByAccountReportPager();
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    // Map column indices to orderBy fields
    String orderByField;
    switch (columnIndex) {
      case 1:
        orderByField = "InnerQuery.reportDate";
        break;
      case 3:
        orderByField = "InnerQuery.totalSaleAmount";
        break;
      case 4:
        orderByField = "InnerQuery.totalBuyAmount";
        break;
      case 5:
        orderByField = "InnerQuery.balanceAmount";
        break;
      case 6:
        orderByField = "av.currencyValue";
        break;
      default:
        orderByField = "InnerQuery.reportDate";
    }

    currentOrderBy.value = orderByField;
    currentOrderByType.value = ascending ? "DESC" : "ASC";

    // Refresh data with new sorting
    getOrderByAccountReportPager();
  }

  @override
  void onInit() {
    fetchAccountList();
    setupScrollListener();
    getOrderByAccountReportPager();
    super.onInit();
  }

  @override void onClose() {
    scrollController.dispose();
    orderByAccountReportList.clear();
    scrollControllerMobile.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollControllerMobile.addListener(() {
      if (scrollControllerMobile.position.pixels >=
          scrollControllerMobile.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }

  Future<void> loadMore() async {
    if (!scrollControllerMobile.hasClients || hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var response = await orderRepository.getOrderByAccountReportPager(
            startIndex: startIndex,
            toIndex: toIndex,
            accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
            startDate: startDateFilter.value,
            endDate: endDateFilter.value,
            name: nameController.text
        );
        if (response.balanceDayOrderAccounts.isNotEmpty == true) {
          orderByAccountReportList.addAll(response.balanceDayOrderAccounts ?? []);
          currentPage.value = nextPage;
          hasMore.value = response.balanceDayOrderAccounts.length == itemsPerPage.value;
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
    getOrderByAccountReportPager();
  }

  void clearSearch() {
    paginated=null;
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getOrderByAccountReportPager();
  }

  // لیست کارکرد سفارشات با صفحه بندی
  Future<void> getOrderByAccountReportPager() async {
    print("### getOrderByAccountReportPager ###");
    orderByAccountReportList.clear();
    try {
      state.value=PageState.loading;
      var response = await orderRepository.getOrderByAccountReportPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
        name: nameController.text,
        orderBy: currentOrderBy.value,
        orderByType: currentOrderByType.value,
      );
      orderByAccountReportList.assignAll(response.balanceDayOrderAccounts ?? []);
      paginated=response.paginated;
      state.value=PageState.list;

      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  Future<void> getOrderByAccountReportPdf() async {
    try {

      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      var response = await orderRepository.getOrderByAccountReportPdf(
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
        name: nameController.text,
      );
      final fileName = 'orderByAccount_${DateTime.now().millisecondsSinceEpoch}.pdf';
      if (kIsWeb) {
        final blob = html.Blob([response], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: response,
          filename: fileName,
        );
      }
      EasyLoading.dismiss();
      Get.snackbar('موفق', 'فایل PDF با موفقیت دریافت شد');
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('خطا', 'خطا در دریافت فایل PDF: \n${e.toString()}');
      print(e.toString());
    }
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
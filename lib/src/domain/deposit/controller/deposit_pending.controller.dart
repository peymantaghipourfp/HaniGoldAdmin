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
import 'package:hanigold_admin/src/config/repository/deposit.repository.dart';
import 'package:hanigold_admin/src/config/repository/reason_rejection.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/base/base_controller.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
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

import '../model/socket_deposit.model.dart';

enum PageState{loading,err,empty,list}

class DepositPendingController extends BaseController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final AccountRepository accountRepository=AccountRepository();
  final DepositRepository depositRepository=DepositRepository();
  final ReasonRejectionRepository reasonRejectionRepository=ReasonRejectionRepository();

  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController nameDepositFilterController=TextEditingController();
  final TextEditingController nameRequestFilterController=TextEditingController();

  RxList<DepositModel> depositList = RxList([]);
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<ReasonRejectionModel> reasonRejectionList=<ReasonRejectionModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  var errorMessage=''.obs;
  var isLoading=true.obs;
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
    getDepositListStatusPager();
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    if (columnIndex == 1) { // Date column
      depositList.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return ascending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!);
      });
    }
  }

  @override
  void onInit() {
    socketSubscription?.cancel();
    _listenToSocket();
    fetchAccountList();
    setupScrollListener();
    getDepositListStatusPager();
    super.onInit();
  }

  @override void onClose() {
    socketSubscription?.cancel();
    scrollController.dispose();
    depositList.clear();
    super.onClose();
  }

  void _listenToSocket() {
    socketSubscription?.cancel();
    socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'deposit') {
            final socketDeposit = SocketDepositModel.fromJson(data);

            getDepositListStatusPager();
          }
        } catch (e) {
          Get.log('Error processing socket message in DepositPendingController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in DepositPendingController: $error');
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
        var fetchedDepositList = await depositRepository.getDepositList(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
          startDate: startDateFilter.value, endDate: endDateFilter.value,
        );
        if (fetchedDepositList.isNotEmpty) {
          // Filter for pending deposits (status == 0)
          var pendingDeposits = fetchedDepositList.where((deposit) => deposit.status == 0).toList();
          depositList.addAll(pendingDeposits);
          currentPage.value = nextPage;
          hasMore.value = fetchedDepositList.length == itemsPerPage.value;
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
    getDepositListStatusPager();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getDepositListStatusPager();
  }

  // لیست واریزهای در انتظار با صفحه بندی
  Future<void> getDepositListStatusPager() async {
    print("### getDepositListStatusPager ###");
    depositList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await depositRepository.getDepositListPendingPager(
        startIndex: currentPage.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        nameDeposit: nameDepositFilterController.text,
        nameRequest: nameRequestFilterController.text,
        toIndex: itemsPerPage.value,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
      );
      isLoading.value=false;
      // فیلتر کردن فقط واریزهای در انتظار (status == 0)
      var pendingDeposits = response.deposit ?? [];
      depositList.assignAll(pendingDeposits);
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

  // آپدیت وضعیت واریزها (updateStatusDeposit)
  Future<DepositModel?> updateStatusDeposit(int depositId,int status,int reasonRejectionId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoading.value = true;

      var response = await depositRepository.updateStatusDeposit(
        status: status,
        depositId: depositId,
        reasonRejectionId: status==2 ? reasonRejectionId : null,
      );
      if(response!= null){
        Get.snackbar("موفقیت آمیز","وضعیت واریز با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت واریز با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getDepositListStatusPager();
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

  Future<List<dynamic>?> deleteDeposit(int depositId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await depositRepository.deleteDeposit(isDeleted: isDeleted, depositId: depositId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getDepositListStatusPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف واریز: $e');
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

  //فایل اکسل
  Future<void> getDepositExcel() async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await depositRepository.getDepositExcel(
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      String fileName = 'deposits_pending_${DateTime.now().toIso8601String()}.xlsx';

      if (kIsWeb) {
        final blob = html.Blob([excelBytes], 'application/vnd.ms-excel');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: excelBytes,
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
      }
      EasyLoading.showSuccess('فایل اکسل با موفقیت دانلود شد');
    }
    catch(e){
      EasyLoading.dismiss();
      state.value = PageState.err;
      errorMessage.value = "خطا در دریافت فایل اکسل: ${e.toString()}";
      Get.snackbar(
        'خطا',
        'خطا در دریافت فایل اکسل',
        snackPosition: SnackPosition.BOTTOM,
      );
    }finally{
      isLoading.value=false;
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'در انتظار';
      case 1:
        return 'تایید شده';
      case 2:
        return 'تایید نشده';
      default:
        return 'نامعتبر';
    }
  }

  void clearFilter() {
    nameDepositFilterController.clear();
    nameRequestFilterController.clear();
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }

  Future<void> captureRowScreenshot(DepositModel deposit, GlobalKey dataTableKey, Map<int, GlobalKey> rowKeys) async {
    final rowKey = rowKeys[deposit.id!];
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
          ..setAttribute('download', 'deposit_screenshot_${deposit.id}.png')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await FileSaver.instance.saveFile(
          name: "deposit_screenshot_${deposit.id}",
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
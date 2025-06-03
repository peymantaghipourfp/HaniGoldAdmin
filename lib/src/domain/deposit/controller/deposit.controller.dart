

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/deposit.repository.dart';
import 'package:hanigold_admin/src/config/repository/upload.repository.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/reason_rejection.repository.dart';
import '../../account/model/account.model.dart';
import '../../users/model/paginated.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';
import '../../withdraw/model/reason_rejection.model.dart';
import '../../withdraw/model/reason_rejection_req.model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

enum PageState{loading,err,empty,list}

class DepositController extends GetxController{
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final UploadRepository uploadRepository=UploadRepository();
  final UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();
  final DepositRepository depositRepository=DepositRepository();
  final ReasonRejectionRepository reasonRejectionRepository=ReasonRejectionRepository();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController nameDepositFilterController=TextEditingController();
  final TextEditingController nameRequestFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  RxList<DepositModel> depositList = RxList([]);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingRegister=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateRR=Rx<PageState>(PageState.list);
  final List<ReasonRejectionModel> reasonRejectionList=<ReasonRejectionModel>[].obs;
  final Rxn<ReasonRejectionModel> selectedReasonRejection = Rxn<ReasonRejectionModel>();
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  Rx<XFile?> selectedImageDesktop = Rx<XFile?>(null);
  RxBool isUploading = false.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }
  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    getDepositListPager();
  }

  @override
  void onInit() {
    getDepositListPager();
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
          depositList.addAll(fetchedDepositList);
          currentPage.value = nextPage;
          hasMore.value = fetchedDepositList.length == itemsPerPage.value;

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

  /*Future<void> pickImage(String recordId, String type, String entityType) async {

        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image == null) {
          final XFile? galleryImage = await _picker.pickImage(source: ImageSource.gallery);
          if(galleryImage!=null) {
        selectedImage.value = File(galleryImage.path);
        await uploadImage(recordId, type, entityType);
      }
    } else {
          selectedImage.value = File(image.path);
          await uploadImage(recordId, type, entityType);
        }
        print("Imaggggge: ${selectedImage}");
  }*/
  /*Future<void> uploadImage(String recordId, String type, String entityType) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    if (selectedImage.value == null) return;

    isUploading.value = true;
    String success = await uploadRepository.uploadImage(
      imageFile: selectedImage.value!,
      recordId: recordId,
      type: type,
      entityType: entityType,
    );

    if (success.isNotEmpty) {
      EasyLoading.dismiss();
      Get.snackbar("موفقیت‌آمیز", "تصویر با موفقیت آپلود شد");
    } else {
      EasyLoading.dismiss();
      Get.snackbar("خطا", "ارسال تصویر ناموفق بود");
    }
    EasyLoading.dismiss();
    isUploading.value = false;
  }*/

  /*Future<void> pickImageDesktop(String recordId, String type, String entityType) async {

      final galleryImage = await _picker.pickImage(source: ImageSource.gallery);
      if(galleryImage!=null) {
        selectedImageDesktop.value = galleryImage;
        await uploadImageDesktop(
            recordId,
            type,
            entityType);
      }

    print("Imaggggge: ${selectedImageDesktop}");
  }*/

  /*Future<void> uploadImageDesktop(String recordId, String type, String entityType) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    if (selectedImageDesktop.value == null) return;
    isUploading.value = true;
    final bytes = await selectedImageDesktop.value.readAsBytes();
      String success = await uploadRepositoryDesktop.uploadImageDesktop(
        imageBytes: bytes,
        fileName: selectedImageDesktop.value.name,
        recordId: recordId,
        type: type,
        entityType: entityType,
      );
      if (success.isNotEmpty) {
        EasyLoading.dismiss();
        Get.snackbar("موفقیت‌آمیز", "تصویر با موفقیت آپلود شد");
      }else{
        EasyLoading.dismiss();
        Get.snackbar("خطا", "ارسال تصویر ناموفق بود");
      }
    EasyLoading.dismiss();
      isUploading.value = false;
  }*/

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
    getDepositListPager();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getDepositListPager();
  }
// لیست دریافت ها با صفحه بندی
  Future<void> getDepositListPager() async {
    print("### getDepositListPager ###");
    depositList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await depositRepository.getDepositListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value, startDate: startDateFilter.value, endDate: endDateFilter.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        nameDeposit: nameDepositFilterController.text ,nameRequest: nameRequestFilterController.text,
      );
      isLoading.value=false;
      depositList.addAll(response.deposit??[]);
      paginated.value=response.paginated;
      state.value=PageState.list;

      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // Future<void> fetchDepositList() async{
  //   try{
  //       depositList.clear();
  //     isLoading.value = true;
  //     state.value=PageState.loading;
  //       //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
  //     final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
  //     final toIndex = currentPage.value * itemsPerPage.value;
  //     var fetchedDepositList=await depositRepository.getDepositList(
  //         startIndex: startIndex,
  //         toIndex: toIndex,
  //       accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
  //       startDate: startDateFilter.value, endDate: endDateFilter.value,
  //     );
  //     hasMore.value = fetchedDepositList.length == itemsPerPage.value;
  //
  //     if (selectedAccountId.value == 0) {
  //       depositList.assignAll(fetchedDepositList);
  //     }else {
  //       if (currentPage.value == 1) {
  //         depositList.assignAll(fetchedDepositList);
  //       } else {
  //         depositList.addAll(fetchedDepositList);
  //       }
  //     }
  //     print(depositList.length);
  //     state.value = depositList.isEmpty ? PageState.empty : PageState.list;
  //     //EasyLoading.dismiss();
  //       depositList.refresh();
  //       update();
  //
  //   }catch(e){
  //     state.value=PageState.err;
  //     errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
  //   }finally{
  //     isLoading.value=false;
  //   }
  // }


  Future<List<dynamic>?> deleteDeposit(int depositId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await depositRepository.deleteDeposit(isDeleted: isDeleted, depositId: depositId);
      if(response!= null){
        Get.snackbar("موفقیت آمیز","حذف واریزی با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف واریزی با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getDepositListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف واریزی: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }

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
            Text('انتخاب دلیل رد واریزی' , style: AppTextStyle.mediumTitleText,textAlign: TextAlign.center,),
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
        Get.snackbar("موفقیت آمیز","وضعیت واریزی با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت واریزی با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        //fetchDepositList();
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

  Future<List<dynamic>?> updateRegistered(int depositId,bool registered) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      var response = await depositRepository.updateRegistered(
        depositId: depositId,
        registered: registered,
      );
      Get.snackbar(response.first['title'],response.first["description"],
          titleText: Text(response.first['title'],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
     // getDepositListPager();
        } catch (e) {
      EasyLoading.dismiss();
      throw ErrorException('خطا در ریجیستر: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }

    return null;
  }

  // خروجی اکسل
  Future<void> exportToExcel() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final excel = Excel.createExcel();
      final sheet = excel['واریزی ها'];

      sheet.appendRow([
        TextCellValue('ردیف'),
        TextCellValue('تاریخ درخواست'),
        TextCellValue('نام کاربر'),
        TextCellValue('بابت'),
        TextCellValue('مبلغ (ریال)'),
        TextCellValue('کد رهگیری'),
        TextCellValue('وضعیت'),
      ]);
      EasyLoading.show(status: 'دریافت فایل اکسل...');
      final allDeposits = await depositRepository.getDepositList(
        startIndex: 1,
        toIndex: 100000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      for (var deposit in allDeposits) {
        sheet.appendRow([
          TextCellValue(deposit.rowNum.toString()),
          TextCellValue(deposit.date?.toPersianDate(twoDigits: true) ?? ''),
          TextCellValue(deposit.wallet?.account?.name ?? ''),
          TextCellValue(deposit.walletWithdraw?.account?.name ?? ''),
          TextCellValue(deposit.amount?.toString() ?? ''),
          TextCellValue(deposit.trackingNumber ?? ''),
          TextCellValue(getStatusText(deposit.status ?? 0 )),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception('خطا در دریافت فایل');
      final uint8List = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'deposits_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
      }else {
        final output = await getDownloadsDirectory();
        final filePath = '${output?.path}/deposits_${DateTime
            .now()
            .millisecondsSinceEpoch}.xlsx';
        final fileBytes = excel.encode();
        if (fileBytes != null) {
          await File(filePath).writeAsBytes(uint8List);

          await FileSaver.instance.saveFile(
            name: 'deposits',
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

      final allDeposits = await depositRepository.getDepositList(
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
                for (var deposit in allDeposits)
                  buildDataRow(deposit),
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
          ..download = 'deposits_${DateTime.now().millisecondsSinceEpoch}.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'deposits.pdf',
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
      5: pw.FlexColumnWidth(2.5),
      6: pw.FlexColumnWidth(1.5),
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
        5: pw.FlexColumnWidth(2.5),
        6: pw.FlexColumnWidth(1.5),
      },
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('وضعیت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('کد رهگیری', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('مبلغ (ریال)', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('بابت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('نام کاربر', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('تاریخ درخواست', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('ردیف', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ],
    );
  }
  // ساخت سلول‌های داده
  pw.Padding buildDataCell(String text, {bool isCenter = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 9),
        textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.right,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.TableRow buildDataRow(DepositModel deposit) {
    return pw.TableRow(
      children: [
        buildDataCell(getStatusText(deposit.status ?? 0)),
        buildDataCell(deposit.trackingNumber ?? ''),
        buildDataCell(deposit.amount?.toString().seRagham(separator: ',') ?? ''),
        buildDataCell(deposit.walletWithdraw?.account?.name ?? ''),
        buildDataCell(deposit.wallet?.account?.name ?? ''),
        buildDataCell(deposit.date?.toPersianDate(twoDigits: true) ?? ''),
        buildDataCell(deposit.rowNum.toString(), isCenter: true),
      ],
    );
  }

  pw.Widget buildPageNumber(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'صفحه ${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 10),
      ),
    );
  }

  void clearFilter() {
    nameDepositFilterController.clear();
    nameRequestFilterController.clear();
    mobileFilterController.clear();
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }

  // خروجی pdf
  /*Future<void> exportToPdf() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      // دریافت داده‌ها
      final allDeposits = await depositRepository.getDepositList(
        startIndex: 1,
        toIndex: 5000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
      );
      const itemsPerPage = 15;
      final totalPages = (allDeposits.length / itemsPerPage).ceil();

      final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);

      final pdf = pw.Document();
      for (int page = 0; page < totalPages; page++){
        final start = page * itemsPerPage;
        final end = (page + 1) * itemsPerPage;
        final currentDeposits = allDeposits.sublist(
          start,
          end > allDeposits.length ? allDeposits.length : end,
        );
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            theme: pw.ThemeData.withFont(
              base: ttf,),
            build: (pw.Context context) {
              return pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(3),
                    2: pw.FlexColumnWidth(3),
                    3: pw.FlexColumnWidth(3),
                    4: pw.FlexColumnWidth(3),
                    5: pw.FlexColumnWidth(2.5),
                    6: pw.FlexColumnWidth(1.5),
                  },
                  children: [
                    // هدر جدول
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('وضعیت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10) ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('کد رهگیری', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('مبلغ (ریال)', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('بابت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('نام کاربر', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('تاریخ درخواست', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('ردیف', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    // داده‌ها
                    for (var deposit in currentDeposits)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(getStatusText(deposit.status ?? 0),style: pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(deposit.trackingNumber ?? '',style: pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(deposit.amount?.toString().seRagham(separator: ',') ?? '',style: pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(deposit.walletWithdraw?.account?.name ?? '',style: pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(deposit.wallet?.account?.name ?? '',style: pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(deposit.date?.toPersianDate(twoDigits: true) ?? '',style: pw.TextStyle(fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(deposit.rowNum.toString(),textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 9)),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }

      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..download = 'deposits_${DateTime.now().millisecondsSinceEpoch}.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'deposits.pdf',
        );
      }

      EasyLoading.dismiss();
      Get.snackbar('موفق', 'فایل PDF با موفقیت دریافت شد');
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('خطا', 'خطا در دریافت فایل PDF: ${e.toString()}');
      print(e.toString());
    }
  }*/
}
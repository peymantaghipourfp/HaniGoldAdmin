

import 'dart:io';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/domain/users/model/list_user.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:async';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/user.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';


enum PageStateUser{loading,err,empty,list}

class UserListController extends GetxController{

  Rx<PageStateUser> state=Rx<PageStateUser>(PageStateUser.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  DataPagerController dataPagerController=DataPagerController();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  UserRepository userRepository=UserRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
   RxList<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  RxList<AccountModel> accountList=<AccountModel>[].obs;
  PaginatedModel? paginated;
  BalanceModel? balanceModel;

  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  var sort = true.obs; // or `false`...
  var sortIndex = 0.obs; // or `false`...
  var id = 0.obs; // or `false`...
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex > 0) {
      if (ascending) {
        accountList.sort((a, b) => a.name!.toString().compareTo(b.name!.toString()));
      } else {
        accountList.sort((a, b) => b.name!.toString().compareTo(a.name!.toString()));
      }
    }

    accountList.refresh();
    update();
  }

  setSort(int index,bool val){
    sort.value= val;
    sortIndex.value= index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getUserList();

  }
  void nextPage() {
    if (hasMore.value) {
      currentPageIndex.value++;
      currentPage.value+=7;
      itemsPerPage.value+=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getUserList();

    }
  }

  void previousPage() {
    if (currentPageIndex.value > 1) {
      currentPageIndex.value--;
      currentPage.value-=7;
      itemsPerPage.value-=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getUserList();
    }
  }

  void isChangePage(int index){
       currentPage.value=index*10-10;
       itemsPerPage.value=index*10;
    getUserList();
  }

// آپدیت موقعیت
  Future<void> updateStatus(int status,int id) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await userRepository.updateStatus(status: status, id: id
      );
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
      getUserList();
      update();
    }
    catch (e) {
     // state.value = PageStateUser.err;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // لیست کاربران
  Future<void> getUserList() async {
    print("getTransactionInfoList : 1");
    isOpenMore.value = false;
    accountList.clear();
    try {
       state.value=PageStateUser.loading;
      var response = await userRepository.getUserList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value, name: nameFilterController.text, mobile: mobileFilterController.text,
          );
      accountList.addAll(response.accounts??[]);
      paginated=response.paginated;
       // nameFilterController.text="";
       // mobileFilterController.text="";
    //  print(paginated?.totalCount??0);
       state.value=PageStateUser.list;
      isOpenMore.value = true;

      update();
    }
    catch (e) {
      state.value = PageStateUser.err;
    } finally {}
  }

  // خروجی اکسل
  Future<void> exportToExcel() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final excel = Excel.createExcel();
      final sheet = excel['کاربران'];

      sheet.appendRow([
        TextCellValue('ردیف'),
        TextCellValue('نام کاربر'),
        TextCellValue('موبایل'),
        TextCellValue('وضعیت'),
        TextCellValue('نقش'),
        TextCellValue('تاریخ ثبت نام'),
      ]);
      EasyLoading.show(status: 'دریافت فایل اکسل...');
      var response = await userRepository.getUserListExport(
        startIndex: 0,
        toIndex: 100000,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      for (var user in response.accounts!) {
        sheet.appendRow([
          TextCellValue(user.rowNum.toString()),
          TextCellValue(user.name ?? ''),
          TextCellValue(user.contactInfo ?? ''),
          TextCellValue(getStatusText(user.status ?? 0 )),
          TextCellValue(''),
          TextCellValue(user.startDate?.toPersianDate(twoDigits: true) ?? ''),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception('خطا در دریافت فایل');
      final uint8List = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'users_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
      }else {
        final output = await getDownloadsDirectory();
        final filePath = '${output?.path}/users_${DateTime
            .now()
            .millisecondsSinceEpoch}.xlsx';
        final fileBytes = excel.encode();
        if (fileBytes != null) {
          await File(filePath).writeAsBytes(uint8List);

          await FileSaver.instance.saveFile(
            name: 'users',
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
        return 'رد شده';
      case 1:
        return 'تایید شده';
      default:
        return 'نامعتبر';
    }
  }

  // خروجی pdf
  Future<void> exportToPdf() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      var response = await userRepository.getUserListExport(
        startIndex: 0,
        toIndex: 100000,
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
                for (var user in response.accounts!)
                  buildDataRow(user),
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
          ..download = 'users_${DateTime.now().millisecondsSinceEpoch}.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'users.pdf',
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
      0: pw.FlexColumnWidth(3),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(2),
      3: pw.FlexColumnWidth(2.5),
      4: pw.FlexColumnWidth(3),
      5: pw.FlexColumnWidth(1.5),
    };
  }
  // ساخت هدر جدول
  pw.Table buildHeaderTable() {
    return pw.Table(
      columnWidths: {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(2.5),
        4: pw.FlexColumnWidth(3),
        5: pw.FlexColumnWidth(1.5),
      },
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('تاریخ درخواست', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('نقش', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('وضعیت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('موبایل', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('نام کاربر', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 10)),
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

  pw.TableRow buildDataRow(AccountModel user) {
    return pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        buildDataCell(user.startDate?.toPersianDate(twoDigits: true) ?? ''),
        buildDataCell(''),
        buildDataCell(getStatusText(user.status ?? 0)),
        buildDataCell(user.contactInfo ?? ''),
        buildDataCell(user.name ?? ''),
        buildDataCell(user.rowNum.toString(), isCenter: true),
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
    nameFilterController.clear();
    mobileFilterController.clear();
  }

}
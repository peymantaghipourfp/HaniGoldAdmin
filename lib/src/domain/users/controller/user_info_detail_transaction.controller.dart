

import 'dart:async';
import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



enum PageStateDe{loading,err,empty,list}

class UserInfoDetailTransactionController extends GetxController{

  Rx<PageStateDe> state=Rx<PageStateDe>(PageStateDe.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
   RxList<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  RxList<TransactionInfoItemModel> transactionInfoList=<TransactionInfoItemModel>[].obs;
  RxList<TransactionInfoItemModel> transactionInfoListPdf=<TransactionInfoItemModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
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
    if (columnIndex == 0) {
      if (ascending) {
        transactionInfoList.sort((a, b) => a.toWallet!.account!.name!.toString().compareTo(b.toWallet!.account!.name!.toString()));
      } else {
        transactionInfoList.sort((a, b) => b.toWallet!.account!.name!.toString().compareTo(a.toWallet!.account!.name!.toString()));
      }
    }

    transactionInfoList.refresh();
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
    print(int.parse(Get.parameters['accountId']!));
    id.value=int.parse(Get.parameters['accountId']!);
    getHeaderTransaction(int.parse(Get.parameters['accountId']!));
    getTransactionInfoListPager(id.value.toString());

  }

  /*void nextPage() {
    if (hasMore.value) {
      currentPageIndex.value++;
      currentPage.value+=7;
      itemsPerPage.value+=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getTransactionInfoListPager(id.value.toString());

    }
  }*/

  /*void previousPage() {
    if (currentPageIndex.value > 1) {
      currentPageIndex.value--;
      currentPage.value-=7;
      itemsPerPage.value-=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getTransactionInfoListPager(id.value.toString());
    }
  }*/



  // هدر مانده کاربر
  Future<void> getHeaderTransaction(int id) async{
    print("getHeaderTransaction : $id");
    try{
      state.value=PageStateDe.loading;
      var response=await userInfoTransactionRepository.getHeaderUserInfoTransaction(id);
      headerInfoUserTransactionModel=response;
     state.value=PageStateDe.list;
      getBalanceList(id);
      if(headerInfoUserTransactionModel==null){
        state.value=PageStateDe.empty;
      }
      update();
    }
    catch(e){
     // state.value=PageState.err;
    }finally{
    }
  }
  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    balanceList.clear();
    try{
      state.value=PageStateDe.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      state.value=PageStateDe.list;
      // if(balanceList.isEmpty){
      //   state.value=PageState.empty;
      // }
      update();
    }
    catch(e){
      //state.value=PageState.err;
    }finally{
    }
  }

  void isChangePage(int index){
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value=index*10;
    getTransactionInfoListPager(id.value.toString());
  }

  // لیست تراکنش های کاربر
  Future<void> getTransactionInfoListPager(String id) async {
    print("getTransactionInfoListPager ::::::::: 1");
    transactionInfoList.clear();
    isOpenMore.value=true;
    try {
      //state.value=PageStateDe.loading;
      var response = await userInfoTransactionRepository.getTransactionInfoListPager(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          accountId: id,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      isOpenMore.value=false;
      transactionInfoList.addAll(response.transactionInfoItems ?? []);
      print(transactionInfoList.length);
      paginated.value=response.paginated;
     //state.value=PageStateDe.list;
      update();
    }
    catch (e) {
      state.value = PageStateDe.err;
    } finally {}
  }

  //فایل اکسل
  Future<void> getUserInfoTransactionDetailExcel() async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await userInfoTransactionRepository.getUserInfoTransactionDetailExcel(
        accountId: id.value == 0 ? null : id.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      String fileName = 'userTransaction_${DateTime.now().toIso8601String()} ${headerInfoUserTransactionModel?.accountName}.xlsx';

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
      state.value = PageStateDe.err;
      "خطا در دریافت فایل اکسل: ${e.toString()}";
      Get.snackbar(
        'خطا',
        'خطا در دریافت فایل اکسل',
        snackPosition: SnackPosition.BOTTOM,
      );
    }finally{
      isLoading.value=false;
    }
  }

  Future<void> captureBalanceScreenshot(BuildContext context, GlobalKey balanceKey) async {
    try {
      RenderRepaintBoundary boundary = balanceKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        if (kIsWeb) {
          final blob = html.Blob([pngBytes], 'image/png');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'user_balance_screenshot_${headerInfoUserTransactionModel?.accountName}.png')
            ..click();
          html.Url.revokeObjectUrl(url);
          Get.snackbar('موفق', 'اسکرین شات با موفقیت ذخیره شد.');
        } else {
          await FileSaver.instance.saveFile(
            name: "user_balance_screenshot_${headerInfoUserTransactionModel?.accountName}",
            bytes: pngBytes,
            ext: 'png',
            mimeType: MimeType.png,
          );
          Get.snackbar('موفق', 'اسکرین شات با موفقیت ذخیره شد.');
        }
      }
    } catch (e) {
      Get.snackbar('خطا', 'ثبت اسکرین شات ناموفق بود: $e');
    }
  }

  String getTypeText(String type) {
    switch (type) {
      case 'issue':
        return 'حواله';
      case "payment":
        return 'پرداخت';
      case "receive":
        return 'دریافت';
      case "reciept":
        return 'برگشت';
      case "sell":
        return 'فروش';
      case "buy":
        return 'خرید';
      case "deposit":
        return 'واریز';
      case "withdraw":
        return 'برداشت';
      default:
        return 'نامعتبر';
    }
  }

  // خروجی Pdf
  Future<void> exportToPdf(String id) async {
    try {

      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      var response = await userInfoTransactionRepository.getTransactionInfoListForPdf(
        startIndex: 1,
        toIndex: 100000,
        accountId: id,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      transactionInfoListPdf.assignAll(response.transactionInfoItems ?? []);
      final List<TransactionInfoItemModel> allTransactions = transactionInfoListPdf;
      final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          textDirection: pw.TextDirection.rtl,
          maxPages: 2000,
          theme: pw.ThemeData.withFont(base: ttf, fontFallback: [ttf]),
          header: (pw.Context context) => buildHeaderTablePdf(),
          build: (pw.Context context) => [
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: getColumnWidthsPdf(),
              children: [
                for (var tx in allTransactions)
                  buildDataRowPdf(tx),
              ],
            ),
          ],
          footer: (pw.Context context) => buildPageNumberPdf(context.pageNumber, context.pagesCount),
        ),
      );

      final bytes = await pdf.save();
      final fileName = 'user_transactions_${headerInfoUserTransactionModel?.accountName ?? ''}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..download = fileName
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
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

  Map<int, pw.TableColumnWidth> getColumnWidthsPdf() {
    return {

      0: pw.FlexColumnWidth(2.5), // مانده سکه
      1: pw.FlexColumnWidth(2.5), // مانده ریالی
      2: pw.FlexColumnWidth(2.5), // مانده طلایی
      3: pw.FlexColumnWidth(2.5), // به مظنه
      4: pw.FlexColumnWidth(3), // به حساب
      5: pw.FlexColumnWidth(3), // از حساب
      6: pw.FlexColumnWidth(3), // توضیحات
      7: pw.FlexColumnWidth(3), // مبلغ
      8: pw.FlexColumnWidth(3), // شرح
      9: pw.FlexColumnWidth(2.5), // نوع تراکنش
      10: pw.FlexColumnWidth(3), // تاریخ
      11: pw.FlexColumnWidth(1.7), // ردیف
    };
  }

  pw.Table buildHeaderTablePdf() {
    return pw.Table(
      columnWidths: getColumnWidthsPdf(),
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            buildDataCellPdf('مانده سکه', isCenter: true),
            buildDataCellPdf('مانده ریالی', isCenter: true),
            buildDataCellPdf('مانده طلایی', isCenter: true),
            buildDataCellPdf('به مظنه', isCenter: true),
            buildDataCellPdf('به حساب', isCenter: true),
            buildDataCellPdf('از حساب', isCenter: true),
            buildDataCellPdf('توضیحات', isCenter: true),
            buildDataCellPdf('مبلغ', isCenter: true),
            buildDataCellPdf('شرح', isCenter: true),
            buildDataCellPdf('نوع', isCenter: true),
            buildDataCellPdf('تاریخ', isCenter: true),
            buildDataCellPdf('ردیف', isCenter: true),
          ],
        ),
      ],
    );
  }

  pw.Padding buildDataCellPdf(String text, {bool isCenter = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 8),
        textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.right,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.TableRow buildDataRowPdf(TransactionInfoItemModel tx) {
    String goldBalance = tx.balances?.where((b) => b.unitName == "گرم").map((b) => "${b.balance ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String rialBalance = tx.balances?.where((b) => b.unitName == "ریال").map((b) => "${b.balance?.toInt().toString().seRagham(separator: ',') ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String coinBalance = tx.balances?.where((b) => b.unitName == "عدد").map((b) => "${b.balance ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';

    String price = '';

    if (tx.type == 'sell' || tx.type == 'buy') {
      price = tx.price?.toString().seRagham(separator: ',') ?? '';
    }

    return pw.TableRow(
      children: [
        buildDataCellPdf(coinBalance,isCenter: true),
        buildDataCellPdf(rialBalance,isCenter: true),
        buildDataCellPdf(goldBalance,isCenter: true),
        buildDataCellPdf(price,isCenter: true),
        buildDataCellPdf(tx.toWallet?.account?.name ?? '',isCenter: true),
        buildDataCellPdf(tx.wallet?.account?.name ?? '',isCenter: true),
        buildDataCellPdf(tx.description ?? '',isCenter: true),
        buildDataCellPdf(tx.amount?.toString().seRagham(separator: ',') ?? '',isCenter: true),
        buildDataCellPdf(tx.details != null && tx.details!.isNotEmpty ? tx.details!.map((e) => "عیار: ${e.carat ?? 0} مقدار: ${e.quantity ?? 0}وزن: ${e.weight ?? 0} ناخالصی: ${e.impurity ?? 0} نام آزمایشگاه: ${e.laboratoryName ?? ''} شماره آزمایشگاه: ${e.laboratoryId ?? 0}").join(' | ') : (tx.item?.itemUnit?.id == 1 ? "${tx.amount} عدد ${tx.item?.name ?? ''}" : tx.item?.itemUnit?.id == 2 ? "${tx.amount} گرم ${tx.item?.name ?? ''}" : "${tx.amount.toString().seRagham().toPersianDigit()} ریال ${tx.item?.name ?? ''}")),
        buildDataCellPdf(getTypeText(tx.type ?? ''),isCenter: true),
        buildDataCellPdf(tx.date?.toPersianDate() ?? '',isCenter: true),
        buildDataCellPdf((tx.rowNum ?? '').toString(),isCenter: true),
      ],
    );
  }

  pw.Widget buildPageNumberPdf(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
          'صفحه${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
      style: pw.TextStyle(fontSize: 8),
    ),
    );
  }

  void clearFilter() {
    paginated.value==null;
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }
}
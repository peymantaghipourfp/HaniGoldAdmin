
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/laboratory.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/transaction.repository.dart';
import '../../../config/repository/url/base_url.dart';
import '../../account/model/account.model.dart';
import '../../users/model/paginated.model.dart';
import '../../users/model/transaction_item.model.dart';
import '../model/transaction_item.model.dart';
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';


enum PageStateTrans{loading,err,empty,list}

class TypeModel{
  final String? type;
  final String? name;
  TypeModel({this.type, this.name});
}

class TransactionController extends GetxController{

  Rx<PageStateTrans> state=Rx<PageStateTrans>(PageStateTrans.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  var isChecked=false.obs;
  var isLoading=false.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  var typeFilter1="".obs;
  String? typeFilter;
  final List<TypeModel> typeList=<TypeModel>[].obs;

  final RemittanceRepository remittanceRepository=RemittanceRepository();
  final AccountRepository accountRepository=AccountRepository();
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController namePayerController=TextEditingController();
  final TextEditingController nameRecieptController=TextEditingController();
  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;
  TransactionRepository transactionRepository=TransactionRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  RxList<TransactionModel> transactionList = <TransactionModel>[].obs;
  RxList<TransactionModel> transactionListPdf = <TransactionModel>[].obs;
  final TextEditingController nameController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  final TextEditingController addressController=TextEditingController();
  RxList<String> imageList = <String>[].obs;
  PaginatedModel? paginated;
  var sort = true.obs; // or `false`...
  var errorMessage = "".obs;
  var sortIndex = 0.obs; // or `false`...
  final PageController pageController = PageController();
  RxInt currentImagePage = 0.obs;
  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  @override
  void onInit() {
    fetchTransactionList();
    typeList.addAll([
      TypeModel(type:null, name: 'انتخاب کنید'),
      TypeModel(type:'issue',name: 'حواله'),
      TypeModel(type:'payment',name: 'پرداخت'),
      TypeModel(type:'receive',name: 'دریافت'),
      TypeModel(type:'sales',name: 'فروش'),
      TypeModel(type:'buy',name: 'خرید'),
      TypeModel(type:'deposit',name: 'واریز'),
    ]);
    super.onInit();
  }

  void changeSelectedType(String newValue) {
    typeFilter = newValue;
    for(int i=0;i<typeList.length;i++){
      if(newValue==typeList[i].name){
        typeFilter1.value=typeList[i].type!;
      }
    }
    update();
    print(typeFilter1.value);
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    if (columnIndex == 2) { // Date column
      transactionList.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return ascending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!);
      });
    }else if (columnIndex == 5) { // Name column
      transactionList.sort((a, b) {
        final aQuantity = a.amount ?? 0;
        final bQuantity = b.amount ?? 0;
        return ascending ? aQuantity.compareTo(bQuantity) : bQuantity.compareTo(aQuantity);
      });
    }
  }

  void isChangePage(int index){
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value=index*10;
    fetchTransactionList();
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
      errorMessage.value="خطا در جستجوی کاربران: ${e.toString()}";
    }
  }

  void selectAccount(AccountModel account) {
    currentPage.value = 1;
    selectedAccountId.value = account.id!;
    searchController.text = account.name!;
    Get.back(); // Close search dialog
    fetchTransactionList();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    fetchTransactionList();
  }

  // لیست عکس ها
  Future<void> getImage(String fileName,String type) async{
    print('تعداد image:');
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    imageList.clear();
    try{
      var fetch=await remittanceRepository.getImage(fileName: fileName, type: type);
      imageList.addAll(fetch.guidIds );
      print('تعداد image:${imageList.first}');
      imageList.refresh();
      update();
    }
    catch(e){
      //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      EasyLoading.dismiss();
    }
  }

  void downloadImage(String guidId) async {
    if (kIsWeb){
      final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
      final anchor = html.AnchorElement(href: url)
        ..download = "image_$guidId"
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      anchor.remove();
    }else{
      try {
        final status = await Permission.storage.request();
        if (!status.isGranted) return;

        final dio = Dio();
        final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir == null) {
          throw Exception('Could not access downloads directory');
        }
        String fileExtension = path.extension(guidId);
        if(fileExtension.isEmpty) fileExtension = '.png';
        final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
        final savePath = path.join(downloadsDir.path, fileName);
        /*final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/images_$guidId.png';*/
        await dio.download(url, savePath);
        print(savePath);
        Get.snackbar(
          'موفقیت',
          'تصویر با موفقیت ذخیره شد',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'خطا',
          'خطا در دانلود تصویر: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
  // لیست تراکنش ها ها
  Future<void> fetchTransactionList()async{
    transactionList.clear();
    try{
      state.value=PageStateTrans.loading;
      var response=await transactionRepository.getTransactionList(
        startIndex: currentPage.value,
        toIndex:  itemsPerPage.value,
        name:nameFilterController.text,
        type: typeFilter1.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      transactionList.assignAll((response.transactionJournals??[]));
      print(transactionList.length);
      paginated=response.paginated;
      state.value=PageStateTrans.list;
    }
    catch(e){
      state.value=PageStateTrans.err;
    }
  }


  void clearFilter() {
    nameFilterController.clear();
    dateStartController.clear();
    typeFilter1.value='';
    typeFilter='انتخاب کنید';
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }

  // خروجی اکسل
  Future<void> exportToExcel() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final excel = Excel.createExcel();
      final sheet = excel['تراکنش ها'];

      sheet.appendRow([
        TextCellValue('ردیف'),
        TextCellValue('نوع'),
        TextCellValue('تاریخ'),
        TextCellValue('نام کاربر'),
        TextCellValue('شرح'),
        TextCellValue('مقدار'),
        TextCellValue('مانده ریالی'),
        TextCellValue('مانده طلایی'),
        TextCellValue('مانده سکه'),
        TextCellValue('مانده ریالی بستانکار'),
        TextCellValue('مانده طلایی بستانکار'),
        TextCellValue('مانده سکه بستانکار'),
      ]);
      EasyLoading.show(status: 'دریافت فایل اکسل...');
      final alltransactions = await transactionRepository.getTransactionList(
        startIndex: 1,
        toIndex: 1000000,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      for (var transaction in alltransactions.transactionJournals!) {
        sheet.appendRow([
          TextCellValue(transaction.rowNum.toString()),
          TextCellValue(getTypeText(transaction.type ?? '' )),
          TextCellValue(transaction.date?.toPersianDate() ?? ''),
          TextCellValue(transaction.toAccount!=null ? "از: ${transaction.account?.name ?? ''}  به:${transaction.toAccount?.name ?? ''}" : transaction.account?.name ?? '' ),
          transaction.details!.isNotEmpty ?
          TextCellValue(
              " ${transaction.details?.map((e)=> {"عیار: ${e.carat ?? 0}","مقدار: ${e.quantity ?? 0}","ناخالصی: ${e.impurity ?? 0}","نام آزمایشگاه: ${e.name ?? ""}"}).toList()} "
          ) :
          TextCellValue(
          transaction.item?.itemUnit?.id==1 ? "${transaction.amount} عدد ${transaction.item?.name ?? ''} \n ${transaction.price != null ? "قیمت واحد: ${transaction.price.toString().seRagham() ?? 0} ریال " "-" "${transaction.totalPrice.toString().seRagham() ?? 0} ریال " : '' }"
              : transaction.item?.itemUnit?.id==2 ? "${transaction.amount} گرم ${transaction.item?.name ?? ''} \n ${transaction.price != null ? "قیمت واحد: ${transaction.price.toString().seRagham() ?? 0} ریال " "-" "${transaction.totalPrice.toString().seRagham() ?? 0} ریال " : '' }" :
          "${transaction.amount.toString().seRagham().toPersianDigit()} ریال ${transaction.item?.name ?? ''} \n ${transaction.price != null ? "قیمت واحد: ${transaction.price.toString().seRagham() ?? 0} ریال " "-" "${transaction.totalPrice.toString().seRagham() ?? 0} ریال " : '' }"
          ),
          TextCellValue(
              transaction.item?.itemUnit?.id==1 ? "${transaction.amount} عدد "
                  : transaction.item?.itemUnit?.id==2 ? "${transaction.amount} گرم " :
              "${transaction.amount.toString().seRagham().toPersianDigit()} ریال "
          ),
          TextCellValue("${transaction.balances?.where((e) => e.unitName == "ریال").map((e)=> "\u202B${e.balance.toString().seRagham() ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
          TextCellValue("${transaction.balances?.where((e) => e.unitName == "گرم").map((e)=> "\u202B${e.balance.toString().seRagham() ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
          TextCellValue("${transaction.balances?.where((e) => e.unitName == "عدد").map((e)=> "\u202B${e.balance.toString().seRagham() ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
          TextCellValue("${transaction.tobalances?.where((e) => e.unitName == "ریال").map((e)=> "\u202B${e.balance.toString().seRagham() ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
          TextCellValue("${transaction.tobalances?.where((e) => e.unitName == "گرم").map((e)=> "\u202B${e.balance.toString().seRagham() ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
          TextCellValue("${transaction.tobalances?.where((e) => e.unitName == "عدد").map((e)=> "\u202B${e.balance.toString().seRagham() ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception('خطا در دریافت فایل');
      final uint8List = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'transactions_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
      }else {
        final output = await getDownloadsDirectory();
        final filePath = '${output?.path}/transactions_${DateTime
            .now()
            .millisecondsSinceEpoch}.xlsx';
        final fileBytes = excel.encode();
        if (fileBytes != null) {
          await File(filePath).writeAsBytes(uint8List);

          await FileSaver.instance.saveFile(
            name: 'inventories',
            bytes: uint8List,
            ext: 'xlsx',
            mimeType: MimeType.microsoftExcel,
          );
        }
      }
      Get.snackbar('موفق', 'فایل اکسل با موفقیت دریافت شد');
      EasyLoading.dismiss();
    } catch (e) {
      Get.snackbar('خطا', 'خطا در دریافت فایل اکسل: ${e.toString()}');
      EasyLoading.dismiss();
      print(e.toString());
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
      case "sales":
        return 'فروش';
      case "buy":
        return 'خرید';
      case "deposit":
        return 'واریز';
      default:
        return 'نامعتبر';
    }
  }

  // اسکرین شات
  Future<void> captureRowScreenshot(TransactionModel transaction, GlobalKey dataTableKey, Map<int, GlobalKey> rowKeys) async {
    final rowKey = rowKeys[transaction.id!];
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
          ..setAttribute('download', 'row_screenshot_${transaction.id}.png')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await FileSaver.instance.saveFile(
          name: "row_screenshot_${transaction.id}",
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

  // خروجی pdf
  Future<void> exportToPdf() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');
      var response=await transactionRepository.getTransactionList(
        startIndex: 1,
        toIndex:  100000,
        name:nameFilterController.text,
        type: typeFilter1.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      transactionListPdf.assignAll((response.transactionJournals??[]));
      final List<TransactionModel> allTransactions = transactionListPdf;
      final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      final pdf = pw.Document();
      pdf.addPage(
          pw.MultiPage(
              pageFormat: PdfPageFormat.a4.landscape,
              textDirection: pw.TextDirection.rtl,
              maxPages: 2000,
              theme: pw.ThemeData.withFont(base: ttf, fontFallback: [ttf]),
              header: (pw.Context context) {
                return pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: getColumnWidthsPdf(),
              children: [
                buildHeaderTablePdf(),
                ],
                );
              },
            build: (pw.Context context) {
              return [
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: getColumnWidthsPdf(),
                  children: [
                    for (var tx in allTransactions) buildDataRowPdf(tx),
                  ],
                )
              ];
            },
            footer: (pw.Context context) {
              return buildPageNumberPdf(context.pageNumber, context.pagesCount);
            },
          ),
      );
      final bytes = await pdf.save();
      final fileName = 'transactions_${DateTime.now().millisecondsSinceEpoch}.pdf';
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
      0: pw.FlexColumnWidth(2.5), // مانده سکه بستانکار
      1: pw.FlexColumnWidth(2.5), // مانده طلایی بستانکار
      2: pw.FlexColumnWidth(2.5), // مانده ریالی بستانکار
      3: pw.FlexColumnWidth(2.5), // مانده سکه
      4: pw.FlexColumnWidth(2.5), // مانده طلایی
      5: pw.FlexColumnWidth(2.5), // مانده ریالی
      6: pw.FlexColumnWidth(2.5), // قیمت کل
      7: pw.FlexColumnWidth(2.5), // قیمت واحد
      8: pw.FlexColumnWidth(3), // مقدار
      9: pw.FlexColumnWidth(3), // شرح
      10: pw.FlexColumnWidth(3), // کاربر
      11: pw.FlexColumnWidth(3), // تاریخ
      12: pw.FlexColumnWidth(3), // نوع
      13: pw.FlexColumnWidth(2), // ردیف
    };
  }

  pw.TableRow buildHeaderTablePdf() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        buildDataCellPdf('مانده سکه بستانکار', isCenter: true),
        buildDataCellPdf('مانده طلایی بستانکار', isCenter: true),
        buildDataCellPdf('مانده ریالی بستانکار', isCenter: true),
        buildDataCellPdf('مانده سکه', isCenter: true),
        buildDataCellPdf('مانده طلایی', isCenter: true),
        buildDataCellPdf('مانده ریالی', isCenter: true),
        buildDataCellPdf('قیمت کل', isCenter: true),
        buildDataCellPdf('قیمت واحد', isCenter: true),
        buildDataCellPdf('مقدار', isCenter: true),
        buildDataCellPdf('شرح', isCenter: true),
        buildDataCellPdf('کاربر', isCenter: true),
        buildDataCellPdf('تاریخ', isCenter: true),
        buildDataCellPdf('نوع', isCenter: true),
        buildDataCellPdf('ردیف', isCenter: true),
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

  pw.TableRow buildDataRowPdf(TransactionModel tx) {
    String rialBalance = tx.balances?.where((b) => b.unitName == "ریال").map((b) => "${b.balance?.toString().seRagham(separator: ',') ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String goldBalance = tx.balances?.where((b) => b.unitName == "گرم").map((b) => "${b.balance ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String coinBalance = tx.balances?.where((b) => b.unitName == "عدد").map((b) => "${b.balance ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String toRialBalance = tx.tobalances?.where((b) => b.unitName == "ریال").map((b) => "${b.balance?.toString().seRagham(separator: ',') ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String toGoldBalance = tx.tobalances?.where((b) => b.unitName == "گرم").map((b) => "${b.balance ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String toCoinBalance = tx.tobalances?.where((b) => b.unitName == "عدد").map((b) => "${b.balance ?? ''} ${b.unitName ?? ''} ${b.itemName ?? ''}").join(", ") ?? '';
    String price = '';
    String totalPrice = '';

    if (tx.type == 'sales' || tx.type == 'buy') {
      price = tx.price?.toString().seRagham(separator: ',') ?? '';
      totalPrice=tx.totalPrice?.toString().seRagham(separator: ',') ?? '';

    }

    return pw.TableRow(
      children: [
        buildDataCellPdf(toCoinBalance,isCenter: true),
        buildDataCellPdf(toGoldBalance,isCenter: true),
        buildDataCellPdf(toRialBalance,isCenter: true),
        buildDataCellPdf(coinBalance,isCenter: true),
        buildDataCellPdf(goldBalance,isCenter: true),
        buildDataCellPdf(rialBalance,isCenter: true),
        buildDataCellPdf(totalPrice,isCenter: true),
        buildDataCellPdf(price,isCenter: true),
        buildDataCellPdf(tx.item?.itemUnit?.id == 1 ? "${tx.amount} عدد " : tx.item?.itemUnit?.id == 2 ? "${tx.amount} گرم " : "${tx.amount.toString().seRagham().toPersianDigit()} ریال ",isCenter: true),
        buildDataCellPdf(tx.details != null && tx.details!.isNotEmpty ? tx.details!.map((e) => "عیار: ${e.carat ?? 0} مقدار: ${e.quantity ?? 0} ناخالصی: ${e.impurity ?? 0} نام آزمایشگاه: ${e.name ?? ''}").join(' | ') : (tx.item?.itemUnit?.id == 1 ? "${tx.amount} عدد ${tx.item?.name ?? ''}" : tx.item?.itemUnit?.id == 2 ? "${tx.amount} گرم ${tx.item?.name ?? ''}" : "${tx.amount.toString().seRagham().toPersianDigit()} ریال ${tx.item?.name ?? ''}"),isCenter: true),
        buildDataCellPdf(tx.toAccount != null ? "از: ${tx.account?.name ?? ''}  به:${tx.toAccount?.name ?? ''}" : tx.account?.name ?? '',isCenter: true),
        buildDataCellPdf(tx.date?.toPersianDate() ?? '',isCenter: true),
        buildDataCellPdf(getTypeText(tx.type ?? ''),isCenter: true),
        buildDataCellPdf((tx.rowNum ?? '').toString(),isCenter: true),
      ],
    );
  }

  pw.Widget buildPageNumberPdf(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'صفحه ${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }
}


import 'dart:async';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_report_gold.model.dart';
import 'package:hanigold_admin/src/domain/users/service/gold_transaction_invoice_generation_without_balance.service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../config/repository/wallet.repository.dart';
import '../../account/model/social.model.dart';
import '../../product/model/item.model.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/paginated.model.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path;
import 'package:printing/printing.dart';
import '../service/gold_transaction_invoice_generation.service.dart';



enum PageStateDe{loading,err,empty,list}
class TypeModel{
  final String? type;
  final String? name;
  TypeModel({this.type, this.name});
}
class UserInfoDetailGoldTransactionController extends GetxController{

  Rx<PageStateDe> state=Rx<PageStateDe>(PageStateDe.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 25.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final RemittanceRepository remittanceRepository=RemittanceRepository();
  final ItemRepository itemRepository=ItemRepository();
  final AccountRepository accountRepository=AccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerMobile = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController descriptionFilterController=TextEditingController();
  final TextEditingController amountFilterController=TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
  RxList<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  RxList<TransactionReportGoldModel> transactionInfoGoldList=<TransactionReportGoldModel>[].obs;
  RxList<TransactionReportGoldModel> transactionInfoGoldListPdf=<TransactionReportGoldModel>[].obs;
  final Rxn<ItemModel> selectedItemFilter=Rxn<ItemModel>();
  final List<ItemModel> itemList=<ItemModel>[].obs;
  RxList<String> imageList = <String>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  BalanceModel? balanceModel;
  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var isLoadingTransfer=false.obs;
  var isLoadingChecked=false.obs;
  var isLoadingCheckedAll=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  var sort = true.obs; // or `false`...
  var sortIndex = 0.obs; // or `false`...
  var id = 0.obs; // or `false`...
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  var descriptionFilter=''.obs;
  var amountFilter=''.obs;
  var errorMessage = "".obs;
  final PageController pageController = PageController();
  RxInt currentImagePage = 0.obs;
  RxString typeFilter1="".obs;
  RxString typeFilter="انتخاب کنید".obs;
  final List<TypeModel> typeList=<TypeModel>[].obs;
  final Rxn<SocialModel> socialStatus = Rxn<SocialModel>();
  var isLoadingSocialStatus = false.obs;


  void changeSelectedType(String newValue) {
    typeFilter.value = newValue;
    for(int i=0;i<typeList.length;i++){
      if(newValue==typeList[i].name){
        typeFilter1.value=typeList[i].type!;
      }
    }
    update();
  }

  void changeSelectedItemFilter(ItemModel? newValue) {
    selectedItemFilter.value = newValue;
    update();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        transactionInfoGoldList.sort((a, b) => a.account!.name!.toString().compareTo(b.account!.name!.toString()));
      } else {
        transactionInfoGoldList.sort((a, b) => b.account!.name!.toString().compareTo(a.account!.name!.toString()));
      }
    }

    transactionInfoGoldList.refresh();
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
    id.value=int.parse(Get.parameters['accountId']!);
    getHeaderTransaction(int.parse(Get.parameters['accountId']!));
    getTransactionInfoGoldListPager(id.value.toString());
    fetchItemList();
    setupScrollListener();
    typeList.addAll([
      TypeModel(type:null, name: 'انتخاب کنید'),
      TypeModel(type:'issue',name: 'حواله دریافتی'),
      TypeModel(type:'reciept',name: 'حواله پرداختی'),
      TypeModel(type:'payment',name: 'پرداخت'),
      TypeModel(type:'receive',name: 'دریافت'),
      TypeModel(type:'sell',name: 'فروش'),
      TypeModel(type:'buy',name: 'خرید'),
      TypeModel(type:'buy,sell',name: 'خرید و فروش'),
      TypeModel(type:'deposit',name: 'واریز'),
      TypeModel(type:'withdraw',name: 'برداشت'),
      TypeModel(type:'initial',name: 'اول دوره'),
    ]);
  }
  @override void onClose() {
    scrollControllerMobile.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollControllerMobile.addListener(() {
      if (scrollControllerMobile.position.pixels >=
          scrollControllerMobile.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value &&
          !isOpenMore.value) {
        loadMore();
      }
    });
  }
  Future<void> loadMore() async {
    // بررسی شرایط برای بارگذاری بیشتر
    if (scrollControllerMobile.hasClients &&
        hasMore.value &&
        !isLoading.value &&
        !isOpenMore.value) {

      isLoading.value = true;
      final nextPage = currentPage.value + 1;

      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;

        var fetchedListTransactionInfo = await userInfoTransactionRepository.getTransactionInfoGoldListPager(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: id.value.toString(),
          startDate: startDateFilter.value,
          endDate: endDateFilter.value,
          type: typeFilter1.value,
          descriptionFilter: descriptionFilter.value,
          amountFilter: amountFilter.value,
          item: selectedItemFilter.value?.id,
        );

        if (fetchedListTransactionInfo.transactionReportGolds!.isNotEmpty) {
          transactionInfoGoldList.addAll(fetchedListTransactionInfo.transactionReportGolds ?? []);
          currentPage.value = nextPage;

          hasMore.value = fetchedListTransactionInfo.transactionReportGolds!.length >= itemsPerPage.value;

          paginated.value = fetchedListTransactionInfo.paginated;

          transactionInfoGoldList.refresh();
          update();
        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false;
        print("خطا در بارگذاری بیشتر: ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }



  /*void nextPage() {
    if (hasMore.value) {
      currentPageIndex.value++;
      currentPage.value+=7;
      itemsPerPage.value+=7;
      getTransactionInfoListPager(id.value.toString());

    }
  }*/

  /*void previousPage() {
    if (currentPageIndex.value > 1) {
      currentPageIndex.value--;
      currentPage.value-=7;
      itemsPerPage.value-=7;
      getTransactionInfoListPager(id.value.toString());
    }
  }*/



  // هدر مانده کاربر
  Future<void> getHeaderTransaction(int id) async{
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

  // انتقال ولت
  Future<void> getChangeOneWallet(int accountId,int itemId) async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoadingTransfer.value=true;
      var response=await userInfoTransactionRepository.getChangeOneWallet(accountId,itemId);
      if(response!= null){

        Get.snackbar("تغییر ولت", "موفقیت آمیز",
            titleText: Text("تغییر ولت",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text("موفقیت آمیز" , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getBalanceList(id.value);
        getTransactionInfoGoldListPager(id.value.toString());
      }
      isLoadingTransfer.value=false;
    }
    catch(e){
      EasyLoading.dismiss();
      //state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
  }

  void isChangePage(int index){
    currentPage.value=(index*25-25)+1;
    itemsPerPage.value=index*25;
    getTransactionInfoGoldListPager(id.value.toString());
  }

  // لیست عکس ها
  Future<void> getImage(String fileName,String type) async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    imageList.clear();
    try{
      var fetch=await remittanceRepository.getImage(fileName: fileName, type: type);
      imageList.addAll(fetch.guidIds );
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

  // لیست محصولات
  Future<void> fetchItemList() async{
    try{
      // state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      //  state.value=PageState.list;
      if(itemList.isEmpty){
        //   state.value=PageState.empty;
      }
    }
    catch(e){
      // state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{

    }
  }

  // لیست تراکنش های کاربر
  Future<void> getTransactionInfoGoldListPager(String id) async {
    transactionInfoGoldList.clear();
    isOpenMore.value=true;
    try {
      //state.value=PageStateDe.loading;
      var response = await userInfoTransactionRepository.getTransactionInfoGoldListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        accountId: id,
        type: typeFilter1.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
        descriptionFilter: descriptionFilter.value,
        amountFilter: amountFilter.value,
        item: selectedItemFilter.value?.id,
      );
      isOpenMore.value=false;
      transactionInfoGoldList.addAll(response.transactionReportGolds ?? []);
      paginated.value=response.paginated;
      //state.value=PageStateDe.list;
      update();
    }
    catch (e) {
      isOpenMore.value=false;
      state.value = PageStateDe.err;
    } finally {
      isOpenMore.value=false;
    }
  }

  Future<List<dynamic>?> removeCheckedAll(int accountId,bool checked) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingCheckedAll.value = true;
      var response = await userInfoTransactionRepository.removeCheckedAll(accountId, false);
      Get.snackbar(response.first['title'],response.first["description"],
          titleText: Text(response.first['title'],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
      getTransactionInfoGoldListPager(id.value.toString());
      clearFilter();
    } catch (e) {
      EasyLoading.dismiss();
      throw ErrorException('خطا در برداشتن چک باکس: $e');
    } finally {
      EasyLoading.dismiss();
      isLoadingCheckedAll.value = false;
    }
    return null;
  }


    Future< List<dynamic>?> updateGoldChecked(int transactionId,bool checked) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingChecked.value = true;
      // Optimistic UI update: immediately apply the change locally
      final int txIndex = transactionInfoGoldList.indexWhere((t) => (t.id ?? 0) == transactionId);
      bool? previousChecked;
      if (txIndex != -1) {
        previousChecked = transactionInfoGoldList[txIndex].checked;
        transactionInfoGoldList[txIndex].checked = checked;
        transactionInfoGoldList.refresh();
        update();
      }
      var response = await userInfoTransactionRepository.updateChecked(transactionId, checked,);
      if(response!= null){
        EasyLoading.dismiss();
        Get.snackbar(response.first['title'],response.first["description"],
            titleText: Text(response.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        /*getTransactionInfoGoldListPager(id.value.toString());
        clearFilter();*/
      } else {
        // Revert if backend did not confirm
        if (txIndex != -1) {
          transactionInfoGoldList[txIndex].checked = previousChecked;
          transactionInfoGoldList.refresh();
          update();
        }
      }
    } catch (e) {
      // Revert optimistic update on error
      final int txIndex = transactionInfoGoldList.indexWhere((t) => (t.id ?? 0) == transactionId);
      if (txIndex != -1) {
        transactionInfoGoldList[txIndex].checked = !(checked);
        transactionInfoGoldList.refresh();
        update();
      }
      throw ErrorException('خطا در checked: $e');
    } finally {
      EasyLoading.dismiss();
      isLoadingChecked.value = false;
    }

    return null;
  }

  //فایل اکسل
  Future<void> getGoldExcel() async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await userInfoTransactionRepository.getGoldExcel(
        accountId: id.value == 0 ? null : id.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      String fileName = 'userTransaction_${DateTime.now().toIso8601String()} ${headerInfoUserTransactionModel?.accountName}.xlsx';

      if (kIsWeb) {
        final blob = html.Blob([excelBytes], 'application/vnd.ms-excel');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: excelBytes,
          fileExtension: 'xlsx',
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
          html.AnchorElement(href: url)
            ..setAttribute('download', 'user_balance_screenshot_${headerInfoUserTransactionModel?.accountName}.png')
            ..click();
          html.Url.revokeObjectUrl(url);
          Get.snackbar('موفق', 'اسکرین شات با موفقیت ذخیره شد.');
        } else {
          await FileSaver.instance.saveFile(
            name: "user_balance_screenshot_${headerInfoUserTransactionModel?.accountName}",
            bytes: pngBytes,
            fileExtension: 'png',
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
  /*Future<void> exportToPdf(String id) async {
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
  }*/

  Future<void> exportGetGoldPdf(String id) async {
    try {

      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      var response = await userInfoTransactionRepository.getGoldPdf(
        startIndex: 1,
        toIndex: 100000,
        accountId: id,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      final fileName = 'user_transactions_${headerInfoUserTransactionModel?.accountName ?? ''}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      if (kIsWeb) {
        final blob = html.Blob([response], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..download = fileName
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

  /*Map<int, pw.TableColumnWidth> getColumnWidthsPdf() {
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
  }*/

  /*pw.Table buildHeaderTablePdf() {
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
  }*/

  /*pw.Padding buildDataCellPdf(String text, {bool isCenter = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 8),
        textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.right,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }*/

  /*pw.TableRow buildDataRowPdf(TransactionInfoItemModel tx) {
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
  }*/

  /*pw.Widget buildPageNumberPdf(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'صفحه${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }*/

  void clearFilter() {
    paginated.value==null;
    dateStartController.clear();
    dateEndController.clear();
    descriptionFilterController.clear();
    amountFilterController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
    descriptionFilter.value="";
    amountFilter.value="";
    typeFilter1.value='';
    typeFilter.value='انتخاب کنید';
    selectedItemFilter.value = null;
  }
  bool hasActiveFilters() {
    return dateStartController.text.isNotEmpty ||
        dateEndController.text.isNotEmpty ||
        descriptionFilterController.text.isNotEmpty ||
        amountFilterController.text.isNotEmpty ||
        (typeFilter.value != 'انتخاب کنید' && typeFilter.value.isNotEmpty);
  }

  /// Generate invoice for a single gold transaction row
  Future<void> generateInvoiceForGoldTransaction(TransactionReportGoldModel trans) async {
    try {
      EasyLoading.show(status: 'در حال تولید فاکتور...');

      final invoiceService = GoldTransactionInvoiceGenerationService();

      // Get balance list for this account
      List<BalanceItemModel> balances = [];
      if (id.value != 0) {
        balances = await userInfoTransactionRepository.getBalanceList(id.value);
        balances.removeWhere((b) => (b.balance ?? 0) == 0);
      }

      await invoiceService.generateInvoice(
        transaction: trans,
        accountName: headerInfoUserTransactionModel?.accountName ?? '-',
        balanceList: balances,
      );

      EasyLoading.dismiss();
      Get.snackbar(
        "موفقیت",
        "فاکتور تراکنش با موفقیت تولید شد",
        titleText: Text(
          "موفقیت",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          "فاکتور تراکنش با موفقیت تولید شد",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
      );
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "خطا",
        "خطا در تولید فاکتور تراکنش: ${e.toString()}",
        titleText: Text(
          "خطا",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          "خطا در تولید فاکتور تراکنش: ${e.toString()}",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
      );
    }
  }

  /// Generate invoice for a single gold transaction row without balance
  Future<void> generateInvoiceForGoldTransactionWithoutBalance(TransactionReportGoldModel trans) async {
    try {
      EasyLoading.show(status: 'در حال تولید فاکتور...');

      final invoiceService = GoldTransactionInvoiceGenerationWithoutBalanceService();

      // Get balance list for this account
      List<BalanceItemModel> balances = [];
      if (id.value != 0) {
        balances = await userInfoTransactionRepository.getBalanceList(id.value);
        balances.removeWhere((b) => (b.balance ?? 0) == 0);
      }

      await invoiceService.generateInvoice(
        transaction: trans,
        accountName: headerInfoUserTransactionModel?.accountName ?? '-',
        balanceList: balances,
      );

      EasyLoading.dismiss();
      Get.snackbar(
        "موفقیت",
        "فاکتور تراکنش با موفقیت تولید شد",
        titleText: Text(
          "موفقیت",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          "فاکتور تراکنش با موفقیت تولید شد",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
      );
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "خطا",
        "خطا در تولید فاکتور تراکنش: ${e.toString()}",
        titleText: Text(
          "خطا",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          "خطا در تولید فاکتور تراکنش: ${e.toString()}",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
      );
    }
  }

  /// Check social status (Telegram and WhatsApp) for the account
  Future<void> checkAccountSocialStatus() async {
    try {
      isLoadingSocialStatus.value = true;
      EasyLoading.show(status: 'در حال بررسی وضعیت...');
      final response = await accountRepository.checkSocialStatus(accountId: id.value);
      socialStatus.value = response;
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "خطا",
        "خطا در بررسی وضعیت: ${e.toString()}",
        titleText: Text(
          "خطا",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          "خطا در بررسی وضعیت: ${e.toString()}",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
      );
      print("خطا در بررسی وضعیت: ${e.toString()}");
    } finally {
      isLoadingSocialStatus.value = false;
    }
  }

  /// Required input: accountId (int) - uses id.value from controller
  Future<void> sendBalanceToTelegram() async {
    try {
      EasyLoading.show(status: 'در حال ارسال به تلگرام...');
      final response = await walletRepository.sendBalanceToTelegram(accountId: id.value);
      EasyLoading.dismiss();

      // Check if response indicates success
      if (response != null && response.isNotEmpty) {
        // Response is a list, check first element for status
        final firstItem = response.first;
        if (firstItem is Map) {
          final title = firstItem['title'] ?? 'موفقیت';
          final description = firstItem['description'] ?? 'مانده حساب با موفقیت به تلگرام ارسال شد';

          Get.snackbar(
            title.toString(),
            description.toString(),
            titleText: Text(
              title.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),
            ),
            messageText: Text(
              description.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),
            ),
          );
        } else {
          // Simple success message if response format is different
          Get.snackbar(
            "موفقیت",
            "مانده حساب با موفقیت به تلگرام ارسال شد",
            titleText: Text(
              "موفقیت",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),
            ),
            messageText: Text(
              "مانده حساب با موفقیت به تلگرام ارسال شد",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),
            ),
          );
        }
      } else {
        // Empty response - still consider it success
        Get.snackbar(
          "موفقیت",
          "مانده حساب با موفقیت به تلگرام ارسال شد",
          titleText: Text(
            "موفقیت",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),
          ),
          messageText: Text(
            "مانده حساب با موفقیت به تلگرام ارسال شد",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),
          ),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "خطا",
        "خطا در ارسال به تلگرام: ${e.toString()}",
        titleText: Text(
          "خطا",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          "خطا در ارسال به تلگرام: ${e.toString()}",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
      );
    }
  }

}
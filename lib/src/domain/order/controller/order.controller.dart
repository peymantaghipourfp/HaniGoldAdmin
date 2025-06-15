
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:pdf/pdf.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../account/model/account.model.dart';
import '../../users/model/paginated.model.dart';



enum PageState{loading,err,empty,list}
class OrderController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  final TextEditingController searchController=TextEditingController();
  final AccountRepository accountRepository=AccountRepository();
  final OrderRepository orderRepository=OrderRepository();
  var orderList=<OrderModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingRegister=true.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    if (columnIndex == 1) { // Date column
      orderList.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return ascending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!);
      });
    }else if (columnIndex == 2) { // Name column
      orderList.sort((a, b) {
        final aName = a.account?.name ?? '';
        final bName = b.account?.name ?? '';
        return ascending ? aName.compareTo(bName) : bName.compareTo(aName);
      });
    }else if (columnIndex == 4) { // Name column
      orderList.sort((a, b) {
        final aQuantity = a.quantity ?? 0;
        final bQuantity = b.quantity ?? 0;
        return ascending ? aQuantity.compareTo(bQuantity) : bQuantity.compareTo(aQuantity);
      });
    }else if (columnIndex == 5) { // Name column
      orderList.sort((a, b) {
        final aPrice = a.price ?? 0;
        final bPrice = b.price ?? 0;
        return ascending ? aPrice.compareTo(bPrice) : bPrice.compareTo(aPrice);
      });
    }else if (columnIndex == 6) { // Name column
      orderList.sort((a, b) {
        final aTotalPrice = a.totalPrice ?? 0;
        final bTotalPrice = b.totalPrice ?? 0;
        return ascending ? aTotalPrice.compareTo(bTotalPrice) : bTotalPrice.compareTo(aTotalPrice);
      });
    }
  }

  @override
  void onInit() {
    getOrderListPager();
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
    if (!scrollController.hasClients ||hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var fetchedOrderList = await orderRepository.getOrderList(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
          startDate: startDateFilter.value, endDate: endDateFilter.value,
        );
        if (fetchedOrderList.isNotEmpty) {
          orderList.addAll(fetchedOrderList);
          currentPage.value = nextPage;
          hasMore.value = fetchedOrderList.length == itemsPerPage.value;

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

  // مدل آپشن سرچ account
  AccountSearchReqModel? accountSearchReqModel;
  searchAccountName(String name){
    accountSearchReqModel=AccountSearchReqModel(
        account: OptionsModel(
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: 'Name',
                    filterValue: name,
                    filterType: 0,
                    refTable: "Account"
                )]
            )],
            orderBy: "Account.Name",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 1000)
    );
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
    getOrderListPager();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getOrderListPager();
  }

// لیست سفارشات با صفحه بندی
  Future<void> getOrderListPager() async {
    print("### getDepositListPager ###");
    orderList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      print("selectedAccountId.value:::::${selectedAccountId.value}");
      var response = await orderRepository.getOrderListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        name:nameFilterController.text,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      isLoading.value=false;
      orderList.assignAll(response.orders??[]);
      paginated.value=response.paginated;
      state.value=PageState.list;

      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // Future<List<OrderModel>> fetchOrderList() async{
  //   try{
  //     //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
  //       orderList.clear();
  //       isLoading.value=true;
  //     state.value=PageState.loading;
  //     final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
  //     final toIndex = currentPage.value * itemsPerPage.value;
  //     var fetchedOrderList=await orderRepository.getOrderList(
  //         startIndex: startIndex,
  //         toIndex: toIndex,
  //       accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
  //       startDate: startDateFilter.value, endDate: endDateFilter.value,
  //     );
  //     hasMore.value = fetchedOrderList.length == itemsPerPage.value;
  //     //print("بالانس: ${orderList.first.balances}");
  //
  //     if (selectedAccountId.value == 0) {
  //       orderList.assignAll(fetchedOrderList);
  //     }else {
  //       if (currentPage.value == 1) {
  //         orderList.assignAll(fetchedOrderList);
  //       } else {
  //         orderList.addAll(fetchedOrderList);
  //       }
  //     }
  //
  //     state.value = orderList.isEmpty ? PageState.empty : PageState.list;
  //     //EasyLoading.dismiss();
  //       orderList.refresh();
  //       update();
  //
  //   }catch(e){
  //     state.value=PageState.err;
  //     errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
  //   }finally{
  //     isLoading.value=false;
  //     return orderList;
  //   }
  // }

  Future<List<dynamic>?> updateStatusOrder(int orderId,int status)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await orderRepository.updateStatusOrder(status: status, orderId: orderId);
      if(response!= null){
       // OrderModel orderResponse=OrderModel.fromJson(response);
        Get.snackbar(response.first['title'], response.first["description"],
            titleText: Text(response.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getOrderListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در تغییر وضعیت: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;

    }
    return null;
  }

  Future<List<dynamic>?> deleteOrder(int orderId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await orderRepository.deleteOrder(isDeleted: isDeleted, orderId: orderId);
      if(response!= null){
        Get.snackbar("موفقیت آمیز","حذف سفارش با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف سفارش با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        Get.back();
        getOrderListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف سفارش: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;

    }
    return null;
  }

  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    getOrderListPager();
  }

  Future<List<dynamic>?> updateRegistered(int orderId,bool registered) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      var response = await orderRepository.updateRegistered(
        orderId: orderId,
        registered: registered,
      );
      Get.snackbar(response.first['title'],response.first["description"],
          titleText: Text(response.first['title'],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
      getOrderListPager();

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
      final sheet = excel['سفارشات'];

      sheet.appendRow([
        TextCellValue('ردیف'),
        TextCellValue('تاریخ'),
        TextCellValue('نام کاربر'),
        TextCellValue('محصول'),
        TextCellValue('مقدار'),
        TextCellValue('قیمت'),
        TextCellValue('مبلغ کل'),
        TextCellValue('نوع'),
        TextCellValue('وضعیت'),
        TextCellValue('مانده سکه'),
        TextCellValue('مانده ریالی'),
        TextCellValue('مانده طلایی'),
      ]);
      EasyLoading.show(status: 'دریافت فایل اکسل...');
      final allOrders = await orderRepository.getOrderList(
        startIndex: 1,
        toIndex: 10000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      for (var order in allOrders) {
        sheet.appendRow([
          TextCellValue(order.rowNum.toString()),
          TextCellValue(order.date?.toPersianDate(twoDigits: true) ?? ''),
          TextCellValue(order.account?.name ?? ''),
          TextCellValue(order.item?.name ?? ''),
          TextCellValue(order.quantity?.toString().seRagham(separator: ",") ?? ''),
          TextCellValue(order.price?.toString()?? ''),
          TextCellValue(order.totalPrice.toString() ?? ''),
          TextCellValue(getSellBuyText(order.type ?? 0 )),
          TextCellValue(getStatusText(order.status ?? 0 )),
          TextCellValue(order.balances?.where((e) => e.unitName == "عدد").map((e) => "\u202B${e.balance}\u202C ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
          TextCellValue(order.balances?.where((e) => e.unitName == "ریال").map((e) => "\u202B${e.balance}\u202C ${e.unitName } ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
          TextCellValue(order.balances?.where((e) => e.unitName == "گرم").map((e) => "\u202B${e.balance}\u202C ${e.unitName } ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),

        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception('خطا در دریافت فایل');
      final uint8List = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'orders_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
      }else {
        final output = await getDownloadsDirectory();
        final filePath = '${output?.path}/orders_${DateTime
            .now()
            .millisecondsSinceEpoch}.xlsx';
        final fileBytes = excel.encode();
        if (fileBytes != null) {
          await File(filePath).writeAsBytes(uint8List);

          await FileSaver.instance.saveFile(
            name: 'orders',
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

  String getSellBuyText(int type) {
    switch (type) {
      case 0:
        return 'فروش';
      case 1:
        return 'خرید';
      default:
        return 'نامعتبر';
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

      final allOrders = await orderRepository.getOrderList(
        startIndex: 1,
        toIndex: 10000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      final pdf = pw.Document();

      // افزودن MultiPage برای مدیریت خودکار صفحه‌بندی
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          textDirection: pw.TextDirection.rtl,
          maxPages: 2000,
          theme: pw.ThemeData.withFont(base: ttf,fontFallback: [ttf],),
          header: (pw.Context context) => buildHeaderTable(),
          build: (pw.Context context) => [
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: getColumnWidths(),
              children: [
                for (var order in allOrders)
                  buildDataRow(order),
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
          ..download = 'orders_${DateTime.now().millisecondsSinceEpoch}.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'orders.pdf',
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
      2: pw.FlexColumnWidth(3),
      3: pw.FlexColumnWidth(1.7),
      4: pw.FlexColumnWidth(1.5),
      5: pw.FlexColumnWidth(3),
      6: pw.FlexColumnWidth(3),
      7: pw.FlexColumnWidth(2),
      8: pw.FlexColumnWidth(2.5),
      9: pw.FlexColumnWidth(2.5),
      10: pw.FlexColumnWidth(2),
      11: pw.FlexColumnWidth(1.2),
    };
  }
  // ساخت هدر جدول
  pw.Table buildHeaderTable() {
    return pw.Table(
      columnWidths: {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(3),
        3: pw.FlexColumnWidth(1.7),
        4: pw.FlexColumnWidth(1.5),
        5: pw.FlexColumnWidth(3),
        6: pw.FlexColumnWidth(3),
        7: pw.FlexColumnWidth(2),
        8: pw.FlexColumnWidth(2.5),
        9: pw.FlexColumnWidth(2.5),
        10: pw.FlexColumnWidth(2),
        11: pw.FlexColumnWidth(1.2),
      },
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مانده طلایی', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مانده ریالی', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مانده سکه', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('وضعیت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('نوع', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مبلغ کل', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('قیمت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مقدار', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('محصول', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
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

  pw.TableRow buildDataRow(OrderModel order) {
    return pw.TableRow(
      children: [
        buildDataCell(order.balances?.where((e) => e.unitName == "گرم").map((e) => "${e.balance} ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
        buildDataCell(order.balances?.where((e) => e.unitName == "ریال").map((e) => "${e.balance} ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
        buildDataCell(order.balances?.where((e) => e.unitName == "عدد").map((e) => "${e.balance} ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
        buildDataCell(getStatusText(order.status ?? 0)),
        buildDataCell(getSellBuyText(order.type ?? 0)),
        buildDataCell(order.totalPrice?.toString().seRagham(separator: ',') ?? ''),
        buildDataCell(order.price?.toString().seRagham(separator: ',') ?? ''),
        buildDataCell(order.quantity?.toString().seRagham(separator: ',') ?? ''),
        buildDataCell(order.item?.name ?? ''),
        buildDataCell(order.account?.name ?? ''),
        buildDataCell(order.date?.toPersianDate(twoDigits: true) ?? ''),
        buildDataCell(order.rowNum.toString(), isCenter: true),
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
}
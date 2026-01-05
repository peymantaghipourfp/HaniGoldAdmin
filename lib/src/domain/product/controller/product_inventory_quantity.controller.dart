

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/product_inventory.repository.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory.model.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory_quantity.model.dart';
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;

import '../../inventory/model/inventory_detail.model.dart';
import '../../users/model/paginated.model.dart';
import 'dart:typed_data';


enum PageState{loading,err,empty,list}
enum PageStateDe{loading,err,empty,list}
class ProductInventoryQuantityController extends GetxController{

  final ProductInventoryRepository productInventoryRepository=ProductInventoryRepository();

  var productInventoryQuantityList=<ProductInventoryQuantityModel>[].obs;
  var isLoading=true.obs;
  RxBool isOpenMore = false.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollControllerMobile = ScrollController();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageStateDe> stateDe=Rx<PageStateDe>(PageStateDe.list);
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 25.obs;
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController userFilterController=TextEditingController();
  final TextEditingController amountFilterController=TextEditingController();
  var id = 0.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  var userFilter=''.obs;
  var amountFilter=''.obs;
  var typeFilter=''.obs;
  RxList<InventoryDetailModel> recieptRemaindedList = <InventoryDetailModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  RxInt selectedItemId = 0.obs;
  RxBool isDetailsExpanded = false.obs;
  RxBool isLoadingDetails = false.obs;



  @override
  void onInit() {
    setupScrollListener();
    getProductInventoryQuantityList();
    super.onInit();
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
          !isLoading.value) {
        loadMore(selectedItemId.value.toString());
      }
    });
  }
  Future<void> loadMore(String itemId) async {
    if (!scrollControllerMobile.hasClients || hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var fetchedRecieptRemaindedList = await productInventoryRepository.getRecieptRemaindedPager(
          startIndex: startIndex,
          toIndex: toIndex,
          itemId: itemId,
          startDate: startDateFilter.value,
          endDate: endDateFilter.value,
          userFilter: userFilter.value,
          amountFilter: amountFilter.value,
        );
        if (fetchedRecieptRemaindedList.inventories!.isNotEmpty ) {
          recieptRemaindedList.addAll(fetchedRecieptRemaindedList.inventories ?? []);
          currentPage.value = nextPage;
          hasMore.value = fetchedRecieptRemaindedList.inventories!.length >= itemsPerPage.value;
          paginated.value = fetchedRecieptRemaindedList.paginated;
          recieptRemaindedList.refresh();
          update();
        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false; // توقف بارگذاری بیشتر در صورت خطا
        "خطا در دریافت اطلاعات بیشتر: ${e.toString()}";
      } finally {
        isLoading.value = false;
      }
    }
  }


  // لیست موجودی محصولات
  Future<void> getProductInventoryQuantityList() async {
    print("### getProductInventoryQuantityList ###");
    productInventoryQuantityList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await productInventoryRepository.getProductInventoryQuantityList();
      isLoading.value=false;
      productInventoryQuantityList.assignAll(response);
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  void isChangePage(int index){
    currentPage.value=(index*25-25)+1;
    itemsPerPage.value=index*25;
    if (selectedItemId.value > 0) {
      getRecieptRemaindedListPager(selectedItemId.value.toString());
    }
  }

  // Toggle item expansion and load details if needed
  void toggleItemDetails(int itemId) {
    if (isDetailsExpanded.value && selectedItemId.value == itemId) {
      // Collapse if the same item is clicked
      isDetailsExpanded.value = false;
    } else {
      // Expand and load details for the clicked item (replaces previous selection)
      isDetailsExpanded.value = true;
      selectedItemId.value = itemId;
      paginated.value=null;
      currentPage.value = 1;
      itemsPerPage.value = 25;
      getRecieptRemaindedListPager(itemId.toString());
    }
    update();
  }



  // لیست ریز موجودی
  Future<void> getRecieptRemaindedListPager(String itemId) async {
    print("getRecieptRemaindedListPager ::::::::: 1");

    // Clear previous details and set loading state
    recieptRemaindedList.clear();
    isLoadingDetails.value = true;
    update();

    try {
      var response = await productInventoryRepository.getRecieptRemaindedPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        itemId: itemId,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
        userFilter: userFilter.value,
        amountFilter: amountFilter.value,
      );

      // Store the details for this item
      recieptRemaindedList.assignAll(response.inventories ?? []);
      paginated.value = response.paginated;
      isLoadingDetails.value = false;

      print("Loaded ${recieptRemaindedList.length} details for item $itemId");
      update();
    }
    catch (e) {
      isLoadingDetails.value = false;
      stateDe.value = PageStateDe.err;
      update();
    }
  }

  // Clear date filter
  /*void clearDateFilter() {
    startDateFilter.value = '';
    endDateFilter.value = '';
    dateStartController.clear();
    dateEndController.clear();
    update();
  }*/
  // Clear all filters
  void clearFilter() {
    currentPage.value=1;
    itemsPerPage.value=25;
    startDateFilter.value = '';
    endDateFilter.value = '';
    userFilter.value = '';
    amountFilter.value = '';
    typeFilter.value = '';
    dateStartController.clear();
    dateEndController.clear();
    userFilterController.clear();
    amountFilterController.clear();
    hasMore.value = true;
    update();
  }

  // Change selected type filter
  /*void changeSelectedType(String newValue) {
    typeFilter.value = newValue;
    update();
  }*/

  // Check if there are active filters
  bool hasActiveFilters() {
    return dateStartController.text.isNotEmpty ||
        startDateFilter.value.isNotEmpty ||
        dateEndController.text.isNotEmpty ||
        endDateFilter.value.isNotEmpty ||
        userFilterController.text.isNotEmpty ||
        userFilter.value.isNotEmpty ||
        amountFilterController.text.isNotEmpty ||
        amountFilter.value.isNotEmpty ||
        (typeFilter.value != null &&
            typeFilter.value != 'انتخاب کنید' &&
            typeFilter.value.isNotEmpty);
  }

  // اکسل موجودی ها
  Future<void> getInventoryQuantityExcel() async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await productInventoryRepository.getInventoryQuantityExcel();

      String fileName = 'ProductInventoryQuantity_${DateTime.now().toIso8601String()}.xlsx';

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
          fileExtension: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
      }
      EasyLoading.showSuccess('فایل اکسل با موفقیت دانلود شد');
    }
    catch(e){
      EasyLoading.dismiss();
      state.value = PageState.err;
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

  // pdf موجودی ها
  Future<void> getInventoryQuantityPdf() async {
    try {

      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      var response = await productInventoryRepository.getInventoryQuantityPdf();
      final fileName = 'product_inventory_quantity_${DateTime.now().toIso8601String()}.pdf';
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

  // اکسل ریز موجودی ها
  Future<void> getRecieptRemaindedListExcel(String itemId) async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await productInventoryRepository.getRecieptRemaindedListExcel(
        itemId: itemId,
      );

      String fileName = 'RecieptRemaindedList_${DateTime.now().toIso8601String()}.xlsx';

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
          fileExtension: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
      }
      EasyLoading.showSuccess('فایل اکسل با موفقیت دانلود شد');
    }
    catch(e){
      EasyLoading.dismiss();
      state.value = PageState.err;
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

  // pdf ریز موجودی ها
  Future<void> getRemaindedListPdf(String itemId) async {
    try {

      EasyLoading.show(status: 'دریافت فایل PDF...');
      isLoading.value = true;

      Uint8List response = await productInventoryRepository.getRemaindedListPdf(
        itemId: itemId,
      );
      String fileName = "product_inventory_remainded_${DateTime.now().toIso8601String()}.pdf";
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
    }finally{
      isLoading.value=false;
    }
  }

}
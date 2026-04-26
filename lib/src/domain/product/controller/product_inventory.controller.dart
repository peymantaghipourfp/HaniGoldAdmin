

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/product_inventory.repository.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory.model.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory_detail.model.dart';

import '../../users/model/paginated.model.dart';


enum PageState{loading,err,empty,list}
enum PageStateDe{loading,err,empty,list}
class ProductInventoryController extends GetxController{

  final ProductInventoryRepository productInventoryRepository=ProductInventoryRepository();

  var productInventoryList=<ProductInventoryModel>[].obs;
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
  RxList<ProductInventoryDetailModel> productInventoryDetailList = <ProductInventoryDetailModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  RxInt selectedItemId = 0.obs;
  RxBool isDetailsExpanded = false.obs;
  RxBool isLoadingDetails = false.obs;



  @override
  void onInit() {
    setupScrollListener();
    // Remove the automatic loading of details since we'll load them on demand
    getProductInventoryList();
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
        var fetchedProductInventoryDetailList = await productInventoryRepository.getProductInventoryDetailListPager(
          startIndex: startIndex,
          toIndex: toIndex,
          startDate: startDateFilter.value,
          endDate: endDateFilter.value,
          typeFilter: typeFilter.value,
          userFilter: userFilter.value,
          amountFilter: amountFilter.value, itemId: itemId,
        );
        if (fetchedProductInventoryDetailList.inventories!.isNotEmpty ) {
          productInventoryDetailList.addAll(fetchedProductInventoryDetailList.inventories ?? []);
          currentPage.value = nextPage;
          hasMore.value = fetchedProductInventoryDetailList.inventories!.length >= itemsPerPage.value;
          paginated.value = fetchedProductInventoryDetailList.paginated;
          productInventoryDetailList.refresh();
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


  // لیست گزارش موجودی محصولات
  Future<void> getProductInventoryList() async {
    productInventoryList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await productInventoryRepository.getProductInventoryList();
      isLoading.value=false;
      productInventoryList.assignAll(response);
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
      getProductInventoryDetailListPager(selectedItemId.value.toString());
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
      getProductInventoryDetailListPager(itemId.toString());
    }
    update();
  }



  // لیست ریز گزارش موجودی
  Future<void> getProductInventoryDetailListPager(String itemId) async {
    //int itemIdInt = int.parse(itemId);

    // Clear previous details and set loading state
    productInventoryDetailList.clear();
    isLoadingDetails.value = true;
    update();

    try {
      var response = await productInventoryRepository.getProductInventoryDetailListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        itemId: itemId,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
        typeFilter: typeFilter.value,
        userFilter: userFilter.value,
        amountFilter: amountFilter.value,
      );

      // Store the details for this item
      productInventoryDetailList.assignAll(response.inventories ?? []);
      paginated.value = response.paginated;
      isLoadingDetails.value = false;

      update();
    }
    catch (e) {
      isLoadingDetails.value = false;
      stateDe.value = PageStateDe.err;
      update();
    }
  }

  // Clear date filter
  void clearDateFilter() {
    startDateFilter.value = '';
    endDateFilter.value = '';
    dateStartController.clear();
    dateEndController.clear();
    update();
  }
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
  void changeSelectedType(String newValue) {
    typeFilter.value = newValue;
    update();
  }

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

}
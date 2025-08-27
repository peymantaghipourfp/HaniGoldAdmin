

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
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageStateDe> stateDe=Rx<PageStateDe>(PageStateDe.list);
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  var id = 0.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  RxList<ProductInventoryDetailModel> productInventoryDetailList = <ProductInventoryDetailModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  RxInt selectedItemId = 0.obs;
  RxBool isDetailsExpanded = false.obs;
  RxBool isLoadingDetails = false.obs;



  @override
  void onInit() {
    // Remove the automatic loading of details since we'll load them on demand
    getProductInventoryList();
    super.onInit();
  }


  // لیست گزارش موجودی محصولات
  Future<void> getProductInventoryList() async {
    print("### getProductInventoryList ###");
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
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value=index*10;
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
      currentPage.value = 1;
      itemsPerPage.value = 10;
      getProductInventoryDetailListPager(itemId.toString());
    }
    update();
  }



  // لیست ریز گزارش موجودی
  Future<void> getProductInventoryDetailListPager(String itemId) async {
    print("getProductInventoryDetailList ::::::::: 1");
    int itemIdInt = int.parse(itemId);

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
      );

      // Store the details for this item
      productInventoryDetailList.assignAll(response.inventories ?? []);
      paginated.value = response.paginated;
      isLoadingDetails.value = false;

      print("Loaded ${productInventoryDetailList.length} details for item $itemId");
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

}
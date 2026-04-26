
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../../product/model/item.model.dart';
import '../../users/model/paginated.model.dart';

enum PageState{loading,err,empty,list}

class OrderEditedReportController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 25.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerMobile = ScrollController();

  final AccountRepository accountRepository=AccountRepository();
  final OrderRepository orderRepository=OrderRepository();
  final ItemRepository itemRepository=ItemRepository();

  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController dateStartCreatedOnController=TextEditingController();
  final TextEditingController dateEndCreatedOnController=TextEditingController();
  final TextEditingController dateStartModifiedOnController=TextEditingController();
  final TextEditingController dateEndModifiedOnController=TextEditingController();
  final TextEditingController nameFilterController=TextEditingController();

  RxList<OrderModel> orderEditedReportList =<OrderModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<ItemModel> itemList=<ItemModel>[].obs;
  PaginatedModel? paginated;
  var errorMessage=''.obs;
  var isLoading=false.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateRR=Rx<PageState>(PageState.list);
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  var startCreatedOnDateFilter=''.obs;
  var endCreatedOnDateFilter=''.obs;
  var startModifiedOnDateFilter=''.obs;
  var endModifiedOnDateFilter=''.obs;
  var amountFilter=''.obs;


  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;

  RxString currentOrderBy = "orders.date".obs;
  RxString currentOrderByType = "DESC".obs;

  Rxn<int> byAdmin = Rxn<int>();
  Rxn<int> type = Rxn<int>();
  final Rxn<ItemModel> selectedItemFilter=Rxn<ItemModel>();

  void changeSelectedItemFilter(ItemModel? newValue) {
    selectedItemFilter.value = newValue;
    update();
  }

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  void isChangePage(int index){
    currentPage.value=(index*25-25)+1;
    itemsPerPage.value=index*25;
    getOrderEditedReportPager();
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    // Map column indices to orderBy fields
    String orderByField;
    switch (columnIndex) {
      case 1:
        orderByField = "orders.date";
        break;
      case 2:
        orderByField = "orders.createdOn";
        break;
      case 3:
        orderByField = "orders.modifiedOn";
        break;
      default:
        orderByField = "orders.date";
    }

    currentOrderBy.value = orderByField;
    currentOrderByType.value = ascending ? "DESC" : "ASC";

    // Refresh data with new sorting
    getOrderEditedReportPager();
  }

  checkByAdmin(int? index) {
    byAdmin.value = index;
    update();
  }
  checkType(int? index) {
    type.value = index;
    update();
  }

  @override
  void onInit() {
    byAdmin.value = null;
    type.value = null;
    fetchAccountList();
    setupScrollListener();
    getOrderEditedReportPager();
    fetchItemList();
    super.onInit();
  }

  @override void onClose() {
    scrollController.dispose();
    scrollControllerMobile.dispose();
    orderEditedReportList.clear();
    super.onClose();
  }

  void setupScrollListener() {
    scrollControllerMobile.addListener(() {
      if (scrollControllerMobile.position.pixels >=
          scrollControllerMobile.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }

  Future<void> loadMore() async {
    if (!scrollControllerMobile.hasClients || hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var response = await orderRepository.getOrderEditedReportPager(
          startIndex: startIndex,
          toIndex: toIndex,
          name:nameFilterController.text,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
          startDate: startDateFilter.value, endDate: endDateFilter.value,
          startCreatedOnDate: startCreatedOnDateFilter.value ,endCreatedOnDate: endCreatedOnDateFilter.value,
          startModifiedOnDate: startModifiedOnDateFilter.value,endModifiedOnDate: endModifiedOnDateFilter.value,
          byAdmin: byAdmin.value,
          type: type.value,
          amountFilter: amountFilter.value,
          item: selectedItemFilter.value?.id,
          orderBy: currentOrderBy.value,
          orderByType: currentOrderByType.value,
        );
        if (response.orders.isNotEmpty == true) {
          orderEditedReportList.addAll(response.orders);
          currentPage.value = nextPage;
          hasMore.value = response.orders.length == itemsPerPage.value;
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

      var fetchedAccountList=await accountRepository.getAccountList("");
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);

      if(accountList.isEmpty){
        print("No accounts found");
      } else {
        print("Loaded ${accountList.length} accounts");
      }
    }
    catch(e){
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
    getOrderEditedReportPager();
  }

  void clearSearch() {
    paginated=null;
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getOrderEditedReportPager();
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

  // لیست کارکرد سفارشات با صفحه بندی
  Future<void> getOrderEditedReportPager() async {
    orderEditedReportList.clear();
    try {
      state.value=PageState.loading;
      var response = await orderRepository.getOrderEditedReportPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        name:nameFilterController.text,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
        startCreatedOnDate: startCreatedOnDateFilter.value ,endCreatedOnDate: endCreatedOnDateFilter.value,
        startModifiedOnDate: startModifiedOnDateFilter.value,endModifiedOnDate: endModifiedOnDateFilter.value,
        byAdmin: byAdmin.value,
        type: type.value,
        amountFilter: amountFilter.value,
        item: selectedItemFilter.value?.id,
        orderBy: currentOrderBy.value,
        orderByType: currentOrderByType.value,
      );
      orderEditedReportList.assignAll(response.orders);
      paginated=response.paginated;
      state.value=PageState.list;

      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }


  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }

  void clearFilter() {
    paginated=null;
    currentPage.value = 1;
    nameFilterController.clear();
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
    dateStartCreatedOnController.clear();
    dateEndCreatedOnController.clear();
    startCreatedOnDateFilter.value="";
    endCreatedOnDateFilter.value="";
    dateStartModifiedOnController.clear();
    dateEndModifiedOnController.clear();
    startModifiedOnDateFilter.value="";
    endModifiedOnDateFilter.value="";
    byAdmin.value=null;
    type.value=null;
    selectedItemFilter.value = null;
  }

}
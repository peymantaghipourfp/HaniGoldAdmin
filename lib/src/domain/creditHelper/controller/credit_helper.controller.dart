import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/credit_helper.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../model/credit_helper.model.dart';
import '../model/credit_type.model.dart';
import '../../../domain/product/model/item.model.dart';
import '../../../domain/users/model/paginated.model.dart';

enum PageState { loading, err, empty, list }

class CreditHelperController extends GetxController {
  Rx<PageState> state = Rx<PageState>(PageState.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 25.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  CreditHelperRepository creditHelperRepository = CreditHelperRepository();
  final ItemRepository itemRepository = ItemRepository();
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerMobile = ScrollController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController dateStartController = TextEditingController();
  final TextEditingController dateEndController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountIdController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController itemIdController = TextEditingController();

  RxList<CreditHelperModel> creditHelperList = <CreditHelperModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  RxString accountNameFilter = ''.obs;
  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxList<CreditTypeModel> typeList = <CreditTypeModel>[].obs;
  Rxn<ItemModel> selectedItemFilter = Rxn<ItemModel>();
  RxString typeFilter = ''.obs;
  RxString amountFilter = ''.obs;
  RxString startDateFilter = ''.obs;
  RxString endDateFilter = ''.obs;
  var isLoading = false.obs;
  var namePayer = "".obs;
  var mobilePayer = "".obs;
  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;
  RxString currentOrderBy = "Id".obs;
  RxString currentOrderByType = "DESC".obs;

  // Filter variables
  RxnInt accountId = RxnInt();
  RxnInt type = RxnInt();
  RxnInt itemId = RxnInt();
  var startDate = ''.obs;
  var endDate = ''.obs;
  var amount = ''.obs;
  RxBool isActive = RxBool(true);
  RxBool isRefreshing = false.obs;
  RxInt refreshCounter = 0.obs;

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    // Map column indices to orderBy fields
    String orderByField;
    switch (columnIndex) {
      case 0: // ردیف (rowNum)
        orderByField = "Id";
        break;
      case 1: // نام حساب (account name)
        orderByField = "Account.Name";
        break;
      case 2: // آیتم (item name)
        orderByField = "Item.Name";
        break;
      case 3: // نوع (typeName)
        orderByField = "Type";
        break;
      case 4: // مقدار (amount)
        orderByField = "Amount";
        break;
      case 5: // فعال (isActive)
        orderByField = "IsActive";
        break;
      case 6: // تاریخ شروع (startDate)
        orderByField = "StartDate";
        break;
      case 7: // تاریخ پایان (endDate)
        orderByField = "EndDate";
        break;
      default:
        orderByField = "Id";
    }

    currentOrderBy.value = orderByField;
    currentOrderByType.value = ascending ? "ASC" : "DESC";

    // Refresh data with new sorting
    getCreditHelperListPager();
  }

  void isChangePage(int index) {
    currentPage.value = (index * 25 - 25) + 1;
    itemsPerPage.value = index * 25;
    getCreditHelperListPager();
  }

  void clearSearch() {
    paginated.value = null;
    currentPage.value = 1;
    itemsPerPage.value = 25;
    accountNameController.clear();
    // Reset sorting to default
    sortAscending.value = true;
    sortColumnIndex.value = null;
    currentOrderBy.value = "Id";
    currentOrderByType.value = "DESC";
    clearFilter();
    getCreditHelperListPager();
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize default sorting
    sortAscending.value = true;
    fetchItemList();
    fetchTypeList();
    getCreditHelperListPager();
    setupScrollListener();
  }

  @override
  void onClose() {
    scrollControllerMobile.dispose();
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
        var fetchedListCreditHelper = await creditHelperRepository.getCreditHelperListPager(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: accountId.value,
          type: type.value,
          itemId: itemId.value,
          accountName: accountNameController.text,
          startDate: startDateFilter.value,
          endDate: endDateFilter.value,
          amount: amountController.text,
          isActive: isActive.value,
        );
        if (fetchedListCreditHelper.creditHelpers!.isNotEmpty) {
          creditHelperList.addAll(fetchedListCreditHelper.creditHelpers!.cast<CreditHelperModel>());
          currentPage.value = nextPage;
          hasMore.value = fetchedListCreditHelper.creditHelpers?.length == itemsPerPage.value;
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

  // لیست اعتبار سنجی
  Future<void> getCreditHelperListPager() async {
    creditHelperList.clear();
    try {
      state.value = PageState.loading;
      var response = await creditHelperRepository.getCreditHelperListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        accountId: accountId.value,
        type: type.value,
        itemId: itemId.value,
        accountName: accountNameController.text,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
        amount: amountController.text,
        isActive: isActive.value,
      );
      state.value = PageState.list;
      creditHelperList.assignAll(response.creditHelpers?.cast<CreditHelperModel>() ?? []);
      paginated.value = response.paginated;
      if (creditHelperList.isEmpty) {
        state.value = PageState.empty;
      }
      update();
    } catch (e) {
      state.value = PageState.err;
    } finally {
    }
  }

  Future<void> refreshCreditHelperListSilently() async {
    isRefreshing.value = true;
    try {
      var response = await creditHelperRepository.getCreditHelperListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        accountId: accountId.value,
        type: type.value,
        itemId: itemId.value,
        accountName: accountNameController.text,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
        amount: amountController.text,
        isActive: isActive.value,
      );

      // Update list without clearing first (prevents flicker)
      creditHelperList.assignAll(response.creditHelpers ?? []);
      paginated.value = response.paginated;
      state.value = PageState.list;

      // Increment refresh counter to invalidate cached tooltip data
      refreshCounter.value++;

    } catch (e) {
      print('Error in silent order refresh: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Infinite scroll loader for mobile: increases page size by 25 and reloads
  Future<int> loadMoreOnMobile() async {
    if (isLoading.value) return 0;
    if (!(hasMore.value)) return 0;

    final int before = creditHelperList.length;
    itemsPerPage.value = itemsPerPage.value + 25;
    await getCreditHelperListPager();
    final int after = creditHelperList.length;

    final int delta = after - before;
    if (delta <= 0) {
      hasMore.value = false;
    }
    return delta;
  }

  // لیست آیتم ها
  Future<void> fetchItemList() async {
    try {
      var fetchedItemList = await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
    } catch (e) {
      print("Error loading items: $e");
    }
  }

  // لیست انواع اعتبار
  Future<void> fetchTypeList() async {
    try {
      var fetchedTypeList = await creditHelperRepository.getTypeCreditHelper();
      typeList.assignAll(fetchedTypeList);
    } catch (e) {
      print("Error loading credit types: $e");
    }
  }

  // تغییر آیتم انتخاب شده
  void changeSelectedItemFilter(ItemModel? newValue) {
    selectedItemFilter.value = newValue;
    itemId.value = newValue?.id;
  }

  // تغییر نوع انتخاب شده
  void changeSelectedType(String newValue) {
    typeFilter.value = newValue;
    // Find the type by name and set the ID
    final selectedType = typeList.firstWhere(
          (type) => type.name == newValue,
      orElse: () => CreditTypeModel(name: null, leverage: null, rowNum: null, id: null, infos: null),
    );
    type.value = selectedType.id;
  }

  // پاک کردن فیلترها
  void clearFilter() {
    amountController.clear();
    dateStartController.clear();
    dateEndController.clear();
    accountNameController.clear();
    selectedItemFilter.value = null;
    typeFilter.value = '';
    amountFilter.value = '';
    startDateFilter.value = '';
    endDateFilter.value = '';
    accountNameFilter.value = '';
    accountIdController.clear();
    typeController.clear();
    itemIdController.clear();
    startDate.value = '';
    endDate.value = '';
    accountId.value = null;
    type.value = null;
    itemId.value = null;
    amount.value = '';
    isActive.value = true;
  }

  // بررسی وجود فیلتر فعال
  bool hasActiveFilters() {
    return dateStartController.text.isNotEmpty ||
        dateEndController.text.isNotEmpty ||
        (selectedItemFilter.value != null) ||
        typeFilter.value.isNotEmpty ||
        amountController.text.isNotEmpty;
  }

  // حذف اعتبار سنجی
  Future<void> deleteCreditHelper(int id) async {
    try {
      Get.defaultDialog(
        backgroundColor: AppColor.backGroundColor,
        title: "حذف اعتبار",
        titleStyle: AppTextStyle.smallTitleText,
        middleText: "آیا از حذف این اعتبار مطمئن هستید؟",
        middleTextStyle: AppTextStyle.bodyText,
        confirm: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
          ),
          onPressed: () async {
            Get.back(); // Close confirmation dialog
            try {
              await creditHelperRepository.deleteCreditHelper(isDeleted: true, id: id);
              // Refresh the list
              refreshCreditHelperListSilently();
              Get.snackbar(
                'موفقیت',
                'اعتبار با موفقیت حذف شد',
                titleText: Text('موفقیت', style: TextStyle(color: AppColor.textColor)),
                messageText: Text('اعتبار با موفقیت حذف شد', style: TextStyle(color: AppColor.textColor)),
              );
            } catch (e) {
              Get.snackbar(
                'خطا',
                'خطا در حذف اعتبار: ${e.toString()}',
                titleText: Text('خطا', style: TextStyle(color: AppColor.accentColor)),
                messageText: Text('خطا در حذف اعتبار: ${e.toString()}', style: TextStyle(color: AppColor.accentColor)),
              );
            }
          },
          child: Text('حذف', style: AppTextStyle.bodyText),
        ),
        cancel: ElevatedButton(
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
          onPressed: () => Get.back(),
          child: Text('لغو', style: AppTextStyle.bodyText),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در درخواست حذف: ${e.toString()}',
        titleText: Text('خطا', style: TextStyle(color: AppColor.accentColor)),
        messageText: Text('خطا در درخواست حذف: ${e.toString()}', style: TextStyle(color: AppColor.accentColor)),
      );
    }
  }

  // تغییر وضعیت فعال/غیرفعال
  Future<void> updateActiveCreditHelper(int id, bool isActive) async {
    try {
      await creditHelperRepository.updateActiveCreditHelper(isActive: isActive, id: id);

      // Update local list item
      final index = creditHelperList.indexWhere((creditHelper) => creditHelper.id == id);
      CreditHelperModel? creditHelperChange;
      if (index != -1) {
        creditHelperList[index] = creditHelperList[index];
        creditHelperChange?.isActive=isActive;
        creditHelperList.refresh(); // Notify listeners
      }

      Get.snackbar(
        'موفقیت',
        'وضعیت اعتبار با موفقیت تغییر یافت',
        titleText: Text('موفقیت', style: TextStyle(color: AppColor.textColor)),
        messageText: Text('وضعیت اعتبار با موفقیت تغییر یافت', style: TextStyle(color: AppColor.textColor)),
      );
      refreshCreditHelperListSilently();
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در تغییر وضعیت: ${e.toString()}',
        titleText: Text('خطا', style: TextStyle(color: AppColor.accentColor)),
        messageText: Text('خطا در تغییر وضعیت: ${e.toString()}', style: TextStyle(color: AppColor.accentColor)),
      );
    }
  }

  // دریافت یک اعتبار برای ویرایش
  Future<CreditHelperModel?> getOneCreditHelper(int id) async {
    try {
      return await creditHelperRepository.getOneCreditHelper(id);
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در دریافت اطلاعات اعتبار: ${e.toString()}',
        titleText: Text('خطا', style: TextStyle(color: AppColor.accentColor)),
        messageText: Text('خطا در دریافت اطلاعات اعتبار: ${e.toString()}', style: TextStyle(color: AppColor.accentColor)),
      );
      return null;
    }
  }

}

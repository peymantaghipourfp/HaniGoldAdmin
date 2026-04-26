import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/repository/account_sales_group.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../../product/model/item.model.dart';
import '../model/account_sales_group.model.dart';
import 'account_sales_group.controller.dart';

class SelectedItemPriceUpdate {
  final int? StateMode;
  final int? itemId;
  final String itemName;
  final String? icon;
  double buyRange;
  double salesRange;
  bool? sellStatus;
  bool? buyStatus;
  /*double maxBuy;
  double maxSell;*/

  SelectedItemPriceUpdate({
    required this.StateMode,
    required this.itemId,
    required this.itemName,
    this.icon,
    required this.buyRange,
    required this.salesRange,
    this.sellStatus,
    this.buyStatus,
    /*required this.maxBuy,
    required this.maxSell,*/
  });
}

class UpdateAccountSalesGroupController extends GetxController {
  final AccountSalesGroupController accountSalesGroupController=Get.find<AccountSalesGroupController>();
  final AccountSalesGroupRepository accountSalesGroupRepository = AccountSalesGroupRepository();
  final ItemRepository itemRepository = ItemRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController buyRangeController = TextEditingController();
  final TextEditingController salesRangeController = TextEditingController();
  final TextEditingController maxBuyController = TextEditingController();
  final TextEditingController maxSellController = TextEditingController();

  final RxnInt accountSalesGroupId = RxnInt();
  final Rxn<AccountSalesGroupModel> current = Rxn<AccountSalesGroupModel>();
  final List<SelectedItemPriceUpdate> selectedItemPrices = <SelectedItemPriceUpdate>[].obs;
  final List<SelectedItemPriceUpdate> removedItemPrices = <SelectedItemPriceUpdate>[].obs;
  final List<ItemModel> itemList = <ItemModel>[].obs;
  final Rxn<ItemModel> selectedItem = Rxn<ItemModel>();
  final RxBool sellStatus = RxBool(true);
  final RxBool buyStatus = RxBool(true);

  final RxBool isLoading = false.obs;
  final RxnString errorStatus = RxnString();
  final RxnString errorMessage = RxnString();
  final RxnString errorCode = RxnString();

  List<ItemModel> get availableItems {
    final selectedIds = selectedItemPrices.map((e) => e.itemId).whereType<int>().toSet();
    return itemList.where((item) => item.id != null && !selectedIds.contains(item.id)).toList();
  }

  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
    buyRangeController.clear();
    salesRangeController.clear();
    sellStatus.value = true;
    buyStatus.value = true;
    /*maxBuyController.clear();
    maxSellController.clear();*/
  }

  void changeSellStatus(bool newValue) {
    sellStatus.value = newValue;
  }

  void changeBuyStatus(bool newValue) {
    buyStatus.value = newValue;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['id'] != null) {
      accountSalesGroupId.value = int.tryParse(args['id'].toString());
    }
    if (accountSalesGroupId.value != null) {
      fetchDetails(accountSalesGroupId.value!);
    } else {
      errorStatus.value = 'failure';
      errorMessage.value = 'شناسه زیرگروه معتبر نیست';
      errorCode.value = 'INVALID_ID';
    }
    fetchItemList();
  }

  Future<void> fetchDetails(int id) async {
    isLoading.value = true;
    // Tool: getOneAccountSubGroup | purpose: prefill update form | inputs: id
    try {
      final sub = await accountSalesGroupRepository.getOneAccountSalesGroup(accountSalesGroupId: id);
      current.value = sub;
      nameController.text = sub.name ?? '';
      selectedItemPrices.assignAll((sub.accountSalesGroupItems ?? [])
          .map((ip) => SelectedItemPriceUpdate(
        StateMode: 2,
        itemId: ip.itemId,
        itemName: ip.itemName ?? '',
        icon: ip.itemIcon ?? '',
        buyRange: ip.buyRange ?? 0,
        salesRange: ip.salesRange ?? 0,
        sellStatus: ip.sellStatus,
        buyStatus: ip.buyStatus,
        /*maxBuy: ip.maxBuy ?? 0,
        maxSell: ip.maxSell ?? 0,*/
      ))
          .toList());
      removedItemPrices.clear();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorStatus.value = 'failure';
      errorMessage.value = 'بارگذاری جزئیات ناموفق: $e';
      errorCode.value = 'FETCH_FAILED';
    }
  }

  // Load items for dropdown
  Future<void> fetchItemList() async {
    try {
      final fetched = await itemRepository.getItemList();
      itemList.assignAll(fetched);
      if (itemList.isEmpty) {
        errorMessage.value = 'هیچ محصولی یافت نشد';
      }
    } catch (e) {
      errorMessage.value = 'خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}';
    }
  }

  // Add a new item with ranges
  void addItemPrice() {
    if (selectedItem.value == null) {
      Get.snackbar('خطا', 'لطفا یک محصول انتخاب کنید',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }

    final buyRangeText = buyRangeController.text.trim();
    final salesRangeText = salesRangeController.text.trim();
    final sellStatusValue = sellStatus.value;
    final buyStatusValue = buyStatus.value;
    /*final maxBuyText = maxBuyController.text.trim();
    final maxSellText = maxSellController.text.trim();*/

    if (buyRangeText.isEmpty) {
      Get.snackbar('خطا', 'لطفا محدوده خرید را وارد کنید',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    if (salesRangeText.isEmpty) {
      Get.snackbar('خطا', 'لطفا محدوده فروش را وارد کنید',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    /*if (maxBuyText.isEmpty) {
      Get.snackbar('خطا', 'لطفا سقف خرید را وارد کنید',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    if (maxSellText.isEmpty) {
      Get.snackbar('خطا', 'لطفا سقف فروش را وارد کنید',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }*/

    final buyRange = double.tryParse(buyRangeText.replaceAll(',', '').toEnglishDigit());
    final salesRange = double.tryParse(salesRangeText.replaceAll(',', '').toEnglishDigit());
    /*final maxBuy = double.tryParse(maxBuyText.replaceAll(',', '').toEnglishDigit());
    final maxSell = double.tryParse(maxSellText.replaceAll(',', '').toEnglishDigit());*/
    if (buyRange == null) {
      Get.snackbar('خطا', 'محدوده خرید باید یک عدد معتبر باشد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    if (salesRange == null) {
      Get.snackbar('خطا', 'محدوده فروش باید یک عدد معتبر باشد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    /*if (maxBuy == null) {
      Get.snackbar('خطا', 'سقف خرید باید یک عدد معتبر باشد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    if (maxSell == null) {
      Get.snackbar('خطا', 'سقف فروش باید یک عدد معتبر باشد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    if (maxBuy < 0) {
      Get.snackbar('خطا', 'سقف خرید نمی‌تواند منفی باشد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    if (maxSell < 0) {
      Get.snackbar('خطا', 'سقف فروش نمی‌تواند منفی باشد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }*/

    // Prevent duplicates
    final sel = selectedItem.value!;
    if (selectedItemPrices.any((e) => e.itemId == sel.id)) {
      Get.snackbar('خطا', 'این محصول قبلا انتخاب شده است',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }
    removedItemPrices.removeWhere((e) => e.itemId == sel.id);
    selectedItemPrices.add(SelectedItemPriceUpdate(
      StateMode: 1,
      itemId: sel.id,
      itemName: sel.name ?? '',
      icon: sel.icon,
      buyRange: buyRange,
      salesRange: salesRange,
      sellStatus: sellStatusValue,
      buyStatus: buyStatusValue,
      /*maxBuy: maxBuy,
      maxSell: maxSell,*/
    ));

    selectedItem.value = null;
    buyRangeController.clear();
    salesRangeController.clear();
    sellStatus.value = true;
    buyStatus.value = true;
    /*maxBuyController.clear();
    maxSellController.clear();*/

    Get.snackbar('موفق', 'محصول با موفقیت اضافه شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.secondary2Color,
        colorText: AppColor.textColor);
  }

  void updateItemStatus(int itemId, bool buyStatus, bool sellStatus) {
    final index = selectedItemPrices.indexWhere((e) => e.itemId == itemId);
    if (index == -1) return;

    final oldItem = selectedItemPrices[index];
    final updatedItem = SelectedItemPriceUpdate(
      StateMode: oldItem.StateMode,
      itemId: oldItem.itemId,
      itemName: oldItem.itemName,
      icon: oldItem.icon,
      buyRange: oldItem.buyRange,
      salesRange: oldItem.salesRange,
      sellStatus: sellStatus,
      buyStatus: buyStatus,
    );

    selectedItemPrices[index] = updatedItem;
  }

  void removeItemPrice(int itemId) {
    //selectedItemPrices.removeWhere((e) => e.itemId == itemId);
    final index = selectedItemPrices.indexWhere((e) => e.itemId == itemId);
    if (index == -1) {
      removedItemPrices.removeWhere((e) => e.itemId == itemId);
      return;
    }
    final removed = selectedItemPrices.removeAt(index);
    removedItemPrices.removeWhere((e) => e.itemId == itemId);
    if (removed.StateMode == 1) {
      return;
    }

    removedItemPrices.add(SelectedItemPriceUpdate(
      StateMode: 3,
      itemId: removed.itemId,
      itemName: removed.itemName,
      icon: removed.icon,
      buyRange: removed.buyRange,
      salesRange: removed.salesRange,
      sellStatus: removed.sellStatus,
      buyStatus: removed.buyStatus,
     /* maxBuy: removed.maxBuy,
      maxSell: removed.maxSell,*/
    ));
  }

  Map<String, dynamic>? validateAll() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return {'status': 'failure', 'message': 'نام زیرگروه نباید خالی باشد', 'code': 'VALIDATION_NAME'};
    }
    if (selectedItemPrices.isEmpty) {
      return {'status': 'failure', 'message': 'لیست محصولات خالی است', 'code': 'VALIDATION_ITEMS_EMPTY'};
    }
    for (final it in selectedItemPrices) {
      if (it.buyRange.isNaN) {
        return {'status': 'failure', 'message': 'محدوده خرید نامعتبر است', 'code': 'VALIDATION_BUY_RANGE'};
      }
      if (it.salesRange.isNaN) {
        return {'status': 'failure', 'message': 'محدوده فروش نامعتبر است', 'code': 'VALIDATION_SALES_RANGE'};
      }
      /*if (it.maxBuy.isNaN) {
        return {'status': 'failure', 'message': 'سقف خرید نامعتبر است', 'code': 'VALIDATION_MAX_BUY'};
      }
      if (it.maxSell.isNaN) {
        return {'status': 'failure', 'message': 'سقف فروش نامعتبر است', 'code': 'VALIDATION_MAX_SELL'};
      }
      if (it.maxBuy < 0) {
        return {'status': 'failure', 'message': 'سقف خرید منفی است', 'code': 'VALIDATION_MAX_BUY_NEGATIVE'};
      }
      if (it.maxSell < 0) {
        return {'status': 'failure', 'message': 'سقف فروش منفی است', 'code': 'VALIDATION_MAX_SELL_NEGATIVE'};
      }*/
    }
    // duplicates by itemId check (if present)
    final ids = selectedItemPrices.where((e) => e.itemId != null).map((e) => e.itemId).toList();
    if (ids.toSet().length != ids.length) {
      return {'status': 'failure', 'message': 'محصول تکراری وجود دارد', 'code': 'VALIDATION_DUPLICATE_ITEM'};
    }
    return null;
  }

  Future<void> submitUpdate() async {
    final validation = validateAll();
    if (validation != null) {
      Get.snackbar('خطا', validation['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }

    final id = accountSalesGroupId.value;
    if (id == null) {
      final result = {'status': 'failure', 'message': 'شناسه نامعتبر است', 'code': 'INVALID_ID'};
      Get.snackbar('خطا', result['message']!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }

    final name = nameController.text.trim();
    //final List<Map<String, dynamic>> itemPrices = selectedItemPrices
    final List<SelectedItemPriceUpdate> combinedItemPrices = [
      ...selectedItemPrices,
      ...removedItemPrices,
    ];
    final List<Map<String, dynamic>> itemPrices = combinedItemPrices
        .map((e) => {
      "StateMode" : e.StateMode,
      "itemId" : e.itemId,
      'buyRange': e.buyRange,
      'salesRange': e.salesRange,
      'sellStatus': e.sellStatus,
      'buyStatus': e.buyStatus,
      /*'maxBuy': e.maxBuy,
      'maxSell': e.maxSell,*/
    })
        .toList();

    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      // Summary before request
      /*final summary = {
        'action': 'updateAccountSalesGroup',
        'purpose': 'ارسال درخواست ویرایش زیرگروه',
        'endpoint': 'AccountSalesGroup/update',
        'payloadPreview': {
          'name': name,
          'id': id,
          'itemPricesSample': itemPrices.isNotEmpty ? itemPrices.first : null,
          'itemPricesCount': itemPrices.length,
        }
      };*/
      final response = await accountSalesGroupRepository.updateAccountSalesGroup(
        accountSalesGroupId: id,
        name: name,
        itemPrices: itemPrices,
      );

      EasyLoading.dismiss();
      if(response.isNotEmpty){
        Get.back();
        Get.snackbar('موفق', 'ویرایش با موفقیت انجام شد',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColor.secondary2Color,
            colorText: AppColor.textColor);

        accountSalesGroupController.getAccountSalesGroupList();

      }
    } catch (e) {
      EasyLoading.dismiss();
      final result = {
        'status': 'failure',
        'message': 'خطا در ویرایش: $e',
        'code': 'UPDATE_FAILED',
      };
      errorStatus.value = 'failure';
      errorMessage.value = result['message'];
      errorCode.value = result['code'];
      Get.snackbar('خطا', result['message']!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
    }
  }
}



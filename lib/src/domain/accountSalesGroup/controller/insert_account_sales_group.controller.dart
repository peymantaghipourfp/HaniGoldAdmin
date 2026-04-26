

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/accountSalesGroup/controller/account_sales_group.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/repository/item.repository.dart';
import '../../../config/repository/account_sales_group.repository.dart';
import '../../../config/const/app_color.dart';
import '../../product/model/item.model.dart';
import '../model/account_sales_group.model.dart';

enum PageState{loading,err,empty,list}

class SelectedItemPrice {
  final int itemId;
  final String itemName;
  final String? icon;
  final double buyRange;
  final double salesRange;
  final bool? sellStatus;
  final bool? buyStatus;

  /*final double maxBuy;
  final double maxSell;*/

  SelectedItemPrice({
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

class InsertAccountSalesGroupController extends GetxController {

  final AccountSalesGroupController accountSalesGroupController=Get.find<AccountSalesGroupController>();

  final ItemRepository itemRepository=ItemRepository();
  final AccountSalesGroupRepository accountSalesGroupRepository=AccountSalesGroupRepository();
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  final List<SelectedItemPrice> selectedItemPrices=<SelectedItemPrice>[].obs;
  var errorMessage=''.obs;

  final TextEditingController nameController=TextEditingController();
  final TextEditingController buyRangeController=TextEditingController();
  final TextEditingController salesRangeController=TextEditingController();
  //final TextEditingController maxBuyController=TextEditingController();
  //final TextEditingController maxSellController=TextEditingController();

  RxBool sellStatus = RxBool(true);
  RxBool buyStatus = RxBool(true);

  // Get available items (not already selected)
  List<ItemModel> get availableItems {
    final selectedIds = selectedItemPrices.map((e) => e.itemId).toSet();
    return itemList.where((item) => !selectedIds.contains(item.id)).toList();
  }

  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
    // Clear input fields when item changes
    buyRangeController.clear();
    salesRangeController.clear();
    sellStatus.value = true;
    buyStatus.value = true;
    //maxBuyController.clear();
    //maxSellController.clear();
  }

  void changeSellStatus(bool newValue) {
    sellStatus.value = newValue;
  }

  void changeBuyStatus(bool newValue) {
    buyStatus.value = newValue;
  }

  @override
  void onInit() {
    fetchItemList();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // لیست محصولات
  Future<void> fetchItemList() async{
    try{
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      if(itemList.isEmpty){
        errorMessage.value="هیچ محصولی یافت نشد";
      }
    }
    catch(e){
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }
  }

  // Add selected item with prices to the list
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
    //final sellStatusValue = sellStatus.value;
    //final buyStatusValue = buyStatus.value;
    //final maxBuyText = maxBuyController.text.trim();
    //final maxSellText = maxSellController.text.trim();

    // Validate inputs
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
    //final maxBuy = double.tryParse(maxBuyText.replaceAll(',', '').toEnglishDigit());
    //final maxSell = double.tryParse(maxSellText.replaceAll(',', '').toEnglishDigit());

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
    }*/

   /* if (maxBuy < 0) {
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

    // Check if item already exists
    if (selectedItemPrices.any((e) => e.itemId == selectedItem.value!.id)) {
      Get.snackbar('خطا', 'این محصول قبلا انتخاب شده است',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }

    // Add to list
    selectedItemPrices.add(SelectedItemPrice(
      itemId: selectedItem.value!.id!,
      itemName: selectedItem.value?.name ?? '',
      icon: selectedItem.value?.icon,
      buyRange: buyRange,
      salesRange: salesRange,
      sellStatus: sellStatus.value,
      buyStatus: buyStatus.value,
      /*maxBuy: maxBuy,
      maxSell: maxSell,*/
    ));

    // Clear inputs
    selectedItem.value = null;
    buyRangeController.clear();
    salesRangeController.clear();
    sellStatus.value = true;
    buyStatus.value = true;
    //maxBuyController.clear();
    //maxSellController.clear();

    /*Get.snackbar('موفق', 'محصول با موفقیت اضافه شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.secondary2Color,
        colorText: AppColor.textColor);*/
  }

  // Remove item from selected list
  void removeItemPrice(int itemId) {
    selectedItemPrices.removeWhere((e) => e.itemId == itemId);
  }

  // Validate form and submit
  Future<void> submitForm() async {

    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('خطا', 'لطفا نام زیرگروه را وارد کنید',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }

    if (selectedItemPrices.isEmpty) {
      Get.snackbar('خطا', 'لطفا حداقل یک محصول با قیمت اضافه کنید',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
      return;
    }

    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      // Prepare item prices data
      List<Map<String, dynamic>> itemPricesData = selectedItemPrices.map((itemPrice) {
        return {
          'itemId': itemPrice.itemId,
          'buyRange': itemPrice.buyRange,
          'salesRange': itemPrice.salesRange,
          'sellStatus': itemPrice.sellStatus,
          'buyStatus': itemPrice.buyStatus,
          /*'maxBuy': itemPrice.maxBuy,
          'maxSell': itemPrice.maxSell,*/
        };
      }).toList();

      var response = await accountSalesGroupRepository.insertAccountSalesGroup(
        name: name,
        itemPrices: itemPricesData,
      );

      EasyLoading.dismiss();

      if (response.isNotEmpty) {
        AccountSalesGroupModel responseData=AccountSalesGroupModel.fromJson(response);
        final info = responseData.infos?.first;
        Get.snackbar(
          info['title'] ?? 'موفق' ,
          info['description'] ?? 'درج رکورد موفقیت آمیز',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.secondary2Color,
          colorText: AppColor.textColor,
        );

        accountSalesGroupController.getAccountSalesGroupList();

        // Clear form
        nameController.clear();
        selectedItemPrices.clear();
        selectedItem.value = null;
        buyRangeController.clear();
        salesRangeController.clear();
        sellStatus.value = true;
        buyStatus.value = true;
        //maxBuyController.clear();
        //maxSellController.clear();

        // Navigate back
        Get.offNamed('/accountSalesGroupList');
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('خطا', 'خطا در ایجاد زیرگروه قیمت گذاری: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor);
    }
  }

}
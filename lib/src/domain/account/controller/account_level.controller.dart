


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';

enum PageState{loading,err,empty,list}

class AccountLevelController extends GetxController {

  final AccountRepository accountRepository=AccountRepository();
  final List<AccountLevelModel> accountLevelList=<AccountLevelModel>[].obs;
  var isLoading=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);


  final TextEditingController nameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController positiveGoldController = TextEditingController();
  final TextEditingController negativeGoldController = TextEditingController();
  final Map<int, TextEditingController> maxBuyControllers = {};
  final Map<int, TextEditingController> maxSellControllers = {};
  final Rxn<AccountLevelModel> editingAccountLevel = Rxn<AccountLevelModel>();
  var isSaving = false.obs;

  @override
  void onInit() {
    getAccountLevelList();
    super.onInit();
  }

  @override
  void onClose() {
    // Reason: Clean up text controllers to prevent memory leaks when controller is disposed
    nameController.dispose();
    balanceController.dispose();
    positiveGoldController.dispose();
    negativeGoldController.dispose();
    _clearItemControllers();
    super.onClose();
  }

  // لیست سطوح کاربری
  Future<void> getAccountLevelList() async {
    accountLevelList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await accountRepository.getAccountLevelList();
      isLoading.value=false;
      accountLevelList.assignAll(response);
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // دریافت جزئیات یک سطح کاربر
  Future<AccountLevelModel?> getOneAccountLevel(int accountLevelId) async {
    EasyLoading.show(status: 'در حال دریافت جزئیات...');
    try {
      var response = await accountRepository.getOneAccountLevel(
        accountLevelId: accountLevelId,
      );
      EasyLoading.dismiss();
      return response;
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'خطا',
        'خطا در دریافت جزئیات سطح کاربری: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return null;
    }
  }


  void initializeEditDialog(AccountLevelModel accountLevel) {
    editingAccountLevel.value = accountLevel;
    nameController.text = accountLevel.name ?? '';
    // Reason: Format balance with thousand separators when initializing
    // Minimum input required: accountLevel.balance as double or null
    final balanceValue = accountLevel.balance ?? 0.0;
    final balanceStr = balanceValue.toStringAsFixed(0);
    balanceController.text = balanceStr.seRagham();
    positiveGoldController.text = accountLevel.positiveGold?.toDisplayString() ?? '0';
    negativeGoldController.text = accountLevel.negativeGold?.toDisplayString() ?? '0';

    // Clear existing item controllers
    _clearItemControllers();

    // Initialize controllers for account level items
    if (accountLevel.accountLevelItems != null) {
      for (var item in accountLevel.accountLevelItems!) {
        final itemId = item.itemId ?? 0;
        if (itemId > 0) {
          maxBuyControllers[itemId] = TextEditingController(
            text: item.maxBuy?.toDisplayString() ?? '0',
          );
          maxSellControllers[itemId] = TextEditingController(
            text: item.maxSell?.toDisplayString() ?? '0',
          );
        }
      }
    }
  }

  // Clear item controllers
  // Reason: Dispose and remove item controllers to prevent memory leaks
  void _clearItemControllers() {
    maxBuyControllers.values.forEach((controller) => controller.dispose());
    maxSellControllers.values.forEach((controller) => controller.dispose());
    maxBuyControllers.clear();
    maxSellControllers.clear();
  }

  // Reset edit dialog state
  // Reason: Clean up edit state when dialog is closed
  void resetEditDialog() {
    editingAccountLevel.value = null;
    nameController.clear();
    balanceController.clear();
    positiveGoldController.clear();
    negativeGoldController.clear();
    _clearItemControllers();
  }

  // Validation: Parse and validate numeric input with auto-correction
  // Reason: Ensure all numeric inputs are valid doubles before processing
  // Minimum input required: value (String to parse), optional defaultValue
  double? parseDouble(String value, {double defaultValue = 0.0}) {
    if (value.trim().isEmpty) return defaultValue;
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed.isNaN || parsed.isInfinite) {
      return defaultValue;
    }
    return parsed;
  }

  // Validation: Ensure non-negative values for gold limits
  // Reason: Gold limits should not be negative (auto-correct to 0 if negative)
  // Minimum input required: value (String to validate)
  double validateNonNegativeGold(String value) {
    final parsed = parseDouble(value, defaultValue: 0.0) ?? 0.0;
    return parsed < 0 ? 0.0 : parsed;
  }

  // ویرایش سطح کاربری
  // Reason: This method validates and updates account level data including balance, positiveGold, negativeGold, and item prices
  // Minimum input required: accountLevelId (must be > 0), balance, positiveGold, negativeGold as valid doubles
  Future<bool> updateAccountLevel({
    required int accountLevelId,
    String? name,
    required double balance,
    required double positiveGold,
    required double negativeGold,
    required List<Map<String, dynamic>> accountLevelItems,
  }) async {
    // Validation: Check accountLevelId is valid
    if (accountLevelId <= 0) {
      Get.snackbar(
        'خطا',
        'شناسه سطح کاربری نامعتبر است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }

    // Validation: Check numeric values are valid (not NaN and not Infinity)
    if (balance.isNaN || balance.isInfinite) {
      Get.snackbar(
        'خطا',
        'مقدار بالانس نامعتبر است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }

    if (positiveGold.isNaN || positiveGold.isInfinite || positiveGold < 0) {
      Get.snackbar(
        'خطا',
        'حد مثبت طلایی باید عددی معتبر و مثبت باشد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }

    if (negativeGold.isNaN || negativeGold.isInfinite || negativeGold > 0) {
      Get.snackbar(
        'خطا',
        'حد منفی طلایی باید عددی معتبر و منفی باشد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }

    EasyLoading.show(status: 'در حال ذخیره تغییرات...');
    try {
      final response = await accountRepository.updateAccountLevel(
        accountLevelId: accountLevelId,
        name: name,
        balance: balance,
        positiveGold: positiveGold,
        negativeGold: negativeGold,
        accountLevelItems: accountLevelItems,
      );

      EasyLoading.dismiss();

      // Validation: Check response is successful
      if (response.containsKey('status') && response['status'] == 'failure') {
        final message = response['message'] ?? 'خطا در ویرایش سطح کاربری';
        Get.snackbar(
          'خطا',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.accentColor,
          colorText: AppColor.textColor,
        );
        return false;
      }

      // Auto-correction: Refresh the list to get updated data
      await getAccountLevelList();

      Get.snackbar(
        'موفق',
        'سطح کاربری با موفقیت ویرایش شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryColor,
        colorText: AppColor.textColor,
      );
      return true;
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'خطا',
        'خطا در ویرایش سطح کاربری: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }
  }

  // Save edited account level
  // Reason: Validate controller state and call updateAccountLevel with formatted data
  // Minimum input required: None - uses controller state (editingAccountLevel, text controllers)
  Future<bool> saveEditedAccountLevel() async {
    final accountLevel = editingAccountLevel.value;
    if (accountLevel == null) {
      Get.snackbar(
        'خطا',
        'هیچ سطح کاربری برای ویرایش انتخاب نشده است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }

    final accountLevelId = accountLevel.id ?? 0;
    if (accountLevelId <= 0) {
      Get.snackbar(
        'خطا',
        'شناسه سطح کاربری نامعتبر است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }

    // Auto-correction: Parse and validate balance (remove comma separators)
    // Reason: Remove thousand separators before parsing to double
    // Minimum input required: Valid numeric string (with or without commas)
    final balanceText = balanceController.text.replaceAll(',', '').replaceAll('،', '');
    final balance = parseDouble(balanceText, defaultValue: 0.0) ?? 0.0;

    // Auto-correction: Validate positiveGold (must be >= 0)
    final positiveGold = validateNonNegativeGold(positiveGoldController.text);
    if (positiveGold != (parseDouble(positiveGoldController.text) ?? 0.0)) {
      positiveGoldController.text = positiveGold.toString();
    }

    // Auto-correction: Validate negativeGold (must be <= 0)
    // Reason: negativeGold should only accept negative numbers or zero
    // Minimum input required: Valid numeric string that is <= 0
    final negativeGoldParsed = parseDouble(negativeGoldController.text, defaultValue: 0.0) ?? 0.0;
    final negativeGold = negativeGoldParsed > 0 ? 0.0 : negativeGoldParsed;
    if (negativeGold != negativeGoldParsed) {
      negativeGoldController.text = negativeGold.toString();
    }

    // Format account level items for API
    // Reason: Convert edited item prices to API format with itemId, maxBuy, maxSell
    // Minimum input required: accountLevelItems list with valid itemIds
    final List<Map<String, dynamic>> accountLevelItems = [];
    if (accountLevel.accountLevelItems != null) {
      for (var item in accountLevel.accountLevelItems!) {
        final itemId = item.itemId ?? 0;
        if (itemId > 0) {
          // Auto-correction: Validate maxBuy and maxSell (must be >= 0)
          final maxBuy = validateNonNegativeGold(
            maxBuyControllers[itemId]?.text ?? item.maxBuy?.toString() ?? '0',
          );
          final maxSell = validateNonNegativeGold(
            maxSellControllers[itemId]?.text ?? item.maxSell?.toString() ?? '0',
          );

          // Update controller values if auto-corrected
          if (maxBuyControllers[itemId] != null &&
              maxBuy != (parseDouble(maxBuyControllers[itemId]!.text) ?? 0.0)) {
            maxBuyControllers[itemId]!.text = maxBuy.toString();
          }
          if (maxSellControllers[itemId] != null &&
              maxSell != (parseDouble(maxSellControllers[itemId]!.text) ?? 0.0)) {
            maxSellControllers[itemId]!.text = maxSell.toString();
          }

          accountLevelItems.add({
            'itemId': itemId,
            'maxBuy': maxBuy,
            'maxSell': maxSell,
          });
        }
      }
    }

    // Validation: Final check before API call
    // Validate result: All numeric values are valid (not NaN, not Infinity, gold limits >= 0)
    if (balance.isNaN || balance.isInfinite) {
      Get.snackbar(
        'خطا',
        'مقدار بالانس نامعتبر است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return false;
    }

    isSaving.value = true;
    // Reason: Use the original name from accountLevel since name field is not editable
    // Minimum input required: accountLevel with valid name
    final success = await updateAccountLevel(
      accountLevelId: accountLevelId,
      name: accountLevel.name,
      balance: balance,
      positiveGold: positiveGold,
      negativeGold: negativeGold,
      accountLevelItems: accountLevelItems,
    );
    isSaving.value = false;

    // Validation: Check update result
    // Auto-correction: Reset edit state only on success
    if (success) {
      resetEditDialog();
    }

    return success;
  }

}
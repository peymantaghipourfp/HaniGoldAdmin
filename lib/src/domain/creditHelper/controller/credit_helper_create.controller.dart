import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/credit_helper.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/repository/item.repository.dart';
import '../../../domain/product/model/item.model.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../base/base_controller.dart';
import '../controller/credit_helper.controller.dart';

enum PageState { loading, err, empty, list }

class CreditHelperCreateController extends BaseController {
  final CreditHelperController creditHelperController = Get.find<CreditHelperController>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final CreditHelperRepository creditHelperRepository = CreditHelperRepository();
  final AccountRepository accountRepository = AccountRepository();
  final ItemRepository itemRepository = ItemRepository();

  final List<AccountModel> accountList = <AccountModel>[].obs;
  final List<ItemModel> itemList = <ItemModel>[].obs;
  Rx<PageState> state = Rx<PageState>(PageState.list);
  var errorMessage = ''.obs;
  var isLoading = true.obs;
  var isLoadingItems = false.obs;

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<ItemModel> selectedItem = Rxn<ItemModel>();
  final Rxn<String> selectedType = Rxn<String>();
  final RxBool isActive = RxBool(true);

  // Error handling
  var hasError = false.obs;
  var errorTitle = ''.obs;
  var dropdownError = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccountList();
    fetchItemList();
    // Get type list from parent controller
    if (creditHelperController.typeList.isNotEmpty) {
      // Set default type if available
      if (creditHelperController.typeList.isNotEmpty) {
        selectedType.value = creditHelperController.typeList.first.name;
      }
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async {
    try {
      state.value = PageState.loading;
      var fetchedAccountList = await accountRepository.getAccountList("");
      accountList.assignAll(fetchedAccountList);
      state.value = PageState.list;
      if (accountList.isEmpty) {
        state.value = PageState.empty;
      }
    } catch (e) {
      state.value = PageState.err;
      errorMessage.value = "خطایی هنگام بارگذاری کاربران به وجود آمده است ${e.toString()}";
      showError('خطا در بارگذاری کاربران', 'خطایی هنگام بارگذاری کاربران به وجود آمده است: ');
    } finally {
      isLoading.value = false;
    }
  }

  // لیست آیتم ها
  Future<void> fetchItemList() async {
    try {
      isLoadingItems.value = true;
      var fetchedItemList = await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
    } catch (e) {
      print("Error loading items: $e");
    } finally {
      isLoadingItems.value = false;
    }
  }

  // پاک کردن لیست ها
  void clearList() {
    selectedAccount.value = null;
    selectedItem.value = null;
    selectedType.value = null;
    amountController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
    isActive.value = true;
    dropdownError.value = "";
    clearError();
  }

  // پاک کردن خطاها
  void clearError() {
    hasError.value = false;
    errorTitle.value = '';
    errorMessage.value = '';
  }

  // نمایش خطا
  void showError(String title, String message) {
    hasError.value = true;
    errorTitle.value = title;
    errorMessage.value = message;
  }

  // درج اعتبار جدید
  Future<void> insertCreditHelper() async {
    try {
      EasyLoading.show(status: 'لطفا صبر کنید...');
      isLoading.value = true;

      // Convert Persian dates to Gregorian
      String? gregorianStartDate;
      String? gregorianEndDate;

      if (startDateController.text.isNotEmpty) {
        gregorianStartDate = convertJalaliToGregorian(startDateController.text);
      }

      if (endDateController.text.isNotEmpty) {
        gregorianEndDate = convertJalaliToGregorian(endDateController.text);
      }

      // Validate required fields
      if (selectedAccount.value == null) {
        showError('خطا', 'لطفا کاربر را انتخاب کنید');
        return;
      }

      if (selectedType.value == null || selectedType.value!.isEmpty) {
        showError('خطا', 'لطفا نوع اعتبار را انتخاب کنید');
        return;
      }
      if (selectedItem.value == null) {
        showError('خطا', 'لطفا آیتم را انتخاب کنید');
        return;
      }

      if (amountController.text.isEmpty) {
        showError('خطا', 'لطفا مقدار اعتبار را وارد کنید');
        return;
      }

      // Find type ID from name
      final selectedTypeModel = creditHelperController.typeList.firstWhere(
            (type) => type.name == selectedType.value,
        orElse: () => throw Exception('نوع انتخاب شده یافت نشد'),
      );

      // Parse amount
      final amount = double.tryParse(amountController.text.replaceAll(',', '').toEnglishDigit());
      if (amount == null || amount <= 0) {
        showError('خطا', 'مقدار اعتبار باید عدد مثبت باشد');
        return;
      }
      if (Get.isDialogOpen!) Get.back();
      var response = await creditHelperRepository.insertCreditHelper(
        startDate: gregorianStartDate,
        endDate: gregorianEndDate,
        accountId: selectedAccount.value?.id ?? 0,
        type: selectedTypeModel.id ?? 0,
        itemId: selectedItem.value?.id ?? 0,
        amount: amount,
        description: descriptionController.text.isEmpty ? null : descriptionController.text,
        isActive: isActive.value,
      );

      if (response != null) {
        // Check if there are any errors in the response
        if (response['infos'] != null && response['infos'].isNotEmpty) {
          var firstInfo = response['infos'].first;
          String title = firstInfo['title'] ?? 'خطا';
          String description = firstInfo['description'] ?? 'خطای نامشخص';

          // Check if this is an error
          if (title.toLowerCase().contains('خطا') || title.toLowerCase().contains('error') ||
              description.toLowerCase().contains('خطا') || description.toLowerCase().contains('error')) {
            showError(title, description);
          } else {
            // Refresh the list
            creditHelperController.refreshCreditHelperListSilently();
            clearList();
            clearError();
            Get.back();
            Get.back();
            // Success message
            Get.snackbar(title, description,
                titleText: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor),),
                messageText: Text(
                    description, textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.textColor)));

            // Close dialogs after a short delay to allow snackbar to display
            /*Future.delayed(Duration(milliseconds: 200), () {
              Get.back(); // Close confirmation dialog
              Get.back(); // Close main create dialog
            });*/
          }
        } else {
          // Refresh the list
          creditHelperController.getCreditHelperListPager();
          clearList();
          clearError();
          Get.back();
          Get.back();
          // No info in response, assume success
          Get.snackbar('موفقیت', 'اعتبار جدید با موفقیت ایجاد شد',
              titleText: Text('موفقیت',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                  'اعتبار جدید با موفقیت ایجاد شد', textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor)));

          // Close dialogs after a short delay to allow snackbar to display
          /*Future.delayed(Duration(milliseconds: 200), () {
            Get.back(); // Close confirmation dialog
            Get.back(); // Close main create dialog
          });*/
        }
      }
    } catch (e) {
      showError('خطا در ایجاد اعتبار', 'خطا: ${e.toString()}');
      print('خطا در ایجاد اعتبار: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
}

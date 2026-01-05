import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/account_sales_group.repository.dart';
import 'package:hanigold_admin/src/config/repository/user.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:hanigold_admin/src/domain/accountSalesGroup/model/account_sales_group.model.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_list.controller.dart';
import 'package:hanigold_admin/src/domain/users/model/city_item.model.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class UserCreateDialogController extends GetxController {
  // Dependencies
  final UserRepository userRepository = UserRepository();
  final AccountSalesGroupRepository accountSalesGroupRepository = AccountSalesGroupRepository();
  final AccountRepository accountRepository = AccountRepository();

  // Loading and error states
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorTitle = ''.obs;
  var errorMessage = ''.obs;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalCodeController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Dropdown data lists
  RxList<StateItemModel> stateList = <StateItemModel>[].obs;
  RxList<CityItemModel> cityList = <CityItemModel>[].obs;
  RxList<AccountGroupModel> accountGroupList = <AccountGroupModel>[].obs;
  RxList<AccountSalesGroupModel> accountSalesGroupList = <AccountSalesGroupModel>[].obs;
  RxList<AccountLevelModel> accountLevelList = <AccountLevelModel>[].obs;

  // Selected values
  final Rxn<StateItemModel> selectedState = Rxn<StateItemModel>();
  final Rxn<CityItemModel> selectedCity = Rxn<CityItemModel>();
  final Rxn<AccountGroupModel> selectedAccountGroup = Rxn<AccountGroupModel>();
  final Rxn<AccountSalesGroupModel> selectedAccountSalesGroup = Rxn<AccountSalesGroupModel>();
  final Rxn<AccountLevelModel> selectedAccountLevel = Rxn<AccountLevelModel>();

  // Other form fields
  var hasDeposit = false.obs;

  // Validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  @override
  void onClose() {
    // Clean up controllers
    nameController.dispose();
    nationalCodeController.dispose();
    userController.dispose();
    mobileController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      getStateList(),
      getCityList(),
      getAccountGroup(),
      getAccountSalesGroupList(),
      getAccountLevelList(),
    ]);
  }

  // لیست استان ها
  Future<void> getStateList() async {
    try {
      final response = await userRepository.getStateList(
        startIndex: 1,
        toIndex: 1000,
      );
      stateList.assignAll(response);
      if (stateList.isNotEmpty) {
        selectedState.value = stateList.first;
      }
    } catch (e) {
      _setError('خطا در دریافت استان‌ها', 'دریافت لیست استان‌ها با مشکل مواجه شد');
    }
  }

  // لیست شهر ها
  Future<void> getCityList() async {
    try {
      final response = await userRepository.getCityList(
        startIndex: 1,
        toIndex: 1000,
      );
      cityList.assignAll(response);
      if (cityList.isNotEmpty) {
        selectedCity.value = cityList.first;
      }
    } catch (e) {
      _setError('خطا در دریافت شهرها', 'دریافت لیست شهرها با مشکل مواجه شد');
    }
  }

  // لیست گروه اکانت ها
  Future<void> getAccountGroup() async {
    try {
      final response = await userRepository.getAccountGroup();
      accountGroupList.assignAll(response);
      if (accountGroupList.isNotEmpty) {
        selectedAccountGroup.value = accountGroupList.first;
      }
    } catch (e) {
      _setError('خطا در دریافت گروه‌های اکانت', 'دریافت لیست گروه‌های اکانت با مشکل مواجه شد');
    }
  }

  // لیست گروه قیمت گذاری
  Future<void> getAccountSalesGroupList() async {
    try {
      final response = await accountSalesGroupRepository.getAccountSalesGroupList();
      accountSalesGroupList.assignAll(response);
      if (accountSalesGroupList.isNotEmpty) {
        selectedAccountSalesGroup.value = accountSalesGroupList.firstWhereOrNull((g) => g.isDefault == true) ?? accountSalesGroupList.first;
      }
    } catch (e) {
      _setError('خطا در دریافت گروه‌های قیمت‌گذاری', 'دریافت لیست گروه‌های قیمت‌گذاری با مشکل مواجه شد');
    }
  }

  // لیست سطوح کاربر
  Future<void> getAccountLevelList() async {
    try {
      final response = await accountRepository.getAccountLevelList();
      accountLevelList.assignAll(response);
      if (accountLevelList.isNotEmpty) {
        selectedAccountLevel.value = accountLevelList.first;
      }
    } catch (e) {
      _setError('خطا در دریافت سطوح کاربر', 'دریافت لیست سطوح کاربر با مشکل مواجه شد');
    }
  }

  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    clearError();

    try {
      final response = await userRepository.insertUser(
        accountGroupId: selectedAccountGroup.value?.id ?? 0,
        accountSalesGroupId: selectedAccountSalesGroup.value?.id ?? 0,
        accountLevelId: selectedAccountLevel.value?.id ?? 0,
        name: nameController.text.trim(),
        nationalCode: nationalCodeController.text.toEnglishDigit(),
        mobile: mobileController.text.toEnglishDigit(),
        phoneNumber: phoneController.text.toEnglishDigit(),
        email: emailController.text.trim(),
        //user: userController.text.trim(),
        hasDeposit: hasDeposit.value,
        state: selectedState.value?.name ?? "",
        idState: selectedState.value?.id ?? 0,
        city: selectedCity.value?.name ?? "",
        idCity: selectedCity.value?.id ?? 0,
        address: addressController.text.trim(),
      );

      // Refresh user list if controller exists
      if (Get.isRegistered<UserListController>()) {
        final userListController = Get.find<UserListController>();
        userListController.getUserList();
        update();
      }

      Get.back(); // Close dialog

      // Show success message
      Get.snackbar(
        response.infos?.first["title"] ?? "موفقیت",
        response.infos?.first["description"] ?? "کاربر با موفقیت ایجاد شد",
        titleText: Text(
          response.infos?.first["title"] ?? "موفقیت",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          response.infos?.first["description"] ?? "کاربر با موفقیت ایجاد شد",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade600,
        snackPosition: SnackPosition.TOP,
      );

    } catch (e) {
      _setError('خطا در ایجاد کاربر', 'ایجاد کاربر با مشکل مواجه شد. لطفا دوباره تلاش کنید.');
    } finally {
      isLoading.value = false;
    }
  }

  void _setError(String title, String message) {
    hasError.value = true;
    errorTitle.value = title;
    errorMessage.value = message;
  }

  void clearError() {
    hasError.value = false;
    errorTitle.value = '';
    errorMessage.value = '';
  }

  void clearForm() {
    nameController.clear();
    nationalCodeController.clear();
    userController.clear();
    mobileController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    hasDeposit.value = false;

    // Reset to defaults
    if (stateList.isNotEmpty) selectedState.value = stateList.first;
    if (cityList.isNotEmpty) selectedCity.value = cityList.first;
    if (accountGroupList.isNotEmpty) selectedAccountGroup.value = accountGroupList.first;
    if (accountSalesGroupList.isNotEmpty) {
      selectedAccountSalesGroup.value = accountSalesGroupList.firstWhereOrNull((g) => g.isDefault == true) ?? accountSalesGroupList.first;
    }
    if (accountLevelList.isNotEmpty) selectedAccountLevel.value = accountLevelList.first;

    clearError();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'لطفا نام را وارد کنید';
    }
    if (value.trim().length < 2) {
      return 'نام باید حداقل ۲ کاراکتر باشد';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'لطفا نام کاربری را وارد کنید';
    }
    if (value.trim().length < 3) {
      return 'نام کاربری باید حداقل ۳ کاراکتر باشد';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'لطفا شماره موبایل را وارد کنید';
    }
    // Convert Persian digits to English for validation
    String englishValue = value.toEnglishDigit();
    final mobileRegex = RegExp(r'^[0-9]{10,11}$');
    if (!mobileRegex.hasMatch(englishValue)) {
      return 'شماره موبایل معتبر نیست';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'ایمیل معتبر نیست';
    }
    return null;
  }

  String? validateAccountGroup(AccountGroupModel? value) {
    if (value == null) {
      return 'لطفا نقش کاربر را انتخاب کنید';
    }
    return null;
  }

  String? validateAccountSalesGroup(AccountSalesGroupModel? value) {
    if (value == null) {
      return 'لطفا گروه قیمت‌گذاری را انتخاب کنید';
    }
    return null;
  }

  String? validateAccountLevel(AccountLevelModel? value) {
    if (value == null) {
      return 'لطفا سطح کاربر را انتخاب کنید';
    }
    return null;
  }

  String? validateState(StateItemModel? value) {
    if (value == null) {
      return 'لطفا استان را انتخاب کنید';
    }
    return null;
  }

  String? validateCity(CityItemModel? value) {
    if (value == null) {
      return 'لطفا شهر را انتخاب کنید';
    }
    return null;
  }
}

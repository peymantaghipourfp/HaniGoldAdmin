import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/account_sales_group.repository.dart';
import 'package:hanigold_admin/src/config/repository/user.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:hanigold_admin/src/domain/accountSalesGroup/model/account_sales_group.model.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_list.controller.dart';
import 'package:hanigold_admin/src/domain/users/model/city_item.model.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class UserUpdateDialogController extends GetxController {
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

  // Update specific fields
  AccountModel? accountModel;
  var accountId = 0.obs;
  var type = 0.obs;
  var code = ''.obs;
  var contactId = 0.obs;
  var contactInfoId0 = 0.obs;
  var contactInfoId1 = 0.obs;
  var contactInfoId2 = 0.obs;

  // Form validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    accountId.value = Get.arguments?['accountId'] ?? 0;
    if (accountId.value != 0) {
      loadInitialData();
      loadAccountData(accountId.value);
    }
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

  Future<void> loadAccountData(int id) async {
    isLoading.value = true;
    clearError();

    try {
      final response = await userRepository.getOneAccount(id: id);
      accountModel = response;

      // Populate form fields
      nameController.text = accountModel?.name ?? '';
      nationalCodeController.text = accountModel?.nationalCode ?? '';

      // Populate contact info
      if (accountModel?.contactInfos != null) {
        for (var contactInfo in accountModel!.contactInfos!) {
          if (contactInfo.type == 0) { // Mobile
            mobileController.text = contactInfo.value ?? '';
            contactId.value = contactInfo.contact?.id ?? 0;
            contactInfoId0.value = contactInfo.id ?? 0;
          } else if (contactInfo.type == 1) { // Phone
            phoneController.text = contactInfo.value ?? '';
            contactInfoId1.value = contactInfo.id ?? 0;
          } else if (contactInfo.type == 2) { // Email
            emailController.text = contactInfo.value ?? '';
            contactInfoId2.value = contactInfo.id ?? 0;
          }
        }
      }

      // Populate address
      if (accountModel?.addresses != null && accountModel!.addresses!.isNotEmpty) {
        addressController.text = accountModel!.addresses!.first.fullAddress ?? '';
        selectedState.value = accountModel!.addresses!.first.state;
        selectedCity.value = accountModel!.addresses!.first.city;
      }

      // Populate account settings
      selectedAccountGroup.value = accountModel?.accountGroup;
      selectedAccountSalesGroup.value = accountModel?.accountSalesGroup;
      selectedAccountLevel.value = accountModel?.accountLevel;
      type.value = accountModel?.type ?? 0;
      code.value = accountModel?.code ?? '';
      hasDeposit.value = accountModel?.hasDeposit ?? false;

    } catch (e) {
      _setError('خطا در دریافت اطلاعات', 'دریافت اطلاعات کاربر با مشکل مواجه شد');
    } finally {
      isLoading.value = false;
    }
  }

  // لیست استان ها
  Future<void> getStateList() async {
    try {
      final response = await userRepository.getStateList(
        startIndex: 1,
        toIndex: 1000,
      );
      stateList.assignAll(response);
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
    } catch (e) {
      _setError('خطا در دریافت شهرها', 'دریافت لیست شهرها با مشکل مواجه شد');
    }
  }

  // لیست گروه اکانت ها
  Future<void> getAccountGroup() async {
    try {
      final response = await userRepository.getAccountGroup();
      accountGroupList.assignAll(response);
    } catch (e) {
      _setError('خطا در دریافت گروه‌های اکانت', 'دریافت لیست گروه‌های اکانت با مشکل مواجه شد');
    }
  }

  // لیست گروه قیمت گذاری
  Future<void> getAccountSalesGroupList() async {
    try {
      final response = await accountSalesGroupRepository.getAccountSalesGroupList();
      accountSalesGroupList.assignAll(response);
    } catch (e) {
      _setError('خطا در دریافت گروه‌های قیمت‌گذاری', 'دریافت لیست گروه‌های قیمت‌گذاری با مشکل مواجه شد');
    }
  }

  // لیست سطوح کاربر
  Future<void> getAccountLevelList() async {
    try {
      final response = await accountRepository.getAccountLevelList();
      accountLevelList.assignAll(response);
    } catch (e) {
      _setError('خطا در دریافت سطوح کاربر', 'دریافت لیست سطوح کاربر با مشکل مواجه شد');
    }
  }

  Future<void> updateUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    clearError();

    try {
      final response = await userRepository.updateUser(
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
        id: accountId.value,
        status: 1, // Active status
        type: type.value,
        code: code.value,
        accountId: accountId.value,
        contactId: contactId.value,
        contactInfoId0: contactInfoId0.value,
        contactInfoId1: contactInfoId1.value,
        contactInfoId2: contactInfoId2.value,
      );

      // Refresh user list if controller exists
      if (Get.isRegistered<UserListController>()) {
        final userListController = Get.find<UserListController>();
        userListController.getUserList();
      }

      Get.back(); // Close dialog

      // Show success message
      Get.snackbar(
        'موفقیت',
        'اطلاعات کاربر با موفقیت بروزرسانی شد',
        titleText: Text(
          'موفقیت',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          'اطلاعات کاربر با موفقیت بروزرسانی شد',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade600,
        snackPosition: SnackPosition.TOP,
      );

    } catch (e) {
      _setError('خطا در بروزرسانی کاربر', 'بروزرسانی کاربر با مشکل مواجه شد. لطفا دوباره تلاش کنید.');
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
    selectedState.value = null;
    selectedCity.value = null;
    selectedAccountGroup.value = null;
    selectedAccountSalesGroup.value = null;
    selectedAccountLevel.value = null;

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

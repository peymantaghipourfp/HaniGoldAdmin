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
import 'package:image_picker/image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';

import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/upload.repository.dart';

class UserUpdateDialogController extends GetxController {
  // Dependencies
  final UserRepository userRepository = UserRepository();
  final AccountSalesGroupRepository accountSalesGroupRepository = AccountSalesGroupRepository();
  final AccountRepository accountRepository = AccountRepository();
  final UploadRepositoryDesktop uploadRepositoryDesktop = UploadRepositoryDesktop();
  final RemittanceRepository remittanceRepository = RemittanceRepository();
  final Uuid uuid = Uuid();

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

  // Image related controllers and state
  final TextEditingController recIdController = TextEditingController();

  final ImagePicker _pickerNationalCode = ImagePicker();
  final ImagePicker _pickerBusinessLicense = ImagePicker();

  RxList<XFile?> selectedImagesNationalCodeDesktop = RxList<XFile?>();
  RxList<XFile?> selectedImagesBusinessLicenseDesktop = RxList<XFile?>();
  RxList<String> existingImagesNationalCode = RxList<String>();
  RxList<String> existingImagesBusinessLicense = RxList<String>();

  RxBool isUploadingNationalCodeDesktop = false.obs;
  RxBool isUploadingBusinessLicenseDesktop = false.obs;
  RxList<bool> uploadStatusesNationalCodeDesktop = RxList<bool>();
  RxList<bool> uploadStatusesBusinessLicenseDesktop = RxList<bool>();

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
    recIdController.dispose();
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

      // Load existing images
      if (accountModel?.recId != null) {
        recIdController.text = accountModel!.recId!;
        await getImage(accountModel!.recId!, "NationalCode");
        await getImage(accountModel!.recId!, "BusinessLicense");
      }

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

  Future<void> updateUser(String recId) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    clearError();

    try {
      if (Get.isDialogOpen!) Get.back();
      await userRepository.updateUser(
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
        recId: recId,
      );
      if (Get.isDialogOpen!) Get.back();
      Get.back(); // Close dialog
      // Refresh user list if controller exists
      if (Get.isRegistered<UserListController>()) {
        final userListController = Get.find<UserListController>();
        userListController.getUserList();
      }

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
    recIdController.clear();
    hasDeposit.value = false;

    // Clear image-related state
    selectedImagesNationalCodeDesktop.clear();
    selectedImagesBusinessLicenseDesktop.clear();
    existingImagesNationalCode.clear();
    existingImagesBusinessLicense.clear();
    uploadStatusesNationalCodeDesktop.clear();
    uploadStatusesBusinessLicenseDesktop.clear();
    isUploadingNationalCodeDesktop.value = false;
    isUploadingBusinessLicenseDesktop.value = false;

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

  // Image management methods
  Future<void> pickImageNationalCodeDesktop() async {
    try {
      final List<XFile?> images = await _pickerNationalCode.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImagesNationalCodeDesktop.addAll(images);
      }
    } catch (e) {
      throw Exception('خطا در انتخاب فایل‌ها');
    }
  }

  Future<void> pickImageBusinessLicenseDesktop() async {
    try {
      final List<XFile?> images = await _pickerBusinessLicense.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImagesBusinessLicenseDesktop.addAll(images);
      }
    } catch (e) {
      throw Exception('خطا در انتخاب فایل‌ها');
    }
  }

  Future<void> handleDroppedFilesNationalCode(List<XFile> files) async {
    try {
      // Filter only image files
      final imageFiles = files.where((file) {
        final fileName = file.name.toLowerCase();
        final extension = fileName.contains('.') ? fileName.split('.').last : '';

        // Also check MIME type as a fallback
        final mimeType = file.mimeType?.toLowerCase() ?? '';
        final isImageByExtension = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
        final isImageByMimeType = mimeType.startsWith('image/');

        return isImageByExtension || isImageByMimeType;
      }).toList();

      if (imageFiles.isNotEmpty) {
        selectedImagesNationalCodeDesktop.addAll(imageFiles);
        Get.snackbar("موفقیت", "${imageFiles.length} تصویر اضافه شد");
      } else {
        Get.snackbar("خطا", "فقط فایل‌های تصویری قابل قبول هستند");
      }
    } catch (e) {
      Get.snackbar("خطا", "خطا در پردازش فایل‌های رها شده");
    }
  }

  Future<void> handleDroppedFilesBusinessLicense(List<XFile> files) async {
    try {
      // Filter only image files
      final imageFiles = files.where((file) {
        final fileName = file.name.toLowerCase();
        final extension = fileName.contains('.') ? fileName.split('.').last : '';

        // Also check MIME type as a fallback
        final mimeType = file.mimeType?.toLowerCase() ?? '';
        final isImageByExtension = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
        final isImageByMimeType = mimeType.startsWith('image/');

        return isImageByExtension || isImageByMimeType;
      }).toList();

      if (imageFiles.isNotEmpty) {
        selectedImagesBusinessLicenseDesktop.addAll(imageFiles);
        Get.snackbar("موفقیت", "${imageFiles.length} تصویر اضافه شد");
      } else {
        Get.snackbar("خطا", "فقط فایل‌های تصویری قابل قبول هستند");
      }
    } catch (e) {
      Get.snackbar("خطا", "خطا در پردازش فایل‌های رها شده");
    }
  }

  Future<void> getImage(String fileName, String type) async {
    try {
      var fetch = await remittanceRepository.getImage(fileName: fileName, type: type);
      if (type == "NationalCode") {
        existingImagesNationalCode.assignAll(fetch.guidIds);
      } else if (type == "BusinessLicense") {
        existingImagesBusinessLicense.assignAll(fetch.guidIds);
      }
    } catch (e) {
      // Handle error silently for existing images
    }
  }

  Future<void> deleteImage(String fileName) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      var fetch = await remittanceRepository.deleteImage(fileName: fileName);
      if (fetch) {
        // Refresh images after deletion
        await getImage(recIdController.text, "NationalCode");
        await getImage(recIdController.text, "BusinessLicense");
      }
    } catch (e) {
      // Handle error
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> uploadAllImagesAndUpdateUser() async {
    // Generate single recordId for all uploads
    String recordId = uuid.v4();

    final hasNationalCodeImages = selectedImagesNationalCodeDesktop.isNotEmpty;
    final hasBusinessLicenseImages = selectedImagesBusinessLicenseDesktop.isNotEmpty;
    final hasAnyImages = hasNationalCodeImages || hasBusinessLicenseImages;

    // If no images selected, update user directly
    if (!hasAnyImages) {
      await updateUser(recordId);
      return;
    }

    // Set loading states for both image types
    isUploadingNationalCodeDesktop.value = true;
    isUploadingBusinessLicenseDesktop.value = true;

    // Initialize status lists
    uploadStatusesNationalCodeDesktop.assignAll(
        List.filled(selectedImagesNationalCodeDesktop.length, false)
    );
    uploadStatusesBusinessLicenseDesktop.assignAll(
        List.filled(selectedImagesBusinessLicenseDesktop.length, false)
    );

    bool allUploadsSuccessful = true;

    try {
      // Upload national code images first
      if (hasNationalCodeImages) {
        for (int i = 0; i < selectedImagesNationalCodeDesktop.length; i++) {
          final file = selectedImagesNationalCodeDesktop[i];
          if (file != null) {
            try {
              final bytes = await file.readAsBytes();
              String success = await uploadRepositoryDesktop.uploadImageDesktop(
                imageBytes: bytes,
                fileName: file.name,
                recordId: recIdController.text,
                type: "image",
                entityType: "NationalCode",
              );
              uploadStatusesNationalCodeDesktop[i] = success.isNotEmpty;
            } catch (e) {
              uploadStatusesNationalCodeDesktop[i] = false;
              allUploadsSuccessful = false;
              Get.snackbar("خطا", "خطا در آپلود تصویر کارت ملی ${i + 1}");
            }
          }
        }
      }

      // Upload business license images
      if (hasBusinessLicenseImages) {
        for (int i = 0; i < selectedImagesBusinessLicenseDesktop.length; i++) {
          final file = selectedImagesBusinessLicenseDesktop[i];
          if (file != null) {
            try {
              final bytes = await file.readAsBytes();
              String success = await uploadRepositoryDesktop.uploadImageDesktop(
                imageBytes: bytes,
                fileName: file.name,
                recordId: recIdController.text,
                type: "image",
                entityType: "BusinessLicense",
              );
              uploadStatusesBusinessLicenseDesktop[i] = success.isNotEmpty;
            } catch (e) {
              uploadStatusesBusinessLicenseDesktop[i] = false;
              allUploadsSuccessful = false;
              Get.snackbar("خطا", "خطا در آپلود تصویر جواز کسب ${i + 1}");
            }
          }
        }
      }

      // Check if all uploads were successful
      final nationalCodeSuccess = !hasNationalCodeImages ||
          uploadStatusesNationalCodeDesktop.every((status) => status);
      final businessLicenseSuccess = !hasBusinessLicenseImages ||
          uploadStatusesBusinessLicenseDesktop.every((status) => status);

      if (nationalCodeSuccess && businessLicenseSuccess) {
        Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
        await updateUser(recordId);
        Get.back();
      } else {
        Get.snackbar("خطا", "برخی از آپلودها با شکست مواجه شدند");
      }

    } finally {
      // Clear loading states and lists
      isUploadingNationalCodeDesktop.value = false;
      isUploadingBusinessLicenseDesktop.value = false;
      selectedImagesNationalCodeDesktop.clear();
      selectedImagesBusinessLicenseDesktop.clear();
      uploadStatusesNationalCodeDesktop.clear();
      uploadStatusesBusinessLicenseDesktop.clear();
    }
  }

}

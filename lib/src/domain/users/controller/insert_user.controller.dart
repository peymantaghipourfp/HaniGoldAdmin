

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_list.controller.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/account_sales_group.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/upload.repository.dart';
import '../../../config/repository/user.repository.dart';
import '../../account/model/account.model.dart';
import '../../accountSalesGroup/model/account_sales_group.model.dart';
import '../model/city_item.model.dart';


enum PageState{loading,err,empty,list}

class InsertUserController extends GetxController{

  var controller=Get.find<UserListController>();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  var isChecked=false.obs;
  var isLoading=false.obs;
  UserRepository userRepository=UserRepository();
  AccountSalesGroupRepository accountSalesGroupRepository=AccountSalesGroupRepository();
  AccountRepository accountRepository=AccountRepository();
  UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();
  RemittanceRepository remittanceRepository=RemittanceRepository();
  ScrollController scrollController = ScrollController();
  // Image upload related fields
  final ImagePicker _pickerNationalCode = ImagePicker();
  final ImagePicker _pickerBusinessLicense = ImagePicker();
  RxList<XFile?> selectedImagesNationalCodeDesktop = RxList<XFile?>();
  RxList<XFile?> selectedImagesBusinessLicenseDesktop = RxList<XFile?>();
  RxBool isUploadingNationalCodeDesktop = false.obs;
  RxBool isUploadingBusinessLicenseDesktop = false.obs;
  RxList<bool> uploadStatusesNationalCodeDesktop = RxList<bool>();
  RxList<bool> uploadStatusesBusinessLicenseDesktop = RxList<bool>();
  var recordId="".obs;
  var uuid = Uuid();

  final TextEditingController nameController=TextEditingController();
  final TextEditingController nationalCodeController=TextEditingController();
  final TextEditingController userController=TextEditingController();
  final TextEditingController mobileController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  //final TextEditingController passwordController=TextEditingController();
  final TextEditingController addressController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  RxList<StateItemModel> stateList=<StateItemModel>[].obs;
  RxList<CityItemModel> cityList=<CityItemModel>[].obs;
  RxList<AccountGroupModel> accountGroupList=<AccountGroupModel>[].obs;
  RxList<AccountSalesGroupModel> accountSalesGroupList=<AccountSalesGroupModel>[].obs;
  RxList<AccountLevelModel> accountLevelList=<AccountLevelModel>[].obs;
  late Rxn<StateItemModel> selectedState=Rxn<StateItemModel>();
  final Rxn<CityItemModel> selectedCity=Rxn<CityItemModel>();
  final Rxn<AccountGroupModel> selectedAccountGroup=Rxn<AccountGroupModel>();
  final Rxn<AccountSalesGroupModel> selectedAccountSalesGroup=Rxn<AccountSalesGroupModel>();
  final Rxn<AccountLevelModel> selectedAccountLevel=Rxn<AccountLevelModel>();
  AccountModel? accountModel;
  var idUser=0.obs;
  var title="".obs;
  RxInt type= 0.obs;
  RxString code= "".obs;
  RxInt accountId= 0.obs;
  RxInt contactId= 0.obs;
  RxInt contactInfoId0= 0.obs;
  RxInt contactInfoId1= 0.obs;
  RxInt contactInfoId2= 0.obs;
  RxInt addressId= 0.obs;

  @override
  void onInit() {
    super.onInit();
    idUser.value=int.parse(Get.parameters["id"] as String);
    idUser.value!=0? getOneUser(idUser.value):null;
    idUser.value!=0? title.value="ویرایش":title.value="افزودن";
    getAccountGroup();
    getAccountSalesGroupList();
    getAccountLevelList();
    getStateList();
    getCityList();
  }


  setChecked(){
    isChecked.value=!isChecked.value;
    update();
  }
  void changeSelectedState(StateItemModel? newValue) {
    selectedState.value = newValue;
  }

  void changeSelectedCity(CityItemModel? newValue) {
    selectedCity.value = newValue;
  }

  void changeSelectedAccountGroup(AccountGroupModel? newValue) {
    selectedAccountGroup.value = newValue;
  }
  void changeSelectedAccountSalesGroup(AccountSalesGroupModel? newValue) {
    selectedAccountSalesGroup.value = newValue;
  }

  void changeSelectedAccountLevel(AccountLevelModel? newValue) {
    selectedAccountLevel.value = newValue;
  }


  // لیست استان ها
  Future<void> getStateList() async {
    stateList.clear();
    try {
       state.value=PageState.loading;
      var response = await userRepository.getStateList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          );
       stateList.addAll(response);
       if(stateList.isNotEmpty){
         selectedState.value=stateList.first;
       }
       state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }
// لیست شهر ها
  Future<void> getCityList() async {
    cityList.clear();
    try {
       state.value=PageState.loading;
      var response = await userRepository.getCityList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          );
       cityList.addAll(response);
       if(cityList.isNotEmpty){
         selectedCity.value=cityList.first;
       }
       state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // لیست گروه اکانت ها
  Future<void> getAccountGroup() async {

    accountGroupList.clear();
    try {
      state.value=PageState.loading;
      var response = await userRepository.getAccountGroup();
      accountGroupList.addAll(response);
      if(accountGroupList.isNotEmpty){
        selectedAccountGroup.value=accountGroupList.first;
      }
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // لیست گروه قیمت گذاری
  Future<void> getAccountSalesGroupList() async {
    accountSalesGroupList.clear();
    try {
      state.value=PageState.loading;
      var response = await accountSalesGroupRepository.getAccountSalesGroupList();
      accountSalesGroupList.addAll(response);
      if (accountSalesGroupList.isNotEmpty) {
        if (selectedAccountSalesGroup.value != null) {
          final match = accountSalesGroupList.firstWhereOrNull(
                  (g) => g.id == selectedAccountSalesGroup.value?.id);
          if (match != null) {
            selectedAccountSalesGroup.value = match;
          } else {
            selectedAccountSalesGroup.value =
                accountSalesGroupList.firstWhereOrNull((g) => g.isDefault == true) ??
                    accountSalesGroupList.first;
          }
        } else {
          selectedAccountSalesGroup.value =
              accountSalesGroupList.firstWhereOrNull((g) => g.isDefault == true) ??
                  accountSalesGroupList.first;
        }
      }
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // لیست سطوح کاربر
  Future<void> getAccountLevelList() async {
    accountLevelList.clear();
    try {
      state.value=PageState.loading;
      var response = await accountRepository.getAccountLevelList();
      accountLevelList.addAll(response);
      if (accountLevelList.isNotEmpty) {
        if (selectedAccountLevel.value != null) {
          final match = accountLevelList.firstWhereOrNull(
                  (g) => g.id == selectedAccountLevel.value?.id);
          if (match != null) {
            selectedAccountLevel.value = match;
          } else {
            selectedAccountLevel.value = accountLevelList.first;
          }
        } else {
          selectedAccountLevel.value = accountLevelList.first;
        }
      }
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }


  Future<void> insertUser(String recId) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
       state.value=PageState.loading;
       var response = await userRepository.insertUser(
         accountGroupId: selectedAccountGroup.value?.id ?? 0,
           accountSalesGroupId: selectedAccountSalesGroup.value?.id ?? 0,
           accountLevelId: selectedAccountLevel.value?.id ?? 0,
           name: nameController.text,
           nationalCode: nationalCodeController.text,
           mobile: mobileController.text.toEnglishDigit(),
           phoneNumber: phoneController.text.toEnglishDigit(),
           email: emailController.text,
           //user: userController.text,
           hasDeposit:  isChecked.value,
           //password: passwordController.text,
           state: selectedState.value?.name??"",
           idState: selectedState.value?.id??0,
           city: selectedCity.value?.name??"",
           idCity: selectedCity.value?.id??0,
           address: addressController.text,
         recId:recId,
          );
       Get.toNamed('/userList');
       Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
           titleText: Text(response.infos?.first["title"],
             textAlign: TextAlign.center,
             style: TextStyle(color: AppColor.textColor),),
           messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
       nameController.text="";
       nationalCodeController.text="";
       mobileController.text="";
       phoneController.text="";
       emailController.text="";
       userController.text="";
       //passwordController.text="";
       addressController.text="";
       state.value=PageState.list;
       controller.getUserList();
      update();
       clearList();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateUser(String recId) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
       state.value=PageState.loading;
       var response = await userRepository.updateUser(
           accountGroupId: selectedAccountGroup.value?.id ?? 0,
         accountSalesGroupId: selectedAccountSalesGroup.value?.id ?? 0,
           accountLevelId: selectedAccountLevel.value?.id ?? 0,
           name: nameController.text,
           nationalCode: nationalCodeController.text,
           mobile: mobileController.text.toEnglishDigit(),
           phoneNumber: phoneController.text.toEnglishDigit(),
           email: emailController.text,
           //user: userController.text,
           hasDeposit:  isChecked.value,
           //password: passwordController.text,
           state: selectedState.value?.name??"",
           idState: selectedState.value?.id??0,
           city: selectedCity.value?.name??"",
           idCity: selectedCity.value?.id??0,
           address: addressController.text, id: idUser.value,
         status: 1,
         type: type.value,
         code: code.value,
         accountId: accountId.value,
         contactId: contactId.value,
         contactInfoId0: contactInfoId0.value,
         contactInfoId1: contactInfoId1.value,
         contactInfoId2: contactInfoId2.value,
         recId:"",
         //addressId: addressId.value,
          );
       Get.back();
       Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
           titleText: Text(response.infos?.first["title"],
             textAlign: TextAlign.center,
             style: TextStyle(color: AppColor.textColor),),
           messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
       nameController.text="";
       nationalCodeController.text="";
       mobileController.text="";
       phoneController.text="";
       emailController.text="";
       userController.text="";
       //passwordController.text="";
       addressController.text="";
       state.value=PageState.list;
       controller.getUserList();
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {
      EasyLoading.dismiss();
      clearList();
    }
  }

  // کاربر
  Future<void> getOneUser(int id) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await userRepository.getOneAccount(id: id
      );
      accountModel=response;
      nameController.text=accountModel?.name??"";
      nationalCodeController.text=accountModel?.nationalCode??"";

      for(int i=0;i<accountModel!.contactInfos!.length;i++){
        if(accountModel!.contactInfos![i].type==0){
          mobileController.text=accountModel?.contactInfos?[i].value??"";
          contactId.value=accountModel?.contactInfos?[i].contact?.id ?? 0;
          contactInfoId0.value=accountModel?.contactInfos?[i].id ?? 0;
        }else  if(accountModel!.contactInfos![i].type==1){
          phoneController.text=accountModel?.contactInfos?[i].value??"";
          contactId.value=accountModel?.contactInfos?[i].contact?.id ?? 0;
          contactInfoId1.value=accountModel?.contactInfos?[i].id ?? 0;
        }else  if(accountModel!.contactInfos![i].type==2){
          emailController.text=accountModel?.contactInfos?[i].value??"";
          contactId.value=accountModel?.contactInfos?[i].contact?.id ?? 0;
          contactInfoId2.value=accountModel?.contactInfos?[i].id ?? 0;
        }
      }
      userController.text="";
      //passwordController.text="";
      addressController.text=accountModel?.addresses?.first.fullAddress??"";
      selectedState.value=accountModel?.addresses?.first.state;
      selectedCity.value=accountModel?.addresses?.first.city;
      selectedAccountGroup.value=accountModel?.accountGroup;
      selectedAccountSalesGroup.value=accountModel?.accountSalesGroup;
      selectedAccountLevel.value=accountModel?.accountLevel;
      type.value=accountModel?.type ?? 0;
      code.value=accountModel?.code ?? "";
      accountId.value=idUser.value;
      //addressId.value=accountModel?.addresses?.first.id ?? 0;

      update();
    }
    catch (e) {

    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearList() {
    nameController.clear();
    nationalCodeController.clear();
    mobileController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    selectedAccountGroup.value=null;
    selectedAccountSalesGroup.value=null;
    selectedAccountLevel.value=null;
    selectedCity.value=null;
    selectedState.value=null;
    // Clear image-related state
    selectedImagesNationalCodeDesktop.clear();
    selectedImagesBusinessLicenseDesktop.clear();
    uploadStatusesNationalCodeDesktop.clear();
    uploadStatusesBusinessLicenseDesktop.clear();
    isUploadingNationalCodeDesktop.value = false;
    isUploadingBusinessLicenseDesktop.value = false;
  }

  // Image handling methods
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
      final imageFiles = files.where((file) {
        final fileName = file.name.toLowerCase();
        final extension = fileName.contains('.') ? fileName.split('.').last : '';
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
      final imageFiles = files.where((file) {
        final fileName = file.name.toLowerCase();
        final extension = fileName.contains('.') ? fileName.split('.').last : '';
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

  Future<void> uploadAllImagesAndInsertUser() async {
    recordId.value = uuid.v4();

    final hasNationalCodeImages = selectedImagesNationalCodeDesktop.isNotEmpty;
    final hasBusinessLicenseImages = selectedImagesBusinessLicenseDesktop.isNotEmpty;
    final hasAnyImages = hasNationalCodeImages || hasBusinessLicenseImages;

    if (!hasAnyImages) {
      await insertUser(recordId.value);
      return;
    }

    isUploadingNationalCodeDesktop.value = true;
    isUploadingBusinessLicenseDesktop.value = true;

    uploadStatusesNationalCodeDesktop.assignAll(
        List.filled(selectedImagesNationalCodeDesktop.length, false)
    );
    uploadStatusesBusinessLicenseDesktop.assignAll(
        List.filled(selectedImagesBusinessLicenseDesktop.length, false)
    );

    bool allUploadsSuccessful = true;

    try {
      if (hasNationalCodeImages) {
        for (int i = 0; i < selectedImagesNationalCodeDesktop.length; i++) {
          final file = selectedImagesNationalCodeDesktop[i];
          if (file != null) {
            try {
              final bytes = await file.readAsBytes();
              String success = await uploadRepositoryDesktop.uploadImageDesktop(
                imageBytes: bytes,
                fileName: file.name,
                recordId: recordId.value,
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

      if (hasBusinessLicenseImages) {
        for (int i = 0; i < selectedImagesBusinessLicenseDesktop.length; i++) {
          final file = selectedImagesBusinessLicenseDesktop[i];
          if (file != null) {
            try {
              final bytes = await file.readAsBytes();
              String success = await uploadRepositoryDesktop.uploadImageDesktop(
                imageBytes: bytes,
                fileName: file.name,
                recordId: recordId.value,
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

      final nationalCodeSuccess = !hasNationalCodeImages ||
          uploadStatusesNationalCodeDesktop.every((status) => status);
      final businessLicenseSuccess = !hasBusinessLicenseImages ||
          uploadStatusesBusinessLicenseDesktop.every((status) => status);

      if (nationalCodeSuccess && businessLicenseSuccess) {
        Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
        await insertUser(recordId.value);
        Get.back();
      } else {
        Get.snackbar("خطا", "برخی از آپلودها با شکست مواجه شدند");
      }

    } finally {
      isUploadingNationalCodeDesktop.value = false;
      isUploadingBusinessLicenseDesktop.value = false;
      selectedImagesNationalCodeDesktop.clear();
      selectedImagesBusinessLicenseDesktop.clear();
      uploadStatusesNationalCodeDesktop.clear();
      uploadStatusesBusinessLicenseDesktop.clear();
    }
  }

}
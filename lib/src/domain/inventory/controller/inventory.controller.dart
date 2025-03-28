

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/inventory.repository.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/repository/upload.repository.dart';
import '../../account/model/account.model.dart';

enum PageState{loading,err,empty,list}
class InventoryController extends GetxController{
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final UploadRepository uploadRepository=UploadRepository();
  final InventoryRepository inventoryRepository=InventoryRepository();
  final AccountRepository accountRepository=AccountRepository();
  final TextEditingController searchController=TextEditingController();

  var inventoryList=<InventoryModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateGetOne=Rx<PageState>(PageState.list);
  RxnInt expandedIndex = RxnInt();

  final ImagePicker _picker = ImagePicker();
  RxList<File> selectedImages = RxList<File>();
  RxList<bool> uploadStatuses = RxList<bool>();
  RxBool isUploading = false.obs;

  final PageController pageController = PageController();
  RxInt currentImagePage = 0.obs;

  final RxMap<int , InventoryModel> getOneInventory=<int , InventoryModel>{}.obs;

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  void toggleItemExpansion(int index) {
    if (expandedIndex.value==index) {
      expandedIndex.value=null;
    } else {
      expandedIndex.value=index;
    }
  }
  bool isItemExpanded(int index) {
    return expandedIndex.value==index;
  }

  @override
  void onInit() {
    fetchInventoryList();
    setupScrollListener();
    super.onInit();
  }
  @override void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }
  Future<void> loadMore() async {
    if (hasMore.value && !isLoading.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var fetchedInventoryList = await inventoryRepository.getInventoryList(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        );
        if (fetchedInventoryList.isNotEmpty) {
          inventoryList.addAll(fetchedInventoryList);
          currentPage.value = nextPage;
          hasMore.value = fetchedInventoryList.length == itemsPerPage.value;
        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false; // توقف بارگذاری بیشتر در صورت خطا
        errorMessage.value = "خطا در دریافت اطلاعات بیشتر: ${e.toString()}";
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> searchAccounts(String name) async {
    try {
      if (name.isEmpty) {
        searchedAccounts.clear();
        return;
      }

      final accounts = await AccountRepository().searchAccountList(name);
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
    fetchInventoryList();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    fetchInventoryList();
  }


  Future<void> fetchInventoryList()async{
    try{
      if (currentPage == 1) {
        inventoryList.clear();
      }
      isLoading.value = true;
      //state.value=PageState.loading;
      final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
      final toIndex = currentPage.value * itemsPerPage.value;
      var fetchedInventoryList=await inventoryRepository.getInventoryList(
          startIndex: startIndex,
          toIndex: toIndex,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
      );
      hasMore.value = fetchedInventoryList.length == itemsPerPage.value;

      if (selectedAccountId.value == 0) {
        inventoryList.assignAll(fetchedInventoryList);
      }else {
        if (currentPage.value == 1) {
          inventoryList.assignAll(fetchedInventoryList);
        } else {
          inventoryList.addAll(fetchedInventoryList);
        }
      }

      state.value = inventoryList.isEmpty ? PageState.empty : PageState.list;

    }catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  Future<void> fetchGetOneInventory(int id)async{
    try {
      getOneInventory.remove(id);
      stateGetOne.value=PageState.loading;
      var fetchedGetOneInventory = await inventoryRepository.getOneInventory(id);
      if(fetchedGetOneInventory!=null){
        getOneInventory[id] = fetchedGetOneInventory;
        stateGetOne.value=PageState.list;
        print('getOneInventories:  ${getOneInventory[id]?.inventoryDetails?.length}');
      }else{
        stateGetOne.value=PageState.empty;
      }
    }
    catch(e){
      stateGetOne.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }

  Future<void> pickImage(String recordId, String type, String entityType,{required int inventoryId}) async {
    final source = await showDialog<ImageSource>(
      context: Get.context!,
      builder: (context) => AlertDialog(backgroundColor: AppColor.backGroundColor,
        title: Text('منبع تصویر',style: AppTextStyle.mediumTitleText.copyWith(fontSize: 18),),
        content: Text('لطفا منبع تصویر را انتخاب کنید',style: AppTextStyle.smallTitleText.copyWith(fontSize: 14),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text('دوربین',style: AppTextStyle.mediumBodyTextBold.copyWith(fontSize: 13),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text('گالری',style: AppTextStyle.mediumBodyTextBold.copyWith(fontSize: 13),),
          ),
        ],
      ),
    );
    if (source != null) {
      if (source == ImageSource.camera) {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          selectedImages.add(File(image.path));
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          selectedImages.addAll(images.map((xFile) => File(xFile.path)));
        }
      }

      if (selectedImages.isNotEmpty) {
        await uploadImages(recordId, type, entityType,inventoryId);
      }
    }
  }

  Future<void> uploadImages(String recordId, String type, String entityType,int inventoryId) async {
    if (selectedImages.isEmpty) return;

    isUploading.value = true;
    uploadStatuses.assignAll(List.filled(selectedImages.length, false));

    try {
      for (int i = 0; i < selectedImages.length; i++) {
        try {
          bool success = await uploadRepository.uploadImage(
            imageFile: selectedImages[i],
            recordId: recordId,
            type: type,
            entityType: entityType,
          );

          uploadStatuses[i] = success;
        } catch (e) {
          Get.snackbar("خطا", "خطا در آپلود تصویر ${i + 1}");
        }
      }

      if (uploadStatuses.every((status) => status)) {
        Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
        await fetchGetOneInventory(inventoryId);
      }
    } finally {
      isUploading.value = false;
      selectedImages.clear();
      uploadStatuses.clear();
    }
  }

}
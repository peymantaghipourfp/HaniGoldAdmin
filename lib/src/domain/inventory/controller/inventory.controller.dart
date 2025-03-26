

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/inventory.repository.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/repository/upload.repository.dart';

enum PageState{loading,err,empty,list}
class InventoryController extends GetxController{
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final UploadRepository uploadRepository=UploadRepository();
  final InventoryRepository inventoryRepository=InventoryRepository();

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
    if (hasMore.value && !isLoading.value) {
      currentPage++;
      await fetchInventoryList();
    }
  }


  Future<void> fetchInventoryList()async{
    try{
      if (currentPage == 1) {
        inventoryList.clear();
      }
      isLoading.value = true;
      state.value=PageState.loading;
      final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
      final toIndex = currentPage.value * itemsPerPage.value;
      var fetchedInventoryList=await inventoryRepository.getInventoryList(
          startIndex: startIndex,
          toIndex: toIndex
      );
      hasMore.value = fetchedInventoryList.length == itemsPerPage.value;
      if (currentPage.value == 1) {
        inventoryList.assignAll(fetchedInventoryList);
      } else {
        inventoryList.addAll(fetchedInventoryList);
      }
      state.value = inventoryList.isEmpty ? PageState.empty : PageState.list;

      if(inventoryList.isEmpty){
        state.value=PageState.empty;
      }
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
      /*if(getOneWithdraw.value==null){
        state.value=PageState.empty;
      }*/
    }
    catch(e){
      stateGetOne.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }

  Future<void> pickImage(String recordId, String type, String entityType) async {
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
        await uploadImages(recordId, type, entityType);
      }
    }
  }

  Future<void> uploadImages(String recordId, String type, String entityType) async {
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
      }
    } finally {
      isUploading.value = false;
      selectedImages.clear();
      uploadStatuses.clear();
    }
  }

}
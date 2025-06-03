

import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/inventory.repository.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../../../config/network/error/network.error.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/upload.repository.dart';
import '../../../config/repository/url/base_url.dart';
import '../../account/model/account.model.dart';
import '../../users/model/paginated.model.dart';

enum PageState{loading,err,empty,list}
class InventoryController extends GetxController{
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;

  ScrollController scrollController = ScrollController();


  final UploadRepository uploadRepository=UploadRepository();
  final UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();
  final InventoryRepository inventoryRepository=InventoryRepository();
  final AccountRepository accountRepository=AccountRepository();
  final RemittanceRepository remittanceRepository=RemittanceRepository();
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();

  var inventoryList=<InventoryModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingRegister=true.obs;
  final isLoadingDelete=false.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateGetOne=Rx<PageState>(PageState.list);
  RxnInt expandedIndex = RxnInt();
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  final ImagePicker _picker = ImagePicker();
  RxList<File?> selectedImages = RxList<File?>();
  RxList<XFile?> selectedImagesDesktop = RxList<XFile?>();
  RxList<bool> uploadStatuses = RxList<bool>();
  RxList<bool> uploadStatusesDesktop = RxList<bool>();
  RxBool isUploading = false.obs;
  RxBool isUploadingDesktop = false.obs;
  List<Uint8List> selectedImagesBytes = [];
  List<String> selectedFileNames = [];
  final PageController pageController = PageController();
  RxInt currentImagePage = 0.obs;
  RxBool showArrows = false.obs;
  RxList<String> imageList = <String>[].obs;

  Rxn<InventoryModel> getOneInventory=Rxn<InventoryModel>();

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  RxBool isDateSort = true.obs;
  var sortIndex = 0.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  var recordId="".obs;
  var uuid = Uuid();

  void sortByDate(int columnIndex,bool desc ) {
    final list = List<InventoryModel>.from(inventoryList);
   // if (columnIndex > 0) {
      isDateSort.value = desc;
      list.sort((a, b) {
        if (a.date == null && b.date == null) return 0;
        if (a.date == null) return -1;
        if (b.date == null) return 1;
        return desc
            ? b.date!.compareTo(a.date!)
            : a.date!.compareTo(b.date!);
      });
   // }
    inventoryList.assignAll(list);
    update();
  }
  setSort(int index,bool val){
    isDateSort.value= val;
    sortIndex.value= index;
    update();
  }

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
    getInventoryListPager();
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
    if (!scrollController.hasClients ||hasMore.value && !isLoading.value ) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var fetchedInventoryList = await inventoryRepository.getInventoryList(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
          startDate: startDateFilter.value, endDate: endDateFilter.value,
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

      final accounts = await AccountRepository().searchAccountList(name,"");
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
    getInventoryListPager();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getInventoryListPager();
  }


  // Future<void> fetchInventoryList()async{
  //   try{
  //     //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
  //       inventoryList.clear();
  //     isLoading.value = true;
  //     state.value=PageState.loading;
  //     final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
  //     final toIndex = currentPage.value * itemsPerPage.value;
  //     var fetchedInventoryList=await inventoryRepository.getInventoryList(
  //         startIndex: startIndex,
  //         toIndex: toIndex,
  //       accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
  //       startDate: startDateFilter.value, endDate: endDateFilter.value,
  //     );
  //     hasMore.value = fetchedInventoryList.length == itemsPerPage.value;
  //
  //     if (selectedAccountId.value == 0) {
  //       inventoryList.assignAll(fetchedInventoryList);
  //     }else {
  //       if (currentPage.value == 1) {
  //         inventoryList.assignAll(fetchedInventoryList);
  //       } else {
  //         inventoryList.addAll(fetchedInventoryList);
  //       }
  //     }
  //
  //     state.value = inventoryList.isEmpty ? PageState.empty : PageState.list;
  //     //EasyLoading.dismiss();
  //       inventoryList.refresh();
  //       update();
  //   }catch(e){
  //     state.value=PageState.err;
  //     errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
  //   }finally{
  //     isLoading.value=false;
  //   }
  // }

  // لیست حواله ها با صفحه بندی
  Future<void> getInventoryListPager() async {
    print("### getInventoryListPager ###");
    inventoryList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await inventoryRepository.getInventoryListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        name:nameFilterController.text,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      isLoading.value=false;
      inventoryList.addAll(response.inventories??[]);
      paginated.value=response.paginated;
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }



  Future<void> fetchGetOneInventory(int id)async{
    try {
      isLoading.value=true;
      stateGetOne.value=PageState.loading;
      var fetchedGetOneInventory = await inventoryRepository.getOneInventory(id);
      if(fetchedGetOneInventory!=null){
        getOneInventory.value = fetchedGetOneInventory;
       /* Get.toNamed('/inventoryDetailUpdateReceive',
            arguments: fetchedGetOneInventory.inventoryDetails?.first);*/
        stateGetOne.value=PageState.list;
       // print('getOneInventories:  ${getOneInventory[id]?.inventoryDetails?.length}');
      }else{
        stateGetOne.value=PageState.empty;
      }
    }
    catch(e){
      stateGetOne.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }
  Future<void> fetchGetOneInventoryForUpdate(int id)async{
    try {
      isLoading.value=true;
      stateGetOne.value=PageState.loading;
      var fetchedGetOneInventory = await inventoryRepository.getOneInventory(id);
      if(fetchedGetOneInventory!=null){
        getOneInventory.value = fetchedGetOneInventory;
        getOneInventory.value?.type==0 ?
         Get.toNamed('/inventoryDetailUpdatePayment', arguments: fetchedGetOneInventory.inventoryDetails?.first):
         Get.toNamed('/inventoryDetailUpdateReceive', arguments: fetchedGetOneInventory.inventoryDetails?.first);
        stateGetOne.value=PageState.list;
        // print('getOneInventories:  ${getOneInventory[id]?.inventoryDetails?.length}');
      }else{
        stateGetOne.value=PageState.empty;
      }
    }
    catch(e){
      stateGetOne.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  Future<List<dynamic>?> deleteInventory(int inventoryId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoadingDelete.value=true;
      var response=await inventoryRepository.deleteInventory(isDeleted: isDeleted, inventoryId: inventoryId);
      if(response!= null){
        Get.snackbar("موفقیت آمیز","حذف دریافت/پرداخت با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف دریافت/پرداخت با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getInventoryListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف دریافت/پرداخت: $e');
    }finally {
      EasyLoading.dismiss();
      isLoadingDelete.value=false;
    }
    return null;
  }

  Future<List<dynamic>?> updateDeleteInventoryReceive(
      String date,
      int id,
      int inventoryDetailId,
      int stateMode,
      int type,
      int accountId,
      int walletId,
      int itemId,
      double quantity,
      )async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await inventoryRepository.deleteInventoryDetail(
          date:date,
          id: id,
          inventoryDetailId: inventoryDetailId,
          stateMode: stateMode,
          type:1,
          accountId: accountId,
          walletId: walletId,
          itemId: itemId,
          quantity: quantity
      );
      if(response!= null){
        Get.back();
        Get.snackbar("موفقیت آمیز","حذف با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        Get.back();
        getInventoryListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }
  Future<List<dynamic>?> updateDeleteInventoryPayment(
      String date,
      int id,
      int inventoryDetailId,
      int stateMode,
      int type,
      int accountId,
      int walletId,
      int itemId,
      double quantity,
      )async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await inventoryRepository.deleteInventoryDetail(
          date: date,
          id: id,
          inventoryDetailId: inventoryDetailId,
          stateMode: stateMode,
          type:0 ,
          accountId: accountId,
          walletId: walletId,
          itemId: itemId,
          quantity: quantity,
      );
      if(response!= null){
        Get.back();
        Get.snackbar("موفقیت آمیز","حذف با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        Get.back();
        getInventoryListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
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
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    if (selectedImages.isEmpty) return;

    isUploading.value = true;
    uploadStatuses.assignAll(List.filled(selectedImages.length, false));

    try {
      for (int i = 0; i < selectedImages.length; i++) {
        try {
          String success = await uploadRepository.uploadImage(
            imageFile: selectedImages[i]!,
            recordId: recordId,
            type: type,
            entityType: entityType,
          );
          uploadStatuses[i] = success as bool;
        } catch (e) {
          EasyLoading.dismiss();
          Get.snackbar("خطا", "خطا در آپلود تصویر ${i + 1}");
        }
      }

      if (uploadStatuses.every((status) => status)) {
        EasyLoading.dismiss();
        Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
        await getInventoryListPager();
       // await fetchGetOneInventory(inventoryId);
      }
    } finally {
      EasyLoading.dismiss();
      isUploading.value = false;
      selectedImages.clear();
      uploadStatuses.clear();
    }
  }

  Future<void> pickImageDesktop(String recordId, String type, String entityType,{required int inventoryId}) async {
    try{
      final List<XFile?> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImagesDesktop.assignAll(images);
        //await uploadImagesDesktop(recordId, type, entityType, inventoryId);
      }
    }catch(e){
      throw Exception('خطا در انتخاب فایل‌ها');
    }
  }

  Future<void> uploadImagesDesktop( String type, String entityType,int inventoryId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    recordId.value=uuid.v4();
    if (selectedImagesDesktop.isEmpty) return;
    isUploadingDesktop.value = true;
    uploadStatusesDesktop.assignAll(List.filled(selectedImagesDesktop.length, false));
    try {
      for (int i = 0; i < selectedImagesDesktop.length; i++) {
        final file = selectedImagesDesktop[i];
        if(file!=null) {
          try{
            final bytes = await file.readAsBytes();
            String success = await uploadRepositoryDesktop.uploadImageDesktop(
              imageBytes: bytes,
              fileName: file.name,
              recordId: recordId.value,
              type: type,
              entityType: entityType,
            );
            uploadStatusesDesktop[i] = success.isNotEmpty;
          }catch(e){
            EasyLoading.dismiss();
            Get.snackbar("خطا", "خطا در آپلود تصویر ${i + 1}");
          }
        }
      }
      if (uploadStatusesDesktop.every((status) => status)) {
        EasyLoading.dismiss();
        Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
        getInventoryListPager();
        await fetchGetOneInventory(inventoryId);
      }
    } finally {
      EasyLoading.dismiss();
      isUploadingDesktop.value = false;
      selectedImagesDesktop.clear();
      uploadStatusesDesktop.clear();
    }
  }

  Future<List<dynamic>?> updateRegistered(int inventoryId,bool registered) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      var response = await inventoryRepository.updateRegistered(
        inventoryId: inventoryId,
        registered: registered,
      );
      if(response!= null){
        //EasyLoading.dismiss();
        Get.snackbar(response.first['title'],response.first["description"],
            titleText: Text(response.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getInventoryListPager();
      }

    } catch (e) {
      EasyLoading.dismiss();
      throw ErrorException('خطا در ریجیستر: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }

    return null;
  }

  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    getInventoryListPager();
  }

  // لیست عکس ها
  Future<void> getImage(String fileName,String type) async{
    print('تعداد image:');
    imageList.clear();
    try{
      var fetch=await remittanceRepository.getImage(fileName: fileName, type: type);
      imageList.addAll(fetch.guidIds );
      print('تعداد image:${imageList.first}');
      imageList.refresh();
      update();
    }
    catch(e){
      //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
    }
  }

  /*void downloadImage(String guidId) async {
    if (kIsWeb){
      final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
      final anchor = html.AnchorElement(href: url)
        ..download = "image_$guidId"
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      anchor.remove();
    }else{
      try {
        final status = await Permission.storage.request();
        if (!status.isGranted) return;

        final dio = Dio();
        final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir == null) {
          throw Exception('Could not access downloads directory');
        }
        String fileExtension = path.extension(guidId);
        if(fileExtension.isEmpty) fileExtension = '.png';
        final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
        final savePath = path.join(downloadsDir.path, fileName);
        *//*final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/images_$guidId.png';*//*
        await dio.download(url, savePath);
        print(savePath);
        Get.snackbar(
          'موفقیت',
          'تصویر با موفقیت ذخیره شد',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'خطا',
          'خطا در دانلود تصویر: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }*/

  // خروجی اکسل
  Future<void> exportToExcel() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final excel = Excel.createExcel();
      final sheet = excel['دریافت پرداخت'];

      sheet.appendRow([
        TextCellValue('ردیف'),
        TextCellValue('تاریخ'),
        TextCellValue('نام ثبت کننده'),
        TextCellValue('محصول'),
        TextCellValue('مقدار'),
        TextCellValue('شرح'),
        TextCellValue('دریافت/پرداخت'),
        TextCellValue('اطلاعات اضافی'),
        TextCellValue('مانده سکه'),
        TextCellValue('مانده ریالی'),
        TextCellValue('مانده طلایی'),
      ]);
      EasyLoading.show(status: 'دریافت فایل اکسل...');
      final allInventories = await inventoryRepository.getInventoryList(
        startIndex: 1,
        toIndex: 100000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      for (var inventory in allInventories) {
        sheet.appendRow([
          TextCellValue(inventory.rowNum.toString()),
          TextCellValue(inventory.date?.toPersianDate(twoDigits: true) ?? ''),
          TextCellValue(inventory.account?.name ?? ''),
          TextCellValue(inventory.inventoryDetails?.first.item?.name ?? ''),
          TextCellValue(inventory.inventoryDetails?.first.quantity?.toString().seRagham(separator: ",") ?? ''),
          TextCellValue(" عیار:${inventory.inventoryDetails?.first.carat ?? 0}| وزن:${inventory.inventoryDetails?.first.weight750 ?? 0}| ناخالصی:${inventory.inventoryDetails?.first.impurity ?? 0}| آزمایشگاه:${inventory.inventoryDetails?.first.laboratory?.name ?? ""}"?? ''),
          TextCellValue(getSellBuyText(inventory.type ?? 0 )),
          TextCellValue(getDetailText(inventory.inventoryDetailsCount ?? 1 )),
          TextCellValue(inventory.balances?.where((e) => e.unitName == "عدد").map((e) => "\u202B${e.balance}\u202C ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
          TextCellValue(inventory.balances?.where((e) => e.unitName == "ریال").map((e) => "\u202B${e.balance}\u202C ${e.unitName } ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
          TextCellValue(inventory.balances?.where((e) => e.unitName == "گرم").map((e) => "\u202B${e.balance}\u202C ${e.unitName } ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception('خطا در دریافت فایل');
      final uint8List = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'inventories_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
      }else {
        final output = await getDownloadsDirectory();
        final filePath = '${output?.path}/inventories_${DateTime
            .now()
            .millisecondsSinceEpoch}.xlsx';
        final fileBytes = excel.encode();
        if (fileBytes != null) {
          await File(filePath).writeAsBytes(uint8List);

          await FileSaver.instance.saveFile(
            name: 'inventories',
            bytes: uint8List,
            ext: 'xlsx',
            mimeType: MimeType.microsoftExcel,
          );
        }
      }
      Get.snackbar('موفق', 'فایل اکسل با موفقیت دریافت شد');
      EasyLoading.dismiss();
    } catch (e) {
      Get.snackbar('خطا', 'خطا در دریافت فایل اکسل: ${e.toString()}');
      EasyLoading.dismiss();
      print(e.toString());
    }
  }

  String getSellBuyText(int type) {
    switch (type) {
      case 0:
        return 'پرداخت';
      case 1:
        return 'دریافت';
      default:
        return 'نامعتبر';
    }
  }
  String getDetailText(int detailCount) {
    switch (detailCount) {
      case 1:
        return 'ندارد';
      default:
        return 'دارد';
    }
  }

  // خروجی pdf
  Future<void> exportToPdf() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      final allInventories = await inventoryRepository.getInventoryList(
        startIndex: 1,
        toIndex: 100000,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      final pdf = pw.Document();

      // افزودن MultiPage برای مدیریت خودکار صفحه‌بندی
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          textDirection: pw.TextDirection.rtl,
          maxPages: 2000,
          theme: pw.ThemeData.withFont(base: ttf,fontFallback: [ttf],),
          header: (pw.Context context) => buildHeaderTable(),
          build: (pw.Context context) => [
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: getColumnWidths(),
              children: [
                for (var inventory in allInventories)
                  buildDataRow(inventory),
              ],
            ),
          ],
          footer: (pw.Context context) => buildPageNumber(context.pageNumber, context.pagesCount),
        ),
      );

      final bytes = await pdf.save();
      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..download = 'inventories_${DateTime.now().millisecondsSinceEpoch}.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'inventories.pdf',
        );
      }

      EasyLoading.dismiss();
      Get.snackbar('موفق', 'فایل PDF با موفقیت دریافت شد');
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('خطا', 'خطا در دریافت فایل PDF: ${e.toString()}');
      print(e.toString());
    }
  }

  Map<int, pw.TableColumnWidth> getColumnWidths() {
    return {
      0: pw.FlexColumnWidth(3),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(3),
      3: pw.FlexColumnWidth(1.3),
      4: pw.FlexColumnWidth(1.3),
      5: pw.FlexColumnWidth(3),
      6: pw.FlexColumnWidth(2),
      7: pw.FlexColumnWidth(2),
      8: pw.FlexColumnWidth(2.5),
      9: pw.FlexColumnWidth(2),
      10: pw.FlexColumnWidth(1.2),
    };
  }
  // ساخت هدر جدول
  pw.Table buildHeaderTable() {
    return pw.Table(
      columnWidths: {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(3),
        3: pw.FlexColumnWidth(1.3),
        4: pw.FlexColumnWidth(1.3),
        5: pw.FlexColumnWidth(3),
        6: pw.FlexColumnWidth(2),
        7: pw.FlexColumnWidth(2),
        8: pw.FlexColumnWidth(2.5),
        9: pw.FlexColumnWidth(2),
        10: pw.FlexColumnWidth(1.2),
      },
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مانده طلایی', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مانده ریالی', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مانده سکه', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('اطلاعات', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('نوع', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('شرح', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('مقدار', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('محصول', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('نام ثبت کننده', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('تاریخ', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Text('ردیف', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
          ],
        ),
      ],
    );
  }
  // ساخت سلول‌های داده
  pw.Padding buildDataCell(String text, {bool isCenter = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 8),
        textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.right,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.TableRow buildDataRow(InventoryModel inventory) {
    return pw.TableRow(
      children: [
        buildDataCell(inventory.balances?.where((e) => e.unitName == "گرم").map((e) => "${e.balance} ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
        buildDataCell(inventory.balances?.where((e) => e.unitName == "ریال").map((e) => "${e.balance} ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
        buildDataCell(inventory.balances?.where((e) => e.unitName == "عدد").map((e) => "${e.balance} ${e.unitName} ${e.itemName}").join(", ") ?? "اطلاعاتی موجود نیست"),
        buildDataCell(getDetailText(inventory.inventoryDetailsCount ?? 1 )),
        buildDataCell(getSellBuyText(inventory.type ?? 0 )),
        buildDataCell(" عیار:${inventory.inventoryDetails?.first.carat ?? 0} وزن:${inventory.inventoryDetails?.first.weight750 ?? 0} ناخالصی:${inventory.inventoryDetails?.first.impurity ?? 0} آزمایشگاه:${inventory.inventoryDetails?.first.laboratory?.name ?? ""}"?? ''),
        buildDataCell(inventory.inventoryDetails?.first.quantity?.toString().seRagham(separator: ",") ?? ''),
        buildDataCell(inventory.inventoryDetails?.first.item?.name ?? ''),
        buildDataCell(inventory.account?.name ?? ''),
        buildDataCell(inventory.date?.toPersianDate(twoDigits: true) ?? ''),
        buildDataCell(inventory.rowNum.toString(), isCenter: true),
      ],
    );
  }

  pw.Widget buildPageNumber(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'صفحه ${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }

  void clearFilter() {
    nameFilterController.clear();
    mobileFilterController.clear();
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }
}
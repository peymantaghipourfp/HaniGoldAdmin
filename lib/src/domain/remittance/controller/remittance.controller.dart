
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_getOne.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection_req.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/upload.repository.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../product/model/item.model.dart';
import '../../users/model/balance_item.model.dart';
import '../../users/model/paginated.model.dart';
import '../model/remittance.model.dart';
import '../view/update_remittance.view.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as path;


enum PageState{loading,err,empty,list}

class RemittanceController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  final RemittanceRepository remittanceRepository=RemittanceRepository();
  final AccountRepository accountRepository=AccountRepository();
  final ItemRepository itemRepository=ItemRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController searchControllerP=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController namePayerController=TextEditingController();
  final TextEditingController nameRecieptController=TextEditingController();
  final TextEditingController mobilePayerController=TextEditingController();
  final TextEditingController quantityPayerController=TextEditingController();
  final TextEditingController descController=TextEditingController();
  RxList<String> getList = RxList([]);
  RxList<RemittanceModel> remittanceList = RxList([]);
  RemittanceModel? remittanceModel;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  RxList<String> imageList = <String>[].obs;
  RxInt currentImagePage = 0.obs;
  final PageController pageController = PageController();
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountListP=<AccountModel>[].obs;
  PaginatedModel? paginated;
  var errorMessage=''.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  RxInt selectedAccountId = 0.obs;
  final Rxn<AccountModel> selectedAccountP = Rxn<AccountModel>();
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  RxList<AccountModel> searchedAccountsP = <AccountModel>[].obs;
  RxList<XFile?> selectedImagesDesktop = RxList<XFile?>();
  final UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();
  RxList<bool> uploadStatusesDesktop = RxList<bool>();
  RxBool isUploadingDesktop = false.obs;
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  BalanceModel? balanceModel;
  RxList<BalanceItemModel> balanceList = <BalanceItemModel>[].obs;
  RxList<BalanceItemModel> balanceListP = <BalanceItemModel>[].obs;
  var uuid = Uuid();
  var isLoadingBalance=true.obs;
  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var isLoadingRegister=false.obs;
  final isLoadingDelete=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  var recordId="".obs;
  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;



  getAccountPayer(String index){
    indexAccountPayerGet=index;
    for(int i=0;i<accountList.length;i++){
      if(accountList[i].id==int.parse(index)){
        namePayer.value=accountList[i].name!;
        namePayerController.text=accountList[i].name!;
        mobilePayerController.text=accountList[i].contactInfo??"";

        mobilePayer.value=accountList[i].contactInfo??"";
      }
    }
    update();
    print(namePayer.value);

  }
  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
  }



  void changeSelectedAccount(AccountModel? newValue)async {
    selectedAccount.value = newValue;
    balanceList.clear();
    balanceList.assignAll((await getBalanceList(selectedAccount.value?.id??0))!);
    balanceList.refresh();
    update();
    // selectedWalletAccount.value = null;
    // getWalletAccount(selectedAccount.value?.id ?? 0);
  }
  void changeSelectedAccountP(AccountModel? newValue)async {
    selectedAccountP.value = newValue;
    balanceListP.clear();
    namePayerController.text=newValue?.name??"";
    balanceListP.assignAll((await getBalanceList(selectedAccountP.value?.id??0))!);
    balanceListP.refresh();
    update();
    // selectedWalletAccount.value = null;
    // getWalletAccount(selectedAccount.value?.id ?? 0);
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
  void resetAccountSearchP() {
    searchControllerP.clear();
    searchedAccountsP.assignAll(accountList);
  }
  String? indexAccountRecieptGet;
  getAccountReciept(String index){
    indexAccountRecieptGet=index;
    update();
  }

  String? indexProductGet;
  getProduct(String index){
    indexProductGet=index;
    update();
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    if (columnIndex == 1) { // Date column
      remittanceList.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return ascending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!);
      });
    }else if (columnIndex == 2) { // Name column
      remittanceList.sort((a, b) {
        final aName = a.createdBy?.name ?? 'نامشخص';
        final bName = b.createdBy?.name ?? 'نامشخص';
        return ascending ? aName.compareTo(bName) : bName.compareTo(aName);
      });
    }
  }

  @override
  void onInit() {
    searchController.addListener(onSearchChanged);
    searchControllerP.addListener(onSearchChangedP);
    getRemittanceListPager();
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    fetchItemList();
    fetchAccountList("");
    fetchAccountListP("");
    clearList();
    super.onInit();
  }

  Timer? debounce;
  void onSearchChanged(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(milliseconds: 500), () async {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        searchedAccounts.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      await fetchAccountList(query);

    });
  }
Timer? debounceP;

  void onSearchChangedP(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(milliseconds: 500), () async {
      final query = searchControllerP.text.trim();
      if (query.isEmpty) {
        searchedAccountsP.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      await fetchAccountListP(query);

    });
  }


  // لیست محصولات
  Future<void> fetchItemList() async{
    try{
     // state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
    //  state.value=PageState.list;
      if(itemList.isEmpty){
     //   state.value=PageState.empty;
      }
    }
    catch(e){
     // state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{

    }
  }
  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    getRemittanceListPager();
  }


  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageDesktop( ) async {
    try{
      final List<XFile?> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImagesDesktop.addAll(images);
      }
      print(selectedImagesDesktop.length);
    }catch(e){
      throw Exception('خطا در انتخاب فایل‌ها');
    }

  }



  Future<void> uploadImagesDesktop( String type, String entityType,) async {

    recordId.value=uuid.v4();
    if (selectedImagesDesktop.isEmpty) {
      insertRemittance(recordId.value);

    } else{
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
              Get.snackbar("خطا", "خطا در آپلود تصویر ${i + 1}");
            }
          }
        }
        if (uploadStatusesDesktop.every((status) => status)) {
          Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
          insertRemittance(recordId.value);
        }
      } finally {
        isUploadingDesktop.value = false;
        selectedImagesDesktop.clear();
        uploadStatusesDesktop.clear();
      }
    }

  }

  Future<void> uploadImagesDesktopUpdate( String type, String entityType,) async {

    recordId.value=uuid.v4();
    if (selectedImagesDesktop.isEmpty) {
      updateRemittance(recordId.value);
    }else{
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
                recordId: remittanceModel?.recId ?? "",
                type: type,
                entityType: entityType,
              );

              uploadStatusesDesktop[i] = success.isNotEmpty;
            }catch(e){
              Get.snackbar("خطا", "خطا در آپلود تصویر ${i + 1}");
            }
          }
        }
        if (uploadStatusesDesktop.every((status) => status)) {
          Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
          updateRemittance(recordId.value);
        }
      } finally {
        isUploadingDesktop.value = false;
        selectedImagesDesktop.clear();
        uploadStatusesDesktop.clear();
      }
    }

  }




  // لیست بالانس
  Future<List<BalanceItemModel>?> getBalanceList(int id) async{
    print("getBalanceList : $id");
    isLoadingBalance.value=false;
    // balanceList.clear();
    // balanceListP.clear();
    try{
     // state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
     // balanceList.addAll(response);
      response.removeWhere((r)=>r.balance==0);
      return response;

      // state.value=PageState.list;
      // isLoadingBalance.value=true;
      // if(balanceList.isEmpty){
      //   state.value=PageState.empty;
      // }
      // update();
    }
    catch(e){
     // state.value=PageState.err;
    }finally{
    }
    return null;
  }
  // // لیست حواله
  // Future<void> fetchRemittanceList() async{
  //   print("kkkkkkkkkk");
  //   remittanceList.clear();
  //   try{
  //     state.value=PageState.loading;
  //     var fetchedAccountList=await remittanceRepository.getRemittanceList(startDate: startDateFilter.value, endDate: endDateFilter.value);
  //     remittanceList.addAll(fetchedAccountList);
  //     state.value=PageState.list;
  //     if(remittanceList.isEmpty){
  //       state.value=PageState.empty;
  //     }
  //    // remittanceList.refresh();
  //     update();
  //   }
  //   catch(e){
  //     state.value=PageState.err;
  //   }finally{
  //   }


  // }// //  حواله
  Future<void> getOneRemittance(int id) async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    print("getOneRemittance");
    try{
      var remittance=await remittanceRepository.getOneRemittance(id: id);
      remittanceModel=remittance;
      namePayerController.text=remittanceModel?.walletPayer?.account?.name??"";
      dateController.text=remittanceModel?.date?.toPersianDate(showTime: true,digitType: NumStrLanguage.English)??"";
      descController.text=remittanceModel?.description??"";
      quantityPayerController.text="${remittanceModel?.quantity??0}";
      mobilePayerController.text=remittanceModel?.walletReciept?.account?.contactInfo??"";
      selectedAccountP.value=remittanceModel?.walletPayer!.account;
      selectedAccount.value=remittanceModel?.walletReciept!.account;
      selectedItem.value=remittanceModel?.item;
      balanceList.assignAll((await getBalanceList(selectedAccount.value?.id??0))!);
      balanceListP.assignAll((await getBalanceList(selectedAccountP.value?.id??0))!);
      getImage(remittanceModel?.recId??"", "Remittance");
     Get.toNamed('/updateRemittance');
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
  }


  // لیست کاربران
  Future<void> fetchAccountList(String name) async{
    try{
   //   state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.searchAccountListNew(name,"");
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);
    //  state.value=PageState.list;
      if(accountList.isEmpty){
     //   state.value=PageState.empty;
      }
      print('تعداد :${accountList.length}');
    }
    catch(e){
    //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
    }
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
 // لیست عکس ها
  Future<void> deleteImage(String fileName,) async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    print('تعداد image:');
    try{
      var fetch=await remittanceRepository.deleteImage(fileName: fileName,);
     if(fetch){
       getImage(remittanceModel?.recId??"", "Remittance");
     }
    }
    catch(e){
    //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      EasyLoading.dismiss();
    }
  }


  Future<void> fetchAccountListP(String name) async{
    try{
     // state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.searchAccountListNew(name,"");
      accountListP.assignAll(fetchedAccountList);
      searchedAccountsP.assignAll(fetchedAccountList);
     // state.value=PageState.list;
      if(accountList.isEmpty){
      //  state.value=PageState.empty;
      }
      print('تعداد :${accountList.length}');
    }
    catch(e){
     // state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
    }
  }


  Future<RemittanceModel?> insertRemittance(String recId) async {
    try {
      isLoading.value = true;
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      RemittanceModel response = await remittanceRepository.insertRemittance(
        date: gregorianDate,
        itemId: selectedItem.value?.id ?? 0,
        quantity: double.parse(quantityPayerController.text.toEnglishDigit()),
        description: descController.text,
        accountIdPayer: selectedAccountP.value?.id??0,
        accountNamePayer: selectedAccountP.value?.name??"",
        accountIdReciept: selectedAccount.value?.id??0,
        accountNameReciept:selectedAccount.value?.name??"",
        recId: recId,
      );
        Get.toNamed('/remittance');
        Get.snackbar(response.infos!.first['title'], response.infos!.first["description"],
            titleText: Text(response.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.infos!.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

      descController.text="";
      dateController.text="";
      quantityPayerController.text="";
     // getRemittanceListPager();
      clearFilter();
       clearSearch();
      clearList();
    } catch (e) {
      throw ErrorException('خطا در ایجاد حواله: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<RemittanceModel?> updateRemittance(String recId) async {
    try {
      isLoading.value = true;
    //  String gregorianDate = convertJalaliToGregorian(dateController.text);
      Gregorian date=remittanceModel!.date!.toGregorian();
      RemittanceModel response = await remittanceRepository.updateRemittance(
        date:"${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
        itemId: selectedItem.value?.id ?? 0,
        quantity: double.parse(quantityPayerController.text.toEnglishDigit()),
        description: descController.text,
        accountIdPayer: selectedAccountP.value?.id??0,
        accountNamePayer: selectedAccountP.value?.name??"",
        accountIdReciept: selectedAccount.value?.id??0,
        accountNameReciept: selectedAccount.value?.name??"", recId: remittanceModel?.recId??"", id: remittanceModel?.id??0,
        walletPayerId: remittanceModel?.walletPayer?.id ?? 0  ,
        walletRecieptId: remittanceModel?.walletReciept?.id ?? 0,
      );
        Get.toNamed('/remittance');
        Get.snackbar(response.infos!.first['title'], response.infos!.first["description"],
            titleText: Text(response.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.infos!.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

      descController.text="";
      dateController.text="";
      quantityPayerController.text="";
     // getRemittanceListPager();
     clearFilter();
     clearSearch();
      clearList();
    } catch (e) {
      throw ErrorException('خطا در ایجاد حواله: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> searchAccounts(String name) async {
    try {
      if (name.isEmpty) {
        searchedAccounts.clear();
        return;
      }

      final accounts = await accountRepository.searchAccountList(name,"");
      searchedAccounts.assignAll(accounts);
    } catch (e) {
      state.value = PageState.err;
    }
  }

  void selectAccount(AccountModel account) {
    currentPage.value = 1;
    selectedAccountId.value = account.id!;
    searchController.text = account.name!;
    Get.back(); // Close search dialog
    getRemittanceListPager();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getRemittanceListPager();
  }
  // لیست حواله ها با صفحه بندی
  Future<void> getRemittanceListPager() async {
    print("### getRemittanceListPager ###");
    isOpenMore.value = false;
    remittanceList.clear();
    try {
      state.value=PageState.loading;
      var response = await remittanceRepository.getRemittanceListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value, startDate: startDateFilter.value, endDate: endDateFilter.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        namePayer: namePayerController.text ,nameReciept: nameRecieptController.text,

      );
      remittanceList.addAll(response.remittances??[]);
      paginated=response.paginated;
      state.value=PageState.list;
      isOpenMore.value = true;

      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }




  Future< RemittanceModel?> updateRegistered(int remittanceId,bool registered) async {
    //EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      var response = await remittanceRepository.updateRegistered(
        remittanceId: remittanceId,
        registered: registered,
      );
      if(response!= null){
        EasyLoading.dismiss();
        Get.snackbar(response.infos!.first['title'],response.infos!.first["description"],
            titleText: Text(response.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.infos!.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getRemittanceListPager();
      }

    } catch (e) {
      throw ErrorException('خطا در ریجیستر: $e');
    } finally {
      isLoadingRegister.value = false;
    }

    return null;
  }

  Future<List< dynamic>?> deleteRemittance(int remittanceId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoadingDelete.value=true;
      var response=await remittanceRepository.deleteRemittance(isDeleted: isDeleted, remittanceId: remittanceId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getRemittanceListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف حواله: $e');
    }finally {
      EasyLoading.dismiss();
      isLoadingDelete.value=false;
    }
    return null;
  }

  // خروجی اکسل
  Future<void> exportToExcel() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final excel = Excel.createExcel();
      final sheet = excel['حواله'];

      sheet.appendRow([
        TextCellValue('ردیف'),
        TextCellValue('تاریخ'),
        TextCellValue('نام ثبت کننده'),
        TextCellValue('بدهکار'),
        TextCellValue('بستانکار'),
        TextCellValue('محصول'),
        TextCellValue('مقدار'),
        TextCellValue('وضعیت'),
        TextCellValue('شرح'),
        TextCellValue('توضیحات'),
        TextCellValue('مانده ریالی'),
        TextCellValue('مانده طلایی'),
        TextCellValue('مانده سکه'),
      ]);
      EasyLoading.show(status: 'دریافت فایل اکسل...');
      final allRemittances = await remittanceRepository.getRemittanceList(startDate: startDateFilter.value, endDate: endDateFilter.value);

      for (var remittance in allRemittances) {
        sheet.appendRow([
          TextCellValue(remittance.rowNum.toString()),
          TextCellValue(remittance.date?.toPersianDate(twoDigits: true) ?? ''),
          TextCellValue(remittance.createdBy?.name ?? ''),
          TextCellValue(remittance.walletPayer?.account?.name ?? ''),
          TextCellValue(remittance.walletReciept?.account?.name ?? ''),
          TextCellValue(remittance.item?.name ?? ''),
          TextCellValue(remittance.quantity?.toString().seRagham(separator: ",") ?? ''),
          TextCellValue(getStatusText(remittance.status ?? 0 )),
          TextCellValue(" از:${remittance.walletPayer?.account?.name ?? 0} به:${remittance.walletReciept?.account?.name ?? 0} ${remittance.item?.itemUnit?.id == 1
              ? "${remittance.quantity} عدد "
              : remittance.item?.itemUnit?.id == 2
              ? "${remittance.quantity} گرم "
              : "${remittance.quantity.toString().seRagham()} ریال " } ${remittance.item?.name} "?? ''),
          TextCellValue(remittance.description ?? ''),
          TextCellValue("بد:${remittance.balancePayer?.where((e) => e.unitName == "ریال").map((e)=> "\u202B${e.balance ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")} بس:${remittance.balanceReciept?.where((e) => e.unitName == "ریال").map((e)=> "\u202B${e.balance ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
          TextCellValue("بد:${remittance.balancePayer?.where((e) => e.unitName == "گرم").map((e) => "\u202B${e.balance ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")} بس:${remittance.balanceReciept?.where((e) => e.unitName == "گرم").map((e) => "\u202B${e.balance ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
          TextCellValue("بد:${remittance.balancePayer?.where((e) => e.unitName == "عدد").map((e) => "\u202B${e.balance ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")} بس:${remittance.balanceReciept?.where((e) => e.unitName == "عدد").map((e) => "\u202B${e.balance ?? 0}\u202C ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
        ]);
      }

      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception('خطا در دریافت فایل');
      final uint8List = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'remittances_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
      }else {
        final output = await getDownloadsDirectory();
        final filePath = '${output?.path}/remittances_${DateTime
            .now()
            .millisecondsSinceEpoch}.xlsx';
        final fileBytes = excel.encode();
        if (fileBytes != null) {
          await File(filePath).writeAsBytes(uint8List);

          await FileSaver.instance.saveFile(
            name: 'remittances',
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

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'تایید نشده';
      case 1:
        return 'تایید شده';
      default:
        return 'نامعتبر';
    }
  }

  // خروجی pdf
  Future<void> exportToPdf() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLoading.show(status: 'دریافت فایل PDF...');

      final allRemittances = await remittanceRepository.getRemittanceList(startDate: startDateFilter.value, endDate: endDateFilter.value);

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
                for (var remittance in allRemittances)
                  buildDataRow(remittance),
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
          ..download = 'remittances_${DateTime.now().millisecondsSinceEpoch}.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'remittances.pdf',
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
      3: pw.FlexColumnWidth(3),
      4: pw.FlexColumnWidth(3),
      5: pw.FlexColumnWidth(1.3),
      6: pw.FlexColumnWidth(2),
      7: pw.FlexColumnWidth(1.6),
      8: pw.FlexColumnWidth(2.5),
      9: pw.FlexColumnWidth(2.5),
      10: pw.FlexColumnWidth(2.5),
      11: pw.FlexColumnWidth(2),
      12: pw.FlexColumnWidth(1.2),
    };
  }
  // ساخت هدر جدول
  pw.Table buildHeaderTable() {
    return pw.Table(
      columnWidths: {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(3),
        3: pw.FlexColumnWidth(3),
        4: pw.FlexColumnWidth(3),
        5: pw.FlexColumnWidth(1.3),
        6: pw.FlexColumnWidth(2),
        7: pw.FlexColumnWidth(1.6),
        8: pw.FlexColumnWidth(2.5),
        9: pw.FlexColumnWidth(2.5),
        10: pw.FlexColumnWidth(2.5),
        11: pw.FlexColumnWidth(2),
        12: pw.FlexColumnWidth(1.2),
      },
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('مانده سکه', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('مانده طلایی', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('مانده ریالی', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('توضیحات', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('شرح', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('وضعیت', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8) ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('مقدار', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('محصول', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('بستانکار', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('بدهکار', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('نام ثبت کننده', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Text('تاریخ', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(3.0),
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
      padding: const pw.EdgeInsets.all(2.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 7),
        textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.right,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.TableRow buildDataRow(RemittanceModel remittance) {
    return pw.TableRow(
      children: [
        buildDataCell("بد:${remittance.balancePayer?.where((e) => e.unitName == "عدد").map((e) => "${e.balance ?? ''} ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")} بس:${remittance.balanceReciept?.where((e) => e.unitName == "عدد").map((e) => "${e.balance ?? ''} ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
        buildDataCell("بد:${remittance.balancePayer?.where((e) => e.unitName == "گرم").map((e) => "${e.balance ?? ''} ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")} بس:${remittance.balanceReciept?.where((e) => e.unitName == "گرم").map((e) => "${e.balance ?? ''} ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
        buildDataCell("بد:${remittance.balancePayer?.where((e) => e.unitName == "ریال").map((e) => "${e.balance ?? ''} ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")} بس:${remittance.balanceReciept?.where((e) => e.unitName == "ریال").map((e) => "${e.balance ?? ''} ${e.unitName ?? ''} ${e.itemName ?? ''}").join(", ")}"),
        buildDataCell(remittance.description ?? ''),
        buildDataCell(" از:${remittance.walletPayer?.account?.name ?? 0} به:${remittance.walletReciept?.account?.name ?? 0} ${remittance.item?.itemUnit?.id == 1
          ? "${remittance.quantity} عدد "
          : remittance.item?.itemUnit?.id == 2
          ? "${remittance.quantity} گرم "
          : "${remittance.quantity.toString().seRagham()} ریال " } ${remittance.item?.name} "?? ''),
        buildDataCell(getStatusText(remittance.status ?? 0 ),isCenter: true),
        buildDataCell(remittance.quantity?.toString().seRagham(separator: ",") ?? '',isCenter: true),
        buildDataCell(remittance.item?.name ?? '',isCenter: true),
        buildDataCell(remittance.walletReciept?.account?.name ?? '',isCenter: true),
        buildDataCell(remittance.walletPayer?.account?.name ?? '',isCenter: true),
        buildDataCell(remittance.createdBy?.name ?? '',isCenter: true),
        buildDataCell(remittance.date?.toPersianDate(twoDigits: true) ?? '',isCenter: true),
        buildDataCell(remittance.rowNum.toString(), isCenter: true),
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
    namePayerController.clear();
    nameRecieptController.clear();
    mobileFilterController.clear();
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value="";
    endDateFilter.value="";
  }
  void clearList() {
    //dateController.clear();
    quantityPayerController.clear();
    mobilePayerController.clear();
    descController.clear();
    namePayerController.clear();
    selectedAccountP.value=null;
    selectedItem.value=null;
    selectedAccount.value=null;
  }

  Future<void> captureRowScreenshot(RemittanceModel remittance, GlobalKey dataTableKey, Map<int, GlobalKey> rowKeys) async {
    final rowKey = rowKeys[remittance.id!];
    if (rowKey == null || rowKey.currentContext == null) {
      Get.snackbar('خطا', 'ردیفی برای ثبت پیدا نشد. کلید آماده نیست.');
      return;
    }

    if (dataTableKey.currentContext == null) {
      Get.snackbar('خطا', 'جدولی برای ثبت پیدا نشد. کلید آماده نیست.');
      return;
    }

    try {
      if (!kIsWeb) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar('خطای دسترسی', 'برای ذخیره تصاویر، مجوز ذخیره‌سازی لازم است.');
          return;
        }
      }

      final RenderRepaintBoundary boundary = dataTableKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 1.0);

      final RenderBox tableBox = dataTableKey.currentContext!.findRenderObject() as RenderBox;
      final tablePosition = tableBox.localToGlobal(Offset.zero);
      final tableSize = tableBox.size;

      final RenderBox cellContentBox = rowKey.currentContext!.findRenderObject() as RenderBox;

      RenderObject? tableCellRenderObject = cellContentBox;
      while (tableCellRenderObject != null && tableCellRenderObject.parentData is! TableCellParentData) {
        if (tableCellRenderObject.parent is RenderObject) {
          tableCellRenderObject = tableCellRenderObject.parent as RenderObject;
        } else {
          tableCellRenderObject = null;
          break;
        }
      }

      if (tableCellRenderObject == null || tableCellRenderObject is! RenderBox) {
        Get.snackbar('خطا', 'render object ردیف جدول پیدا نشد.');
        return;
      }

      final RenderBox rowCellBox = tableCellRenderObject;
      final rowCellPosition = rowCellBox.localToGlobal(Offset.zero);
      final rowHeight = rowCellBox.size.height;

      final cropRect = Rect.fromLTWH(0, // Start from the very left of the table
        rowCellPosition.dy - tablePosition.dy,
        tableSize.width,
        rowHeight,
      );

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final paint = Paint();
      canvas.drawImageRect(image, cropRect, Rect.fromLTWH(0, 0, cropRect.width, cropRect.height), paint,);

      final picture = recorder.endRecording();
      final croppedImage = await picture.toImage(cropRect.width.toInt(), cropRect.height.toInt());
      final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        Get.snackbar('خطا', 'دریافت داده‌های تصویر ناموفق بود.');
        return;
      }
      final uint8List = byteData.buffer.asUint8List();

      if (kIsWeb) {
        final blob = html.Blob([uint8List], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'row_screenshot_${remittance.id}.png')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await FileSaver.instance.saveFile(
          name: "row_screenshot_${remittance.id}",
          bytes: uint8List,
          ext: 'png',
          mimeType: MimeType.png,
        );
      }

      Get.snackbar('موفق', 'تصویر اسکرین شات با موفقیت ذخیره شد.');

    } catch (e) {
      Get.snackbar('خطا', 'ثبت اسکرین شات ناموفق بود: $e');
    }
  }

  void downloadImage(String guidId) async {
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
        /*final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/images_$guidId.png';*/
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
  }
}

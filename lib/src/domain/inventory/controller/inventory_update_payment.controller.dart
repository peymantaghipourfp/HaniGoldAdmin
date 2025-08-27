

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/inventory.repository.dart';
import 'package:hanigold_admin/src/config/repository/laboratory.repository.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet_account_req.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/upload.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../config/repository/wallet.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account.model.dart';
import '../../laboratory/model/laboratory.model.dart';
import '../../users/model/balance_item.model.dart';
import '../../users/model/paginated.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';

enum PageState{loading,err,empty,list}

class InventoryDetailUpdatePaymentController extends GetxController{

  final InventoryController inventoryController=Get.find<InventoryController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchLaboratoryController=TextEditingController();
  final TextEditingController quantityController=TextEditingController();
  final TextEditingController impurityController=TextEditingController();
  final TextEditingController weight750Controller=TextEditingController();
  final TextEditingController caratController=TextEditingController();
  final TextEditingController receiptNumberController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController accountController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  final InventoryRepository inventoryRepository=InventoryRepository();
  final LaboratoryRepository laboratoryRepository=LaboratoryRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();
  final RemittanceRepository remittanceRepository=RemittanceRepository();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<WalletModel> walletAccountList=<WalletModel>[].obs;
  final List<LaboratoryModel> laboratoryList=<LaboratoryModel>[].obs;
  final List<InventoryDetailModel> forPaymentList=<InventoryDetailModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;

  Rx<PageState> stateGetOne=Rx<PageState>(PageState.list);
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  RxList<InventoryDetailModel> getOneInventory=<InventoryDetailModel>[].obs;
  var inventoryId=0.obs;
  var inventoryDetailId=0.obs;
  var inputItemId=0.obs;
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<WalletModel> selectedWalletAccount=Rxn<WalletModel>();
  final Rxn<LaboratoryModel> selectedLaboratory=Rxn<LaboratoryModel>();
  final Rxn<InventoryDetailModel> selectedInputItem=Rxn<InventoryDetailModel>();
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;
  RxList<LaboratoryModel> searchedLaboratories = <LaboratoryModel>[].obs;
  RxInt editingIndex = RxInt(-1);
  RxBool isEditing = false.obs;
  var accountId=0.obs;
  var accountName=''.obs;
  final RxSet<int> selectedForPaymentId = RxSet<int>();
  RxInt selectedLaboratoryId = RxInt(0);
  final ImagePicker _picker = ImagePicker();
  RxList<XFile?> selectedImagesDesktop = RxList<XFile?>();
  var recordId="".obs;
  var uuid = Uuid();
  RxList<bool> uploadStatusesDesktop = RxList<bool>();
  RxBool isUploadingDesktop = false.obs;
  RxList<String> imageList = <String>[].obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;

  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    selectedWalletAccount.value = null;
    getWalletAccount(selectedAccount.value?.id ?? 0);
  }

  void changeSelectedWalletAccount(WalletModel? newValue) {
    selectedWalletAccount.value = newValue;
    selectedLaboratoryId.value = 0;
    searchLaboratoryController.clear();
    getForPaymentListPager();
    print("idItemUnit: ${newValue?.item?.itemUnit?.id}");

  }
  void changeSelectedLaboratory(LaboratoryModel? newValue) {
    selectedLaboratory.value=newValue;
  }
  void selectQuantity(double quantity){
    quantityController.text=quantity.toString();
    update();
  }

  void selectInputItem(InventoryDetailModel item) {
    selectedInputItem.value = item;
    inputItemId.value = item.id ?? 0;
    selectQuantity(item.quantityRemainded ?? 0.0);
    selectedLaboratory.value = item.laboratory;
    quantityController.text = item.quantityRemainded?.toString() ?? '0';
    impurityController.text = item.impurity?.toString() ?? '0';
    weight750Controller.text = item.weight750?.toString() ?? '0';
    caratController.text = item.carat?.toString() ?? '0';
    receiptNumberController.text = item.receiptNumber ?? '';
  }

  late InventoryDetailModel? inventoryDetail;
  @override
  void onInit() async{

    //inventoryDetail = Get.arguments;
    inventoryDetailId.value=int.parse(Get.parameters['id']!);
    /*if(inventoryDetailId.value!=null){
      await fetchGetOneInventory(inventoryDetailId.value,Get.parameters['index']!);
    }*/
    searchController.addListener(onSearchChanged);
    fetchAccountList();
    fetchWalletAccountList();
    getForPaymentListPager();
    /*var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text =
    "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";*/
    super.onInit();
  }

  @override
  void onClose() {
    debounce?.cancel();
    searchController.dispose();
    searchLaboratoryController.dispose();
    super.onClose();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    accountList.clear();
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList("");
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);
      state.value=PageState.list;
      if(accountList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  void onSearchChanged(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(milliseconds: 500), () async {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        searchedAccounts.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      await searchAccountList(query);

    });
  }
  Future<void> searchAccountList(String name) async {
    try {
      isLoading.value = true;
      if (name.isEmpty) {
        searchedAccounts.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      final results = await accountRepository.searchAccountList(name,"");
      searchedAccounts.assignAll(results);
      state.value = searchedAccounts.isEmpty ? PageState.empty : PageState.list;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی کاربران');
    } finally {
      isLoading.value = false;
    }
  }

  // مدل آپشن ولت
  WalletAccountReqModel? walletAccountReqModel;
  getWalletAccount(int id){
    walletAccountReqModel= WalletAccountReqModel(
        wallet: OptionsModel(
            orderBy: "wallet.Id",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 10000,
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: "AccountId",
                    filterValue: id.toString(),
                    filterType: 4,
                    refTable: "wallet"
                )
                ]
            )
            ]
        )
    );
    fetchWalletAccountList();
  }

  // لیست ولت اکانت
  Future<void> fetchWalletAccountList()async{
    try{
      state.value=PageState.loading;
      var fetchedWalletAccountList=await walletRepository.getWalletList(walletAccountReqModel!);
      walletAccountList.assignAll(fetchedWalletAccountList);
      for(int i=0;i<walletAccountList.length;i++){
        if(walletAccountList[i].id==inventoryDetail?.wallet?.id){
          selectedWalletAccount.value=walletAccountList[i];
        }
      }
      state.value=PageState.list;
      if(walletAccountList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=e.toString();
    }
  }

  Future<void> searchLaboratory(String name) async {
    try {
      isLoading.value = true;
      if (name.isEmpty) {
        searchedLaboratories.clear();
      }
      final laboratory = await laboratoryRepository.searchLaboratoryList(name);
      searchedLaboratories.assignAll(laboratory);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی آزمایشگاه');
    } finally {
      isLoading.value = false;
    }
  }
  void selectLaboratory(LaboratoryModel laboratory) {

    selectedLaboratoryId.value = laboratory.id!;
    searchLaboratoryController.text = laboratory.name!;
    Get.back(); // Close search dialog
    getForPaymentListPager();
  }

  void clearSearch() {

    selectedLaboratoryId.value = 0;
    searchLaboratoryController.clear();
    searchedLaboratories.clear();
    getForPaymentListPager();
  }

  // لیست دریافتی ها
  // Future<void> fetchForPaymentList()async{
  //   try{
  //     isLoading.value=true;
  //     state.value=PageState.loading;
  //     var fetchedForPaymentList=await inventoryRepository.getForPaymentlist(
  //         itemId:selectedWalletAccount.value?.item?.id ?? 0,
  //         laboratoryId: selectedLaboratoryId.value == 0
  //             ? null :selectedLaboratoryId.value
  //     );
  //     forPaymentList.assignAll(fetchedForPaymentList);
  //     state.value=PageState.list;
  //     if(forPaymentList.isEmpty){
  //       state.value=PageState.empty;
  //     }
  //   }
  //   catch(e){
  //     state.value=PageState.err;
  //     errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
  //   }finally{
  //     isLoading.value=false;
  //   }
  // }

  void isChangePage(int index){
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value=index*10;
    getForPaymentListPager();
  }

  // لیست دریافتی ها با صفحه بندی
  Future<void> getForPaymentListPager() async {
    print("### getForPaymentListPager ###");
    //isLoading.value=true;
    try {
      //state.value=PageState.loading;
      var response = await inventoryRepository.getForPaymentlistPager(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          itemId:selectedWalletAccount.value?.item?.id ?? 0,
          /*laboratoryId: selectedLaboratoryId.value == 0
              ? null :selectedLaboratoryId.value*/
      );
      forPaymentList.clear();
      //isLoading.value=false;
      forPaymentList.addAll(response.inventories??[]);
      paginated.value=response.paginated;
      //state.value=PageState.list;
      update();
    }
    catch (e) {
      //state.value = PageState.err;
    } finally {}
  }


  /*Future<void> fetchGetOneInventory(int id,String index)async{
    try {
      stateGetOne.value=PageState.loading;
      var fetchedGetOneInventory = await inventoryRepository.getInventoryDetail(id);
      if(fetchedGetOneInventory!=null){
        getOneInventory.value = fetchedGetOneInventory;
        if(index==""){
          setInventoryDetail(getOneInventory.value);
          inventoryDetail=getOneInventory;
          inventoryDetailId.value=inventoryDetail?.id ?? 0;
          accountId.value = inventoryDetail!.wallet!.account!.id!;
          accountName.value = inventoryDetail!.wallet!.account!.name!;
          getWalletAccount(accountId.value);
          getBalanceList(accountId.value);
        }else{
          inventoryDetail=getOneInventory;
          setInventoryDetail(inventoryDetail!);
          inventoryDetailId.value=inventoryDetail?.id ?? 0;
          accountId.value = inventoryDetail!.wallet!.account!.id!;
          accountName.value = inventoryDetail!.wallet!.account!.name!;
          getWalletAccount(accountId.value);
          getBalanceList(accountId.value);
        }

        stateGetOne.value=PageState.list;
      }else{
        stateGetOne.value=PageState.empty;
      }
    }
    catch(e){
      stateGetOne.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }*/

  Future<void> pickImageDesktop( ) async {
    try{
      final List<XFile?> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImagesDesktop.addAll(images);

      }
    }catch(e){
      throw Exception('خطا در انتخاب فایل‌ها');
    }

  }

  Future<void> uploadImagesDesktopUpdate( String type, String entityType,) async {

    recordId.value=uuid.v4();
    if (selectedImagesDesktop.isEmpty) {
      updateInventoryDetailPayment(recordId.value);
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
                recordId: inventoryDetail?.recId ?? '',
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
          updateInventoryDetailPayment(recordId.value);
          Get.back();
        }
      } finally {
        isUploadingDesktop.value = false;
        selectedImagesDesktop.clear();
        uploadStatusesDesktop.clear();
      }
    }

  }

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

  Future<void> deleteImage(String fileName,) async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    print('تعداد image:');
    try{
      var fetch=await remittanceRepository.deleteImage(fileName: fileName,);
      if(fetch){
        getImage(inventoryDetail?.recId??"", "InventoryDetail");
      }
    }
    catch(e){
      //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      EasyLoading.dismiss();
    }
  }

  Future<InventoryModel?> updateInventoryDetailPayment(String recId)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value=true;
      //String gregorianDate = convertJalaliToGregorian(dateController.text);
      Gregorian date=inventoryDetail!.date!.toGregorian();
      print(inventoryId.value);
      print(inventoryDetailId.value);
      print(accountId.value);
      print(accountName.value);
      print(inputItemId.value);
      if (selectedInputItem.value?.id != null &&
          !selectedForPaymentId.contains(selectedInputItem.value!.id)) {
        selectedForPaymentId.add(selectedInputItem.value!.id!);
      }
      var response=await inventoryRepository.updateDetailInventoryPayment(
        id: inventoryId.value,
        inventoryDetailId: inventoryDetailId.value,
        date: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
        accountId: accountId.value,
        accountName: accountName.value,
        type: 1,
        description: descriptionController.text,
        walletId: selectedWalletAccount.value?.id ?? 0,
        itemId: selectedWalletAccount.value!.item?.id ?? 0,
        itemName: selectedWalletAccount.value?.item?.name ?? '',
        quantity: double.tryParse(quantityController.text.toEnglishDigit()) ?? 0.0,
        impurity: double.tryParse(impurityController.text.toEnglishDigit()) ?? 0.0,
        weight750: double.tryParse(weight750Controller.text.toEnglishDigit()) ?? 0.0,
        carat: int.tryParse(caratController.text.toEnglishDigit()) ?? 0,
        receiptNumber:receiptNumberController.text,
        stateMode : 2,
        laboratoryName: selectedLaboratory.value?.name,
        laboratoryId: selectedLaboratory.value?.id,
        //inputItemId: selectedWalletAccount.value?.item?.itemUnit?.id==2 ? (selectedInputItem.value?.id ?? inputItemId.value) : null,
        inputItemId: selectedWalletAccount.value?.item?.itemUnit?.id==2 ? ((selectedInputItem.value?.id ?? inputItemId.value) == 0 ? null : (selectedInputItem.value?.id ?? inputItemId.value)) : null,
        recId: inventoryDetail?.recId ?? '',

      );
      print(response);
      if (response != null) {
        Get.back();
        InventoryModel responseData=InventoryModel.fromJson(response);
        Get.snackbar(responseData.infos?.first['title'], responseData.infos?.first["description"],
          titleText: Text(responseData.infos?.first['title'],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(
            responseData.infos?.first["description"], textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
        );
        inventoryController.fetchGetInventoryDetail(responseData.id ?? 0);
        inventoryController.getInventoryListPager();
        Get.back();
        clearList();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
    return null;
  }

  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    balanceList.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      isLoadingBalance.value=true;
      state.value=PageState.list;
      if(balanceList.isEmpty){
        state.value=PageState.empty;
      }
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

  void setInventoryDetail(InventoryDetailModel inventoryDetail){
    inventoryId.value=inventoryDetail.inventoryId ?? 0;
    quantityController.text=inventoryDetail.quantity.toString() ?? '';
    impurityController.text=inventoryDetail.impurity.toString() ?? '';
    weight750Controller.text=inventoryDetail.weight750.toString() ?? '';
    caratController.text=inventoryDetail.carat.toString() ?? '';
    receiptNumberController.text=inventoryDetail.receiptNumber.toString() ?? '';
    selectedLaboratory.value=inventoryDetail.laboratory;
    inputItemId.value=inventoryDetail.inputItemId ?? 0;
    descriptionController.text=inventoryDetail.description ?? "";
    dateController.text = inventoryDetail.date?.toPersianDate(showTime: true,digitType: NumStrLanguage.English) ?? '';
    getImage(inventoryDetail.recId ?? '', "InventoryDetail");
  }
  void clearList() {
    dateController.clear();
    quantityController.clear();
    descriptionController.clear();
    receiptNumberController.clear();
    impurityController.clear();
    weight750Controller.clear();
    caratController.clear();
    selectedWalletAccount.value=null;
    selectedAccount.value = null;
    selectedLaboratory.value=null;
    var now = Jalali.now();
    dateController.text = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
  void resetFieldsForTab(int tabIndex) {
    //dateController.clear();
    quantityController.clear();
    descriptionController.clear();
    receiptNumberController.clear();
    impurityController.clear();
    weight750Controller.clear();
    caratController.clear();
    selectedWalletAccount.value=null;
    selectedAccount.value = null;
    selectedLaboratory.value=null;
    var now = Jalali.now();
    dateController.text = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
  void resetLaboratorySearch() {
    searchLaboratoryController.clear();
    searchedLaboratories.assignAll(laboratoryList);
  }
}


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/inventory.repository.dart';
import 'package:hanigold_admin/src/config/repository/laboratory.repository.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet_account_req.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/wallet.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account.model.dart';
import '../../laboratory/model/laboratory.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';

enum PageState{loading,err,empty,list}

class InventoryDetailInsertController extends GetxController{

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
  final TextEditingController typeController=TextEditingController();
  final TextEditingController accountController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  final InventoryRepository inventoryRepository=InventoryRepository();
  final LaboratoryRepository laboratoryRepository=LaboratoryRepository();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<WalletModel> walletAccountList=<WalletModel>[].obs;
  final List<LaboratoryModel> laboratoryList=<LaboratoryModel>[].obs;

  Rx<PageState> stateGetOne=Rx<PageState>(PageState.list);
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;

  final Rxn<InventoryModel> getOneInventory=Rxn<InventoryModel>();
  var typeId=0.obs;
  var inventoryId=0.obs;
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<WalletModel> selectedWalletAccount=Rxn<WalletModel>();
  final Rxn<LaboratoryModel> selectedLaboratory=Rxn<LaboratoryModel>();
  RxInt selectedTabIndex = 0.obs;
  //final RxList<InventoryDetail> tempDetails = <InventoryDetail>[].obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;
  RxList<LaboratoryModel> searchedLaboratories = <LaboratoryModel>[].obs;
  RxInt editingIndex = RxInt(-1);
  RxBool isEditing = false.obs;
  var accountId=0.obs;
  var accountName=''.obs;

  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    selectedWalletAccount.value = null;
    getWalletAccount(selectedAccount.value?.id ?? 0);
  }

  void changeSelectedWalletAccount(WalletModel? newValue) {
    selectedWalletAccount.value = newValue;

    print(selectedWalletAccount.value?.item?.id);
    print(selectedWalletAccount.value?.item?.name);
  }
  void changeSelectedLaboratory(LaboratoryModel? newValue) {
    selectedLaboratory.value=newValue;
  }

  @override
  void onInit() async{

    final InventoryModel? inventory = Get.arguments;
    if(inventory!=null){
      inventoryId.value=inventory.id ?? 0;
      typeId.value=inventory.type ?? 0;
      dateController.text=inventory.date?.toPersianDate(showTime: true,digitType: NumStrLanguage.English) ?? '';
      accountId.value = inventory.account!.id!;
      accountName.value = inventory.account!.name!;
      getWalletAccount(accountId.value);
    }

    searchController.addListener(onSearchChanged);
    searchLaboratoryController.addListener(onSearchLaboratoryChanged);
    fetchAccountList();
    fetchWalletAccountList();
    fetchLaboratoryList();
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text =
    "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
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
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList();
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
      final results = await accountRepository.searchAccountList(name);
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
            orderByType: "desc",
            startIndex: 1,
            toIndex: 1000,
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

  // لیست آزمایشگاه ها
  Future<void> fetchLaboratoryList()async{
    try{
      state.value=PageState.loading;
      var fetchedLaboratoryList=await laboratoryRepository.getLaboratoryList();
      laboratoryList.assignAll(fetchedLaboratoryList);
      searchedLaboratories.assignAll(fetchedLaboratoryList);
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
  void onSearchLaboratoryChanged(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(milliseconds: 500), () async {
      final query = searchLaboratoryController.text.trim();
      if (query.isEmpty) {
        searchedLaboratories.assignAll(laboratoryList);
        state.value = PageState.list;
        return;
      }
      await searchLaboratoryList(query);

    });
  }
  Future<void> searchLaboratoryList(String name) async {
    try {
      isLoading.value = true;
      if (name.isEmpty) {
        searchedLaboratories.assignAll(laboratoryList);
        state.value = PageState.list;
        return;
      }
      final results = await laboratoryRepository.searchLaboratoryList(name);
      searchedLaboratories.assignAll(results);
      state.value = searchedLaboratories.isEmpty ? PageState.empty : PageState.list;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی آزمایشگاه');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchGetOneInventory(int id)async{
    try {
      stateGetOne.value=PageState.loading;
      var fetchedGetOneInventory = await inventoryRepository.getOneInventory(id);
      if(fetchedGetOneInventory!=null){
        getOneInventory.value = fetchedGetOneInventory;
        stateGetOne.value=PageState.list;
      }else{
        stateGetOne.value=PageState.empty;
      }
    }
    catch(e){
      stateGetOne.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }

  Future<InventoryModel?> insertInventoryDetail()async{
    try{
      isLoading.value=true;
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      print(inventoryId.value);
      print(accountName.value);
      var response=await inventoryRepository.insertDetailInventory(
        id: inventoryId.value,
        date: gregorianDate,
        accountId: accountId.value,
        accountName: accountName.value,
        type: typeId.value,
        description: descriptionController.text,
        walletId: selectedWalletAccount.value?.id ?? 0,
        itemId: selectedWalletAccount.value!.item?.id ?? 0,
        itemName: selectedWalletAccount.value?.item?.name ?? '',
        quantity: double.tryParse(quantityController.text.toEnglishDigit()) ?? 0.0,
        impurity: double.tryParse(impurityController.text.toEnglishDigit()) ?? 0.0,
        weight750: double.tryParse(weight750Controller.text.toEnglishDigit()) ?? 0.0,
        carat: int.tryParse(caratController.text.toEnglishDigit()) ?? 0,
        receiptNumber: receiptNumberController.text,
        stateMode : 1,
        laboratoryName: selectedLaboratory.value?.name ?? '',
        laboratoryId: selectedLaboratory.value?.id ?? 0,

      );
      print(response);
      if (response != null) {
        Get.back();
        Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
          titleText: Text('موفقیت آمیز',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(
            'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
        );
        Get.back();
        clearList();
      }
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
    return null;
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
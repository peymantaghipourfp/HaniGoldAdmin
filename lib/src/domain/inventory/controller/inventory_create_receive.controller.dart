

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
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../config/repository/wallet.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account.model.dart';
import '../../laboratory/model/laboratory.model.dart';
import '../../users/model/balance_item.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';

enum PageState{loading,err,empty,list}

class InventoryCreateReceiveController extends GetxController{

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

  final AccountRepository accountRepository=AccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  final InventoryRepository inventoryRepository=InventoryRepository();
  final LaboratoryRepository laboratoryRepository=LaboratoryRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<WalletModel> walletAccountList=<WalletModel>[].obs;
  final List<LaboratoryModel> laboratoryList=<LaboratoryModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<WalletModel> selectedWalletAccount=Rxn<WalletModel>();
  final Rxn<LaboratoryModel> selectedLaboratory=Rxn<LaboratoryModel>();
  final RxList<InventoryDetailModel> tempDetails = <InventoryDetailModel>[].obs;
  final RxBool isFinalizing = false.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;
  RxList<LaboratoryModel> searchedLaboratories = <LaboratoryModel>[].obs;
  RxInt editingIndex = RxInt(-1);
  RxBool isEditing = false.obs;

  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    selectedWalletAccount.value = null;
    getWalletAccount(selectedAccount.value?.id ?? 0);
  //  getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
  }

  void updateW750(){
    if (selectedWalletAccount.value?.item?.itemUnit?.id == 2) {
      int carat = int.parse(caratController.text=="" ? "0" : caratController.text.toEnglishDigit());
      double quantity = double.tryParse(quantityController.text=="" ? "0" : quantityController.text.toEnglishDigit()) ?? 0;
      double w750 = (carat * quantity)/750;
      weight750Controller.text = w750.toString().toPersianDigit();
    } else {
      weight750Controller.clear();
    }
  }
  void changeSelectedWalletAccount(WalletModel? newValue) {
    selectedWalletAccount.value = newValue;
    if (newValue?.item?.itemUnit?.id == 2) {
    caratController.text = '750';
    updateW750();
    } else {
      weight750Controller.clear();
      caratController.clear();
    }

    print(selectedWalletAccount.value?.item?.id);
    print(selectedWalletAccount.value?.item?.name);
  }
  void changeSelectedLaboratory(LaboratoryModel? newValue) {
    selectedLaboratory.value=newValue;
  }

  @override
  void onInit() {
    searchController.addListener(onSearchChanged);
    searchLaboratoryController.addListener(onSearchLaboratoryChanged);
    quantityController.addListener(updateW750);
    caratController.addListener(updateW750);
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
      var fetchedAccountList=await accountRepository.getAccountList("1");
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
        final results = await accountRepository.searchAccountList(name,"1");
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

// لیست موقت فاکتور
  Future<void> addToTempList() async {
    try {
      if (selectedAccount.value == null ||
          selectedWalletAccount.value == null ||
          quantityController.text.isEmpty) {
        throw ErrorException('لطفا فیلدهای ضروری را پر کنید');
      }

      final newDetail = InventoryDetailModel(
        wallet: selectedWalletAccount.value!,
        item: selectedWalletAccount.value!.item!,
        quantity: double.tryParse(quantityController.text.toEnglishDigit()) ?? 0.0,
        type: 1,
        impurity: double.tryParse(impurityController.text.toEnglishDigit()) ?? 0.0,
        weight750: double.tryParse(weight750Controller.text.toEnglishDigit()) ?? 0.0,
        carat: int.tryParse(caratController.text.toEnglishDigit()) ?? 0,
        receiptNumber: receiptNumberController.text,
        laboratory: selectedLaboratory.value,
        stateMode : 1,
      );

      tempDetails.add(newDetail);

      // ریست کردن فیلدها
      quantityController.clear();
      receiptNumberController.clear();
      descriptionController.clear();
      impurityController.clear();
      weight750Controller.clear();
      caratController.clear();
      selectedWalletAccount.value = null;
      selectedLaboratory.value=null;

      Get.snackbar("موفق", "آیتم به لیست موقت اضافه شد");

    } catch (e) {
      throw ErrorException('خطا در افزودن آیتم: ${e.toString()}');
    }
  }


  Future<InventoryModel?> submitFinalInventory()async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      if (tempDetails.isEmpty) {
        throw ErrorException('لیست آیتم‌ها خالی است');
      }
      isLoading.value=true;
      isFinalizing.value=true;

      String gregorianDate = convertJalaliToGregorian(dateController.text);
      var response=await inventoryRepository.insertInventoryReceive(
          date: gregorianDate,
          accountId: selectedAccount.value?.id ?? 0,
          accountName: selectedAccount.value?.name ?? "",
          type: 1,
          description: descriptionController.text,
        details:tempDetails,
      );
      print(response);
      if (response != null) {
        Get.back();
        tempDetails.clear();
        Get.snackbar("موفقیت آمیز", "ثبت نهایی انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
        );
        inventoryController.fetchInventoryList();
        Get.toNamed('inventoryList');
        clearList();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
      isFinalizing.value=false;
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
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
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
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
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
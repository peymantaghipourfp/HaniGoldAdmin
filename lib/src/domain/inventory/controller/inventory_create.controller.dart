

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/inventory.repository.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet_account_req.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/wallet.repository.dart';
import '../../account/model/account.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';

enum PageState{loading,err,empty,list}

class InventoryCreateController extends GetxController{

  final TextEditingController amountController=TextEditingController();
  final TextEditingController impurityController=TextEditingController();
  final TextEditingController weight750Controller=TextEditingController();
  final TextEditingController caratController=TextEditingController();
  final TextEditingController receiptNumberController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController typeController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  final InventoryRepository inventoryRepository=InventoryRepository();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<WalletModel> walletAccountList=<WalletModel>[].obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<WalletModel> selectedWalletAccount=Rxn<WalletModel>();
  RxInt selectedTabIndex = 0.obs;
  final RxList<InventoryDetail> tempDetails = <InventoryDetail>[].obs;
  final RxBool isFinalizing = false.obs;

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

  @override
  void onInit() {
    fetchAccountList();
    fetchWalletAccountList();
    var now = Jalali.now();
    var currentTime = TimeOfDay.now();
    dateController.text =
    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
    "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:00";
    super.onInit();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList();
      accountList.assignAll(fetchedAccountList);
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

// لیست موقت فاکتور
  Future<void> addToTempList() async {
    try {
      if (selectedAccount.value == null ||
          selectedWalletAccount.value == null ||
          amountController.text.isEmpty) {
        throw ErrorException('لطفا فیلدهای ضروری را پر کنید');
      }

      final newDetail = InventoryDetail(
        wallet: selectedWalletAccount.value!,
        item: selectedWalletAccount.value!.item!,
        amount: double.tryParse(amountController.text.toEnglishDigit()) ?? 0.0,
        type: selectedTabIndex.value,
        impurity: double.tryParse(impurityController.text.toEnglishDigit()) ?? 0.0,
        weight750: double.tryParse(weight750Controller.text.toEnglishDigit()) ?? 0.0,
        carat: int.tryParse(caratController.text.toEnglishDigit()) ?? 0,
        receiptNumber: receiptNumberController.text,
        stateMode : 1,
      );

      tempDetails.add(newDetail);

      // ریست کردن فیلدها
      amountController.clear();
      receiptNumberController.clear();
      descriptionController.clear();
      impurityController.clear();
      weight750Controller.clear();
      caratController.clear();
      selectedWalletAccount.value = null;

      Get.snackbar("موفق", "آیتم به لیست موقت اضافه شد");

    } catch (e) {
      throw ErrorException('خطا در افزودن آیتم: ${e.toString()}');
    }
  }


  Future<InventoryModel?> submitFinalInventory()async{
    try{
      if (tempDetails.isEmpty) {
        throw ErrorException('لیست آیتم‌ها خالی است');
      }
      isLoading.value=true;
      isFinalizing.value=true;

      final dateTimeParts = dateController.text.split(' ');
      final jalaliDatePart = dateTimeParts[0];
      final currentTime  = DateTime.now().toIso8601String().substring(11, 19);

      final jalaliParts = jalaliDatePart.split('-');
      final jalaliDate = Jalali(
        int.parse(jalaliParts[0]),
        int.parse(jalaliParts[1]),
        int.parse(jalaliParts[2]),
      );

      final gregorianDate = jalaliDate.toGregorian();
      final formattedGregorianDate =
          "${gregorianDate.year}-${gregorianDate.month.toString().padLeft(2, '0')}-"
          "${gregorianDate.day.toString().padLeft(2, '0')}";

      var response=await inventoryRepository.insertInventory(
          date: formattedGregorianDate,
          accountId: selectedAccount.value?.id ?? 0,
          accountName: selectedAccount.value?.name ?? "",
          type: selectedTabIndex.value == 0 ? 1 : 0,
          description: descriptionController.text,
        details:tempDetails,
        stateMode: 1,
      );
      print(response);
      if (response != null) {
        tempDetails.clear();
        Get.snackbar("موفقیت آمیز", "ثبت نهایی انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        clearList();
      }
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
      isFinalizing.value=false;
    }
    return null;
  }

  void clearList() {
    dateController.clear();
    amountController.clear();
    descriptionController.clear();
    receiptNumberController.clear();
    impurityController.clear();
    weight750Controller.clear();
    caratController.clear();
    selectedWalletAccount.value=null;
    selectedAccount.value = null;
    var now = Jalali.now();
    dateController.text = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
  void resetFieldsForTab(int tabIndex) {
    //dateController.clear();
    amountController.clear();
    descriptionController.clear();
    receiptNumberController.clear();
    impurityController.clear();
    weight750Controller.clear();
    caratController.clear();
    selectedWalletAccount.value=null;
    selectedAccount.value = null;
    var now = Jalali.now();
    dateController.text = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}


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
import 'package:pluto_grid/pluto_grid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../product/model/item.model.dart';
import '../model/remittance.model.dart';


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
  final TextEditingController dateController=TextEditingController();
  final TextEditingController namePayerController=TextEditingController();
  final TextEditingController mobilePayerController=TextEditingController();
  final TextEditingController quantityPayerController=TextEditingController();
  final TextEditingController descController=TextEditingController();
  RxList<String> getList = RxList([]);
  RxList<RemittanceModel> remittanceList = RxList([]);
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountListP=<AccountModel>[].obs;

  var errorMessage=''.obs;
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<AccountModel> selectedAccountP = Rxn<AccountModel>();
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  RxList<AccountModel> searchedAccountsP = <AccountModel>[].obs;
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  BalanceModel? balanceModel;
  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
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



  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    // selectedWalletAccount.value = null;
    // getWalletAccount(selectedAccount.value?.id ?? 0);
  }
  void changeSelectedAccountP(AccountModel? newValue) {
    selectedAccountP.value = newValue;
    namePayerController.text=newValue?.name??"";
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



  @override
  void onInit() {
    searchController.addListener(onSearchChanged);
    searchControllerP.addListener(onSearchChangedP);
    fetchRemittanceList();
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    fetchItemList();
    fetchAccountList("");
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
  void nextPage() {
    if (hasMore.value) {
      currentPage.value++;
      fetchRemittanceList();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchRemittanceList();
    }
  }


  // لیست حواله
  Future<void> fetchRemittanceList() async{
    print("kkkkkkkkkk");
    remittanceList.clear();
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await remittanceRepository.getRemittanceList();
      remittanceList.addAll(fetchedAccountList);
      state.value=PageState.list;
      if(remittanceList.isEmpty){
        state.value=PageState.empty;
      }
     // remittanceList.refresh();
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

  // لیست کاربران
  Future<void> fetchAccountList(String name) async{
    try{
   //   state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.searchAccountListNew(name);
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


  Future<void> fetchAccountListP(String name) async{
    try{
     // state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.searchAccountListNew(name);
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


  Future<RemittanceModel?> insertRemittance() async {
    try {
      isLoading.value = true;
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      RemittanceModel response = await remittanceRepository.insertRemittance(
        date: gregorianDate,
        itemId: selectedItem.value?.id ?? 0,
        quantity: double.parse(quantityPayerController.text.toEnglishDigit()),
        description: descController.text,
        accountIdPayer: selectedAccount.value?.id??0,
        accountNamePayer: selectedAccount.value?.name??"",
        accountIdReciept: selectedAccountP.value?.id??0,
        accountNameReciept: selectedAccountP.value?.name??"",
      );
        Get.toNamed('/remittance');
        Get.snackbar(response.infos!.first['title'], response.infos!.first["description"],
            titleText: Text(response.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.infos!.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

        fetchRemittanceList();

    } catch (e) {
      throw ErrorException('خطا در ایجاد حواله: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }



}
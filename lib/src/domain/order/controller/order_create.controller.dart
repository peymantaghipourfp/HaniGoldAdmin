

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/item.repository.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../users/model/balance_item.model.dart';
import '../model/order.model.dart';
import 'order.controller.dart';


enum PageState{loading,err,empty,list}

class OrderTypeModel{
  final int? id;
  final String? name;
  OrderTypeModel({this.id, this.name});
}


class OrderCreateController extends GetxController{

  final OrderController orderController=Get.find<OrderController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController=TextEditingController();
  final TextEditingController quantityController=TextEditingController();
  final TextEditingController totalPriceController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();

  final List<OrderTypeModel> orderTypeList=<OrderTypeModel>[].obs;
  final ItemRepository itemRepository=ItemRepository();
  final AccountRepository accountRepository=AccountRepository();
  final OrderRepository orderRepository=OrderRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  var maxItemSell=0.obs;
  var maxItemBuy=0.obs;
  final Rxn<ItemModel> getOneItem=Rxn<ItemModel>();
  final Rxn<OrderTypeModel> selectedBuySell = Rxn<OrderTypeModel>();
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;

  void changeSelectedBuySell(OrderTypeModel? newValue) {
      selectedBuySell.value = newValue;
      selectedBuySell.value?.id==0 ?
      priceController.text=selectedItem.value!.price.toString().seRagham(separator: ',') :
      priceController.text=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');

  }
  void changeSelectedItem(ItemModel? newValue) {
    clearListChangeItem();
    selectedItem.value = newValue;
    selectedBuySell.value?.id==0 ?
    priceController.text=selectedItem.value!.price.toString().seRagham(separator: ',') :
    priceController.text=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');

    maxItemSell.value=newValue!.maxSell!;
    maxItemBuy.value=newValue.maxBuy!;
    print(maxItemSell.value);
    print(maxItemBuy.value);
  }
  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
  }
  void updateTotalPrice(){
    double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double quantity=double.tryParse(quantityController.text==""? "0" :quantityController.text.toEnglishDigit()) ?? 0;
    double totalPrice= price * quantity;
    totalPriceController.text=totalPrice.toString().toPersianDigit().seRagham();
  }

  void updateQuantity(){
    double totalPrice=double.tryParse(totalPriceController.text ==""?"0" : totalPriceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double quantity=totalPrice / price;
    quantityController.text=quantity.toString();
  }

  @override
  void onInit() {
    orderTypeList.addAll([
      OrderTypeModel(id:null, name: 'انتخاب کنید'),
      OrderTypeModel(id:0,name: 'فروش به کاربر'),
      OrderTypeModel(id:1,name: 'خرید از کاربر'),
    ]);
    searchController.addListener(onSearchChanged);
    fetchItemList();
    fetchAccountList();
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    super.onInit();
  }
  @override
  void onClose() {
    debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // لیست محصولات
  Future<void> fetchItemList() async{
    try{
      state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      itemList.removeWhere((e) => e.price==null,);
      state.value=PageState.list;
      if(itemList.isEmpty){
        state.value=PageState.empty;
      }
      print("itemList${itemList.length}");
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  Future<ItemModel?> fetchGetOneItem(int id)async{
    try {
      state.value=PageState.loading;
      var fetchedGetOne = await itemRepository.getOneItem(id);

      if (fetchedGetOne != null) {
        getOneItem.value = fetchedGetOne;
      }
      state.value=PageState.list;
      state.value=PageState.empty;
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }return null;
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
      print('تعداد :${accountList.length}');
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
    debounce=Timer(const Duration(seconds: 4), () async {
      await searchAccountList(searchController.text.trim());

    });
  }
  Future<void> searchAccountList(String name) async {
    try {
      isLoading.value = true;
      if (name.length>2) {
        searchedAccounts.assignAll(accountList);
      } else {
        final results = await accountRepository.searchAccountList(name);
        searchedAccounts.assignAll(results);
        state.value=PageState.list;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی کاربران');
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderModel?> insertOrder()async{
    try {
      EasyLoading.show(status: 'لطفا صبر کنید...');
      isLoading.value = true;
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      var response = await orderRepository.insertOrder(
        date: gregorianDate,
        accountId: selectedAccount.value?.id ?? 0,
        accountName: selectedAccount.value?.name ?? "",
        type: selectedBuySell.value?.id ?? 0,
        itemId: selectedItem.value?.id ?? 0,
        itemName: selectedItem.value?.name ?? "",
        price: double.parse(priceController.text.replaceAll(',', '').toEnglishDigit()),
        quantity: double.tryParse(quantityController.text.toEnglishDigit()) ?? 0.0,
        description: descriptionController.text,
      );
      print(response);
      if (response != null) {
        OrderModel orderResponse=OrderModel.fromJson(response);
        Get.toNamed('/orderList');
        Get.snackbar(orderResponse.infos!.first['title'], orderResponse.infos!.first["description"],
            titleText: Text(orderResponse.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                orderResponse.infos!.first["description"] , textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        orderController.fetchOrderList();
        balanceList.clear();
        clearList();
      }
    }
    catch(e){
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
    isLoadingBalance.value=false;
    balanceList.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
     balanceList.removeWhere((r)=>r.balance==0);
      state.value=PageState.list;
      isLoadingBalance.value=true;
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
    priceController.clear();
    quantityController.clear();
    descriptionController.clear();
    totalPriceController.clear();
    selectedBuySell.value=null;
    selectedItem.value=null;
    selectedAccount.value=null;
  }
  void clearListChangeItem() {
    priceController.clear();
    quantityController.clear();
    descriptionController.clear();
    totalPriceController.clear();
    selectedItem.value=null;
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
}
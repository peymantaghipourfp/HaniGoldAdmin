

import 'dart:async';

import 'package:flutter/material.dart';
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
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
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
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;

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
  }
  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
    selectedBuySell.value?.id==0 ?
    priceController.text=(selectedItem.value!.price!-selectedItem.value!.differentPrice!.toDouble()).toString().seRagham(separator: ',')
        :
    priceController.text=selectedItem.value!.price.toString().seRagham(separator: ',');
    maxItemSell.value=newValue!.maxSell!;
    maxItemBuy.value=newValue.maxBuy!;
    print(maxItemSell.value);
    print(maxItemBuy.value);
  }
  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
  }
  void updateTotalPrice(){
    double price=double.tryParse(priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double quantity=double.tryParse(quantityController.text.toEnglishDigit()) ?? 0;
    double totalPrice= price * quantity;
    totalPriceController.text=totalPrice.toStringAsFixed(2).seRagham().toPersianDigit();
  }


  @override
  void onInit() {
    orderTypeList.addAll([
      OrderTypeModel(id: null, name: 'انتخاب کنید'),
      OrderTypeModel(id: 0,name: 'فروش به کاربر'),
      OrderTypeModel(id: 1,name: 'خرید از کاربر'),
    ]);
    searchController.addListener(onSearchChanged);
    fetchItemList();
    fetchAccountList();
    priceController.addListener(updateTotalPrice);
    quantityController.addListener(updateTotalPrice);

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
      state.value=PageState.list;
      if(itemList.isEmpty){
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
        Get.back();
        Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        clearList();
        orderController.fetchOrderList();
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
    return null;
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
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
}
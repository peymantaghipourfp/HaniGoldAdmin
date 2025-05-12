
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/item.repository.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

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

class OrderUpdateController extends GetxController{

  final OrderController orderController=Get.find<OrderController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController=TextEditingController();
  final TextEditingController quantityController=TextEditingController();
  final TextEditingController totalPriceController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();

  final ItemRepository itemRepository=ItemRepository();
  final AccountRepository accountRepository=AccountRepository();
  final OrderRepository orderRepository=OrderRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();

  final List<OrderTypeModel> orderTypeList=<OrderTypeModel>[
    OrderTypeModel(id: 0, name: 'فروش به کاربر'),
    OrderTypeModel(id: 1, name: 'خرید از کاربر'),
  ];
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  final Rxn<OrderTypeModel> selectedBuySell = Rxn<OrderTypeModel>();
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;

  final RxInt orderId=0.obs;
  var maxItemSell=0.obs;
  var maxItemBuy=0.obs;

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
    priceController.text=(selectedItem.value!.price!-selectedItem.value!.differentPrice!.toDouble()).toString().seRagham(separator: ',');

    maxItemSell.value=newValue!.maxSell!;
    maxItemBuy.value=newValue.maxBuy!;
  }
  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
  }
  void updateTotalPrice(){
    double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double quantity=double.tryParse(quantityController.text==""? "0" : quantityController.text.toEnglishDigit()) ?? 0.0;
    double totalPrice= price * quantity;
    totalPriceController.text=totalPrice.toStringAsFixed(2).seRagham().toPersianDigit();
  }

  void updateQuantity(){
    double totalPrice=double.tryParse(totalPriceController.text ==""?"0" : totalPriceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double quantity=totalPrice / price;
    quantityController.text=quantity.toString();
  }

  @override
  void onInit(){
    searchController.addListener(onSearchChanged);
    fetchItemList();
    fetchAccountList();
    final OrderModel? existingOrder = Get.arguments as OrderModel?;
    if (existingOrder != null) {
      setOrderDetails(existingOrder);
      getBalanceList(existingOrder.account?.id ?? 0);
    }
    /*final now = DateTime.now();
    final jalaliDate = Jalali.fromDateTime(now);
    final formattedDate = "${jalaliDate.year}-${jalaliDate.month.toString().padLeft(2, '0')}-${jalaliDate.day.toString().padLeft(2, '0')}";
    final formattedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    dateController.text="$formattedDate $formattedTime";*/
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
      final OrderModel? existingOrder = Get.arguments as OrderModel?;
      if (existingOrder != null && existingOrder.item != null) {
        final match = itemList.firstWhereOrNull(
              (i) => i.id == existingOrder.item!.id,
        );
        if (match != null) {
          selectedItem.value = match;
          maxItemSell.value=match.maxSell!;
          maxItemBuy.value=match.maxBuy!;
        }
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }
  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList();
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);
      state.value=PageState.list;
      final OrderModel? existingOrder = Get.arguments as OrderModel?;
      if (existingOrder != null && existingOrder.account != null) {
        selectedAccount.value=existingOrder.account;

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


  Future<OrderModel?> updateOrder() async {
    //print(priceController.text);
    if(orderId.value==0){
      return null;
    }
    try {
      isLoading.value = true;

      String gregorianDate = convertJalaliToGregorian(dateController.text);
     var response = await orderRepository.updateOrder(
        orderId: orderId.value,
        date: gregorianDate,
        accountId: selectedAccount.value?.id ?? 0,
        accountName: selectedAccount.value?.name ?? "",
        type: selectedBuySell.value?.id ?? 0,
        itemId: selectedItem.value?.id ?? 0,
        itemName: selectedItem.value?.name ?? "",
        price: double.parse(priceController.text.replaceAll(',', '').toEnglishDigit()),
        quantity: double.parse(quantityController.text.toEnglishDigit()),
        description: descriptionController.text,
      );

     if(response!= null){
       OrderModel orderResponse=OrderModel.fromJson(response);
       Get.back();
       Get.snackbar(orderResponse.infos!.first['title'], orderResponse.infos!.first["description"],
           titleText: Text(orderResponse.infos!.first['title'],
             textAlign: TextAlign.center,
             style: TextStyle(color: AppColor.textColor),),
           messageText: Text(orderResponse.infos!.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
       orderController.fetchOrderList();
       balanceList.clear();
       clearList();
     }

    } catch (e) {
      throw ErrorException('خطا در به‌روزرسانی سفارش: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  void setOrderDetails(OrderModel order) {
    orderId.value=order.id ?? 0;
    selectedBuySell.value = (order.type == 1)
        ? OrderTypeModel(id: 1, name: 'خرید از کاربر')
        : OrderTypeModel(id: 0, name: 'فروش به کاربر');
    //selectedItem.value = itemList.firstWhereOrNull((item) => item.id == order.item?.id);
    //selectedAccount.value = accountList.firstWhereOrNull((account) => account.id == order.account?.id);

    dateController.text = order.date?.toPersianDate(showTime: true,digitType: NumStrLanguage.English) ?? '' ?? '';
    priceController.text = order.price?.toString().seRagham(separator: ',') ?? '';
    quantityController.text = order.quantity?.toString() ?? '';
    totalPriceController.text = order.totalPrice?.toString().seRagham(separator: ',') ?? '';
    descriptionController.text = order.description ?? '';
    isLoadingBalance.value=true;
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
    priceController.clear();
    quantityController.clear();
    descriptionController.clear();
    totalPriceController.clear();
    selectedBuySell.value=null;
    selectedItem.value=null;
    selectedAccount.value=null;
  }
  void clearListChangeItem() {
    dateController.clear();
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
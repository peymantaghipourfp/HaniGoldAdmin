
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

import '../../../utils/convert_Jalali_to_gregorian.component.dart';
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

  final List<OrderTypeModel> orderTypeList=<OrderTypeModel>[
    OrderTypeModel(id: 0, name: 'فروش به کاربر'),
    OrderTypeModel(id: 1, name: 'خرید از کاربر'),
  ];
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;

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
  }
  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
    selectedBuySell.value?.id==0 ?
    priceController.text=(selectedItem.value!.price!-selectedItem.value!.differentPrice!.toDouble()).toString().seRagham(separator: ',')
    :
    priceController.text=selectedItem.value!.price.toString().seRagham(separator: ',');
    maxItemSell.value=newValue!.maxSell!;
    maxItemBuy.value=newValue.maxBuy!;
  }
  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
  }
  void updateTotalPrice(){
    double price=double.tryParse(priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double quantity=double.tryParse(quantityController.text.toEnglishDigit()) ?? 0.0;
    double totalPrice= price * quantity;
    totalPriceController.text=totalPrice.toStringAsFixed(2).seRagham().toPersianDigit();
  }

  @override
  void onInit(){
    searchController.addListener(onSearchChanged);
    fetchItemList();
    fetchAccountList();
    final OrderModel? existingOrder = Get.arguments as OrderModel?;
    if (existingOrder != null) {
      setOrderDetails(existingOrder);
    }
    priceController.addListener(updateTotalPrice);
    quantityController.addListener(updateTotalPrice);

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
        final match = accountList.firstWhereOrNull(
              (a) => a.id == existingOrder.account!.id,
        );
        if (match != null) {
          selectedAccount.value = match;
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
       Get.back();
       Get.snackbar("موفقیت آمیز","ویرایش با موفقیت آنجام شد",
           titleText: Text('موفقیت آمیز',
             textAlign: TextAlign.center,
             style: TextStyle(color: AppColor.textColor),),
           messageText: Text('ویرایش با موفقیت آنجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
       clearList();
       orderController.fetchOrderList();

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
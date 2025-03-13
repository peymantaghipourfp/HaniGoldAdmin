
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

  final TextEditingController priceController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
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

  final RxInt orderId=0.obs;

  void changeSelectedBuySell(OrderTypeModel? newValue) {
    selectedBuySell.value = newValue;
  }
  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
    selectedBuySell.value?.id==0?
    priceController.text=selectedItem.value!.price.toString().seRagham(separator: ','):
    priceController.text=(selectedItem.value!.price!-selectedItem.value!.differentPrice!.toDouble()).toString().seRagham(separator: ',');

  }
  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
  }
  void updateTotalPrice(){
    double price=double.tryParse(priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
    double amount=double.tryParse(amountController.text.toEnglishDigit()) ?? 0;
    double totalPrice= price * amount;
    totalPriceController.text=totalPrice.toStringAsFixed(2).seRagham().toPersianDigit();
  }


  @override
  void onInit(){
    fetchItemList();
    fetchAccountList();
    final OrderModel? existingOrder = Get.arguments as OrderModel?;
    if (existingOrder != null) {
      setOrderDetails(existingOrder);
    }
    priceController.addListener(updateTotalPrice);
    amountController.addListener(updateTotalPrice);
    var now=Jalali.now();
    dateController.text="${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    super.onInit();
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


  Future<OrderModel?> updateOrder() async {
    //print(priceController.text);
    if(orderId.value==0){
      return null;
    }
    try {
      isLoading.value = true;
     var response = await orderRepository.updateOrder(
        orderId: orderId.value,
        date: dateController.text,
        accountId: selectedAccount.value?.id ?? 0,
        accountName: selectedAccount.value?.name ?? "",
        type: selectedBuySell.value?.id ?? 0,
        itemId: selectedItem.value?.id ?? 0,
        itemName: selectedItem.value?.name ?? "",
        price: double.parse(priceController.text.replaceAll(',', '').toEnglishDigit()),
        amount: double.parse(amountController.text.toEnglishDigit()),
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

    dateController.text = order.date.toString() ?? '';
    priceController.text = order.price?.toString().seRagham(separator: ',') ?? '';
    amountController.text = order.amount?.toString() ?? '';
    totalPriceController.text = order.totalPrice?.toString().seRagham(separator: ',') ?? '';
    descriptionController.text = order.description ?? '';

  }


  void clearList() {
    dateController.clear();
    priceController.clear();
    amountController.clear();
    descriptionController.clear();
    totalPriceController.clear();
    selectedBuySell.value=null;
    selectedItem.value=null;
    selectedAccount.value=null;
  }
}
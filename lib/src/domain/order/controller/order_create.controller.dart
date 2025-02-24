
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/item.repository.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';

import '../model/order.model.dart';


enum PageState{loading,err,empty,list}

class OrderTypeModel{
  final int? id;
  final String? name;
  OrderTypeModel({this.id, this.name});
}

class OrderCreateController extends GetxController{

  final TextEditingController priceController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
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

  final Rxn<OrderTypeModel> selectedBuySell = Rxn<OrderTypeModel>();
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();

  void changeSelectedBuySell(OrderTypeModel? newValue) {
      selectedBuySell.value = newValue;
  }
  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
    selectedBuySell.value?.id==0?
    priceController.text=selectedItem.value!.price.toString():
    priceController.text=(selectedItem.value!.price!-selectedItem.value!.differentPrice!.toDouble()).toString();

  }
  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
  }
  void updateTotalPrice(){
    double price=double.tryParse(priceController.text) ?? 0;
    double amount=double.tryParse(amountController.text) ?? 0;
    double totalPrice= price * amount;
    totalPriceController.text=totalPrice.toStringAsFixed(2);
  }


  @override
  void onInit() {
    orderTypeList.addAll([
      OrderTypeModel(id: 0,name: 'فروش به کاربر'),
      OrderTypeModel(id: 1,name: 'خرید از کاربر'),
    ]);
    fetchItemList();
    fetchAccountList();
    priceController.addListener(updateTotalPrice);
    amountController.addListener(updateTotalPrice);
    super.onInit();
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

  Future<void> insertOrder()async{
    isLoading.value=true;
    try{
      await orderRepository.insertOrder(
          date: dateController.text,
          accountId: selectedAccount.value?.id ?? 0,
          accountName: selectedAccount.value?.name ?? "",
          type: selectedBuySell.value?.id ?? 0,
          itemId: selectedItem.value?.id ?? 0,
          itemName: selectedItem.value?.name ?? "",
          price: double.parse(priceController.text),
          amount: double.parse(amountController.text),
        description: descriptionController.text,
      );
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
  }
  Future<void> updateOrder({required int orderId}) async {
    isLoading.value = true;
    try {
      await orderRepository.updateOrder(
        orderId: orderId,
        date: dateController.text,
        accountId: selectedAccount.value?.id ?? 0,
        accountName: selectedAccount.value?.name ?? "",
        type: selectedBuySell.value?.id ?? 0,
        itemId: selectedItem.value?.id ?? 0,
        itemName: selectedItem.value?.name ?? "",
        price: double.parse(priceController.text),
        amount: double.parse(amountController.text),
        description: descriptionController.text,
      );
    } catch (e) {
      throw ErrorException('خطا در به‌روزرسانی سفارش: $e');
    } finally {
      isLoading.value = false;
    }
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
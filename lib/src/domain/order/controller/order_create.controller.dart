

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../../../config/const/audio.service.dart';
import '../../../config/const/socket.service.dart';
import '../../../config/repository/account_sales_group.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account_level_get_one_item.model.dart';
import '../../accountSalesGroup/model/account_sales_group_get_one_item.model.dart';
import '../../product/model/socket_item.model.dart';
import '../../users/model/balance_item.model.dart';
import '../model/order.model.dart';
import 'order.controller.dart';
import '../../base/base_controller.dart';


enum PageState{loading,err,empty,list}

class OrderTypeModel{
  final int? id;
  final String? name;
  OrderTypeModel({this.id, this.name});
}

class OrderCreateController extends BaseController{

  final OrderController orderController=Get.find<OrderController>();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController priceController=TextEditingController();
  final TextEditingController quantityController=TextEditingController();
  final TextEditingController totalPriceController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();

  final List<OrderTypeModel> orderTypeList=<OrderTypeModel>[].obs;
  final ItemRepository itemRepository=ItemRepository();
  final AccountRepository accountRepository=AccountRepository();
  final AccountSalesGroupRepository accountSalesGroupRepository=AccountSalesGroupRepository();
  final OrderRepository orderRepository=OrderRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;
  var isLoadingItems=false.obs;

  var maxItemSell=0.obs;
  var maxItemBuy=0.obs;
  var manualPriceChecked = false.obs;
  var notLimitChecked = false.obs;
  var isCardChecked = false.obs;
  final Rxn<ItemModel> getOneItem=Rxn<ItemModel>();
  final Rxn<OrderTypeModel> selectedBuySell = Rxn<OrderTypeModel>();
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;
  var priceTemp=''.obs;
  var socketPrice=''.obs;
  var currentPrice=''.obs;
  final Rxn<AccountLevelGetOneItemModel> selectedAccountLevelItem = Rxn<AccountLevelGetOneItemModel>();
  var isLoadingAccountLevelItem = false.obs;
  final Rxn<AccountSalesGroupGetOneItemModel> selectedAccountSalesGroupItem = Rxn<AccountSalesGroupGetOneItemModel>();
  var isLoadingAccountSalesGroupItem = false.obs;
  // Error handling
  var hasError = false.obs;
  var errorTitle = ''.obs;
  var dropdownError="".obs;

  //SocketService socketService = Get.find<SocketService>();
  StreamSubscription? socketSubscription;

  void changeSelectedBuySell(OrderTypeModel? newValue) {
      selectedBuySell.value = newValue;
      // قیمت فیلد همیشه خالی باشد
      priceController.clear();
      currentPrice.value = '';
      if (selectedItem.value != null) {
        _updateSocketPriceFromCurrent();
      } else {
        socketPrice.value = '';
      }
      /*if(selectedItem.value!=null){
        if(selectedItem.value?.itemUnit?.name=='گرم'){
          if(selectedBuySell.value?.id==0){
            priceController.text=(selectedItem.value!.mesghalPrice).toString().seRagham(separator: ',');
            priceTemp.value=selectedItem.value!.price.toString().seRagham(separator: ',');
          }else if(selectedBuySell.value?.id==1){
            priceController.text=(((selectedItem.value!.mesghalPrice!)-(selectedItem.value!.mesghalDifferentPrice!)).toDouble()).toString().seRagham(separator: ',');
            priceTemp.value=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');
          }
        }else{
          if(selectedBuySell.value?.id==0){
            priceController.text=selectedItem.value!.price.toString().seRagham(separator: ',');
            priceTemp.value=selectedItem.value!.price.toString().seRagham(separator: ',');
          }else if(selectedBuySell.value?.id==1){
            priceController.text=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');
            priceTemp.value=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');
          }
        }
      }*/
  }

  void changeSelectedItem(ItemModel? newValue) {
    clearListChangeItem();
    selectedItem.value = newValue;
// قیمت فیلد همیشه خالی باشد
    priceController.clear();
    currentPrice.value = '';
    if (newValue != null) {
      _updateSocketPriceFromCurrent();
      _fetchAccountLevelForCurrentSelection();
      _fetchAccountSalesGroupForCurrentSelection();
    } else {
      socketPrice.value = '';
      selectedAccountLevelItem.value = null;
      selectedAccountSalesGroupItem.value = null;
    }
    /*if(newValue?.itemUnit?.name=='گرم'){
      if(selectedBuySell.value?.id==0) {
        priceController.text=selectedItem.value!.mesghalPrice.toString().seRagham(separator: ',');
        priceTemp.value=newValue!.price.toString().seRagham(separator: ',');
      }else {
        priceController.text=(((selectedItem.value!.mesghalPrice!)-(selectedItem.value!.mesghalDifferentPrice!)).toDouble()).toString().seRagham(separator: ',');
        priceTemp.value=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');
      }
    }else{
      if(selectedBuySell.value?.id==0){
        priceController.text=selectedItem.value!.price.toString().seRagham(separator: ',');
        priceTemp.value=newValue!.price.toString().seRagham(separator: ',');
      }else{
        priceController.text=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');
        priceTemp.value=(((selectedItem.value!.price!)-(selectedItem.value!.differentPrice!)).toDouble()).toString().seRagham(separator: ',');
      }
    }*/

    //maxItemSell.value=newValue!.maxSell!;
    //maxItemBuy.value=newValue.maxBuy!;
    //print(maxItemSell.value);
    //print(maxItemBuy.value);
    print(priceTemp.value);
  }

  void _listenToSocket() {
    socketSubscription?.cancel();
    socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'itemPrice') {
            final socketItem = SocketItemModel.fromJson(data);
            /*Get.snackbar('تغییر قیمت', 'قیمت ${socketItem.name} تغییر کرد.',
              titleText: Text('تغییر قیمت',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                'قیمت ${socketItem.name} تغییر کرد.', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
            );*/
            print("socketItem.mesghalPrice:::${socketItem.mesghalPrice}");
            changePriceItem(socketItem);
            _fetchAccountSalesGroupForCurrentSelection();
          }
        } catch (e) {
          Get.log('Error processing socket message in OrderCreateController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in OrderCreateController: $error');
    });
  }

  void changePriceItem(SocketItemModel socketItem){
    for(int i=0 ; i<itemList.length ; i++){
      if(itemList[i].id==socketItem.id){
        itemList[i].baseMesghalPrice=socketItem.mesghalPrice;
        itemList[i].basePrice=socketItem.price;
        itemList[i].baseMesghalDifferentPrice = socketItem.mesghalDifferentPrice;
        itemList[i].baseDifferentPrice = socketItem.differentPrice;

        if(selectedItem.value?.id == socketItem.id) {
          _updateSocketPriceFromCurrent();
        }
      }
    }
    /*if(selectedItem.value!=null){
      if(selectedItem.value?.id==socketItem.id && manualPriceChecked.value==false){
        selectedItem.value?.mesghalPrice=socketItem.mesghalPrice;
        if(selectedBuySell.value?.id==0 && manualPriceChecked.value==false){
          priceController.text=socketItem.mesghalPrice.toString().seRagham(separator: ',');
          priceTemp.value=socketItem.price.toString().seRagham(separator: ',');

        }else if(selectedBuySell.value?.id==1 && manualPriceChecked.value==false){
          priceController.text=((socketItem.mesghalPrice?.toDouble() ?? 0)-(socketItem.mesghalDifferentPrice?.toDouble() ?? 0)).toString().seRagham(separator: ',');
          priceTemp.value=(((socketItem.price!)-(socketItem.differentPrice!)).toDouble()).toString().seRagham(separator: ',');

        }
      }
    }*/
    update();
  }

  Future<void> changeSelectedAccount(AccountModel? newValue) async {
    selectedAccount.value = newValue;
    selectedItem.value = null;
    selectedAccountLevelItem.value = null;
    itemList.clear();
    isLoadingItems.value = true;
    getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
    // Load items filtered by selected account
    if(newValue?.id != null){
      await fetchItemList(accountId: newValue!.id);
      await _fetchAccountLevelForCurrentSelection();
      await _fetchAccountSalesGroupForCurrentSelection();
    }
  }


  void updateTotalPrice(){
    if(selectedItem.value?.itemUnit?.name=='گرم'){
      double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit())!/4.3318;
      double quantity=double.tryParse(quantityController.text==""? "0" :quantityController.text.toEnglishDigit()) ?? 0;
      double totalPrice= price * quantity;
      totalPriceController.text=totalPrice.toStringAsFixed(0).toPersianDigit().seRagham();
      priceTemp.value=price.toString();
    }
    else{
      double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit())!;
      double quantity=double.tryParse(quantityController.text==""? "0" :quantityController.text.toEnglishDigit()) ?? 0;
      double totalPrice= price * quantity;
      totalPriceController.text=totalPrice.toStringAsFixed(0).toPersianDigit().seRagham();
      priceTemp.value=price.toString();
    }
    // به‌روزرسانی قیمت فعلی برای مقایسه
    currentPrice.value = priceController.text;

    _updateSocketPriceFromCurrent();
  }

  void _updateSocketPriceFromCurrent() {
    if (selectedItem.value != null) {
      // جستجو در لیست محصولات برای یافتن قیمت فعلی سوکت
      for (var item in itemList) {
        if (item.id == selectedItem.value?.id) {
          if (selectedItem.value?.itemUnit?.name == 'گرم') {
            if (selectedBuySell.value?.id == 0) {
              socketPrice.value = item.baseMesghalPrice.toString().seRagham(separator: ',');
            } else if (selectedBuySell.value?.id == 1) {
              socketPrice.value = (((item.baseMesghalPrice ?? 0) - (item.baseMesghalDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
            } else {
              socketPrice.value = item.baseMesghalPrice.toString().seRagham(separator: ',');
            }
          } else {
            if (selectedBuySell.value?.id == 0) {
              socketPrice.value = item.basePrice.toString().seRagham(separator: ',');
            } else if (selectedBuySell.value?.id == 1) {
              socketPrice.value = (((item.basePrice ?? 0) - (item.baseDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
            } else {
              socketPrice.value = item.basePrice.toString().seRagham(separator: ',');
            }
          }
          break;
        }
      }
    }
  }
  
  void updateQuantity(){
    if(selectedItem.value?.itemUnit?.name=='گرم'){
      double totalPrice=double.tryParse(totalPriceController.text ==""?"0" : totalPriceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
      double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
      double mesghal=totalPrice / price; // مثقال
      double quantity=mesghal*4.3318;
      quantityController.text=quantity.toStringAsFixed(2);
    }else{
      double totalPrice=double.tryParse(totalPriceController.text ==""?"0" : totalPriceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
      double price=double.tryParse(priceController.text ==""?"0" : priceController.text.replaceAll(',', '').toEnglishDigit()) ?? 0;
      double quantity=totalPrice / price;
      quantityController.text=quantity.toStringAsFixed(2);
    }
  }

  @override
  void onInit() {
    socketSubscription?.cancel();
    _listenToSocket();
    fetchAccountList();
    orderTypeList.addAll([
      OrderTypeModel(id:null, name: 'انتخاب کنید'),
      OrderTypeModel(id:0,name: 'فروش به کاربر'),
      OrderTypeModel(id:1,name: 'خرید از کاربر'),
    ]);
    searchController.addListener(onSearchChanged);
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    super.onInit();
  }

  void onDropdownMenuStateChange(bool isOpen) {
    if (isOpen) {
      // Add a small delay to ensure the dropdown is fully opened
      Future.delayed(const Duration(milliseconds: 100), () {
        searchFocusNode.requestFocus();
      });
    } else {
      resetAccountSearch();
    }
  }

  @override
  void onClose() {
    debounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    socketSubscription?.cancel();
    super.onClose();
  }

  // لیست محصولات
  Future<void> fetchItemList({int? accountId}) async{
    isLoadingItems.value=true;
    if(accountId==null){
      // Without account we don't fetch items
      itemList.clear();
      isLoadingItems.value=false;
      return;
    }
    try{
      state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList(accountId: accountId.toString());
      itemList.assignAll(fetchedItemList);
      itemList.removeWhere((e) => e.status==false,);
      state.value=PageState.list;
      if(itemList.isEmpty){
        state.value=PageState.empty;
      }
      print("itemList$itemList");
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
      showError('خطا در بارگذاری محصولات', 'خطایی هنگام بارگذاری محصولات به وجود آمده است: ');
    }finally{
      isLoading.value=false;
      isLoadingItems.value=false;
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
      var fetchedAccountList=await accountRepository.getAccountList("");
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
      showError('خطا در بارگذاری کاربران', 'خطایی هنگام بارگذاری کاربران به وجود آمده است: ');
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
        final results = await accountRepository.searchAccountList(name,"");
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
      if (Get.isDialogOpen!) Get.back();
      var response = await orderRepository.insertOrder(
        date: gregorianDate,
        accountId: selectedAccount.value?.id ?? 0,
        accountName: selectedAccount.value?.name ?? "",
        type: selectedBuySell.value?.id ?? 0,
        itemId: selectedItem.value?.id ?? 0,
        itemName: selectedItem.value?.name ?? "",
        price: double.parse(priceTemp.value.replaceAll(',', '').toEnglishDigit()),
        quantity: double.tryParse(quantityController.text.toEnglishDigit()) ?? 0.0,
        description: descriptionController.text,
        notLimit:true,
        manualPrice:true,
        isCard: isCardChecked.value,
      );
      print(response);
      if (response != null) {
        OrderModel orderResponse=OrderModel.fromJson(response);
        /*Get.snackbar(orderResponse.infos!.first['title'], orderResponse.infos!.first["description"],
            titleText: Text(orderResponse.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                orderResponse.infos!.first["description"] , textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        orderController.getOrderListPager();
        orderController.fetchTotalBalanceList();
        balanceList.clear();
        clearList();*/
        // Check if there are any errors in the response
        if (orderResponse.infos != null && orderResponse.infos!.isNotEmpty) {
          var firstInfo = orderResponse.infos!.first;
          String title = firstInfo['title'] ?? 'خطا';
          String description = firstInfo['description'] ?? 'خطای نامشخص';
          Get.snackbar(title, description,
              titleText: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                  description , textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor)));
          // Check if this is an error (you might need to adjust this condition based on your API response structure)
          if (title.toLowerCase().contains('خطا') || title.toLowerCase().contains('error') ||
              description.toLowerCase().contains('خطا') || description.toLowerCase().contains('error')) {
            showError(title, description);
          } else {
            // Success message - show snackbar and clear form
            Get.snackbar(title, description,
                titleText: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor),),
                messageText: Text(
                    description , textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.textColor)));
            /*orderController.getOrderListPager();
            orderController.fetchTotalBalanceList();*/
            // Use silent refresh to update list without UI flicker
            orderController.refreshOrderListSilently();
            orderController.refreshTotalBalanceSilently();
            balanceList.clear();
            clearList();
            clearError(); // Clear any previous errors
          }
        } else {
          // No info in response, assume success
          /*orderController.getOrderListPager();
          orderController.fetchTotalBalanceList();*/
          // Use silent refresh to update list without UI flicker
          orderController.refreshOrderListSilently();
          orderController.refreshTotalBalanceSilently();
          balanceList.clear();
          clearList();
          clearError();
        }
      }
    }
    catch(e){
      showError('خطا در ایجاد سفارش', 'خطا: ');
      print('خطا:$e');
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

  Future<void> _fetchAccountLevelForCurrentSelection() async {
    final accountId = selectedAccount.value?.id;
    final itemId = selectedItem.value?.id;
    if (accountId == null || itemId == null) {
      selectedAccountLevelItem.value = null;
      return;
    }
    try {
      isLoadingAccountLevelItem.value = true;
      final result = await accountRepository.accountLevelGetOneItem(
        accountId: accountId,
        itemId: itemId,
      );
      selectedAccountLevelItem.value = result;
    } catch (_) {
      selectedAccountLevelItem.value = null;
    } finally {
      isLoadingAccountLevelItem.value = false;
    }
  }

  Future<void> _fetchAccountSalesGroupForCurrentSelection() async {
    final accountId = selectedAccount.value?.id;
    final itemId = selectedItem.value?.id;
    if (accountId == null || itemId == null) {
      selectedAccountSalesGroupItem.value = null;
      return;
    }
    try {
      isLoadingAccountSalesGroupItem.value = true;
      final result = await accountSalesGroupRepository.accountSalesGroupGetOneItem(
        accountId: accountId,
        itemId: itemId,
      );
      selectedAccountSalesGroupItem.value = result;
    } catch (_) {
      selectedAccountSalesGroupItem.value = null;
    } finally {
      isLoadingAccountSalesGroupItem.value = false;
    }
  }

   void clearList() {
    //dateController.clear();
     var now = Jalali.now();
     DateTime date=DateTime.now();
     dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    priceController.clear();
    quantityController.clear();
    descriptionController.clear();
    totalPriceController.clear();
    selectedBuySell.value=null;
    selectedItem.value=null;
    selectedAccount.value=null;
    selectedAccountLevelItem.value = null;
     selectedAccountSalesGroupItem.value = null;
    itemList.clear();
    socketPrice.value="";
    currentPrice.value="";
    //manualPriceChecked.value=false;
    //notLimitChecked.value=false;
    isCardChecked.value=false;
    clearError();
  }
  void clearListChangeItem() {
    priceController.clear();
    quantityController.clear();
    descriptionController.clear();
    totalPriceController.clear();
    selectedItem.value=null;
    //manualPriceChecked.value=false;
    //notLimitChecked.value=false;
    isCardChecked.value=false;
    selectedAccountLevelItem.value = null;
    selectedAccountSalesGroupItem.value = null;
  }

  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
  // Error handling methods
  void showError(String title, String message) {
    hasError.value = true;
    errorTitle.value = title;
    errorMessage.value = message;
  }

  void clearError() {
    hasError.value = false;
    errorTitle.value = '';
    errorMessage.value = '';
  }

  // Set price from sales group
  void setPriceFromSalesGroup(double mesghalPrice) {
    priceController.text = mesghalPrice.toStringAsFixed(0).toPersianDigit().seRagham(separator: ',');
    currentPrice.value = priceController.text;
    updateTotalPrice();
  }

  // دریافت قیمت از socket
  Future<void> fetchPriceFromSocket() async {
    if (selectedItem.value != null) {
      // جستجو در لیست محصولات برای یافتن قیمت به‌روز
      for (var item in itemList) {
        if (item.id == selectedItem.value?.id) {
          if (selectedItem.value?.itemUnit?.name == 'گرم') {
            if (selectedBuySell.value?.id == 0) {
              socketPrice.value = item.baseMesghalPrice.toString().seRagham(separator: ',');
              priceController.text = item.baseMesghalPrice.toString().seRagham(separator: ',');
              priceTemp.value = item.basePrice.toString().seRagham(separator: ',');
            } else if (selectedBuySell.value?.id == 1) {
              socketPrice.value = (((item.baseMesghalPrice ?? 0) - (item.baseMesghalDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
              priceController.text = (((item.baseMesghalPrice ?? 0) - (item.baseMesghalDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
              priceTemp.value = (((item.basePrice ?? 0) - (item.baseDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
            }
          } else {
            if (selectedBuySell.value?.id == 0) {
              socketPrice.value = item.basePrice.toString().seRagham(separator: ',');
              priceController.text = item.basePrice.toString().seRagham(separator: ',');
              priceTemp.value = item.basePrice.toString().seRagham(separator: ',');
            } else if (selectedBuySell.value?.id == 1) {
              socketPrice.value = (((item.basePrice ?? 0) - (item.baseDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
              priceController.text = (((item.basePrice ?? 0) - (item.baseDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
              priceTemp.value = (((item.basePrice ?? 0) - (item.baseDifferentPrice ?? 0)).toDouble()).toString().seRagham(separator: ',');
            }
          }
          updateTotalPrice();
          break;
        }
      }
    }
  }


}
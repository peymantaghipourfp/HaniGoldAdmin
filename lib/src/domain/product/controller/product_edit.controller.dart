

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/domain/product/model/socket_item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/item.repository.dart';
import '../model/item.model.dart';


enum PageState{loading,err,empty,list}
class ProductEditController extends GetxController{

  final TextEditingController itemNameController=TextEditingController();
  final TextEditingController itemGroupNameController=TextEditingController();
  final TextEditingController itemUnitNameController=TextEditingController();
  final TextEditingController w750Controller=TextEditingController();
  final TextEditingController initBalanceController=TextEditingController();
  final TextEditingController wageController=TextEditingController();
  final TextEditingController cardPriceController=TextEditingController();

  final TextEditingController priceController=TextEditingController();
  final TextEditingController differentPriceController=TextEditingController();

  ScrollController scrollController = ScrollController();

  final ItemRepository itemRepository=ItemRepository();

  final List<ItemModel> itemList=<ItemModel>[].obs;
  final RxList<ItemModel> activeItemList=<ItemModel>[].obs;
  final RxList<ItemModel> inactiveItemList=<ItemModel>[].obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=false.obs;
  bool isLoadingActive=false;
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  final Rxn<ItemModel> getOneItem = Rxn<ItemModel>();
  var buySellSwitch = false.obs;
  var sellStateSwitch = false.obs;
  var buyStateSwitch = false.obs;
  var hasWageSwitch = false.obs;
  var hasCardSwitch = false.obs;
  var isDecimalSwitch = false.obs;
  var showMarketSwitch = false.obs;
  var itemId=0.obs;
  //var hasRefrenceSwitch = false.obs;
  final Rxn<int> selectedRefrenceId = Rxn<int>();
  final RxList<ItemModel> refrenceList = <ItemModel>[].obs;


  /*static bool isSocketListening = false;
  final SocketService socketService = Get.find();
  StreamSubscription? socketSubscription;*/
  /*final WebSocketRepository webSocketRepository=WebSocketRepository();
  final RxString _status = 'disconnected'.obs;
  final RxList<String> _messages = <String>[].obs;
  final RxString _error = ''.obs;
  String? _url; // ذخیره URL برای reconnect
  // Getterها
  String get status => _status.value;
  List<String> get messages => _messages;
  String get error => _error.value;*/

  @override
  void onInit()async{
    //connect(WebSocketUrl.webSocketUrl);
    //socketSubscription?.cancel();
    //_listenToSocket();
    /*fetchActiveItemList();
    fetchInactiveItemList();*/
    itemId.value=int.parse(Get.parameters['id']!);
    await fetchGetOneItem(itemId.value);
    await fetchItems();
    /*if(getOneItem.value!=null) {
      itemController.text = getOneItem.value!.name!;
    }*/
    super.onInit();
  }

  void initSwitches(ItemModel item) {
    buySellSwitch.value = item.status ?? false;
    sellStateSwitch.value = item.sellStatus ?? false;
    buyStateSwitch.value = item.buyStatus ?? false;
    hasWageSwitch.value = item.hasWage ?? false;
    hasCardSwitch.value = item.hasCard ?? false;
    isDecimalSwitch.value = item.isDecimal ?? false;
    showMarketSwitch.value = item.showMarket ?? false;
    //hasRefrenceSwitch.value = item.refrence != null;
    /*if (item.refrence != null) {
      selectedRefrenceId.value = item.refrence!.id;
    }*/
  }

  bool getSwitchValue(String label) {
    switch (label) {
      case 'قابل خرید و فروش کاربر':
        return buySellSwitch.value;
      case 'وضعیت فروش':
        return sellStateSwitch.value;
      case 'وضعیت خرید':
        return buyStateSwitch.value;
      case 'وضعیت اجرت':
        return hasWageSwitch.value;
      case 'وضعیت کارتخوان':
        return hasCardSwitch.value;
      case 'اعشار پذیر':
        return isDecimalSwitch.value;
      case 'نمایش به مشتری':
        return showMarketSwitch.value;
      /*case 'مرجع دارد':
        return hasRefrenceSwitch.value;*/
      default:
        return false;
    }
  }


  /*void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;

    if (newValue != null && newValue.id != null) {

      fetchGetOneItem(newValue.id!);
    }
  }*/

  /*void _listenToSocket() {
    if (isSocketListening) {
      print('Socket already listening, skipping duplicate subscription.');
      return;
    }
    isSocketListening = true;
    socketSubscription?.cancel();
    socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'itemPrice') {
            final socketItem = SocketItemModel.fromJson(data);
            *//*Get.snackbar('تغییر قیمت', 'قیمت ${socketItem.name} تغییر کرد.',
              titleText: Text('تغییر قیمت',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                'قیمت ${socketItem.name} تغییر کرد.', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
            );*//*
            fetchGetOneItem(itemId.value);
          }
        } catch (e) {
          Get.log('Error processing socket message in ProductController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in ProductController: $error');
    });
  }*/

  // لیست محصولات برای رفرنس
  Future<void> fetchItems() async {
    try {
      state.value = PageState.loading;
      var fetchedItems = await itemRepository.getItemList();
      refrenceList.assignAll(fetchedItems);
      state.value = PageState.list;
    } catch (e) {
      state.value = PageState.err;
      errorMessage.value = " خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }
  // لیست محصولات
  Future<List<ItemModel>> fetchActiveItemList() async{
    try{
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      activeItemList.assignAll(
        fetchedItemList.where((item) => item.status == true).toList(),
      );
      state.value=PageState.list;
      //EasyLoading.dismiss();
      if(itemList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
      return activeItemList;
    }
  }
  Future<List<ItemModel>> fetchInactiveItemList() async{
    try{
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      inactiveItemList.assignAll(
        fetchedItemList.where((item) => item.status == false).toList(),
      );
      state.value=PageState.list;
      //EasyLoading.dismiss();
      if(itemList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
      return inactiveItemList;
    }
  }

  Future<bool> insertPriceItem(int id, double price, double different,int itemUnitId,{bool showSnackbar = true} )async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await itemRepository.insertPriceItem(
          itemId: id ,
          price: price,
          differentPrice: different,
          itemUnitId: itemUnitId
      );
      print(response);
      if (response != null) {
        if (showSnackbar){
          Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
              titleText: Text('موفقیت آمیز',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                  'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor)));
        }
        activeItemList.clear();
        clearList();
        fetchActiveItemList();
        fetchInactiveItemList();
      }
      return false;
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
  }

  Future<bool> insertDifferentPriceItem(int id, double different, double price,int itemUnitId,{bool showSnackbar = true} )async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await itemRepository.insertDifferentPriceItem(
          itemId: id ,
          differentPrice: different,
          price: price,
          itemUnitId: itemUnitId
      );
      print(response);
      if (response != null) {
        if(showSnackbar){
          Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
              titleText: Text('موفقیت آمیز',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                  'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor)));
        }
        activeItemList.clear();
        clearList();
        fetchActiveItemList();
        fetchInactiveItemList();
      }
      return false;
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
  }

  Future<void> updateStatusItem(int id,bool status,bool sellStatus,bool buyStatus) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await itemRepository.updateStatusItem(
        id: id,
        status: status,
        sellStatus:sellStatus,
        buyStatus:buyStatus,
      );
      fetchActiveItemList();
      fetchInactiveItemList();
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

      update();
    } catch (e) {
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> updateItemRange(int id,int maxSell,int maxBuy, double salesRange, double buyRange,{bool showSnackbar = true} )async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await itemRepository.updateItemRange(
        itemId: id,
        maxSell: maxSell,
        maxBuy: maxBuy,
        salesRange: salesRange,
        buyRange: buyRange ,
      );
      print(response);
      if (response != null) {
        if(showSnackbar){
          Get.snackbar("موفقیت آمیز", "آپدیت با موفقیت آنجام شد",
              titleText: Text('موفقیت آمیز',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                  'آپدیت با موفقیت آنجام شد', textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor)));
        }
        activeItemList.clear();
        clearList();
        fetchActiveItemList();
      }
      return false;
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
  }

  Future<ItemModel?> fetchGetOneItem(int id)async{
    try {
      state.value=PageState.loading;
      var fetchedGetOne = await itemRepository.getOneItem(id);
      getOneItem.value = fetchedGetOne;
      itemNameController.text=getOneItem.value?.name ?? "";
      itemGroupNameController.text=getOneItem.value?.itemGroup?.name ?? '';
      itemUnitNameController.text=getOneItem.value?.itemUnit?.name ?? "";
      wageController.text=getOneItem.value?.wage?.toStringAsFixed(0).seRagham(separator: ',') ?? '';
      cardPriceController.text="${getOneItem.value?.cardPrice ?? 0}";
      initBalanceController.text="${getOneItem.value?.initBalance ?? 0}";
      w750Controller.text="${getOneItem.value?.w750 ?? 0}";
      initSwitches(fetchedGetOne);
      state.value=PageState.list;
      state.value=PageState.empty;
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }return null;
  }

  Future<ItemModel?> updateItem() async {

    if(itemId.value==0){
      return null;
    }
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoading.value = true;

      var response = await itemRepository.updateItem(
          itemId: itemId.value,
          itemName: itemNameController.text,
          //itemGroupId: itemGroupId,
          itemGroupName: itemGroupNameController.text,
          //itemUnitId: itemUnitId,
          itemUnitName: itemUnitNameController.text,
          isDecimal: isDecimalSwitch.value,
          status: buySellSwitch.value,
          showMarket: showMarketSwitch.value,
          sellStatus: sellStateSwitch.value,
          buyStatus: buyStateSwitch.value,
          hasWage: hasWageSwitch.value,
          wage: double.parse(wageController.text.replaceAll(',', '').toEnglishDigit()),
          hasCard: hasCardSwitch.value,
          cardPrice: double.parse(cardPriceController.text.replaceAll(',', '').toEnglishDigit()),
          initBalance: double.parse(initBalanceController.text),
          w750: double.parse(w750Controller.text),
          //refrenceId: hasRefrenceSwitch.value ? selectedRefrenceId.value : null,
      );

      if(response!= null){
        ItemModel itemResponse=ItemModel.fromJson(response);
        //Get.back();
        Get.snackbar(itemResponse.infos!.first['title'], itemResponse.infos!.first["description"],
            titleText: Text(itemResponse.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(itemResponse.infos!.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchGetOneItem(itemId.value);
        fetchActiveItemList();
        fetchInactiveItemList();
      }

    } catch (e) {
      EasyLoading.dismiss();
      throw ErrorException('خطا در به‌روزرسانی محصول: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }

  void clearList() {
    priceController.clear();
    differentPriceController.clear();
    selectedItem.value=null;

  }

  /*@override
  void onClose() {
    socketSubscription?.cancel();
    isSocketListening = false;
    super.onClose();
  }*/

}
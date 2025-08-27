

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/config/repository/web_socket.repository.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_edit.controller.dart';
import 'package:hanigold_admin/src/domain/product/model/socket_item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/url/web_socket_url.dart';
import '../model/item.model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../base/base_controller.dart';

enum PageState{loading,err,empty,list}
class ProductController extends BaseController{

  //ProductEditController productEditController = Get.find<ProductEditController>();

  final TextEditingController priceController1=TextEditingController();
  final TextEditingController priceController2=TextEditingController();
  final TextEditingController priceController3=TextEditingController();
  final TextEditingController priceController4=TextEditingController();
  final TextEditingController differentPriceController1=TextEditingController();
  final TextEditingController differentPriceController2=TextEditingController();
  final TextEditingController differentPriceController3=TextEditingController();
  final TextEditingController priceController=TextEditingController();
  final TextEditingController differentPriceController=TextEditingController();
  //final TextEditingController itemController=TextEditingController();
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
  ItemModel? getOneItem ;


  //SocketService socketService = Get.find<SocketService>();
  StreamSubscription? socketSubscription;
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
  void onInit(){
    //connect(WebSocketUrl.webSocketUrl);
    socketSubscription?.cancel();
    _listenToSocket();
    fetchActiveItemList();
    fetchInactiveItemList();
    /*if(getOneItem.value!=null) {
      itemController.text = getOneItem.value!.name!;
    }*/
    super.onInit();
  }


  /*void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;

    if (newValue != null && newValue.id != null) {

      productEditController.fetchGetOneItem(newValue.id!);
    }
  }*/

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
            // Update the specific item in activeItemList
            final activeIndex = activeItemList.indexWhere((item) => item.id == socketItem.id);
            if (activeIndex != -1) {
              activeItemList[activeIndex].price = socketItem.price;
              activeItemList[activeIndex].differentPrice = socketItem.differentPrice;
              activeItemList[activeIndex].mesghalPrice = socketItem.mesghalPrice;
              activeItemList[activeIndex].mesghalDifferentPrice = socketItem.mesghalDifferentPrice;
              activeItemList.refresh();
            }

            // Update the specific item in inactiveItemList
            final inactiveIndex = inactiveItemList.indexWhere((item) => item.id == socketItem.id);
            if (inactiveIndex != -1) {
              inactiveItemList[inactiveIndex].price = socketItem.price;
              inactiveItemList[inactiveIndex].differentPrice = socketItem.differentPrice;
              inactiveItemList[inactiveIndex].mesghalPrice = socketItem.mesghalPrice;
              inactiveItemList[inactiveIndex].mesghalDifferentPrice = socketItem.mesghalDifferentPrice;
              inactiveItemList.refresh();
            }
          }
        } catch (e) {
          Get.log('Error processing socket message in ProductController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in ProductController: $error');
    });
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
        if(showSnackbar){
          Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
              titleText: Text('موفقیت آمیز',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                  'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textColor)));
        }
        //activeItemList.clear();
        // Update the specific item in activeItemList
        final activeIndex = activeItemList.indexWhere((item) => item.id == id);
        if (activeIndex != -1) {
          /*activeItemList[activeIndex].price = price;
          activeItemList[activeIndex].differentPrice = different;*/
          activeItemList[activeIndex].mesghalPrice = price;
          activeItemList[activeIndex].mesghalDifferentPrice = different;
          activeItemList.refresh();
        }

        // Update the specific item in inactiveItemList
        final inactiveIndex = inactiveItemList.indexWhere((item) => item.id == id);
        if (inactiveIndex != -1) {
          /*inactiveItemList[inactiveIndex].price = price;
          inactiveItemList[inactiveIndex].differentPrice = different;*/
          inactiveItemList[inactiveIndex].mesghalPrice = price;
          inactiveItemList[inactiveIndex].mesghalDifferentPrice = different;
          inactiveItemList.refresh();
        }
        clearList();
        //fetchActiveItemList();
        //fetchInactiveItemList();
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
    EasyLoading.show(status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await itemRepository.updateStatusItem(
        id: id,
        status: status,
        sellStatus: sellStatus,
        buyStatus: buyStatus,
      );
      //fetchActiveItemList();
      //fetchInactiveItemList();
      // Update the specific item in activeItemList
      final activeIndex = activeItemList.indexWhere((item) => item.id == id);
      final inactiveIndex = inactiveItemList.indexWhere((item) => item.id == id);

      ItemModel? itemToMove;

      if (activeIndex != -1) {
        // Item is currently in active list
        itemToMove = activeItemList[activeIndex];
        itemToMove.status = status;
        itemToMove.sellStatus = sellStatus;
        itemToMove.buyStatus = buyStatus;

        if (!status) {
          // Item is being deactivated, move from active to inactive
          activeItemList.removeAt(activeIndex);
          inactiveItemList.add(itemToMove);
        }
      } else if (inactiveIndex != -1) {
        // Item is currently in inactive list
        itemToMove = inactiveItemList[inactiveIndex];
        itemToMove.status = status;
        itemToMove.sellStatus = sellStatus;
        itemToMove.buyStatus = buyStatus;

        if (status) {
          // Item is being activated, move from inactive to active
          inactiveItemList.removeAt(inactiveIndex);
          activeItemList.add(itemToMove);
        }
      }

      // Refresh both lists to update the UI
      activeItemList.refresh();
      inactiveItemList.refresh();
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

  void clearList() {
    priceController.clear();
    differentPriceController.clear();
    selectedItem.value=null;

  }

  @override
  void onClose() {
    socketSubscription?.cancel();
    super.onClose();
  }

  /*Future<ItemModel?> fetchGetOneItem(int id)async{
    try {
      state.value=PageState.loading;
      var fetchedGetOne = await itemRepository.getOneItem(id);

      if (fetchedGetOne != null) {
        getOneItem = fetchedGetOne;
      }
      state.value=PageState.list;
      state.value=PageState.empty;
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }return null;
  }*/

  /*Future<bool> insertDifferentPriceItem(int id, double different, double price,int itemUnitId,{bool showSnackbar = true} )async{
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
  }*/

  /*Future<bool> updateItemRange(int id,int maxSell,int maxBuy, double salesRange, double buyRange,{bool showSnackbar = true} )async{
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
  }*/

  //--------- اتصال به سوکت
  /*Future<void> connect(String url) async {
    try {
      _url = url; // ذخیره URL برای reconnect
      _status.value = 'connecting';
      _error.value = '';

      final channel = webSocketRepository.connect(url);

      webSocketRepository.listen(
            (data) => _handleData(data),
        onError: (err) => _handleError(err),
        onDone: () => _handleDone(),
      );

      _status.value = 'connected';
    } catch (e) {
      _handleError(e);
    }
  }*/

  /*void _handleData(dynamic data) {
    print("webSocket:::::::::::::::${data}");
    if (data is String) {
      try {
        final decodedData = jsonDecode(data);
        final updatedItem = SocketItemModel.fromJson(decodedData);

        activeItemList.assignAll(
          itemList.where((item) => item.status == true).toList(),
        );
        inactiveItemList.assignAll(
          itemList.where((item) => item.status == false).toList(),
        );

        Get.snackbar('تغییر قیمت', 'قیمت ${updatedItem.name} تغییر کرد.',
          titleText: Text('تغییر قیمت',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(
            'قیمت ${updatedItem.name} تغییر کرد.', textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
        );
      } catch (e) {
        _messages.add('دریافت پیام غیر مرتبط: $data');
      }
      fetchActiveItemList();
      fetchInactiveItemList();
    }
  }*/

  /*void _handleError(dynamic err) {
    _error.value = 'Error: ${err.toString()}';
    _status.value = 'error';
    _reconnect();
  }*/

  /*void _handleDone() {
    _status.value = 'disconnected';
    _reconnect();
  }*/

  // ارسال پیام
  /*void sendMessage(String message) {
    if (status == 'connected') {
      webSocketRepository.sendMessage(message);
    }
  }*/

  // اتصال مجدد خودکار
  /*void _reconnect() {
    if (_status.value != 'connecting' && _url != null) {
      _status.value = 'reconnecting';
      Future.delayed(const Duration(seconds: 3), () => connect(_url!));
    }
  }*/

  // قطع اتصال
  /*void disconnect() {
    webSocketRepository.disconnect();
    _status.value = 'disconnected';
  }*/

  // پاکسازی منابع
  /*@override
  void onClose() {
    disconnect();
    super.onClose();
  }*/

}
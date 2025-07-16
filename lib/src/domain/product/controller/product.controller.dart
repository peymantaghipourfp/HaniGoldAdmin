

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/config/repository/web_socket.repository.dart';
import 'package:hanigold_admin/src/domain/product/model/socket_item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/url/web_socket_url.dart';
import '../model/item.model.dart';

enum PageState{loading,err,empty,list}
class ProductController extends GetxController{

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
  final Rxn<ItemModel> getOneItem = Rxn<ItemModel>();


  final SocketService socketService = Get.find();
  StreamSubscription? _socketSubscription;
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
  void onInit() {
    //connect(WebSocketUrl.webSocketUrl);
    _listenToSocket();
    fetchActiveItemList();
    fetchInactiveItemList();
    /*if(getOneItem.value!=null) {
      itemController.text = getOneItem.value!.name!;
    }*/
    super.onInit();
  }


  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;

    if (newValue != null && newValue.id != null) {

      fetchGetOneItem(newValue.id!);
    }
  }

  void _listenToSocket() {
    _socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'itemPrice') {
            fetchActiveItemList();
            fetchInactiveItemList();
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

  Future<bool> insertPriceItem(int id, double price, double different,int itemUnitId )async{
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
        Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
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

  Future<bool> insertDifferentPriceItem(int id, double different, double price,int itemUnitId )async{
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
        Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
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

  Future<void> updateStatusItem(int id,bool status) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await itemRepository.updateStatusItem(
        id: id, status: status,
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

  Future<bool> updateItemRange(int id,int maxSell,int maxBuy, double salesRange, double buyRange )async{
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
        Get.snackbar("موفقیت آمیز", "آپدیت با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'آپدیت با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
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

  void clearList() {
    priceController.clear();
    differentPriceController.clear();
    selectedItem.value=null;

  }

  @override
  void onClose() {
    _socketSubscription?.cancel();
    super.onClose();
  }

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
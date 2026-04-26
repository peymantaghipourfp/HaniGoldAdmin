

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// Conditional import for BroadcastChannel
import 'broadcast_channel_stub.dart'
if (dart.library.html) 'broadcast_channel_web.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/model/socket_item.model.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/item.repository.dart';
import '../model/item.model.dart';
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
  RxBool isRefreshing = false.obs;
  RxInt refreshCounter = 0.obs;
  BroadcastChannelHandler? _broadcastChannelHandler;
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
    _setupSocketReconnectionHandler();
    _setupBroadcastChannel();
    fetchActiveItemList();
    fetchInactiveItemList();
    /*if(getOneItem.value!=null) {
      itemController.text = getOneItem.value!.name!;
    }*/
    super.onInit();
  }

  // Setup BroadcastChannel for cross-tab status change notifications (Web only)
  void _setupBroadcastChannel() {
    _broadcastChannelHandler = BroadcastChannelHandler();
    _broadcastChannelHandler!.setup('product_status_changes', (data) {
      if (data['type'] == 'statusChanged') {
        // Refresh lists to sync with server
        refreshItemListsSilently();
      }
    });
  }

  // Notify other tabs about status changes
  void _notifyOtherTabsOfStatusChange() {
    try {
      if (_broadcastChannelHandler != null) {
        _broadcastChannelHandler!.sendMessage('product_status_changes', {
          'type': 'statusChanged',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      Get.log('Error sending broadcast message: $e');
    }
  }

  void _setupSocketReconnectionHandler() {
    ever(isSocketConnected, (bool connected) {
      if (connected) {
        _listenToSocket();
      }
    });
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
        try {
          Map<String, dynamic>? data;
          if (message is String) {
            data = json.decode(message);
          } else if (message is Map) {
            data = Map<String, dynamic>.from(message);
          }
          if (data != null && data['channel'] == 'itemPrice') {
            final socketItem = SocketItemModel.fromJson(data);
            /*Get.snackbar('تغییر قیمت', 'قیمت ${socketItem.name} تغییر کرد.',
              titleText: Text('تغییر قیمت',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                'قیمت ${socketItem.name} تغییر کرد.', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
            );*/
            /*
            fetchActiveItemList();
            fetchInactiveItemList();*/
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
            // Show price change notification
            /*Get.snackbar(
              'تغییر قیمت',
              'قیمت ${socketItem.Name ?? 'محصول'} تغییر کرد.',
              titleText: Text(
                'تغییر قیمت',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),
              ),
              messageText: Text(
                'قیمت ${socketItem.Name ?? 'محصول'} تغییر کرد.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),
              ),
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 3),
            );*/
            refreshItemListsSilently();
          }
          else if (data != null && (data['channel'] == 'item' || data['channel'] == 'itemStatus')) {
            // Perform full refresh to sync status changes across tabs
            refreshItemListsSilently();
          }
        } catch (e) {
          Get.log('Error processing socket message in ProductController: $e');
        }
    }, onError: (error) {
      Get.log('Socket stream error in ProductController: $error');
      Future.delayed(Duration(seconds: 2), () {
        if (socketService.isConnected) {
          _listenToSocket();
        }
      });
    });
  }

  @override
  void onClose() {
    socketSubscription?.cancel();
    _broadcastChannelHandler?.close();
    super.onClose();
  }

  // لیست محصولات
  Future<List<ItemModel>> fetchActiveItemList({bool showLoading = true}) async{
    try{
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      if (showLoading) {
        if (activeItemList.isEmpty) {
          state.value=PageState.loading;
        }
      }
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
      refreshCounter.value++;
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
      return activeItemList;
    }
  }

  Future<List<ItemModel>> fetchInactiveItemList({bool showLoading = true}) async{
    try{
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      if (showLoading) {
        if (inactiveItemList.isEmpty) {
          state.value=PageState.loading;
        }
      }
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

  // Silent refresh for socket updates - no loading state change
  Future<void> refreshActiveItemListSilently() async {
    isRefreshing.value = true;
    try {
      var fetchedItemList = await itemRepository.getItemList();

      // Update list without clearing first (prevents flicker)
      itemList.assignAll(fetchedItemList);
      activeItemList.assignAll(
        fetchedItemList.where((item) => item.status == true).toList(),
      );
      state.value = PageState.list;

      // Increment refresh counter to invalidate cached data
      refreshCounter.value++;

    } catch (e) {
      print('Error in silent active item refresh: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Silent refresh for inactive items - no loading state change
  Future<void> refreshInactiveItemListSilently() async {
    isRefreshing.value = true;
    try {
      var fetchedItemList = await itemRepository.getItemList();

      // Update list without clearing first (prevents flicker)
      itemList.assignAll(fetchedItemList);
      inactiveItemList.assignAll(
        fetchedItemList.where((item) => item.status == false).toList(),
      );
      state.value = PageState.list;

      // Increment refresh counter to invalidate cached data
      refreshCounter.value++;

    } catch (e) {
      print('Error in silent inactive item refresh: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Combined silent refresh for both lists - optimized single API call
  Future<void> refreshItemListsSilently() async {
    isRefreshing.value = true;
    try {
      var fetchedItemList = await itemRepository.getItemList();

      // Update list without clearing first (prevents flicker)
      itemList.assignAll(fetchedItemList);
      activeItemList.assignAll(
        fetchedItemList.where((item) => item.status == true).toList(),
      );
      inactiveItemList.assignAll(
        fetchedItemList.where((item) => item.status == false).toList(),
      );
      state.value = PageState.list;

      // Increment refresh counter to invalidate cached data
      refreshCounter.value++;

    } catch (e) {
      print('Error in silent item lists refresh: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<Map<String, dynamic>?> insertPriceItem(int id, double price, double different,int itemUnitId,{bool showSnackbar = true} )async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await itemRepository.insertPriceItem(
          itemId: id ,
          price: price,
          differentPrice: different,
          itemUnitId: itemUnitId
      );
      if (response != null) {
        Map<String, dynamic>? firstInfo;
        final infos = response['infos'];
        if (infos is List && infos.isNotEmpty) {
          final rawInfo = infos.first;
          if (rawInfo is Map<String, dynamic>) {
            firstInfo = rawInfo;
          }
        }

        final dynamic code = firstInfo != null ? firstInfo['code'] : null;
        final String title = (firstInfo != null && firstInfo['title'] != null)
            ? firstInfo['title'].toString()
            : 'موفقیت آمیز';
        final String description = (firstInfo != null && firstInfo['description'] != null)
            ? firstInfo['description'].toString()
            : 'درج با موفقیت انجام شد';

        // Only show snackbar for non-3006 codes here.
        // For code 3006 (validation error), UI widgets handle error display and value rollback.
        if (code != 3006 && showSnackbar) {
          Get.snackbar(
            title,
            description,
            titleText: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),
            ),
            messageText: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),
            ),
          );
        }
        //activeItemList.clear();
        if (code != 3006) {
          // Update the specific item in activeItemList
          final activeIndex = activeItemList.indexWhere((item) =>
          item.id == id);
          if (activeIndex != -1) {
            /*activeItemList[activeIndex].price = price;
          activeItemList[activeIndex].differentPrice = different;*/
            activeItemList[activeIndex].mesghalPrice = price;
            activeItemList[activeIndex].mesghalDifferentPrice = different;
            activeItemList.refresh();
          }

          // Update the specific item in inactiveItemList
          final inactiveIndex = inactiveItemList.indexWhere((item) =>
          item.id == id);
          if (inactiveIndex != -1) {
            /*inactiveItemList[inactiveIndex].price = price;
          inactiveItemList[inactiveIndex].differentPrice = different;*/
            inactiveItemList[inactiveIndex].mesghalPrice = price;
            inactiveItemList[inactiveIndex].mesghalDifferentPrice = different;
            inactiveItemList.refresh();
          }
        }
        clearList();
        //fetchActiveItemList();
        //fetchInactiveItemList();
      }
      return response;
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

      // Refresh lists silently to ensure data is in sync with server for current tab
      refreshItemListsSilently();
      // Notify other tabs via BroadcastChannel to trigger their refresh
      _notifyOtherTabsOfStatusChange();
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
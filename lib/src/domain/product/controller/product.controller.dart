

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/item.repository.dart';
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

  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;

    if (newValue != null && newValue.id != null) {

      fetchGetOneItem(newValue.id!);
    }
  }

  @override
  void onInit() {
    fetchActiveItemList();
    /*if(getOneItem.value!=null) {
      itemController.text = getOneItem.value!.name!;
    }*/
    super.onInit();
  }

  // لیست محصولات
  Future<List<ItemModel>> fetchActiveItemList() async{
    try{
      state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      activeItemList.assignAll(
        fetchedItemList.where((item) => item.status == true).toList(),
      );
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
      return activeItemList;
    }
  }
  Future<List<ItemModel>> fetchInactiveItemList() async{
    try{
      state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      inactiveItemList.assignAll(
        fetchedItemList.where((item) => item.status == false).toList(),
      );
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

  Future<bool> insertPriceItem(int id, double price, double different )async{
    try{
      isLoading.value = true;
      var response=await itemRepository.insertPriceItem(
          itemId: id ,
          price: price,
        differentPrice: different,
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
      }
      return false;
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
  }

  Future<bool> insertDifferentPriceItem(int id, double different, double price )async{
    try{
      isLoading.value = true;
      var response=await itemRepository.insertDifferentPriceItem(
        itemId: id ,
        differentPrice: different,
        price: price,
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

      }
      return false;
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
  }

  void clearList() {
    priceController.clear();
    differentPriceController.clear();
    selectedItem.value=null;

  }

}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/item.repository.dart';
import '../model/item.model.dart';

enum PageState{loading,err,empty,list}
class ProductController extends GetxController{

  final TextEditingController priceController=TextEditingController();
  final TextEditingController differentPriceController=TextEditingController();
  final TextEditingController itemController=TextEditingController();

  final ItemRepository itemRepository=ItemRepository();

  final List<ItemModel> itemList=<ItemModel>[].obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;

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
    fetchItemList();
    if(getOneItem.value!=null) {
      itemController.text = getOneItem.value!.name!;
    }
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

  Future<ItemModel?> insertPriceItem()async{
    try{
      isLoading.value = true;
      var response=await itemRepository.insertPriceItem(
          itemId: selectedItem.value?.id ?? 0,
          price: double.parse(priceController.text.replaceAll(',', '').toEnglishDigit()),
          differentPrice: double.parse(differentPriceController.text.replaceAll(',', '').toEnglishDigit()),
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
        clearList();
      }
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
    return null;
  }

  void clearList() {
    priceController.clear();
    differentPriceController.clear();
    selectedItem.value=null;

  }

}
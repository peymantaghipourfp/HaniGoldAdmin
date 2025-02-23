
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/item.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';


enum PageState{loading,err,empty,list}
class OrderCreateController extends GetxController{

  final TextEditingController priceController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
  final TextEditingController totalPriceController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();

  final List<String> orderTypeList=['فروش به کاربر','خرید از کاربر'];
  final ItemRepository itemRepository=ItemRepository();
  final AccountRepository accountRepository=AccountRepository();
  var itemList=<ItemModel>[].obs;
  var accountList=<AccountModel>[].obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;

  final RxnString selectedBuySell = RxnString();
  final RxnString selectedItem=RxnString();
  final RxnString selectedAccount = RxnString();
  void changeSelectedBuySell(String? newValue) {
    selectedBuySell.value = newValue;
  }
  void changeSelectedItem(String? newValue) {
    selectedItem.value = newValue;
  }
  void changeSelectedAccount(String? newValue) {
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
}
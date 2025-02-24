
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_create.controller.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';



enum PageState{loading,err,empty,list}
class OrderController extends GetxController{

  final OrderCreateController orderCreateController=Get.find<OrderCreateController>();
  final TextEditingController searchController=TextEditingController();
  final OrderRepository orderRepository=OrderRepository();
  var orderList=<OrderModel>[].obs;
  var filteredOrders=<OrderModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrderList();
    searchController.addListener((){
      filterOrders(searchController.text);
    });
  }


  Future<void> fetchOrderList() async{
    try{
      state.value=PageState.loading;
      var fetchedOrderList=await orderRepository.getOrderList();
      orderList.assignAll(fetchedOrderList);
      filteredOrders.assignAll(fetchedOrderList);
      state.value=PageState.list;

      if(orderList.isEmpty){
        state.value=PageState.empty;
      }
    }catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  void filterOrders(String query){
    if(query.isEmpty){
      filteredOrders.value=orderList;
    }else{
      filteredOrders.value=orderList.where((order){
        return(order.account?.name?.contains(query) ?? false) ||
            (order.item?.name?.contains(query) ?? false) ||
            (order.totalPrice?.toString().contains(query) ?? false)||
            (order.date?.toPersianDate(showTime: true,twoDigits: true,timeSeprator: '-').contains(query) ?? false );
      }).toList();
    }
    update();
  }

  void setOrderDetails(OrderModel order) {
    orderCreateController.selectedBuySell.value = orderCreateController.orderTypeList.firstWhereOrNull((type) => type.id == order.type);
    orderCreateController.selectedItem.value = orderCreateController.itemList.firstWhereOrNull((item) => item.id == order.item?.id);
    orderCreateController.selectedAccount.value = orderCreateController.accountList.firstWhereOrNull((account) => account.id == order.account?.id);

    orderCreateController.dateController.text = order.date.toString() ?? '';
    orderCreateController.priceController.text = order.price?.toString() ?? '';
    orderCreateController.amountController.text = order.amount?.toString() ?? '';
    orderCreateController.totalPriceController.text = order.totalPrice?.toString() ?? '';
    orderCreateController.descriptionController.text = order.description ?? '';

    var existingOrderId = order.id;
  }

  @override void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
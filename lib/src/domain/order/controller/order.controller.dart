
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';



enum PageState{loading,err,empty,list}
class OrderController extends GetxController{

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


  @override void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
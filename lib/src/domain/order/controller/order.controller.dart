
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';



enum PageState{loading,err,empty,list}
class OrderController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

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
    setupScrollListener();
    searchController.addListener((){
      filterOrders(searchController.text);
    });
  }
  @override void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }
  Future<void> loadMore() async {
    if (hasMore.value && !isLoading.value) {
      currentPage++;
      await fetchOrderList();
    }
  }


  Future<void> fetchOrderList() async{
    try{
      if (currentPage == 1) {
        orderList.clear();
      }
      isLoading.value = true;
      //state.value=PageState.loading;
      final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
      final toIndex = currentPage.value * itemsPerPage.value;
      var fetchedOrderList=await orderRepository.getOrderList(
          startIndex: startIndex,
          toIndex: toIndex
      );
      hasMore.value = fetchedOrderList.length == itemsPerPage.value;

      if (currentPage.value == 1) {
        orderList.assignAll(fetchedOrderList);
      } else {
        orderList.addAll(fetchedOrderList);
      }
      filteredOrders.assignAll(fetchedOrderList);

      state.value = orderList.isEmpty ? PageState.empty : PageState.list;
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

}
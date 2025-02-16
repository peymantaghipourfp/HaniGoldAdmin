
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';



enum PageState{loading,err,empty,list}
class OrderController extends GetxController{

  var orderList=<OrderModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var pageState=PageState.loading.obs;

  void setPageState(PageState state){
    pageState.value=state;
  }
  void setError(String message){
    pageState.value=PageState.err;
    errorMessage.value=message;
  }

  final OrderRepository orderRepository=OrderRepository();

  @override
  void onInit() {
    super.onInit();
    fetchOrderList();
  }
  Future<void> fetchOrderList() async{
    try{
      isLoading.value=true;
      //pageState.value=PageState.loading;
      var fetchedOrderList=await orderRepository.getOrderList();
      orderList.assignAll(fetchedOrderList);
    }catch(e){
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }
}
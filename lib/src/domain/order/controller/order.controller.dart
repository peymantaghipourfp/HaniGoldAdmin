
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/order.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../account/model/account.model.dart';



enum PageState{loading,err,empty,list}
class OrderController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final TextEditingController searchController=TextEditingController();
  final AccountRepository accountRepository=AccountRepository();
  final OrderRepository orderRepository=OrderRepository();
  var orderList=<OrderModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingRegister=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  @override
  void onInit() {
    fetchOrderList();
    setupScrollListener();
    super.onInit();
  }
  @override void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  void goToPage(int page) {
    if (page < 1) return;
    currentPage.value = page;
    fetchOrderList();
  }

  void nextPage() {
    if (hasMore.value) {
      currentPage.value++;
      fetchOrderList();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchOrderList();
    }
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
    if (!scrollController.hasClients ||hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var fetchedOrderList = await orderRepository.getOrderList(
          startIndex: startIndex,
          toIndex: toIndex,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        );
        if (fetchedOrderList.isNotEmpty) {
          orderList.addAll(fetchedOrderList);
          currentPage.value = nextPage;
          hasMore.value = fetchedOrderList.length == itemsPerPage.value;

        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false; // توقف بارگذاری بیشتر در صورت خطا
        errorMessage.value = "خطا در دریافت اطلاعات بیشتر: ${e.toString()}";
      } finally {
        isLoading.value = false;
      }
    }
  }

  // مدل آپشن سرچ account
  AccountSearchReqModel? accountSearchReqModel;
  searchAccountName(String name){
    accountSearchReqModel=AccountSearchReqModel(
        account: OptionsModel(
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: 'Name',
                    filterValue: name,
                    filterType: 0,
                    refTable: "Account"
                )]
            )],
            orderBy: "Account.Name",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 1000)
    );
  }

  Future<void> searchAccounts(String name) async {
    try {
      if (name.isEmpty) {
        searchedAccounts.clear();
        return;
      }

      final accounts = await accountRepository.searchAccountList(name);
      searchedAccounts.assignAll(accounts);
    } catch (e) {
      setError("خطا در جستجوی کاربران: ${e.toString()}");
    }
  }

  void selectAccount(AccountModel account) {
    currentPage.value = 1;
    selectedAccountId.value = account.id!;
    searchController.text = account.name!;
    Get.back(); // Close search dialog
    fetchOrderList();
  }

  void clearSearch() {
    currentPage.value = 1;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    fetchOrderList();
  }



  Future<List<OrderModel>> fetchOrderList() async{
    try{
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
        orderList.clear();
        isLoading.value=true;
      state.value=PageState.loading;
      final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
      final toIndex = currentPage.value * itemsPerPage.value;
      var fetchedOrderList=await orderRepository.getOrderList(
          startIndex: startIndex,
          toIndex: toIndex,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
      );
      hasMore.value = fetchedOrderList.length == itemsPerPage.value;
      //print("بالانس: ${orderList.first.balances}");

      if (selectedAccountId.value == 0) {
        orderList.assignAll(fetchedOrderList);
      }else {
        if (currentPage.value == 1) {
          orderList.assignAll(fetchedOrderList);
        } else {
          orderList.addAll(fetchedOrderList);
        }
      }

      state.value = orderList.isEmpty ? PageState.empty : PageState.list;
      //EasyLoading.dismiss();
        orderList.refresh();
        update();

    }catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
      return orderList;
    }
  }

  Future<List<dynamic>?> updateStatusOrder(int orderId,int status)async{
    try{
      isLoading.value = true;
      var response=await orderRepository.updateStatusOrder(status: status, orderId: orderId);
      if(response!= null){
       // OrderModel orderResponse=OrderModel.fromJson(response);
        Get.snackbar(response.first['title'], response.first["description"],
            titleText: Text(response.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchOrderList();
      }
    }catch(e){
      throw ErrorException('خطا در تغییر وضعیت: $e');
    }finally {
      isLoading.value = false;

    }
    return null;
  }

  Future<List<dynamic>?> deleteOrder(int orderId,bool isDeleted)async{
    try{
      isLoading.value = true;
      var response=await orderRepository.deleteOrder(isDeleted: isDeleted, orderId: orderId);
      if(response!= null){
        Get.snackbar("موفقیت آمیز","حذف سفارش با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف سفارش با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        Get.back();
        fetchOrderList();
      }
    }catch(e){
      throw ErrorException('خطا در حذف سفارش: $e');
    }finally {
      isLoading.value = false;

    }
    return null;
  }

  Future<List<dynamic>?> updateRegistered(int orderId,bool registered) async {
    //EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      var response = await orderRepository.updateRegistered(
        orderId: orderId,
        registered: registered,
      );
      if(response!= null){
        //EasyLoading.dismiss();
        Get.snackbar(response.first['title'],response.first["description"],
            titleText: Text(response.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchOrderList();
      }

    } catch (e) {
      throw ErrorException('خطا در ریجیستر: $e');
    } finally {
      isLoading.value = false;
    }

    return null;
  }

}
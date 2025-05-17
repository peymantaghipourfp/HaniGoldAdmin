
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/repository/trading_balance.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../model/balance_trading.model.dart';



enum PageStateBalance{loading,err,empty,list}

class TradingBalanceController extends GetxController{

  Rx<PageStateBalance> state=Rx<PageStateBalance>(PageStateBalance.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 7.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  TradingBalanceRepository tradingBalanceRepository=TradingBalanceRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final List<BalanceTradingModel> tradingBalanceList=<BalanceTradingModel>[].obs;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  var sort = true.obs; // or `false`...
  var sortIndex = 0.obs; // or `false`...
  var id = 0.obs; // or `false`...


  @override
  void onInit() {
    super.onInit();
    getListTransactionInfo();


  }



    // لیست مانده کاربران
  Future<void> getListTransactionInfo() async{
    print("getListTransactionInfo : ");
    tradingBalanceList.clear();
    try{
      state.value=PageStateBalance.loading;
      var response=await tradingBalanceRepository.getTradingBalanceList( );
      state.value=PageStateBalance.list;
      tradingBalanceList.addAll(response);
      if(tradingBalanceList.isEmpty){
        state.value=PageStateBalance.empty;
      }
      update();
    }
    catch(e){
      state.value=PageStateBalance.err;
    }finally{
    }
  }
}

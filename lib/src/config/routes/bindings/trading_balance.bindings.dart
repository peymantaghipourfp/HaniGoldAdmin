import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/balance/controller/trading_balance.controller.dart';

class TradingBalanceBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>TradingBalanceController());
    //Get.lazyPut(()=>HomeController());
  }

}
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/transferWallet/controller/transfer_wallet_list.controller.dart';

import '../../../domain/transferWallet/controller/transfer_after_tomorrow_change.controller.dart';

class TransferWalletBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>TransferWalletController());
    Get.lazyPut(()=>TransferAfterTomorrowChangeController());
  }
}
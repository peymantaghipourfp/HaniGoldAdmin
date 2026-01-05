import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/transaction.repository.dart';
import 'package:hanigold_admin/src/config/repository/user_info_transaction.repository.dart';
import 'package:hanigold_admin/src/domain/transaction/model/all_balances.model.dart';
import 'package:hanigold_admin/src/domain/users/model/check_result.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_info_item.model.dart';

class CheckResultController extends GetxController {
  final UserInfoTransactionRepository userInfoTransactionRepository = UserInfoTransactionRepository();

  // Observable variables for reactive UI
  final RxList<CheckResultModel> checkResultList = <CheckResultModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getCheckResult({
    required int id,
  }) async {
    print("getCheckResult ::::::::: 1");
    checkResultList.clear();
    isLoading.value=true;
    try {
      var response = await userInfoTransactionRepository.getCheckResult(id);
      isLoading.value=false;
      checkResultList.addAll(response);
      print("checkResultList:::::::::::${checkResultList.length}");
      update();
    }
    catch (e) {
      isLoading.value=false;
    } finally {
      isLoading.value=false;
    }
  }


  /// Refresh balances
  Future<void> refreshCheckResult() async {
    await getCheckResult(id : 0);

  }

  /// Clear all data
  void clearData() {
    checkResultList.clear();
    isLoading.value = false;
    error.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
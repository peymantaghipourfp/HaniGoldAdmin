import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/transaction.repository.dart';
import 'package:hanigold_admin/src/domain/transaction/model/all_balances.model.dart';

class BalanceDateDialogController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();

  // Observable variables for reactive UI
  final RxList<AllBalancesModel> balances = <AllBalancesModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxString selectedDate = ''.obs;
  final RxInt accountId = 0.obs;
  final RxString accountName = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Load balances for a specific account and date
  /// [accountId] - The ID of the account
  /// [date] - The date in string format (e.g., "2024-01-01")
  /// [accountName] - The name of the account for display purposes
  Future<void> loadBalancesByDate({
    required int accountId,
    required String date,
    String? accountName,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      balances.clear();

      // Set account info for display
      this.accountId.value = accountId;
      this.accountName.value = accountName ?? 'نامشخص';
      selectedDate.value = date;

      final balanceList = await _transactionRepository.getAllBalancesDateList(accountId, date);
      balances.addAll(balanceList);

      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  /// Get coin balances (مانده سکه)
  List<AllBalancesModel> get coinBalances =>
      balances.where((b) => b.unitName == 'عدد').toList();

  /// Get rial balances (مانده ریالی)
  List<AllBalancesModel> get rialBalances =>
      balances.where((b) => b.unitName == 'ریال').toList();

  /// Get gold balances (مانده طلایی)
  List<AllBalancesModel> get goldBalances =>
      balances.where((b) => b.unitName == 'گرم').toList();

  /// Get currency balances (مانده ارز)
  List<AllBalancesModel> get currencyBalances =>
      balances.where((b) => b.unitName == 'دلار' || b.unitName == 'یورو' || b.unitName == 'پوند').toList();

  /// Refresh balances with current date and account
  Future<void> refreshBalances() async {
    if (accountId.value > 0 && selectedDate.value.isNotEmpty) {
      await loadBalancesByDate(
        accountId: accountId.value,
        date: selectedDate.value,
        accountName: accountName.value,
      );
    }
  }

  /// Load balances for a new date
  Future<void> loadBalancesForNewDate(String newDate) async {
    if (accountId.value > 0) {
      await loadBalancesByDate(
        accountId: accountId.value,
        date: newDate,
        accountName: accountName.value,
      );
    }
  }

  /// Clear all data
  void clearData() {
    balances.clear();
    isLoading.value = false;
    error.value = '';
    selectedDate.value = '';
    accountId.value = 0;
    accountName.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}

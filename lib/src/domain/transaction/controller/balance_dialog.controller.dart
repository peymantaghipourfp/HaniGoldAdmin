import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/transaction.repository.dart';
import 'package:hanigold_admin/src/domain/transaction/model/all_balances.model.dart';

class BalanceDialogController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();

  // Observable variables for reactive UI
  final RxList<AllBalancesModel> balances = <AllBalancesModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxString entityName = ''.obs;
  final RxString entityType = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Load balances for any entity type
  /// [id] - The ID of the entity (account, inventory, etc.)
  /// [type] - The type of entity ('account', 'inventory', etc.)
  /// [name] - The name of the entity for display purposes
  Future<void> loadBalances({
    required int id,
    required String type,
    String? name,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      balances.clear();

      // Set entity info for display
      entityName.value = name ?? 'نامشخص';
      entityType.value = type;

      final balanceList = await _transactionRepository.getAllBalancesList(id, type );
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

  /// Refresh balances
  Future<void> refreshBalances() async {
    if (entityType.value.isNotEmpty) {
      await loadBalances(
        id: int.tryParse(entityType.value) ?? 0,
        type: entityType.value,
        name: entityName.value,
      );
    }
  }

  /// Clear all data
  void clearData() {
    balances.clear();
    isLoading.value = false;
    error.value = '';
    entityName.value = '';
    entityType.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
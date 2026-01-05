import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../model/transaction_info_item.model.dart';
import '../model/paginated.model.dart';

class InvoicePreviewController extends GetxController {
  final UserInfoTransactionRepository userInfoTransactionRepository = UserInfoTransactionRepository();

  // Data
  RxList<TransactionInfoItemModel> transactionInfoList = <TransactionInfoItemModel>[].obs;
  RxList<TransactionInfoItemModel> selectedTransactions = <TransactionInfoItemModel>[].obs;
  Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();

  // Controllers
  final TextEditingController dateStartController = TextEditingController();
  final TextEditingController dateEndController = TextEditingController();

  // Variables
  var isLoading = false.obs;
  var id = 0.obs;
  var startDateFilter = ''.obs;
  var endDateFilter = ''.obs;
  var currentPage = 1.obs;
  var itemsPerPage = 25.obs;

  // Checkbox states
  RxMap<int, bool> checkboxStates = <int, bool>{}.obs;
  RxBool selectAll = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters['accountId'] != null) {
      id.value = int.parse(Get.parameters['accountId']!);
      getTransactionInfoListPager(id.value.toString());
    }
  }

  // Get transaction list
  Future<void> getTransactionInfoListPager(String accountId) async {
    try {
      isLoading.value = true;
      var response = await userInfoTransactionRepository.getTransactionInfoListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        accountId: accountId,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
      );

      transactionInfoList.assignAll(response.transactionInfoItems ?? []);
      paginated.value = response.paginated;

      // Initialize checkbox states
      for (var transaction in transactionInfoList) {
        checkboxStates[transaction.id ?? 0] = false;
      }

      update();
    } catch (e) {
      print('Error getting transaction list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle checkbox selection
  void toggleCheckbox(int transactionId) {
    checkboxStates[transactionId] = !(checkboxStates[transactionId] ?? false);

    // Update selected transactions list
    selectedTransactions.clear();
    for (var transaction in transactionInfoList) {
      if (checkboxStates[transaction.id ?? 0] == true) {
        selectedTransactions.add(transaction);
      }
    }

    // Update select all state
    selectAll.value = selectedTransactions.length == transactionInfoList.length;

    update();
  }

  // Handle select all
  void toggleSelectAll() {
    selectAll.value = !selectAll.value;

    for (var transaction in transactionInfoList) {
      checkboxStates[transaction.id ?? 0] = selectAll.value;
    }

    if (selectAll.value) {
      selectedTransactions.assignAll(transactionInfoList);
    } else {
      selectedTransactions.clear();
    }

    update();
  }

  // Date picker for start date
  Future<void> selectStartDate(BuildContext context) async {
    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1400, 1, 1),
      lastDate: Jalali(1450, 12, 29),
      initialEntryMode: PersianDatePickerEntryMode.calendar,
      initialDatePickerMode: PersianDatePickerMode.day,
      locale: const Locale("fa", "IR"),
    );

    if (pickedDate != null) {
      Gregorian gregorian = pickedDate.toGregorian();
      startDateFilter.value = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
      dateStartController.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  // Date picker for end date
  Future<void> selectEndDate(BuildContext context) async {
    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1400, 1, 1),
      lastDate: Jalali(1450, 12, 29),
      initialEntryMode: PersianDatePickerEntryMode.calendar,
      initialDatePickerMode: PersianDatePickerMode.day,
      locale: const Locale("fa", "IR"),
    );

    if (pickedDate != null) {
      Gregorian gregorian = pickedDate.toGregorian();
      endDateFilter.value = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
      dateEndController.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  // Apply filter
  void applyFilter() {
    currentPage.value = 1;
    itemsPerPage.value = 25;
    getTransactionInfoListPager(id.value.toString());
  }

  // Clear filter
  void clearFilter() {
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value = "";
    endDateFilter.value = "";
    currentPage.value = 1;
    itemsPerPage.value = 25;
    getTransactionInfoListPager(id.value.toString());
  }

  // Change page
  void isChangePage(int index) {
    currentPage.value = (index * 25 - 25) + 1;
    itemsPerPage.value = index * 25;
    getTransactionInfoListPager(id.value.toString());
  }

  // Get transaction type text
  String getTypeText(String type) {
    switch (type) {
      case 'issue':
        return 'حواله';
      case "payment":
        return 'پرداخت';
      case "receive":
        return 'دریافت';
      case "reciept":
        return 'برگشت';
      case "sell":
        return 'فروش';
      case "buy":
        return 'خرید';
      case "deposit":
        return 'واریز';
      case "withdraw":
        return 'برداشت';
      default:
        return 'نامعتبر';
    }
  }

  @override
  void onClose() {
    dateStartController.dispose();
    dateEndController.dispose();
    super.onClose();
  }
}

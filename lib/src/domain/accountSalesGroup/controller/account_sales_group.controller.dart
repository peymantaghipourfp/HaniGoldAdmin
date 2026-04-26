


import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account_sales_group.repository.dart';

import '../../../config/const/app_color.dart';
import '../../account/model/account.model.dart';
import '../model/account_sales_group.model.dart';

enum PageState{loading,err,empty,list}

class AccountSalesGroupController extends GetxController {

  final AccountSalesGroupRepository accountSalesGroupRepository=AccountSalesGroupRepository();
  final List<AccountSalesGroupModel> accountSalesGroupList=<AccountSalesGroupModel>[].obs;
  final List<AccountModel> accountListForSalesGroup=<AccountModel>[].obs;
  final List<AccountModel> selectedAccountsForAssignment = <AccountModel>[].obs;
  int? _currentAccountSalesGroupIdForAssignment;
  final Rx<PageState> assignDialogState = Rx<PageState>(PageState.loading);
  var isLoading=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);

  @override
  void onInit() {
    getAccountSalesGroupList();
    super.onInit();
  }

  // لیست گروه ها
  Future<void> getAccountSalesGroupList() async {
    accountSalesGroupList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await accountSalesGroupRepository.getAccountSalesGroupList();
      isLoading.value=false;
      accountSalesGroupList.assignAll(response);
      state.value=PageState.list;
      //update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // دریافت جزئیات یک زیرگروه
  Future<AccountSalesGroupModel?> getOneAccountSalesGroup(int accountSalesGroupId) async {
    EasyLoading.show(status: 'در حال دریافت جزئیات...');
    try {
      var response = await accountSalesGroupRepository.getOneAccountSalesGroup(
        accountSalesGroupId: accountSalesGroupId,
      );
      EasyLoading.dismiss();
      return response;
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'خطا',
        'خطا در دریافت جزئیات زیرگروه قیمت گذاری: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return null;
    }
  }

  Future<List<dynamic>?> deleteAccountSalesGroup(int accountSalesGroupId,bool isDeleted)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      if (Get.isDialogOpen!) Get.back();
      var response=await accountSalesGroupRepository.deleteAccountSalesGroup(isDeleted: isDeleted, accountSalesGroupId: accountSalesGroupId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getAccountSalesGroupList();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw 'خطا در حذف زیرگروه قیمت گذاری: $e';
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }

  // لیست کاربران
  Future<void> fetchAccountListSalesGroup(String accountSalesGroupId,{String name = ''}) async{
    try{
      assignDialogState.value = PageState.loading;
      _currentAccountSalesGroupIdForAssignment = null;
      final targetId = int.tryParse(accountSalesGroupId);
      if (_currentAccountSalesGroupIdForAssignment != targetId) {
        selectedAccountsForAssignment.clear();
        _currentAccountSalesGroupIdForAssignment = targetId;
      }
      final fetchedAccountListForSalesGroup =
      await accountSalesGroupRepository.getAccountListForSalesGroup(
        accountSalesGroupId: accountSalesGroupId,
        name: name,
      );
      List<AccountModel> assignedAccounts = const <AccountModel>[];
      if (targetId != null) {
        try {
          assignedAccounts =
          await accountSalesGroupRepository.getAssignedAccountsForSalesGroup(
            accountSalesGroupId: accountSalesGroupId,
            name: name,
          );
        } catch (e) {
          debugPrint('⚠️ خطا در لود حساب های اختصاص داده شده $targetId: $e');
          assignedAccounts = const <AccountModel>[];
        }
      }
      final mergedAccounts =
      _mergeAccounts(fetchedAccountListForSalesGroup, assignedAccounts);
      accountListForSalesGroup.assignAll(mergedAccounts);

      _preselectAccountsForSalesGroup(targetId, mergedAccounts);
      _preselectAssignedAccounts(assignedAccounts);
      if (accountListForSalesGroup.isEmpty) {
        assignDialogState.value = PageState.empty;
      } else {
        assignDialogState.value = PageState.list;
      }
    }
    catch(e){
      assignDialogState.value = PageState.err;
      " خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      //isLoading.value=false;
    }
  }

  void _preselectAccountsForSalesGroup(int? targetAccountSalesGroupId, List<AccountModel> accounts) {
    if (targetAccountSalesGroupId == null) {
      return;
    }

    final existingIds = selectedAccountsForAssignment
        .where((element) => element.id != null)
        .map((element) => element.id!)
        .toSet();

    for (final account in accounts) {
      final accountId = account.id;
      if (accountId == null) {
        continue;
      }
      final accountSalesGroups = account.accountSalesGroup;
      if (accountSalesGroups == null) {
        continue;
      }
      //final belongsToTarget = accountSalesGroups.any((accountSalesGroup) => accountSalesGroup.id == targetAccountSalesGroupId);
      if (accountSalesGroups.id== targetAccountSalesGroupId && !existingIds.contains(accountId)) {
        selectedAccountsForAssignment.add(account);
        existingIds.add(accountId);
      }
    }
  }

  void _preselectAssignedAccounts(List<AccountModel> assignedAccounts) {
    if (assignedAccounts.isEmpty) {
      return;
    }
    selectAllAccountsForAssignment(assignedAccounts);
  }

  List<AccountModel> _mergeAccounts(
      List<AccountModel> primary,
      List<AccountModel> secondary,
      ) {
    final accountsById = LinkedHashMap<int, AccountModel>();
    final List<AccountModel> withoutId = [];

    void addAccounts(List<AccountModel> source) {
      for (final account in source) {
        final accountId = account.id;
        if (accountId == null) {
          if (!withoutId.contains(account)) {
            withoutId.add(account);
          }
          continue;
        }
        accountsById[accountId] = account;
      }
    }
    addAccounts(secondary); // ensure already assigned accounts keep priority
    addAccounts(primary);
    return [
      ...accountsById.values,
      ...withoutId,
    ];
  }

  void toggleAccountSelection(AccountModel account) {
    final accountId = account.id;
    if (accountId == null) {
      return;
    }
    final existingIndex = selectedAccountsForAssignment
        .indexWhere((element) => element.id == accountId);
    if (existingIndex >= 0) {
      selectedAccountsForAssignment.removeAt(existingIndex);
    } else {
      selectedAccountsForAssignment.add(account);
    }
  }

  bool isAccountSelected(int? accountId) {
    if (accountId == null) {
      return false;
    }
    return selectedAccountsForAssignment
        .any((element) => element.id == accountId);
  }

  void removeSelectedAccount(int accountId) {
    selectedAccountsForAssignment
        .removeWhere((element) => element.id == accountId);
  }

  void selectAllAccountsForAssignment(Iterable<AccountModel> accounts) {
    final existingIds = selectedAccountsForAssignment
        .where((element) => element.id != null)
        .map((element) => element.id)
        .toSet();
    for (final account in accounts) {
      final accountId = account.id;
      if (accountId == null) {
        continue;
      }
      if (!existingIds.contains(accountId)) {
        selectedAccountsForAssignment.add(account);
        existingIds.add(accountId);
      }
    }
  }

  void clearAllAccountsForAssignment(Iterable<AccountModel> accounts) {
    for (final account in accounts) {
      final accountId = account.id;
      if (accountId != null) {
        removeSelectedAccount(accountId);
      }
    }
  }

  void clearSelectedAccountsForAssignment() {
    selectedAccountsForAssignment.clear();
  }


  void resetAssignmentState() {
    selectedAccountsForAssignment.clear();
    //accountListForSalesGroup.clear();
    assignDialogState.value = PageState.loading;
  }

  Future<void> updateAssignAccountsToSalesGroup(int accountSalesGroupId) async {
    /*if (accountSalesGroupId <= 0) {
      Get.snackbar(
        'خطا',
        'شناسه زیرگروه نامعتبر است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return;
    }*/
    /*if (selectedAccountsForAssignment.isEmpty) {
      Get.snackbar(
        'خطا',
        'هیچ حسابی انتخاب نشده است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return;
    }*/
    final accountsPayload = selectedAccountsForAssignment
        .where((account) => account.id != null)
        .map((account) => {
      'id': account.id,
      //'accountSalesGroup': {'id': accountSalesGroupId},
    }).toList();

    /*if (accountsPayload.isEmpty) {
      Get.snackbar(
        'خطا',
        'هیچ حساب معتبری برای اختصاص وجود ندارد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
      return;
    }*/

    try {
      EasyLoading.show(status: 'در حال ذخیره تغییرات...');
      final response =
      await accountSalesGroupRepository.updateAssignedAccountsForSalesGroup(
        accountSalesGroupId: accountSalesGroupId,
        accounts: accountsPayload,
      );
      await fetchAccountListSalesGroup(accountSalesGroupId.toString());
      EasyLoading.dismiss();
      Get.back();
      Get.snackbar(
        response['title'] ?? 'موفقیت',
        response['description'] ?? 'حساب‌ها با موفقیت اختصاص یافتند',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryColor.withOpacity(0.8),
        colorText: AppColor.textColor,
      );
      await getAccountSalesGroupList();
      resetAssignmentState();
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'خطا',
        'ذخیره تغییرات با خطا مواجه شد: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.accentColor,
        colorText: AppColor.textColor,
      );
    }
  }

}
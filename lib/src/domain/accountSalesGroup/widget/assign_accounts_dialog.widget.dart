

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../account/model/account.model.dart';
import '../controller/account_sales_group.controller.dart';
import '../model/account_sales_group.model.dart';

class AssignAccountsDialog extends StatefulWidget {
  final AccountSalesGroupController controller;
  final AccountSalesGroupModel accountSalesGroup;
  final bool isDesktop;

  const AssignAccountsDialog({super.key,
    required this.controller,
    required this.accountSalesGroup,
    required this.isDesktop,
  });

  @override
  State<AssignAccountsDialog> createState() => AssignAccountsDialogState();
}

class AssignAccountsDialogState extends State<AssignAccountsDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.controller.fetchAccountListSalesGroup(widget.accountSalesGroup.id?.toString() ?? '');
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text.trim();
    });
  }

  void _handleSelectAll(List<AccountModel> accounts) {
    if (accounts.isEmpty) {
      return;
    }
    widget.controller.selectAllAccountsForAssignment(accounts);
  }

  void _handleClearAll(List<AccountModel> accounts) {
    if (accounts.isEmpty) {
      return;
    }
    widget.controller.clearAllAccountsForAssignment(accounts);
  }

  void _handleClearAllNew(List<AccountModel> accounts) {
    if (widget.controller.selectedAccountsForAssignment.isEmpty) {
      return;
    }
    widget.controller.clearSelectedAccountsForAssignment();
  }

  List<AccountModel> _getFilteredAccounts(List<AccountModel> accounts) {
    if (_searchText.isEmpty) {
      return accounts;
    }
    final query = _searchText.toLowerCase();
    return accounts.where((account) {
      final accountName = account.name ?? '';
      return accountName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding =
    widget.isDesktop ? const EdgeInsets.all(28) : const EdgeInsets.all(20);
    return Obx(() {
      final dialogState = widget.controller.assignDialogState.value;
      final accounts = widget.controller.accountListForSalesGroup;
      final selectedAccounts = widget.controller.selectedAccountsForAssignment;
      final hasSelection = selectedAccounts.isNotEmpty;
      final filteredAccountsForAll = dialogState == PageState.list
          ? _getFilteredAccounts(accounts)
          : <AccountModel>[];

      return Padding(
        padding: padding,
        child:
            widget.isDesktop ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اختصاص حساب به زیرگروه',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: widget.isDesktop ? 18 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColor.dividerColor.withAlpha(40),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFF64748B)),
                                ),
                                child: Text(
                                  widget.accountSalesGroup.name ?? '',
                                  style: AppTextStyle.bodyText.copyWith(
                                    fontSize: widget.isDesktop ? 14 : 13,
                                    color: AppColor.dividerColor.withAlpha(200),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColor.textPrimaryColor.withAlpha(40),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFF64748B)),
                                ),
                                child: Text(
                                  "(${widget.accountSalesGroup.accountCount ?? 0})" ,
                                  style: AppTextStyle.bodyText.copyWith(
                                      fontSize: widget.isDesktop ? 14 : 13,
                                      color: AppColor.primaryColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: AppColor.textColor),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,),
                  decoration: BoxDecoration(
                    color: AppColor.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.textColor.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                          color: AppColor.textColor.withAlpha(200)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: AppTextStyle.labelText.copyWith(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'جستجو حساب...',
                            border: InputBorder.none,
                            hintStyle: AppTextStyle.bodyText.copyWith(
                              fontSize: 12,
                              color: AppColor.textColor.withAlpha(130),
                            ),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                          },
                          child: Icon(Icons.close,
                              size: 18, color: AppColor.textColor.withAlpha(150)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                /*if (dialogState == PageState.list) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _handleSelectAll(filteredAccountsForAll),
                          icon: const Icon(Icons.check_box),
                          label: const Text('انتخاب همه'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.secondary3Color,
                            side: BorderSide(color: AppColor.secondary3Color),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle:
                            AppTextStyle.labelText.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleClearAll,
                          icon: const Icon(Icons.check_box_outline_blank),
                          label: const Text('حذف همه'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.errorColor,
                            side: BorderSide(color: AppColor.errorColor
                                .withAlpha(150)),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle:
                            AppTextStyle.labelText.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],*/
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: hasSelection ? 5 : 1,
                        child: _buildAccountContent(dialogState, accounts),
                      ),
                      if (hasSelection) const SizedBox(width: 12),
                      if (hasSelection)
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              Text(
                                'حساب‌های انتخاب شده',
                                style: AppTextStyle.labelText.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColor.iconViewColor),
                                  ),
                                  child:  SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 10,),
                                        child: Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: selectedAccounts.map((account) {
                                            return Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 3, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColor.primaryColor
                                                    .withAlpha(38),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: AppColor.primaryColor),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    account.name ?? '',
                                                    style: AppTextStyle.labelText
                                                        .copyWith(
                                                      fontSize: 10,
                                                      color: AppColor.primaryColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  GestureDetector(
                                                    onTap: () => widget.controller
                                                        .removeSelectedAccount(
                                                        account.id ?? 0),
                                                    child: Icon(Icons.close,
                                                        size: 16,
                                                        color: AppColor.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),

                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (widget.accountSalesGroup.id ?? 0) > 0
                        ? () => widget.controller.updateAssignAccountsToSalesGroup(
                        widget.accountSalesGroup.id ?? 0)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      foregroundColor: AppColor.textColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: AppTextStyle.labelText.copyWith(fontSize: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('ذخیره تغییرات'),
                  ),
                )
              ],
            ):
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختصاص حساب به زیرگروه',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: widget.isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColor.dividerColor.withAlpha(40),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF64748B)),
                            ),
                            child: Text(
                              widget.accountSalesGroup.name ?? '',
                              style: AppTextStyle.bodyText.copyWith(
                                fontSize: widget.isDesktop ? 14 : 13,
                                color: AppColor.dividerColor.withAlpha(200),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColor.textPrimaryColor.withAlpha(40),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF64748B)),
                            ),
                            child: Text(
                              "(${widget.accountSalesGroup.accountCount ?? 0})" ,
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: widget.isDesktop ? 14 : 13,
                                  color: AppColor.primaryColor
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: AppColor.textColor),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,),
              decoration: BoxDecoration(
                color: AppColor.textFieldColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.textColor.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search,
                      color: AppColor.textColor.withAlpha(200)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: AppTextStyle.labelText.copyWith(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'جستجو حساب...',
                        border: InputBorder.none,
                        hintStyle: AppTextStyle.bodyText.copyWith(
                          fontSize: 12,
                          color: AppColor.textColor.withAlpha(130),
                        ),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: Icon(Icons.close,
                          size: 18, color: AppColor.textColor.withAlpha(150)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            /*if (dialogState == PageState.list) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handleSelectAll(filteredAccountsForAll),
                      icon: const Icon(Icons.check_box),
                      label: const Text('انتخاب همه'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.secondary3Color,
                        side: BorderSide(color: AppColor.secondary3Color),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle:
                        AppTextStyle.labelText.copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>  _handleClearAll(filteredAccountsForAll),
                      icon: const Icon(Icons.check_box_outline_blank),
                      label: const Text('حذف همه'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.errorColor,
                        side: BorderSide(color: AppColor.errorColor
                            .withAlpha(150)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle:
                        AppTextStyle.labelText.copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],*/
            if (hasSelection) ...[
              Text(
                'حساب‌های انتخاب شده',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: Get.width,
                height: Get.height*0.2,
                padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.iconViewColor),
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: selectedAccounts.map((account) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withAlpha(38),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColor.primaryColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              account.name ?? '',
                              style: AppTextStyle.labelText.copyWith(
                                fontSize: 11,
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => widget.controller
                                  .removeSelectedAccount(account.id ?? 0),
                              child: Icon(Icons.close,
                                  size: 20, color: AppColor.primaryColor),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Expanded(
              child: _buildAccountContent(dialogState, accounts),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (widget.accountSalesGroup.id ?? 0) > 0
                    ? () => widget.controller.updateAssignAccountsToSalesGroup(
                    widget.accountSalesGroup.id ?? 0)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: AppColor.textColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: AppTextStyle.labelText.copyWith(fontSize: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('ذخیره تغییرات'),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildAccountContent(PageState state, List<AccountModel> accounts) {
    switch (state) {
      case PageState.loading:
        return const Center(child: CircularProgressIndicator());
      case PageState.err:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColor.accentColor, size: 40),
              const SizedBox(height: 12),
              Text(
                'خطا در دریافت لیست حساب‌ها',
                style: AppTextStyle.labelText.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.controller.fetchAccountListSalesGroup(
                    widget.accountSalesGroup.id?.toString() ?? ''),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: AppColor.textColor,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('تلاش مجدد'),
              ),
            ],
          ),
        );
      case PageState.empty:
        return Center(
          child: Text(
            'حسابی برای نمایش وجود ندارد',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 13,
              color: AppColor.textColor.withAlpha(175),
            ),
          ),
        );
      case PageState.list:
        final filteredAccounts = _getFilteredAccounts(accounts);
        final allSelected = filteredAccounts.isNotEmpty &&
            filteredAccounts.every(
                  (account) => widget.controller.isAccountSelected(account.id),
            );
        if (filteredAccounts.isEmpty) {
          return Center(
            child: Text(
              _searchText.isEmpty ? 'هیچ حسابی یافت نشد' : 'نتیجه‌ای یافت نشد',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 13,
                color: AppColor.textColor.withAlpha(175),
              ),
            ),
          );
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Checkbox(
                    value: allSelected,
                    onChanged: (value) {
                      if (value == true) {
                        _handleSelectAll(filteredAccounts);
                      } else {
                        _handleClearAll(filteredAccounts);
                      }
                    },
                    activeColor: AppColor.primaryColor,
                  ),
                   Text(
                      'انتخاب همه حساب‌ها',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,fontWeight: FontWeight.bold,),
                    ),

                  /*OutlinedButton.icon(
                    onPressed: () => _handleSelectAll(filteredAccounts),
                    icon: const Icon(Icons.check_box),
                    label: const Text('انتخاب همه'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.secondary3Color,
                      side: BorderSide(color: AppColor.secondary3Color),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: AppTextStyle.labelText.copyWith(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _handleClearAll,
                    icon: const Icon(Icons.check_box_outline_blank),
                    label: const Text('حذف همه'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.errorColor,
                      side: BorderSide(color: AppColor.errorColor.withAlpha(150)),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: AppTextStyle.labelText.copyWith(fontSize: 12),
                    ),
                  ),*/
                ],
              ),
            ),
            //const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.iconViewColor),
                ),
                child: ListView.separated(
                  itemCount: filteredAccounts.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 0.5, color: AppColor.textFieldColor),
                  itemBuilder: (context, index) {
                    final account = filteredAccounts[index];
                    final isSelected =
                    widget.controller.isAccountSelected(account.id);
                    return ListTile(
                      dense: true,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16,),
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (_) =>
                            widget.controller.toggleAccountSelection(account),
                        activeColor: AppColor.primaryColor,
                      ),
                      title: Text(
                        account.name ?? '',
                        style: AppTextStyle.labelText.copyWith(fontSize: 12),
                      ),
                      onTap: () =>
                          widget.controller.toggleAccountSelection(account),
                    );
                  },
                ),
              ),
            ),
          ],
        );
    }
  }
}
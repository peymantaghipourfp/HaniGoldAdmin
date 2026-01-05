

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_info_gold_transaction.controller.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../model/report_setting.model.dart';

class FilterDialogGold extends StatefulWidget {
  final UserInfoGoldTransactionController controller;

  const FilterDialogGold({super.key, required this.controller});

  @override
  State<FilterDialogGold> createState() => _FilterDialogGoldState();
}

class _FilterDialogGoldState extends State<FilterDialogGold> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoadingSettings = false;
  final String _reportSettingName = 'TotalBalance';

  // Filter modes: 'all', 'exclude', 'include', 'custom'
  String _selectedMode = 'all';
  final Set<int> _selectedAccounts = {};

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Defer _initLoad until after the first frame to avoid Obx subscription issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLoad();
    });
  }

  Future<void> _exportExcel() async {
    // Mirror current dialog selections into controller filter fields for export
    if (_selectedMode == 'all') {
      widget.controller.filteredAccountIds = null;
      widget.controller.accountFilterType = null;
    } else if (_selectedMode == 'include') {
      widget.controller.filteredAccountIds = _selectedAccounts.toList();
      widget.controller.accountFilterType = 32;
    } else if (_selectedMode == 'exclude') {
      widget.controller.filteredAccountIds = _selectedAccounts.toList();
      widget.controller.accountFilterType = 33;
    } else if (_selectedMode == 'custom') {
      widget.controller.filteredAccountIds = _selectedAccounts.toList();
      widget.controller.accountFilterType = 32;
    }

    await widget.controller.getListUserInfoTransactionExcel();
  }

  Future<void> _initLoad() async {
    if (!mounted) return;
    setState(() { _isLoadingSettings = true; });
    try {
      // Ensure accounts are loaded before mapping IDs to names
      await widget.controller.fetchAccountList();
      print('Account list loaded successfully');
      // Load saved report settings
      await widget.controller.fetchGetOneReportSetting(_reportSettingName);

      final setting = widget.controller.getOneReportSetting.value;
      if (setting != null) {
        // Determine current mode based on saved settings
        final hasIncludes = (setting.includes ?? []).isNotEmpty;
        final hasExcludes = (setting.excludes ?? []).isNotEmpty;

        _selectedMode = 'all';

        /*if (hasIncludes && !hasExcludes) {
          _selectedMode = 'include';
          _selectedAccounts.clear();
          for (final item in (setting.includes ?? const [])) {
            if (item.id != null) _selectedAccounts.add(item.id!);
          }
        } else if (hasExcludes && !hasIncludes) {
          _selectedMode = 'exclude';
          _selectedAccounts.clear();
          for (final item in (setting.excludes ?? const [])) {
            if (item.id != null) _selectedAccounts.add(item.id!);
          }
        } else if (hasIncludes && hasExcludes) {
          _selectedMode = 'exclude';
          _selectedAccounts.clear();
          for (final item in (setting.excludes ?? const [])) {
            if (item.id != null) _selectedAccounts.add(item.id!);
          }
        } else {
          _selectedMode = 'all';
        }*/
      }
    } catch (e) {
      // Log error for debugging
      print('Error in _initLoad: $e');
      _selectedMode = 'all';
    } finally {
      if (mounted) {
        setState(() { _isLoadingSettings = false; });
      }
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _toggleAccountSelection(int accountId) {
    setState(() {
      if (_selectedAccounts.contains(accountId)) {
        _selectedAccounts.remove(accountId);
      } else {
        _selectedAccounts.add(accountId);
      }
    });
  }

  void _selectAllAccounts() {
    setState(() {
      // Get filtered accounts based on current search text
      final filteredAccounts = widget.controller.accountList.where((account) {
        if (_searchText.isEmpty) return true;
        final accountName = account.name ?? '';
        return accountName.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();

      // Add all filtered account IDs to selection
      for (final account in filteredAccounts) {
        if (account.id != null) {
          _selectedAccounts.add(account.id!);
        }
      }
    });
  }

  void _deselectAllAccounts() {
    setState(() {
      _selectedAccounts.clear();
    });
  }

  Future<void> _applyFilter() async {
    try {

      // Apply filter based on mode
      if (_selectedMode == 'all') {
        // Clear filters for 'all' mode
        widget.controller.filteredAccountIds = null;
        widget.controller.accountFilterType = null;
      } else if (_selectedMode == 'include') {
        // Set filterType 32 for include mode
        widget.controller.filteredAccountIds = _selectedAccounts.toList();
        widget.controller.accountFilterType = 32;

        // Load current settings to preserve excludes
        final currentSetting = widget.controller.getOneReportSetting.value;
        final previousExcludes = currentSetting?.excludes ?? [];

        // Map new selections to Clude objects
        final includes = _selectedAccounts.map((id) {
          try {
            final account = widget.controller.accountList.firstWhere((acc) => acc.id == id);
            return Clude(id: id, name: account.name);
          } catch (e) {
            return Clude(id: id, name: '');
          }
        }).toList();

        // Update with preserved excludes
        await widget.controller.updateReportSetting(
          ReportSettingModel(
            name: _reportSettingName,
            includes: includes,
            excludes: previousExcludes, // Preserve previous excludes
            includeString: "",
            excludeString: "",
            id: currentSetting?.id ?? 1,
            infos: currentSetting?.infos ?? [],
          ),
        );
        print('✓ Include mode: Updated includes, preserved ${previousExcludes.length} excludes');
        Get.back();
      } else if (_selectedMode == 'exclude') {
        // Set filterType 33 for exclude mode
        widget.controller.filteredAccountIds = _selectedAccounts.toList();
        widget.controller.accountFilterType = 33;

        // Load current settings to preserve includes
        final currentSetting = widget.controller.getOneReportSetting.value;
        final previousIncludes = currentSetting?.includes ?? [];

        // Map new selections to Clude objects
        final excludes = _selectedAccounts.map((id) {
          try {
            final account = widget.controller.accountList.firstWhere((acc) => acc.id == id);
            return Clude(id: id, name: account.name);
          } catch (e) {
            return Clude(id: id, name: '');
          }
        }).toList();

        // Update with preserved includes
        await widget.controller.updateReportSetting(
          ReportSettingModel(
            name: _reportSettingName,
            includes: previousIncludes, // Preserve previous includes
            excludes: excludes,
            includeString: "",
            excludeString: "",
            id: currentSetting?.id ?? 1,
            infos: currentSetting?.infos ?? [],
          ),
        );
        Get.back();
        print('✓ Exclude mode: Updated excludes, preserved ${previousIncludes.length} includes');
      } else if (_selectedMode == 'custom') {
        // Clear filters for custom mode (can be extended later)
        widget.controller.filteredAccountIds = _selectedAccounts.toList();
        widget.controller.accountFilterType = 32;

      }
      // Refresh list with applied filters
      await widget.controller.getListTransactionInfoGoldPager();
      await widget.controller.getTransactionInfoFooter();
      widget.controller.currentPage.value=1;
      widget.controller.itemsPerPage.value=25;
      Get.back();
      Get.snackbar(
        'موفق',
        'فیلتر با موفقیت اعمال شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در اعمال فیلتر: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'فیلتر کاربران',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: AppColor.textColor),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        SizedBox(height: 20),
        // Dropdown for filter mode selection
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12,),
          decoration: BoxDecoration(
            color: AppColor.textFieldColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.textColor.withOpacity(0.3)),
          ),
          child: DropdownButton<String>(
            value: _selectedMode,
            isExpanded: true,
            underline: SizedBox(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12),
            dropdownColor: AppColor.textFieldColor,
            items: [
              DropdownMenuItem(value: 'all', child: Text('همه')),
              DropdownMenuItem(value: 'exclude', child: Text('شامل نشود')),
              DropdownMenuItem(value: 'include', child: Text('شامل شود')),
              DropdownMenuItem(value: 'custom', child: Text('سفارشی')),
            ],
            onChanged: (value) async {
              if (value != null) {
                setState(() {
                  _selectedMode = value;
                  _selectedAccounts.clear();
                  _isLoadingSettings = true;
                });
                try {
                  // Reload settings from server
                  await widget.controller.fetchGetOneReportSetting(_reportSettingName);

                  final setting = widget.controller.getOneReportSetting.value;
                  if (setting != null && mounted) {
                    setState(() {
                      // Populate selections based on new mode
                      if (value == 'include') {
                        for (final item in (setting.includes ?? const [])) {
                          if (item.id != null) _selectedAccounts.add(item.id!);
                        }
                        print('✓ Loaded ${_selectedAccounts.length} include accounts');
                      } else if (value == 'exclude') {
                        for (final item in (setting.excludes ?? const [])) {
                          if (item.id != null) _selectedAccounts.add(item.id!);
                        }
                        print('✓ Loaded ${_selectedAccounts.length} exclude accounts');
                      }
                    });
                  }
                } catch (e) {
                  print('⚠ Error loading settings on mode change: $e');
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoadingSettings = false;
                    });
                  }
                }
              }
            },
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: _buildContent(),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                side: BorderSide(color: AppColor.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                foregroundColor: AppColor.primaryColor,
                textStyle: AppTextStyle.labelText.copyWith(fontSize: 12),
              ),
              onPressed: () async { await _exportExcel(); },
              child: Text('خروجی اکسل'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
                backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: BorderSide(color: AppColor.textColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              onPressed: _applyFilter,
              child: Text(
                'اعمال فیلتر',
                style: AppTextStyle.labelText.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    // For 'all' mode, show message instead of account list
    if (_selectedMode == 'all') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: AppColor.primaryColor),
            SizedBox(height: 16),
            Text(
              'نمایش همه کاربران',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'برای نمایش همه کاربران بر روی اعمال فیلتر کلیک کنید.',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 12,
                color: AppColor.textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    // For 'include' and 'exclude' and 'custom' modes, show account selection
    return _buildAccountList();
  }

  Widget _buildAccountList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search/Filter input
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10,),
          decoration: BoxDecoration(
            color: AppColor.textFieldColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.textColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: AppColor.textColor, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyle.labelText.copyWith(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'جستجو...',
                    border: InputBorder.none,
                    hintStyle: AppTextStyle.labelText.copyWith(
                      fontSize: 12,
                      color: AppColor.textColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              if (_searchText.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.close, color: AppColor.textColor, size: 20),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Select All / Deselect All buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectAllAccounts,
                icon: Icon(Icons.check_box, size: 18),
                label: Text('انتخاب همه'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.secondary3Color,
                  side: BorderSide(color: AppColor.secondary3Color),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: AppTextStyle.labelText.copyWith(fontSize: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _deselectAllAccounts,
                icon: Icon(Icons.check_box_outline_blank, size: 18),
                label: Text('حذف همه'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.errorColor,
                  side: BorderSide(color: AppColor.errorColor.withAlpha(130)),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: AppTextStyle.labelText.copyWith(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (_isLoadingSettings)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'در حال بارگذاری تنظیمات...',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        // Selected accounts display
        if (_selectedAccounts.isNotEmpty) ...[
          Text(
            'حساب‌های انتخاب شده:',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.iconViewColor),
            ),
            width: Get.width,height: Get.height*0.2,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 5,
                runSpacing: 8,
                children: _selectedAccounts.map((accountId) {
                  final account = widget.controller.accountList.firstWhere(
                        (acc) => acc.id == accountId,
                    orElse: () => widget.controller.accountList.first,
                  );
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.primaryColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          account.name ?? '',
                          style: AppTextStyle.labelText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _toggleAccountSelection(accountId),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
        // Account list - wrapped in Obx for reactivity to accountList changes
        Expanded(
          child: Obx(() {
            final filteredAccounts = widget.controller.accountList.where((account) {
              if (_searchText.isEmpty) return true;
              final accountName = account.name ?? '';
              return accountName.toLowerCase().contains(_searchText.toLowerCase());
            }).toList();

            return filteredAccounts.isEmpty
                ? Center(
              child: Text(
                _searchText.isEmpty
                    ? 'هیچ حسابی یافت نشد'
                    : 'نتیجه‌ای یافت نشد',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 14,
                  color: AppColor.textColor.withOpacity(0.6),
                ),
              ),
            )
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.iconViewColor),
              ),
                  child: ListView.builder(
                                itemCount: filteredAccounts.length,
                                itemBuilder: (context, index) {
                  final account = filteredAccounts[index];
                  final isSelected = _selectedAccounts.contains(account.id);

                  return Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,),
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (value) => _toggleAccountSelection(account.id ?? 0),
                        activeColor: AppColor.primaryColor,
                      ),
                      title: Text(
                        account.name ?? '',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      onTap: () => _toggleAccountSelection(account.id ?? 0),
                    ),
                  );
                                },
                              ),
                );
          }),
        ),
      ],
    );
  }
}
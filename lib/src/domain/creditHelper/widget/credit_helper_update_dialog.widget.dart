import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/creditHelper/controller/credit_helper_update.controller.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../domain/account/model/account.model.dart';

class CreditHelperUpdateDialogWidget extends StatefulWidget {
  final int creditHelperId;

  const CreditHelperUpdateDialogWidget({super.key, required this.creditHelperId});

  @override
  State<CreditHelperUpdateDialogWidget> createState() => _CreditHelperUpdateDialogWidgetState();
}

class _CreditHelperUpdateDialogWidgetState extends State<CreditHelperUpdateDialogWidget>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late CreditHelperUpdateController creditHelperUpdateController;

  // For draggable functionality
  Offset _dialogOffset = Offset.zero;

  CreditHelperUpdateController _getOrCreateController() {
    if (Get.isRegistered<CreditHelperUpdateController>()) {
      final controller = Get.find<CreditHelperUpdateController>();
      // Re-initialize with new credit helper ID if different
      if (controller.creditHelperId.value != widget.creditHelperId) {
        Get.delete<CreditHelperUpdateController>(force: true);
        return Get.put(CreditHelperUpdateController());
      }
      return controller;
    } else {
      return Get.put(CreditHelperUpdateController());
    }
  }

  @override
  void initState() {
    super.initState();
    creditHelperUpdateController = _getOrCreateController();
    creditHelperUpdateController.creditHelperId.value = widget.creditHelperId;
    _initializeCreditHelper();
  }

  Future<void> _initializeCreditHelper() async {
    await creditHelperUpdateController.fetchGetOneCreditHelper(widget.creditHelperId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showConfirmDialog() {
    Get.defaultDialog(
      backgroundColor: AppColor.backGroundColor,
      title: 'ویرایش اعتبار',
      titleStyle: AppTextStyle.smallTitleText,
      middleText: "آیا از ویرایش این اعتبار مطمئن هستید؟",
      middleTextStyle: AppTextStyle.bodyText,
      confirm: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor,),
        ),
        onPressed: () async {
          await creditHelperUpdateController.updateCreditHelper();
          if (!creditHelperUpdateController.hasError.value) {
            Get.back();
          }
        },
        child: Text('ویرایش', style: AppTextStyle.bodyText),
      ),
      cancel: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
        onPressed: () => Get.back(),
        child: Text('لغو', style: AppTextStyle.bodyText),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 3),
        Icon(Icons.circle, size: 5, color: AppColor.primaryColor),
        SizedBox(width: 5),
        Text(label, style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor),
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Transform.translate(
      offset: _dialogOffset,
      child: Dialog(
        backgroundColor: AppColor.backGroundColor2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColor.secondaryColor)),
        insetPadding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16, vertical: 24),
        child: Container(
          width: isDesktop ? Get.width * 0.6 : Get.width * 0.95,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.85,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Draggable header
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dialogOffset += details.delta;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColor.backGroundColor2,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.drag_indicator, color: AppColor.textColor.withAlpha(150), size: 20),
                          SizedBox(width: 8),
                          Text('ویرایش اعتبار', style: AppTextStyle.smallTitleText),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          creditHelperUpdateController.clearList();
                          Get.back();
                        },
                        icon: Icon(Icons.close, color: AppColor.textColor),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SingleChildScrollView(
                    child: _buildForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 16, vertical: isDesktop ? 4 : 8),
        decoration: BoxDecoration(
          color: AppColor.secondary50Color.withAlpha(200),
          borderRadius: BorderRadius.circular(12),
          //border: Border.all(color: AppColor.secondaryColor),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Account selection
              _buildLabelCompact('انتخاب کاربر'),
              SizedBox(height: 4),
              creditHelperUpdateController.accountList.isEmpty
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                ),
              )
                  : Container(
                padding: EdgeInsets.only(bottom: 5),
                child: CustomDropdown<AccountModel>(
                  items: creditHelperUpdateController.accountList,
                  selectedItem: creditHelperUpdateController.selectedAccount.value,
                  enableSearch: true,
                  errorText: creditHelperUpdateController.dropdownError.value,
                  itemLabel: (account) => account.name ?? "",
                  onChanged: (account) async {
                    setState(() {
                      creditHelperUpdateController.selectedAccount.value = account;
                      creditHelperUpdateController.dropdownError.value = "";
                    });
                  },
                  isIcon: false,
                ),
              ),

              // Type selection
              _buildLabelCompact('نوع اعتبار'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Obx(() {
                  final creditHelperController = Get.find<CreditHelperUpdateController>();
                  final items = creditHelperController.creditHelperController.typeList.map((type) => type.name ?? '').toList();
                  return CustomDropdownWidget(
                    validator: (value) {
                      if (value == null || value.isEmpty || value == 'انتخاب کنید') {
                        return 'نوع اعتبار را انتخاب کنید';
                      }
                      return null;
                    },
                    items: ['انتخاب کنید', ...items],
                    selectedValue: creditHelperUpdateController.selectedType.value ?? 'انتخاب کنید',
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue != 'انتخاب کنید') {
                        creditHelperUpdateController.selectedType.value = newValue;
                      }
                    },
                    backgroundColor: AppColor.textFieldColor,
                    borderRadius: 7,
                    borderColor: AppColor.secondaryColor,
                    hideUnderline: true,
                  );
                }),
              ),

              // Item selection (optional)
              _buildLabelCompact('محصول'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Obx(() {
                  return CustomDropdownWidget(
                    validator: (value) {
                      if (value == null || value.isEmpty || value == 'انتخاب کنید') {
                        return 'محصول را انتخاب کنید';
                      }
                      return null;
                    },
                    items: [
                      'انتخاب کنید',
                      ...creditHelperUpdateController.itemList.map((item) => item.name ?? '')
                    ],
                    selectedValue: creditHelperUpdateController.selectedItem.value?.name ?? 'انتخاب کنید',
                    onChanged: (String? newValue) {
                      if (newValue == 'انتخاب کنید') {
                        creditHelperUpdateController.selectedItem.value = null;
                      } else {
                        var selectedItem = creditHelperUpdateController.itemList.firstWhere(
                              (item) => item.name == newValue,
                        );
                        creditHelperUpdateController.selectedItem.value = selectedItem;
                      }
                    },
                    backgroundColor: AppColor.textFieldColor,
                    borderRadius: 7,
                    borderColor: AppColor.secondaryColor,
                    hideUnderline: true,
                  );
                }),
              ),

              // Amount input
              _buildLabelCompact('مقدار اعتبار'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا مقدار اعتبار را وارد کنید';
                    }
                    final amount = double.tryParse(value.replaceAll(',', '').toEnglishDigit());
                    if (amount == null || amount <= 0) {
                      return 'مقدار اعتبار باید عدد مثبت باشد';
                    }
                    return null;
                  },
                  controller: creditHelperUpdateController.amountController,
                  style: AppTextStyle.labelText.copyWith(fontSize: 12),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9,.٫]')),
                  ],
                  onChanged: (value) {
                    String cleanedValue = value.replaceAll(',', '');
                    if (cleanedValue.isNotEmpty) {
                      // Handle decimal numbers properly
                      String persianFormatted = cleanedValue.toPersianDigit();
                      // Convert Persian decimal separator to English for proper formatting
                      persianFormatted = persianFormatted.replaceAll('٫', '.');
                      creditHelperUpdateController.amountController.text = persianFormatted.seRagham();
                      creditHelperUpdateController.amountController.selection =
                          TextSelection.collapsed(
                            offset: creditHelperUpdateController.amountController.text.length,
                          );
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColor.textFieldColor,
                  ),
                ),
              ),

              // Active status
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'فعال',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(() => Switch(
                      value: creditHelperUpdateController.isActive.value,
                      onChanged: (value) {
                        creditHelperUpdateController.isActive.value = value;
                      },
                      activeColor: AppColor.primaryColor,
                      inactiveThumbColor: AppColor.accentColor,
                    )),
                  ],
                ),
              ),

              // Date inputs row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('تاریخ شروع (اختیاری)'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            controller: creditHelperUpdateController.startDateController,
                            readOnly: true,
                            style: AppTextStyle.labelText.copyWith(fontSize: 11),
                            textDirection: TextDirection.ltr,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 15, bottom: 15, right: 5, left: 5),
                              suffixIconConstraints: BoxConstraints(minWidth: 25),
                              suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor, size: 17),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: AppColor.textFieldColor,
                              errorMaxLines: 1,
                            ),
                            onTap: () async {
                              // انتخاب تاریخ
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
                                // انتخاب زمان
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedTime != null) {
                                  final formattedDate =
                                      "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                                  final formattedTime =
                                      "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";

                                  creditHelperUpdateController.startDateController.text = "$formattedDate $formattedTime";
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('تاریخ پایان (اختیاری)'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            controller: creditHelperUpdateController.endDateController,
                            readOnly: true,
                            style: AppTextStyle.labelText.copyWith(fontSize: 11),
                            textDirection: TextDirection.ltr,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 15, bottom: 15, right: 5, left: 5),
                              suffixIconConstraints: BoxConstraints(minWidth: 25),
                              suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor, size: 17),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: AppColor.textFieldColor,
                              errorMaxLines: 1,
                            ),
                            onTap: () async {
                              // انتخاب تاریخ
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
                                // انتخاب زمان
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedTime != null) {
                                  final formattedDate =
                                      "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                                  final formattedTime =
                                      "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";

                                  creditHelperUpdateController.endDateController.text = "$formattedDate $formattedTime";
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Description
              _buildLabelCompact('توضیحات (اختیاری)'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  controller: creditHelperUpdateController.descriptionController,
                  maxLines: 3,
                  style: AppTextStyle.labelText,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColor.textFieldColor,
                  ),
                ),
              ),

              // Error widget
              Obx(() => creditHelperUpdateController.hasError.value
                  ? Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            creditHelperUpdateController.errorTitle.value,
                            style: AppTextStyle.bodyText.copyWith(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            creditHelperUpdateController.errorMessage.value,
                            style: AppTextStyle.bodyText.copyWith(
                              color: Colors.red.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => creditHelperUpdateController.clearError(),
                      child: Icon(Icons.close, color: Colors.red.shade600, size: 18),
                    ),
                  ],
                ),
              )
                  : SizedBox.shrink()),

              SizedBox(height: 16),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
                    elevation: WidgetStatePropertyAll(1),
                    backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (creditHelperUpdateController.selectedAccount.value != null) {
                        _showConfirmDialog();
                      } else {
                        creditHelperUpdateController.dropdownError.value = 'لطفا کاربر را انتخاب کنید';
                      }
                    }
                  },
                  child: creditHelperUpdateController.isLoading.value
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                  )
                      : Text(
                    'ویرایش اعتبار',
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLabelCompact(String text) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      padding: EdgeInsets.only(bottom: 3, top: 5),
      child: Text(
        text,
        style: AppTextStyle.labelText.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

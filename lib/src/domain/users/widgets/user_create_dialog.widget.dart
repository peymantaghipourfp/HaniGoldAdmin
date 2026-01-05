import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:hanigold_admin/src/domain/accountSalesGroup/model/account_sales_group.model.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_create_dialog.controller.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

class UserCreateDialogWidget extends StatefulWidget {
  const UserCreateDialogWidget({super.key});

  @override
  State<UserCreateDialogWidget> createState() => _UserCreateDialogWidgetState();
}

class _UserCreateDialogWidgetState extends State<UserCreateDialogWidget>
    with SingleTickerProviderStateMixin {

  late UserCreateDialogController controller;

  // For draggable functionality
  Offset _dialogOffset = Offset.zero;

  UserCreateDialogController _getOrCreateController() {
    if (Get.isRegistered<UserCreateDialogController>()) {
      return Get.find<UserCreateDialogController>();
    } else {
      return Get.put(UserCreateDialogController());
    }
  }

  @override
  void initState() {
    super.initState();
    controller = _getOrCreateController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showConfirmDialog() {
    Get.defaultDialog(
      backgroundColor: AppColor.backGroundColor,
      title: 'ایجاد کاربر جدید',
      titleStyle: AppTextStyle.smallTitleText,
      middleText: "آیا از ایجاد کاربر مطمئن هستید؟",
      middleTextStyle: AppTextStyle.bodyText,
      confirm: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
        ),
        onPressed: () async {
          Get.back(); // Close confirm dialog
          await controller.createUser();
        },
        child: Text('ایجاد', style: AppTextStyle.bodyText),
      ),
      cancel: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
        onPressed: () => Get.back(),
        child: Text('لغو', style: AppTextStyle.bodyText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Transform.translate(
      offset: _dialogOffset,
      child: Dialog(
        backgroundColor: AppColor.backGroundColor2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColor.secondaryColor)
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16, vertical: 24),
        child: Container(
          width: isDesktop ? Get.width * 0.7 : Get.width * 0.95,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.9,
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
                          Text('ایجاد کاربر جدید', style: AppTextStyle.smallTitleText),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          controller.clearForm();
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

    bool isValidNationalCode(String input) {
      final code = input.toEnglishDigit();

      if (!RegExp(r'^\d{10}$').hasMatch(code)) return false;

      final invalidCodes = [
        '0000000000',
        '1111111111',
        '2222222222',
        '3333333333',
        '4444444444',
        '5555555555',
        '6666666666',
        '7777777777',
        '8888888888',
        '9999999999',
      ];

      if (invalidCodes.contains(code)) return false;

      int sum = 0;
      for (int i = 0; i < 9; i++) {
        sum += int.parse(code[i]) * (10 - i);
      }

      int remainder = sum % 11;
      int controlDigit = int.parse(code[9]);

      if (remainder < 2) {
        return controlDigit == remainder;
      } else {
        return controlDigit == (11 - remainder);
      }
    }

    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 16, vertical: isDesktop ? 4 : 8),
        decoration: BoxDecoration(
          color: AppColor.secondary50Color.withAlpha(200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name input
              Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('نام و نام خانوادگی'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            validator: controller.validateName,
                            controller: controller.nameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: AppTextStyle.labelText.copyWith(fontSize: 12),
                            textInputAction: TextInputAction.next,
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
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('کد ملی (اختیاری)'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            controller: controller.nationalCodeController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: AppTextStyle.labelText.copyWith(fontSize: 12),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null; // فیلد اختیاری است
                              }
                              if (!isValidNationalCode(value)) {
                                return 'کد ملی معتبر نیست';
                              }
                              return null;
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
                      ],
                    ),
                  ),
                ],
              ),

              // Username input
              /*_buildLabelCompact('نام کاربری'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  validator: controller.validateUsername,
                  controller: controller.userController,
                  style: AppTextStyle.labelText.copyWith(fontSize: 12),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColor.textFieldColor,
                  ),
                ),
              ),*/

              // Mobile and Phone row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('شماره موبایل'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            validator: controller.validateMobile,
                            controller: controller.mobileController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: AppTextStyle.labelText.copyWith(fontSize: 12),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                            ],
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
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('شماره تلفن (اختیاری)'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            controller: controller.phoneController,
                            style: AppTextStyle.labelText.copyWith(fontSize: 12),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                            ],
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
                      ],
                    ),
                  ),
                ],
              ),

              // Email input
              _buildLabelCompact('ایمیل (اختیاری)'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  validator: controller.validateEmail,
                  controller: controller.emailController,
                  style: AppTextStyle.labelText.copyWith(fontSize: 12),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
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

              // Account Group selection
              _buildLabelCompact('نقش کاربر'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Obx(() {
                  if (controller.accountGroupList.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                      ),
                    );
                  }
                  return CustomDropdownWidget(
                    validator: (value) {
                      if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                        return 'نقش کاربر را انتخاب کنید';
                      }
                      return null;
                    },
                    items: [
                      'انتخاب کنید',
                      ...controller.accountGroupList.map((accountGroup) => accountGroup.name ?? '')
                    ],
                    selectedValue: controller.selectedAccountGroup.value?.name ?? 'انتخاب کنید',
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue != 'انتخاب کنید') {
                        controller.selectedAccountGroup.value = controller.accountGroupList.firstWhere(
                              (accountGroup) => accountGroup.name == newValue,
                        );
                      } else {
                        controller.selectedAccountGroup.value = null;
                      }
                    },
                    backgroundColor: AppColor.textFieldColor,
                    borderRadius: 12,
                    borderColor: AppColor.secondaryColor,
                    hideUnderline: true,
                  );
                }),
              ),

              // Account Sales Group and Account Level row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('گروه قیمت‌گذاری', textColor: Color(0xff5789f5)),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Obx(() {
                            if (controller.accountSalesGroupList.isEmpty) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ),
                              );
                            }
                            return CustomDropdownWidget(
                              validator: (value) {
                                if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                  return 'گروه قیمت‌گذاری را انتخاب کنید';
                                }
                                return null;
                              },
                              items: [
                                'انتخاب کنید',
                                ...controller.accountSalesGroupList.map((salesGroup) => salesGroup.name ?? '')
                              ],
                              selectedValue: controller.selectedAccountSalesGroup.value?.name ?? 'انتخاب کنید',
                              onChanged: (String? newValue) {
                                if (newValue != null && newValue != 'انتخاب کنید') {
                                  controller.selectedAccountSalesGroup.value = controller.accountSalesGroupList.firstWhere(
                                        (salesGroup) => salesGroup.name == newValue,
                                  );
                                } else {
                                  controller.selectedAccountSalesGroup.value = null;
                                }
                              },
                              backgroundColor: AppColor.textFieldColor,
                              borderRadius: 12,
                              borderColor: AppColor.secondaryColor,
                              hideUnderline: true,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('سطح کاربر', textColor: Color(0xff13d595)),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Obx(() {
                            if (controller.accountLevelList.isEmpty) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ),
                              );
                            }
                            return CustomDropdownWidget(
                              validator: (value) {
                                if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                  return 'سطح کاربر را انتخاب کنید';
                                }
                                return null;
                              },
                              items: [
                                'انتخاب کنید',
                                ...controller.accountLevelList.map((level) => level.name ?? '')
                              ],
                              selectedValue: controller.selectedAccountLevel.value?.name ?? 'انتخاب کنید',
                              onChanged: (String? newValue) {
                                if (newValue != null && newValue != 'انتخاب کنید') {
                                  controller.selectedAccountLevel.value = controller.accountLevelList.firstWhere(
                                        (level) => level.name == newValue,
                                  );
                                } else {
                                  controller.selectedAccountLevel.value = null;
                                }
                              },
                              backgroundColor: AppColor.textFieldColor,
                              borderRadius: 12,
                              borderColor: AppColor.secondaryColor,
                              hideUnderline: true,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // State and City row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('استان'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Obx(() {
                            if (controller.stateList.isEmpty) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ),
                              );
                            }
                            return CustomDropdownWidget(
                              validator: (value) {
                                if (value == null || value.isEmpty || value == 'انتخاب کنید') {
                                  return 'استان را انتخاب کنید';
                                }
                                return null;
                              },
                              items: ['انتخاب کنید', ...controller.stateList.map((state) => state.name ?? '')],
                              selectedValue: controller.selectedState.value?.name ?? 'انتخاب کنید',
                              onChanged: (String? newValue) {
                                if (newValue != null && newValue != 'انتخاب کنید') {
                                  controller.selectedState.value = controller.stateList.firstWhere(
                                        (state) => state.name == newValue,
                                  );
                                } else {
                                  controller.selectedState.value = null;
                                }
                              },
                              backgroundColor: AppColor.textFieldColor,
                              borderRadius: 12,
                              borderColor: AppColor.secondaryColor,
                              hideUnderline: true,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelCompact('شهر'),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Obx(() {
                            if (controller.cityList.isEmpty) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ),
                              );
                            }
                            return CustomDropdownWidget(
                              validator: (value) {
                                if (value == null || value.isEmpty || value == 'انتخاب کنید') {
                                  return 'شهر را انتخاب کنید';
                                }
                                return null;
                              },
                              items: ['انتخاب کنید', ...controller.cityList.map((city) => city.name ?? '')],
                              selectedValue: controller.selectedCity.value?.name ?? 'انتخاب کنید',
                              onChanged: (String? newValue) {
                                if (newValue != null && newValue != 'انتخاب کنید') {
                                  controller.selectedCity.value = controller.cityList.firstWhere(
                                        (city) => city.name == newValue,
                                  );
                                } else {
                                  controller.selectedCity.value = null;
                                }
                              },
                              backgroundColor: AppColor.textFieldColor,
                              borderRadius: 12,
                              borderColor: AppColor.secondaryColor,
                              hideUnderline: true,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Address input
              _buildLabelCompact('آدرس (اختیاری)'),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  controller: controller.addressController,
                  maxLines: 3,
                  style: AppTextStyle.labelText.copyWith(fontSize: 12),
                  textInputAction: TextInputAction.next,
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

              // Has Deposit checkbox
              /*Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'امکان برداشت',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(() => Switch(
                      value: controller.hasDeposit.value,
                      onChanged: (value) {
                        controller.hasDeposit.value = value;
                      },
                      activeThumbColor: AppColor.primaryColor,
                      inactiveThumbColor: AppColor.accentColor,
                    )),
                  ],
                ),
              ),*/

              // Error widget
              Obx(() => controller.hasError.value
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
                            controller.errorTitle.value,
                            style: AppTextStyle.bodyText.copyWith(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            controller.errorMessage.value,
                            style: AppTextStyle.bodyText.copyWith(
                              color: Colors.red.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.clearError(),
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
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    if (controller.formKey.currentState!.validate()) {
                      _showConfirmDialog();
                    }
                  },
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                  )
                      : Text(
                    'ایجاد کاربر',
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

  Widget _buildLabelCompact(String text,{Color? textColor}) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      padding: EdgeInsets.only(bottom: 3, top: 5),
      child: Text(
        text,
        style: AppTextStyle.labelText.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: textColor ?? AppColor.textColor),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../controller/update_account_sales_group.controller.dart';

class UpdateAccountSalesGroupView extends GetView<UpdateAccountSalesGroupController> {
  UpdateAccountSalesGroupView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(
        title: 'ویرایش زیرگروه',
        onBackTap: () => Get.back(),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Form(
                key: formKey,
                child: isDesktop ? _buildDesktopView(context) : _buildMobileView(context),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      color: AppColor.appBarColor.withAlpha(130),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildErrorBanner(),
              _buildNameField(isDesktop: true),
              const SizedBox(height: 20),
              // Add-product section (same as insert flow)
              Text(
                'افزودن محصول',
                style: AppTextStyle.labelText.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Column(
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        Expanded(flex: 2, child: _buildItemDropdown(isDesktop: true)),
                        /*const SizedBox(width: 16),
                        Expanded(child: _buildMaxBuyField(isDesktop: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildMaxSellField(isDesktop: true)),*/
                      ]),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildBuyRangeField(isDesktop: true)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildSalesRangeField(isDesktop: true)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.addItemPrice,
                    icon: const Icon(Icons.add),
                    label: const Text('افزودن'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      foregroundColor: AppColor.textColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'محصولات و محدوده‌ها',
                style: AppTextStyle.labelText.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSelectedItemsEditableList(isDesktop: true),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.submitUpdate();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.buttonColor,
                    foregroundColor: AppColor.textColor,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('ثبت ویرایش', style: AppTextStyle.labelText.copyWith(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildErrorBanner(),
            _buildNameField(isDesktop: false),
            const SizedBox(height: 16),
            Text('افزودن محصول',
                style: AppTextStyle.labelText.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildItemDropdown(isDesktop: false),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildBuyRangeField(isDesktop: false)),
              const SizedBox(width: 12),
              Expanded(child: _buildSalesRangeField(isDesktop: false)),
            ]),
            const SizedBox(height: 12),
            /*Row(
              children: [
                Expanded(child: _buildMaxBuyField(isDesktop: false)),
                const SizedBox(width: 12),
                Expanded(child: _buildMaxSellField(isDesktop: false)),
              ],
            ),
            const SizedBox(height: 12),*/
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.addItemPrice,
                icon: const Icon(Icons.add),
                label: const Text('افزودن محصول'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: AppColor.textColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('محصولات و محدوده‌ها',
                style: AppTextStyle.labelText.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildSelectedItemsEditableList(isDesktop: false),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.submitUpdate();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: AppColor.textColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('ثبت ویرایش', style: AppTextStyle.labelText.copyWith(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDropdown({required bool isDesktop}) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محصول',
          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 13 : 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColor.secondary2Color.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.textColor.withAlpha(75)),
          ),
          child: DropdownButtonFormField<dynamic>(
            initialValue: controller.selectedItem.value,
            hint: Text(
              'محصول را انتخاب کنید',
              style: AppTextStyle.bodyText.copyWith(
                color: AppColor.textColor.withAlpha(125),
                fontSize: isDesktop ? 14 : 13,
              ),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isDesktop ? 16 : 14,
              ),
            ),
            style: AppTextStyle.bodyText.copyWith(fontSize: isDesktop ? 14 : 13),
            dropdownColor: AppColor.appBarColor,
            items: controller.availableItems.map((item) {
              return DropdownMenuItem<dynamic>(
                value: item,
                child: Text(item.name ?? 'نامشخص', style: AppTextStyle.bodyText),
              );
            }).toList(),
            onChanged: (value) {
              controller.changeSelectedItem(value);
            },
          ),
        ),
      ],
    ));
  }

  Widget _buildBuyRangeField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('محدوده خرید',
            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 13 : 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.buyRangeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9,-]'))],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            String cleanedValue = value.replaceAll(',', '');
            // Ensure minus sign is only at the start
            if (cleanedValue.contains('-') && !cleanedValue.startsWith('-')) {
              cleanedValue = cleanedValue.replaceAll('-', '');
            }
            if (cleanedValue.isNotEmpty || cleanedValue == '-') {
              final hasMinus = cleanedValue.startsWith('-');
              final digitsOnly = hasMinus ? cleanedValue.substring(1) : cleanedValue;
              if (digitsOnly.isNotEmpty || cleanedValue == '-') {
                final formatted = digitsOnly.toPersianDigit().seRagham();
                controller.buyRangeController.text = hasMinus ? '-$formatted' : formatted;
                controller.buyRangeController.selection =
                    TextSelection.collapsed(offset: controller.buyRangeController.text.length);
              }
            }
          },
          style: AppTextStyle.bodyText.copyWith(fontSize: isDesktop ? 14 : 13),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(125), fontSize: isDesktop ? 14 : 13),
            filled: true,
            fillColor: AppColor.secondary2Color.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.secondary3Color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.accentColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 16 : 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSalesRangeField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('محدوده فروش',
            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 13 : 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.salesRangeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9,-]'))],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            String cleanedValue = value.replaceAll(',', '');
            // Ensure minus sign is only at the start
            if (cleanedValue.contains('-') && !cleanedValue.startsWith('-')) {
              cleanedValue = cleanedValue.replaceAll('-', '');
            }
            if (cleanedValue.isNotEmpty || cleanedValue == '-') {
              final hasMinus = cleanedValue.startsWith('-');
              final digitsOnly = hasMinus ? cleanedValue.substring(1) : cleanedValue;
              if (digitsOnly.isNotEmpty || cleanedValue == '-') {
                final formatted = digitsOnly.toPersianDigit().seRagham();
                controller.salesRangeController.text = hasMinus ? '-$formatted' : formatted;
                controller.salesRangeController.selection =
                    TextSelection.collapsed(offset: controller.salesRangeController.text.length);
              }
            }
          },
          style: AppTextStyle.bodyText.copyWith(fontSize: isDesktop ? 14 : 13),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(130), fontSize: isDesktop ? 14 : 13),
            filled: true,
            fillColor: AppColor.secondary2Color.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.secondary3Color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.accentColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 16 : 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMaxBuyField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('سقف خرید',
            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 13 : 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.maxBuyController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]'))],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            String cleanedValue = value.replaceAll(',', '');
            if (cleanedValue.isNotEmpty) {
              controller.maxBuyController.text = cleanedValue.toPersianDigit().seRagham();
              controller.maxBuyController.selection =
                  TextSelection.collapsed(offset: controller.maxBuyController.text.length);
            }
          },
          style: AppTextStyle.bodyText.copyWith(fontSize: isDesktop ? 14 : 13),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(125), fontSize: isDesktop ? 14 : 13),
            filled: true,
            fillColor: AppColor.secondary2Color.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.secondary3Color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.accentColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 16 : 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMaxSellField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('سقف فروش',
            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 13 : 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.maxSellController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]'))],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            String cleanedValue = value.replaceAll(',', '');
            if (cleanedValue.isNotEmpty) {
              controller.maxSellController.text = cleanedValue.toPersianDigit().seRagham();
              controller.maxSellController.selection =
                  TextSelection.collapsed(offset: controller.maxSellController.text.length);
            }
          },
          style: AppTextStyle.bodyText.copyWith(fontSize: isDesktop ? 14 : 13),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(125), fontSize: isDesktop ? 14 : 13),
            filled: true,
            fillColor: AppColor.secondary2Color.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.secondary3Color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.accentColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 16 : 14),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Obx(() {
      if (controller.errorStatus.value == 'failure') {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.accentColor.withAlpha(40),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.accentColor.withAlpha(140)),
          ),
          child: Row(
            children: [
              SvgPicture.asset('assets/svg/error.svg', height: 20,
                  colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '{"status":"failure","message":"${controller.errorMessage.value ?? ''}","code":"${controller.errorCode.value ?? ''}"}',
                  style: AppTextStyle.bodyText,
                  maxLines: 4,
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildNameField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نام زیرگروه',
            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 14 : 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.nameController,
          style: AppTextStyle.bodyText.copyWith(fontSize: isDesktop ? 14 : 13,),
          decoration: InputDecoration(
            hintText: 'نام زیرگروه را وارد کنید',
            hintStyle: AppTextStyle.bodyText.copyWith(
              color: AppColor.textColor.withAlpha(130),
              fontSize: isDesktop ? 14 : 13,
            ),
            filled: true,
            fillColor: AppColor.secondary2Color.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.secondary3Color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.accentColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 16 : 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '{"status":"failure","message":"لطفا نام زیرگروه را وارد کنید","code":"VALIDATION_NAME"}';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSelectedItemsEditableList({required bool isDesktop}) {
    return Obx(() {
      final items = controller.selectedItemPrices;
      if (items.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.secondary2Color.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.textColor.withAlpha(75)),
          ),
          child: Center(
            child: Text('هیچ محصولی وجود ندارد',
                style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(150))),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColor.secondary2Color.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.textColor.withAlpha(75)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('ویرایش محدوده‌ها (${items.length})',
                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 14 : 13, fontWeight: FontWeight.bold,)),
            ),
            const Divider(height: 1, color: AppColor.dividerColor),
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final itemPrice = entry.value;
              return _buildEditableItemRow(itemPrice, index, isDesktop);
            }),
          ],
        ),
      );
    });
  }

  Widget _buildEditableItemRow(SelectedItemPriceUpdate item, int index, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 14 : 10 ,vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondary100Color, AppColor.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.textColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item.icon}',
                width: 25,
                height: 25,),
              SizedBox(width: 5,),
              Expanded(child: Text(item.itemName , style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 14 : 13, fontWeight: FontWeight.bold,color: AppColor.dividerColor))),
              GestureDetector(
                onTap: () => controller.removeItemPrice(item.itemId ?? 0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColor.accentColor.withAlpha(40),
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/trash-bin.svg',
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor.withAlpha(200),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _buildRangeField(
                label: 'محدوده خرید',
                isDesktop: isDesktop,
                initial: item.buyRange,
                allowNegative: true,
                onChanged: (v) {
                  final cleaned = v.replaceAll(',', '').toEnglishDigit();
                  final parsed = double.tryParse(cleaned);
                  if (parsed != null) item.buyRange = parsed;
                },
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField(
                label: 'محدوده فروش',
                isDesktop: isDesktop,
                initial: item.salesRange,
                allowNegative: true,
                onChanged: (v) {
                  final cleaned = v.replaceAll(',', '').toEnglishDigit();
                  final parsed = double.tryParse(cleaned);
                  if (parsed != null) item.salesRange = parsed;
                },
              )),
            ],
          ),
          /*const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildRangeField(
                label: 'سقف خرید',
                isDesktop: isDesktop,
                initial: item.maxBuy,
                allowNegative: false,
                onChanged: (v) {
                  final cleaned = v.replaceAll(',', '').toEnglishDigit();
                  final parsed = double.tryParse(cleaned);
                  if (parsed != null) item.maxBuy = parsed;
                },
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField(
                label: 'سقف فروش',
                isDesktop: isDesktop,
                initial: item.maxSell,
                allowNegative: false,
                onChanged: (v) {
                  final cleaned = v.replaceAll(',', '').toEnglishDigit();
                  final parsed = double.tryParse(cleaned);
                  if (parsed != null) item.maxSell = parsed;
                },
              )),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget _buildRangeField({
    required String label,
    required bool isDesktop,
    required double initial,
    required bool allowNegative,
    required Function(String) onChanged,
  }) {
    final hasMinus = initial < 0;
    final absValue = hasMinus ? -initial : initial;
    final formatted = absValue.toString().seRagham();
    final controllerLocal = TextEditingController(text: hasMinus ? '-$formatted' : formatted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 13 : 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controllerLocal,
          keyboardType: TextInputType.numberWithOptions(decimal: true, signed: allowNegative),
          inputFormatters: [
            FilteringTextInputFormatter.allow(allowNegative ? RegExp(r'[۰-۹0-9,-]') : RegExp(r'[۰-۹0-9,]')),
          ],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            String cleaned = value.replaceAll(',', '');
            // Ensure minus sign is only at the start if allowed
            if (allowNegative) {
              if (cleaned.contains('-') && !cleaned.startsWith('-')) {
                cleaned = cleaned.replaceAll('-', '');
              }
              if (cleaned.isNotEmpty || cleaned == '-') {
                final hasMinus = cleaned.startsWith('-');
                final digitsOnly = hasMinus ? cleaned.substring(1) : cleaned;
                if (digitsOnly.isNotEmpty || cleaned == '-') {
                  final formatted = digitsOnly.toPersianDigit().seRagham();
                  controllerLocal.text = hasMinus ? '-$formatted' : formatted;
                  controllerLocal.selection = TextSelection.collapsed(offset: controllerLocal.text.length);
                }
              }
            } else {
              if (cleaned.isNotEmpty) {
                controllerLocal.text = cleaned.toPersianDigit().seRagham();
                controllerLocal.selection = TextSelection.collapsed(offset: controllerLocal.text.length);
              }
            }
            onChanged(value);
          },
          style: AppTextStyle.bodyText.copyWith(fontSize: isDesktop ? 14 : 13),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(125), fontSize: isDesktop ? 14 : 13),
            filled: true,
            fillColor: AppColor.secondary2Color.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.textColor.withAlpha(75)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.secondary3Color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.accentColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 16 : 14),
          ),
          validator: (value) {
            final text = (value ?? '').trim();
            if (text.isEmpty) {
              return '{"status":"failure","message":"این فیلد نباید خالی باشد","code":"VALIDATION_EMPTY"}';
            }
            final parsed = double.tryParse(text.replaceAll(',', '').toEnglishDigit());
            if (parsed == null) {
              return '{"status":"failure","message":"عدد معتبر وارد کنید","code":"VALIDATION_NUMBER"}';
            }
            if (!allowNegative && parsed < 0) {
              return '{"status":"failure","message":"عدد منفی مجاز نیست","code":"VALIDATION_NEGATIVE"}';
            }
            return null;
          },
        ),
      ],
    );
  }
}



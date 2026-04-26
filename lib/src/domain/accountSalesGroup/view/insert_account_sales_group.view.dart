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
import '../controller/insert_account_sales_group.controller.dart';

class InsertAccountSalesGroupView extends GetView<InsertAccountSalesGroupController> {
  InsertAccountSalesGroupView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(
        title: 'ایجاد گروه قیمت گذاری',
        onBackTap: () {
          Get.toNamed('/home');
           },
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: Form(
              key: formKey,
              child: isDesktop
                  ? _buildDesktopView(context)
                  : _buildMobileView(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      color: AppColor.appBarColor.withAlpha(130),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            _buildNameField(isDesktop: true),
            const SizedBox(height: 24),

            // Item selection section
            Text(
              'افزودن محصول',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Column(
                  children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildItemDropdown(isDesktop: true),
                        ),
                        /*const SizedBox(width: 16),
                        Expanded(
                          child: _buildMaxBuyField(isDesktop: true),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMaxSellField(isDesktop: true),
                        ),*/
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _buildBuyRangeField(isDesktop: true),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSalesRangeField(isDesktop: true),
                        ),
                        const SizedBox(width: 16),
                         Row(
                            children: [
                              _buildBuyStatusField(isDesktop: true),
                              const SizedBox(width: 16),
                              _buildSellStatusField(isDesktop: true),
                            ],
                          ),

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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Selected items list
            Obx(() => controller.selectedItemPrices.isEmpty
                ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.secondary2Color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.textColor.withAlpha(75)),
              ),
              child: Center(
                child: Text(
                  'هیچ محصولی اضافه نشده است',
                  style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.textColor.withAlpha(150),
                  ),
                ),
              ),
            )
                : _buildSelectedItemsList(isDesktop: true)),
            const SizedBox(height: 32),

            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: AppColor.textColor,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'ثبت گروه قیمت گذاری',
                  style: AppTextStyle.labelText.copyWith(fontSize: 16),
                ),
              ),
            ),
          ],
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
            // Name field
            _buildNameField(isDesktop: false),
            const SizedBox(height: 20),

            // Item selection section
            Text(
              'افزودن محصول',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildItemDropdown(isDesktop: false),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildBuyRangeField(isDesktop: false),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSalesRangeField(isDesktop: false),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildBuyStatusField(isDesktop: false),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSellStatusField(isDesktop: false),
                ),
              ]
            ),
            const SizedBox(height: 12),

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Selected items list
            Obx(() => controller.selectedItemPrices.isEmpty
                ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.secondary2Color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.textColor.withAlpha(75)),
              ),
              child: Center(
                child: Text(
                  'هیچ محصولی اضافه نشده است',
                  style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.textColor.withAlpha(150),
                    fontSize: 12,
                  ),
                ),
              ),
            )
                : _buildSelectedItemsList(isDesktop: false)),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: AppColor.textColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'ثبت گروه قیمت گذاری',
                  style: AppTextStyle.labelText.copyWith(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نام گروه قیمت گذاری',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.nameController,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktop ? 14 : 13,
          ),
          decoration: InputDecoration(
            hintText: 'نام گروه را وارد کنید',
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isDesktop ? 16 : 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'لطفا نام گروه را وارد کنید';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildItemDropdown({required bool isDesktop}) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محصول',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.bold,
          ),
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
            hint: Text('محصول را انتخاب کنید', style: AppTextStyle.bodyText.copyWith(
              color: AppColor.textColor.withAlpha(125),
              fontSize: isDesktop ? 14 : 13,
            ),),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isDesktop ? 16 : 14,
              ),
            ),
            style: AppTextStyle.bodyText.copyWith(
              fontSize: isDesktop ? 14 : 13,
            ),
            dropdownColor: AppColor.appBarColor,
            items: controller.availableItems.map((item) {
              return DropdownMenuItem<dynamic>(
                value: item,
                child: Text(item.name ?? 'نامشخص' , style: AppTextStyle.bodyText,),
              );
            }).toList(),
            onChanged: (value) {
              controller.changeSelectedItem(value);
            },
            validator: (value) {
              // This is optional validation, as we validate in addItemPrice
              return null;
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
        Text(
          'محدوده خرید',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.buyRangeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9,-]')),
          ],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            // حذف کاماهای قبلی و فرمت جدید
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
                    TextSelection.collapsed(
                        offset: controller.buyRangeController.text.length);
              }
            }
          },
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktop ? 14 : 13,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: AppTextStyle.bodyText.copyWith(
              color: AppColor.textColor.withAlpha(125),
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isDesktop ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSalesRangeField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محدوده فروش',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.salesRangeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9,-]')),
          ],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            // حذف کاماهای قبلی و فرمت جدید
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
                    TextSelection.collapsed(
                        offset: controller.salesRangeController.text.length);
              }
            }
          },
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktop ? 14 : 13,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isDesktop ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellStatusField({required bool isDesktop}) {
    return Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("وضعیت فروش", style: AppTextStyle.labelText.copyWith(
                fontSize: 11, color: AppColor.textColor)),
            Transform.scale(
              scale: 0.75,
              child: Switch(
                value: controller.sellStatus.value,
                onChanged: (value) {
                  controller.changeSellStatus(value);
                },
                activeThumbColor: AppColor.primaryColor,
                inactiveThumbColor: AppColor.accentColor,
                activeTrackColor: AppColor.primaryColor.withAlpha(100),
                inactiveTrackColor: AppColor.accentColor.withAlpha(100),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildBuyStatusField({required bool isDesktop}) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("وضعیت خرید", style: AppTextStyle.labelText.copyWith(
              fontSize: 11, color: AppColor.textColor)),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: controller.buyStatus.value,
              onChanged: (value) {
                controller.changeBuyStatus(value);
              },
              activeThumbColor: AppColor.primaryColor,
              inactiveThumbColor: AppColor.accentColor,
              activeTrackColor: AppColor.primaryColor.withAlpha(100),
              inactiveTrackColor: AppColor.accentColor.withAlpha(100),
            ),
          ),
        ],
      );
    }
    );
  }

  /*Widget _buildMaxBuyField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سقف خرید',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.maxBuyController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
          ],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            String cleanedValue = value.replaceAll(',', '');
            if (cleanedValue.isNotEmpty) {
              controller.maxBuyController.text = cleanedValue.toPersianDigit().seRagham();
              controller.maxBuyController.selection =
                  TextSelection.collapsed(offset: controller.maxBuyController.text.length);
            }
          },
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktop ? 14 : 13,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isDesktop ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }*/

  /*Widget _buildMaxSellField({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سقف فروش',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.maxSellController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
          ],
          textDirection: TextDirection.ltr,
          onChanged: (value) {
            String cleanedValue = value.replaceAll(',', '');
            if (cleanedValue.isNotEmpty) {
              controller.maxSellController.text = cleanedValue.toPersianDigit().seRagham();
              controller.maxSellController.selection =
                  TextSelection.collapsed(offset: controller.maxSellController.text.length);
            }
          },
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktop ? 14 : 13,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isDesktop ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }*/

  Widget _buildSelectedItemsList({required bool isDesktop}) {
    return Obx(() => Container(
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
            child: Text(
              'محصولات انتخاب شده (${controller.selectedItemPrices.length})',
              style: AppTextStyle.labelText.copyWith(
                fontSize: isDesktop ? 15 : 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColor.dividerColor),
          ...controller.selectedItemPrices.asMap().entries.map((entry) {
            final index = entry.key;
            final itemPrice = entry.value;
            return _buildSelectedItemCard(itemPrice, index, isDesktop);
          }),
        ],
      ),
    ));
  }

  Widget _buildSelectedItemCard(dynamic itemPrice, int index, bool isDesktop) {
    return Container(
      margin: EdgeInsets.all(isDesktop ? 8 : 2),
      padding: EdgeInsets.all(isDesktop ? 16 : 5),
      decoration: BoxDecoration(
        color: AppColor.appBarColor.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.textColor.withAlpha(50)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${itemPrice.icon}',
                      width: 25,
                      height: 25,),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Text(
                        itemPrice.itemName,
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: isDesktop ? 14 : 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.removeItemPrice(itemPrice.itemId),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'محدوده خرید: ',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: AppColor.textColor.withAlpha(175),
                      ),
                    ),
                    Text(
                      (itemPrice.buyRange ?? 0 ) < 0 ? "${itemPrice.buyRange?.abs().toString().seRagham() ?? '0'}-" :  itemPrice.buyRange?.toString().seRagham() ?? '0',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'ریال',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: AppColor.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 25),
                    Text(
                      'محدوده فروش: ',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: AppColor.textColor.withAlpha(175),
                      ),
                    ),
                    Text(
                      (itemPrice.salesRange ?? 0) < 0 ? "${itemPrice.salesRange?.abs().toString().seRagham() ?? '0'}-" : itemPrice.salesRange?.toString().seRagham() ?? '0',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'ریال',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: AppColor.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'وضعیت خرید: ',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: AppColor.textColor.withAlpha(175),
                      ),
                    ),
                    Text(
                      itemPrice.buyStatus==true ? "فعال" : "غیر فعال",
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: itemPrice.buyStatus==true ? AppColor.primaryColor : AppColor.accentColor,
                      ),
                    ),
                    const SizedBox(width: 25),
                    Text(
                      'وضعیت فروش: ',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: AppColor.textColor.withAlpha(175),
                      ),
                    ),
                    Text(
                      itemPrice.sellStatus==true ? "فعال" : "غیر فعال",
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: isDesktop ? 12 : 11,
                        color: itemPrice.sellStatus==true ? AppColor.primaryColor : AppColor.accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_edit.controller.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/product/widget/buy_range.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/max_sell.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_different.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_sell.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/sale_range.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../widget/max_buy.widget.dart';

class ProductEditView extends StatefulWidget {
  const ProductEditView({super.key});

  @override
  State<ProductEditView> createState() => _ProductEditViewState();
}

class _ProductEditViewState extends State<ProductEditView> {
  final GlobalKey<MaxSellWidgetState> _maxSellKey = GlobalKey<MaxSellWidgetState>();
  final GlobalKey<MaxBuyWidgetState> _maxBuyKey = GlobalKey<MaxBuyWidgetState>();
  final GlobalKey<SaleRangeWidgetState> _saleRangeKey = GlobalKey<SaleRangeWidgetState>();
  final GlobalKey<BuyRangeWidgetState> _buyRangeKey = GlobalKey<BuyRangeWidgetState>();
  //final GlobalKey<PriceSellWidgetState> _priceSellKey = GlobalKey<PriceSellWidgetState>();
  final GlobalKey<PriceDifferentWidgetState> _priceDifferentKey = GlobalKey<PriceDifferentWidgetState>();

  ProductEditController productEditController = Get.find<ProductEditController>();
  late ItemModel item;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar1(
        title: 'ویرایش محصول',
        onBackTap: () => Get.back(),
      ),
      drawer: const AppDrawer(),
      body: Obx(() {
        if (productEditController.getOneItem.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        final item = productEditController.getOneItem.value!;
        final isMobile = Get.width < 600;
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgHaniGold.png'),
              fit: BoxFit.contain,
              opacity: 0.06,
            ),
          ),
          child: Center(
            child: Container(
              width: isMobile ? Get.width * 0.95 : Get.width * 0.55,
              padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(

                          onPressed: () {
                            Get.offNamed('/productUpdatePrice');
                          },
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: isMobile ? 25 : 50,
                                    vertical: 15
                                ),),
                              elevation: WidgetStatePropertyAll(5),
                              backgroundColor:
                              WidgetStatePropertyAll(AppColor.buttonColor),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10)))),
                          child: Text(
                            'لیست محصولات', style: AppTextStyle.bodyText,),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildToggle('قابل خرید و فروش کاربر',(val) => productEditController.buySellSwitch.value = val,),
                      _buildTextField('عنوان',productEditController.itemNameController,true),
                      _buildTextField('دسته بندی',productEditController.itemGroupNameController,true),
                      _buildTextField('واحد',productEditController.itemUnitNameController,true),
                      _buildTextFieldNum('وزن ۷۵۰ (برای دسته بندی سکه)'.toString(),productEditController.w750Controller,false),
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildToggle('وضعیت اجرت',(val) => productEditController.hasWageSwitch.value = val,),
                                  ],
                                ),
                                 productEditController.hasWageSwitch.value==true ?
                                _buildTextFieldNumber('اجرت' ,productEditController.wageController,false) : SizedBox.shrink(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildToggle('وضعیت کارتخوان',(val) => productEditController.hasCardSwitch.value = val,),
                                  ],
                                ),
                                 productEditController.hasCardSwitch.value==true ?
                                _buildTextFieldNumber('مبلغ افزاینده' ,productEditController.cardPriceController,false) : SizedBox.shrink(),
                              ],
                            ),
                          )
                        ],
                      ),
                      _buildTextFieldNumber('موجودی ابتدای دوره (اختیاری)',productEditController.initBalanceController,true),
                      /*_buildToggle('مرجع دارد', (val) => productEditController.hasRefrenceSwitch.value = val),
                      if (productEditController.hasRefrenceSwitch.value)
                        _buildReferenceDropdown(),*/
                      _buildToggle('وضعیت فروش',(val) => productEditController.sellStateSwitch.value = val,),
                      _buildMaxSellEditorRow('سقف فروش', item),
                      _buildSalesRangeEditorRow('محدوده فروش', item),
                      //_buildSellPriceEditorRow('قیمت فروش ریال', item),
                      _buildDifferentPriceEditorRow('تفاوت قیمت خرید و فروش', item),
                      _buildToggle('وضعیت خرید',(val) => productEditController.buyStateSwitch.value = val,),
                      _buildMaxBuyEditorRow('سقف خرید', item),
                      _buildBuyRangeEditorRow('محدوده خرید', item),
                      //_buildBuyPriceRow('قیمت خرید ریال', "${((item.mesghalPrice ?? 0) - (item.mesghalDifferentPrice ?? 0)).toStringAsFixed(0).seRagham(separator: ',')} ریال "),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildToggle('اعشار پذیر', (val) => productEditController.isDecimalSwitch.value = val,),
                          _buildToggle('نمایش به مشتری',(val) => productEditController.showMarketSwitch.value = val,),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                              _priceDifferentKey.currentState?.submitDifferentPrice(showSnackbar: false);
                              _maxSellKey.currentState?.submitMaxSell(showSnackbar: false);
                              _maxBuyKey.currentState?.submitMaxBuy(showSnackbar: false);
                              _saleRangeKey.currentState?.submitSaleRange(showSnackbar: false);
                              _buyRangeKey.currentState?.submitBuyRange(showSnackbar: false);
                              //_priceSellKey.currentState?.submitPrice(showSnackbar: false);
                              await productEditController.updateItem();
                              Get.offNamed('/productUpdatePrice');
                          },
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15
                                ),),
                              elevation: WidgetStatePropertyAll(5),
                              backgroundColor:
                              WidgetStatePropertyAll(AppColor.primaryColor),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10)))),
                          child: Text(
                            'ویرایش محصول', style: AppTextStyle.bodyText,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  /*Widget _buildSellPriceEditorRow(String label, ItemModel item) {
    String price = item.mesghalPrice.toString().replaceAll(
        RegExp(r'[^0-9]'), '');
    List<String> parts = [];
    String remaining = price;
    int count = 0;
    while (remaining
        .isNotEmpty &&
        count < 3) {
      int end = remaining
          .length;
      int start = end -
          3;
      if (start < 0)
        start = 0;
      String part = remaining
          .substring(
          start, end);
      parts.add(part);
      remaining =
          remaining
              .substring(
              0,
              start);
      count++;
    }
    String price1 = parts
        .isNotEmpty
        ? parts[0]
        : '';
    String price2 = parts
        .length >= 2
        ? parts[1]
        : '';
    String price3 = parts
        .length >= 3
        ? parts[2]
        : '';
    String price4 = remaining;
    if (label == 'قیمت فروش ریال') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.bodyText),
            PriceSellWidget(
              key: _priceSellKey,
              price1: price1,
              price2: price2,
              price3: price3,
              price4: price4,
              mesghalDifferent: item.mesghalDifferentPrice ?? 0,
              id: item.id!,
              itemUnitId: item.itemUnit?.id ?? 0,

            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }*/

  Widget _buildDifferentPriceEditorRow(String label, ItemModel item) {
    String differentPrice = item
        .mesghalDifferentPrice
        .toString()
        .replaceAll(
        RegExp(
            r'[^0-9]'),
        '');
    List<
        String> parts = [
    ];
    String remaining = differentPrice;
    int count = 0;
    while (remaining
        .isNotEmpty &&
        count < 3) {
      int end = remaining
          .length;
      int start = end -
          3;
      if (start < 0)
        start = 0;
      String part = remaining
          .substring(
          start, end);
      parts.add(part);
      remaining =
          remaining
              .substring(
              0,
              start);
      count++;
    }
    String differentPrice1 = parts
        .isNotEmpty
        ? parts[0]
        : '0';
    String differentPrice2 = parts
        .length >= 2
        ? parts[1]
        : '0';
    String differentPrice3 = parts
        .length >= 3
        ? parts[2]
        : '0';
    if (label == 'تفاوت قیمت خرید و فروش') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.bodyText),
            PriceDifferentWidget(
              key: _priceDifferentKey,
              differentPrice1: differentPrice1,
              differentPrice2: differentPrice2,
              differentPrice3: differentPrice3,
              mesghalPrice: item
                  .mesghalPrice ?? 0,
              id: item
                  .id!,
              itemUnitId: item.itemUnit?.id ?? 0,
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildMaxBuyEditorRow(String label, ItemModel item) {
    String maxBuy = item
        .maxBuy
        .toString();
    if (label == 'سقف خرید') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.bodyText),
            MaxBuyWidget(
              key: _maxBuyKey,
              maxBuy: maxBuy,
              maxSell: item.maxSell ?? 0,
              saleRange: item.salesRange ?? 0,
              buyRange: item.buyRange ?? 0,
              id: item.id!,

            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildMaxSellEditorRow(String label, ItemModel item) {
    String maxSell = item
        .maxSell
        .toString();
    if (label == 'سقف فروش') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.bodyText),
            MaxSellWidget(
              key: _maxSellKey,
              maxSell: maxSell,
              maxBuy: item.maxBuy ?? 0,
              saleRange: item.salesRange ?? 0,
              buyRange: item.buyRange ?? 0,
              id: item.id!,

            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildSalesRangeEditorRow(String label, ItemModel item) {
    String salesRange = item
        .salesRange
        .toString();
    if (label == 'محدوده فروش') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.bodyText),
            SaleRangeWidget(
              key: _saleRangeKey,
              maxSell: item.maxSell ?? 0,
              maxBuy: item.maxBuy ?? 0,
              salesRange: salesRange,
              buyRange: item.buyRange ?? 0,
              id: item.id!,
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildBuyRangeEditorRow(String label, ItemModel item) {
    String buyRange = item
        .buyRange
        .toString();
    if (label == 'محدوده خرید') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.bodyText),
            BuyRangeWidget(
              key: _buyRangeKey,
              maxBuy: item.maxBuy ?? 0,
              maxSell: item.maxSell ?? 0,
              saleRange: item.salesRange ?? 0,
              buyRange: buyRange,
              id: item.id!,
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildBuyPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.bodyText),
          SizedBox(
            width: 100,
            child: Text(
              value,
              style: AppTextStyle.bodyText,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildW750Field(String label, String initialValue1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.bodyText),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: _buildTextField('', initialValue1,productEditController.w750Controller),
              ),
            ],
          )
        ],
      ),
    );
  }*/

  Widget _buildTextField(String label,TextEditingController controller,bool readOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        style: AppTextStyle.bodyText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyle.labelText,
          filled: true,
          fillColor: AppColor.backGroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
  Widget _buildTextFieldNum(String label,TextEditingController controller,bool readOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
            String newText = newValue.text
                .replaceAll(
                '٠', '0')
                .replaceAll(
                '١', '1')
                .replaceAll(
                '٢', '2')
                .replaceAll(
                '٣', '3')
                .replaceAll(
                '٤', '4')
                .replaceAll(
                '٥', '5')
                .replaceAll(
                '٦', '6')
                .replaceAll(
                '٧', '7')
                .replaceAll(
                '٨', '8')
                .replaceAll(
                '٩', '9');
            return newValue.copyWith(text: newText,
                selection: TextSelection.collapsed(offset: newText.length));
          }),
        ],
        style: AppTextStyle.bodyText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyle.labelText,
          filled: true,
          fillColor: AppColor.backGroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldNumber(String label,TextEditingController controller,bool readOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
        ],
        style: AppTextStyle.bodyText,
        onChanged: (value) {
          // حذف کاماهای قبلی و فرمت جدید
          String cleanedValue = value
              .replaceAll(',', '');
          if (cleanedValue.isNotEmpty) {
            controller.text = cleanedValue
                .toPersianDigit()
                .seRagham();
            controller.selection =
                TextSelection.collapsed(
                    offset: controller.text.length);
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyle.labelText,
          filled: true,
          fillColor: AppColor.backGroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(String label, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.bodyText),
          SizedBox(width: 5,),
          Obx(() {
            return Switch(
              value: productEditController.getSwitchValue(label),
              onChanged: onChanged,
              activeColor: AppColor.buttonColor,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReferenceDropdown() {
    return Obx(() {
      if (productEditController.refrenceList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CustomDropdownWidget(
          items: productEditController.refrenceList.map((item) => item.name ?? '').toList(),
          selectedValue: productEditController.refrenceList.firstWhereOrNull((item) => item.id == productEditController.selectedRefrenceId.value)?.name,
          onChanged: (newValue) {
            final selectedItem = productEditController.refrenceList.firstWhereOrNull((item) => item.name == newValue);
            if (selectedItem != null) {
              productEditController.selectedRefrenceId.value = selectedItem.id;
              print("selectedReferenceId:::${productEditController.selectedRefrenceId.value}");
            }
          },
          backgroundColor: AppColor
              .textFieldColor,
          borderRadius: 7,
          borderColor: AppColor
              .secondaryColor,
          hideUnderline: true,
        ),
      );
    });
  }
}
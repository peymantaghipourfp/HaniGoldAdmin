import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_edit.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';


class SaleRangeWidget extends StatefulWidget {
  final int maxSell;
  final int maxBuy;
  final String salesRange;
  final double buyRange;
  final int id;
  const SaleRangeWidget({
    super.key, required this.maxSell, required this.maxBuy, required this.salesRange, required this.buyRange, required this.id,
  });

  @override
  State<SaleRangeWidget> createState() => SaleRangeWidgetState();
}

class SaleRangeWidgetState extends State<SaleRangeWidget> {
  TextEditingController saleRangeController = TextEditingController();
  late FocusNode focusNode1;
  String? initialSaleRange;

  ProductEditController productController = Get.find<ProductEditController>();
  bool isLoading=false;
  bool isSubmitting = false;

  @override
  void initState() {
    saleRangeController.text = widget.salesRange.toString().seRagham(separator: ',');
    focusNode1 = FocusNode();
    setupFocusListeners();

    super.initState();
  }

  void setupFocusListeners() {
    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        initialSaleRange = saleRangeController.text;
      } else {
        if (!isSubmitting) {
          if (saleRangeController.text != initialSaleRange && saleRangeController.text.isEmpty) {
            saleRangeController.text = widget.salesRange.toString().seRagham(separator: ',');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    focusNode1.dispose();
    super.dispose();
  }

  Future<void> submitSaleRange({bool showSnackbar = true}) async {
    if (isSubmitting || isLoading) return;
    isSubmitting = true;
    setState(() => isLoading = true);
    //EasyLoading.show(status: 'منتظر بمانید...');
    try {
      await productController.updateItemRange(
        widget.id,
        widget.maxSell,
        widget.maxBuy,
        double.parse(saleRangeController.text ==""?"0" : saleRangeController.text.replaceAll(',', '').toEnglishDigit()),
        widget.buyRange,
        showSnackbar: showSnackbar,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      isSubmitting = false;
      //EasyLoading.dismiss();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Get.width < 600;
    return Row(
      children: [
        isLoading ?
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor)) :
        SizedBox(height: 27,width: isMobile ? 40 : 45,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 4)),
                elevation: WidgetStatePropertyAll(5),
                backgroundColor:
                WidgetStatePropertyAll(AppColor.primaryColor),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            onPressed: () => submitSaleRange(showSnackbar: true),
            child: Text(
              'تایید',
              style: AppTextStyle.labelText,
            ),

          ),
        ),
        SizedBox(width: 3,),
        SizedBox(
          height: 35,
          width: isMobile ? 90 : 130,
          child: Padding(
            padding: const EdgeInsets.only(top: 3,bottom: 1),
            child: TextFormField(
              controller: saleRangeController,
              focusNode: focusNode1,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.number,
              inputFormatters: [
                //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
              ],
              style: AppTextStyle.labelText,
              onFieldSubmitted: (value) => submitSaleRange(showSnackbar: true),
              onTap: () {
                saleRangeController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: saleRangeController.text.length,
                );
              },
              onChanged: (value) {
                // حذف کاماهای قبلی و فرمت جدید
                String cleanedValue = value
                    .replaceAll(',', '');
                if (cleanedValue.isNotEmpty) {
                  saleRangeController.text =
                      cleanedValue
                          .toPersianDigit()
                          .seRagham();
                  saleRangeController.selection =
                      TextSelection.collapsed(
                          offset: saleRangeController.text.length);
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                filled: true,
                fillColor: AppColor.backGroundColor,
                counterText: '',
                hoverColor: AppColor.textFieldColor,
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );

  }
}
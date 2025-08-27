import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_edit.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';


class BuyRangeWidget extends StatefulWidget {
  final int maxSell;
  final int maxBuy;
  final double saleRange;
  final String buyRange;
  final int id;
  const BuyRangeWidget({
    super.key, required this.maxSell, required this.maxBuy, required this.saleRange, required this.buyRange, required this.id,
  });

  @override
  State<BuyRangeWidget> createState() => BuyRangeWidgetState();
}

class BuyRangeWidgetState extends State<BuyRangeWidget> {
  TextEditingController buyRangeController = TextEditingController();
  late FocusNode focusNode1;
  String? initialBuyRange;

  ProductEditController productController = Get.find<ProductEditController>();
  bool isLoading=false;
  bool isSubmitting = false;

  @override
  void initState() {
    buyRangeController.text = widget.buyRange.toString().seRagham(separator: ',');
    focusNode1 = FocusNode();
    setupFocusListeners();

    super.initState();
  }

  void setupFocusListeners() {
    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        initialBuyRange = buyRangeController.text;
      } else {
        if (!isSubmitting) {
          if (buyRangeController.text != initialBuyRange && buyRangeController.text.isEmpty) {
            buyRangeController.text = widget.buyRange.toString().seRagham(separator: ',');
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

  Future<void> submitBuyRange({bool showSnackbar = true}) async {
    if (isSubmitting || isLoading) return;
    isSubmitting = true;
    setState(() => isLoading = true);
    //EasyLoading.show(status: 'منتظر بمانید...');
    try {
      await productController.updateItemRange(
        widget.id,
        widget.maxSell,
        widget.maxBuy,
        widget.saleRange,
        double.parse(buyRangeController.text ==""?"0" : buyRangeController.text.replaceAll(',', '').toEnglishDigit()),
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
            onPressed:() => submitBuyRange(showSnackbar: true),
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
              controller: buyRangeController,
              focusNode: focusNode1,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.number,
              inputFormatters: [
                //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
              ],
              style: AppTextStyle.labelText,
              onFieldSubmitted: (value) => submitBuyRange(showSnackbar: true),
              onTap: () {
                buyRangeController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: buyRangeController.text.length,
                );
              },
              onChanged: (value) {
                // حذف کاماهای قبلی و فرمت جدید
                String cleanedValue = value
                    .replaceAll(',', '');
                if (cleanedValue.isNotEmpty) {
                  buyRangeController.text = cleanedValue.toPersianDigit().seRagham();
                  buyRangeController.selection =
                      TextSelection.collapsed(
                          offset: buyRangeController.text.length);
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
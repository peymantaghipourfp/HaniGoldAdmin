import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_edit.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';


class MaxBuyWidget extends StatefulWidget {
  final String maxBuy;
  final int maxSell;
  final double saleRange;
  final double buyRange;
  final int id;
  const MaxBuyWidget({
    super.key, required this.maxBuy, required this.maxSell, required this.saleRange, required this.buyRange, required this.id,
  });

  @override
  State<MaxBuyWidget> createState() => MaxBuyWidgetState();
}

class MaxBuyWidgetState extends State<MaxBuyWidget> {
  TextEditingController maxBuyController = TextEditingController();
  late FocusNode focusNode1;
  String? initialMaxBuy;

  ProductEditController productController = Get.find<ProductEditController>();
  bool isLoading=false;
  bool isSubmitting = false;

  @override
  void initState() {
    maxBuyController.text = widget.maxBuy;
    focusNode1 = FocusNode();
    setupFocusListeners();

    super.initState();
  }

  void setupFocusListeners() {
    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        initialMaxBuy = maxBuyController.text;
      } else {
        if (!isSubmitting) {
          if (maxBuyController.text != initialMaxBuy &&
              (maxBuyController.text== '0000' ||maxBuyController.text== '000' ||maxBuyController.text== '00' ||maxBuyController.text=='0' || maxBuyController.text.isEmpty)) {
            maxBuyController.text = widget.maxBuy;
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

  Future<void> submitMaxBuy({bool showSnackbar = true}) async {
    if (isSubmitting || isLoading) return;
    isSubmitting = true;
    setState(() => isLoading = true);
    //EasyLoading.show(status: 'منتظر بمانید...');
    try {
      await productController.updateItemRange(
        widget.id,
        widget.maxSell,
        int.parse(
          (
              maxBuyController.text.length==1 ? '000${maxBuyController.text}':maxBuyController.text.length==2 ? '00${maxBuyController.text}':maxBuyController.text.length==3 ? '0${maxBuyController.text}':maxBuyController.text
          ).toEnglishDigit(),
        ),
        widget.saleRange,
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
            onPressed: () => submitMaxBuy(showSnackbar: true),
            child: Text(
              'تایید',
              style: AppTextStyle.labelText,
            ),

          ),
        ),
        SizedBox(width: 3,),
        SizedBox(
          height: 35,
          width: isMobile ? 55 : 70,
          child: Padding(
            padding: const EdgeInsets.only(top: 3,bottom: 1),
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 4,
              controller: maxBuyController,
              focusNode: focusNode1,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyle.labelText,
              onFieldSubmitted: (value) => submitMaxBuy(showSnackbar: true),
              onTap: () {
                maxBuyController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: maxBuyController.text.length,
                );
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
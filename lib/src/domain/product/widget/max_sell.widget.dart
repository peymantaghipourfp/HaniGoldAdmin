import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';


class MaxSellWidget extends StatefulWidget {
  final String maxSell;
  final int maxBuy;
  final double saleRange;
  final double buyRange;
  final int id;
  const MaxSellWidget({
    super.key, required this.maxSell, required this.maxBuy, required this.saleRange, required this.buyRange, required this.id,
  });

  @override
  State<MaxSellWidget> createState() => _MaxSellWidgetState();
}

class _MaxSellWidgetState extends State<MaxSellWidget> {
  TextEditingController maxSellController = TextEditingController();
  late FocusNode focusNode1;
  String? initialMaxSell;

  ProductController productController = Get.find<ProductController>();
  bool isLoading=false;
  bool isSubmitting = false;

  @override
  void initState() {
    maxSellController.text = widget.maxSell;
    focusNode1 = FocusNode();
    setupFocusListeners();

    super.initState();
  }

  void setupFocusListeners() {
    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        initialMaxSell = maxSellController.text;
      } else {
        if (!isSubmitting) {
          if (maxSellController.text != initialMaxSell &&
              (maxSellController.text== '0000' ||maxSellController.text== '000' ||maxSellController.text== '00' ||maxSellController.text=='0' || maxSellController.text.isEmpty)) {
            maxSellController.text = widget.maxSell;
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

  Future<void> submitMaxSell() async {
    if (isSubmitting || isLoading) return;
    isSubmitting = true;
    setState(() => isLoading = true);
    //EasyLoading.show(status: 'منتظر بمانید...');
    try {
      await productController.updateItemRange(
        widget.id,
        int.parse(
          (
              maxSellController.text.length==1 ? '000${maxSellController.text}':maxSellController.text.length==2 ? '00${maxSellController.text}':maxSellController.text.length==3 ? '0${maxSellController.text}':maxSellController.text
          ).toEnglishDigit(),
        ),
        widget.maxBuy,
        widget.saleRange,
        widget.buyRange,
      );
      //productController.clearList();
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
    return Row(
      children: [
        isLoading ?
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor)) :
        SizedBox(height: 27,width: 45,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 4)),
                elevation: WidgetStatePropertyAll(5),
                backgroundColor:
                WidgetStatePropertyAll(AppColor.primaryColor),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            onPressed:submitMaxSell,
            child: Text(
              'تایید',
              style: AppTextStyle.labelText,
            ),

          ),
        ),
        SizedBox(width: 3,),
        SizedBox(
          height: 28,
          width: 60,
          child: TextFormField(
            maxLength: 4,
            controller: maxSellController,
            focusNode: focusNode1,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTextStyle.labelText,
            onFieldSubmitted: (value) => submitMaxSell(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              counterText: '',
              hoverColor: AppColor.backGroundColor,
              isDense: true,
            ),
          ),
        ),
      ],
    );

  }
}
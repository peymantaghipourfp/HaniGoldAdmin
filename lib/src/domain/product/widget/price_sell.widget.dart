import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';


class PriceSellWidget extends StatefulWidget {
  final String price1;
  final String price2;
  final String price3;
  final String price4;
  final double different;
  final int id;

  const PriceSellWidget({

    super.key, required this.price1, required this.price2, required this.price3, required this.price4, required this.different, required this.id,
  });


  @override
  State<PriceSellWidget> createState() => _PriceSellWidgetState();
}

class _PriceSellWidgetState extends State<PriceSellWidget> {
  TextEditingController priceController1 = TextEditingController();
  TextEditingController priceController2 = TextEditingController();
  TextEditingController priceController3 = TextEditingController();
  TextEditingController priceController4 = TextEditingController();

  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  late FocusNode focusNode4;

  String? initialPrice1;
  String? initialPrice2;
  String? initialPrice3;
  String? initialPrice4;

  ProductController productController = Get.find<ProductController>();
  bool isLoading=false;
  bool isSubmitting = false;

  @override
  void initState() {
    priceController1.text = widget.price1;
    priceController2.text = widget.price2;
    priceController3.text = widget.price3;
    priceController4.text = widget.price4;

    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();

    setupFocusListeners();

    super.initState();
  }

  void setupFocusListeners() {
    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        initialPrice1 = priceController1.text;
      } else {
        if (!isSubmitting) {
          if (priceController1.text != initialPrice1 &&
              (priceController1.text== '00' ||priceController1.text=='0' || priceController1.text.isEmpty)) {
            priceController1.text = '000';
          }
        }
      }
    });
    focusNode2.addListener(() {
      if (focusNode2.hasFocus) {
        initialPrice2 = priceController2.text;
      } else {
        if (!isSubmitting) {
          if (priceController2.text != initialPrice2 &&
              (priceController2.text== '00' ||priceController2.text=='0' || priceController2.text.isEmpty)) {
            priceController2.text = '000';
          }
        }
      }
    });

    focusNode3.addListener(() {
      if (focusNode3.hasFocus) {
        initialPrice3 = priceController3.text;
      } else {
        if (!isSubmitting) {
          if (priceController3.text != initialPrice3 &&
              (priceController3.text== '00' ||priceController3.text=='0' || priceController3.text.isEmpty)) {
            priceController3.text = '000';
          }
        }
      }
    });

    focusNode4.addListener(() {
      if (focusNode4.hasFocus) {
        initialPrice4 = priceController4.text;
      } else {
        if (!isSubmitting) {
          if (priceController4.text != initialPrice4 &&
              (priceController4.text== '00' ||priceController4.text=='0' || priceController4.text.isEmpty)) {
            priceController4.text = '000';
          }
        }
      }
    });
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }

  Future<void> submitPrice() async {
    if (isSubmitting || isLoading) return;
    isSubmitting = true;
    setState(() => isLoading = true);
    //EasyLoading.show(status: 'منتظر بمانید...');
    try {
      await productController.insertPriceItem(
        widget.id,
        double.parse(
          (
              "${priceController4.text.length==1 ? '00${priceController4.text}':priceController4.text.length==2 ? '0${priceController4.text}':priceController4.text}"
              "${priceController3.text.length==1 ? '00${priceController3.text}':priceController3.text.length==2 ? '0${priceController3.text}':priceController3.text}"
              "${priceController2.text.length==1 ? '00${priceController2.text}':priceController2.text.length==2 ? '0${priceController2.text}':priceController2.text}"
              "${priceController1.text.length==1 ? '00${priceController1.text}':priceController1.text.length==2 ? '0${priceController1.text}':priceController1.text}"
          ).toEnglishDigit(),
        ),
        widget.different,
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
              onPressed:submitPrice,
              child: Text(
                'تایید',
                style: AppTextStyle.labelText,
              ),

            ),
          ),
          SizedBox(width: 3,),
          SizedBox(
            height: 28,
            width: 45,
            child: TextFormField(
              maxLength: 3,
              controller: priceController1,
              focusNode: focusNode1,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyle.labelText,
              onFieldSubmitted: (value) => submitPrice(),
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
          SizedBox(
            height: 28,
            width: 45,
            child: TextFormField(
              maxLength: 3,
              controller: priceController2,
              focusNode: focusNode2,
              style: AppTextStyle.labelText,
              onFieldSubmitted: (value) => submitPrice(),
              textInputAction: TextInputAction.search,
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
          SizedBox(
            height: 28,
            width: 45,
            child: TextFormField(
              maxLength: 3,
              controller: priceController3,
              focusNode: focusNode3,
              style: AppTextStyle.labelText,
              onFieldSubmitted: (value) => submitPrice(),
              textInputAction: TextInputAction.search,
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
          SizedBox(
            height: 28,
            width: 45,
            child: TextFormField(
              maxLength: 3,
              controller: priceController4,
              focusNode: focusNode4,
              style: AppTextStyle.labelText,
              onFieldSubmitted: (value) => submitPrice(),
              textInputAction: TextInputAction.search,
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/product.controller.dart';


class PriceDifferentWidget extends StatefulWidget {
  final String differentPrice1;
  final String differentPrice2;
  final String differentPrice3;
  final double price;
  final int id;

  const PriceDifferentWidget({

    super.key, required this.differentPrice1, required this.differentPrice2, required this.differentPrice3, required this.price, required this.id,
  });


  @override

  State<PriceDifferentWidget> createState() => _PriceDifferentWidgetState();
}

class _PriceDifferentWidgetState extends State<PriceDifferentWidget> {
  TextEditingController differentPriceController1=TextEditingController();
  TextEditingController differentPriceController2=TextEditingController();
  TextEditingController differentPriceController3=TextEditingController();

  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;

  String initialDifferentPrice1 = '';
  String initialDifferentPrice2 = '';
  String initialDifferentPrice3 = '';

  ProductController productController=Get.find<ProductController>();
  bool isLoading=false;
  bool isSubmitting = false;

  @override
  void initState() {
    differentPriceController1.text=widget.differentPrice1;
    differentPriceController2.text=widget.differentPrice2;
    differentPriceController3.text=widget.differentPrice3;

    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    setupFocusListeners();

    super.initState();
  }
  void setupFocusListeners() {
    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        initialDifferentPrice1 = differentPriceController1.text;
      } else {
        if (!isSubmitting) {
          if (differentPriceController1.text != initialDifferentPrice1 &&
          (differentPriceController1.text== '00' ||differentPriceController1.text=='0' || differentPriceController1.text.isEmpty)) {
            differentPriceController1.text = '000';
          }
        }
      }
    });
    focusNode2.addListener(() {
      if (focusNode2.hasFocus) {
        initialDifferentPrice2 = differentPriceController2.text;
      } else {
        if (!isSubmitting) {
          if (differentPriceController2.text != initialDifferentPrice2 &&
              (differentPriceController2.text== '00' ||differentPriceController2.text=='0' || differentPriceController2.text.isEmpty)) {
            differentPriceController2.text = '000';
          }
        }
      }
    });

    focusNode3.addListener(() {
      if (focusNode3.hasFocus) {
        initialDifferentPrice3 = differentPriceController3.text;
      } else {
        if (!isSubmitting) {
          if (differentPriceController3.text != initialDifferentPrice3 &&
              (differentPriceController3.text== '00' ||differentPriceController3.text=='0' || differentPriceController3.text.isEmpty)) {
            differentPriceController3.text = '000';
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
    super.dispose();
  }

  Future<void> submitDifferentPrice() async {
    if (isSubmitting || isLoading) return;

    isSubmitting = true;
    setState(() => isLoading = true);

    try {
      await productController.insertDifferentPriceItem(
        widget.id,
        double.parse(
          ("${differentPriceController3.text}${differentPriceController2.text}"
              "${differentPriceController1.text}")
              .toEnglishDigit(),
        ),
        widget.price,
      );
    } finally {
      setState(() => isLoading = false);
      isSubmitting = false;
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
        SizedBox(height: 29,width: 50,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 4)),
                elevation: WidgetStatePropertyAll(5),
                backgroundColor:
                WidgetStatePropertyAll(AppColor.primaryColor),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            onPressed: submitDifferentPrice,
            child: Text(
              'تایید',
              style: AppTextStyle.labelText,
            ),

          ),
        ),
        SizedBox(width: 3,),
        SizedBox(
          height: 30,
          width: 50,
          child: TextFormField(
            maxLength: 3,
            controller: differentPriceController1,
            focusNode: focusNode1,
            style: AppTextStyle.labelText,
            onFieldSubmitted: (value) => submitDifferentPrice(),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              counterText: '',
            ),
          ),
        ),
        SizedBox(
          height: 30,
          width: 50,
          child: TextFormField(
            maxLength: 3,
            controller: differentPriceController2,
            focusNode: focusNode2,
            style: AppTextStyle.labelText,
            onFieldSubmitted: (value) => submitDifferentPrice(),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              counterText: '',
            ),
          ),
        ),
        SizedBox(
          height: 30,
          width: 50,
          child: TextFormField(
            maxLength: 3,
            controller: differentPriceController3,
            focusNode: focusNode3,
            style: AppTextStyle.labelText,
            onFieldSubmitted: (value) => submitDifferentPrice(),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }
}
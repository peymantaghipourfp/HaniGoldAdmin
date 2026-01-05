import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_edit.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../model/item.model.dart';


class PriceSellWidget extends StatefulWidget {
  final String price1;
  final String price2;
  final String price3;
  final String price4;
  final double mesghalDifferent;
  final int id;
  final int itemUnitId;
  final Refrence? refrence;

  const PriceSellWidget({

    super.key, required this.price1, required this.price2, required this.price3, required this.price4, required this.mesghalDifferent, required this.id, required this.itemUnitId, required this.refrence
  });


  @override
  State<PriceSellWidget> createState() => PriceSellWidgetState();
}

class PriceSellWidgetState extends State<PriceSellWidget> {
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
  void didUpdateWidget(covariant PriceSellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if props changed (e.g., from socket update)
    // Only update if the user is not currently editing (no focus on any field)
    bool userIsEditing = focusNode1.hasFocus || focusNode2.hasFocus ||
        focusNode3.hasFocus || focusNode4.hasFocus;

    if (!userIsEditing && !isSubmitting) {
      // Check if any price prop changed
      if (widget.price1 != oldWidget.price1 ||
          widget.price2 != oldWidget.price2 ||
          widget.price3 != oldWidget.price3 ||
          widget.price4 != oldWidget.price4) {
        // Update text controllers with new values
        priceController1.text = widget.price1;
        priceController2.text = widget.price2;
        priceController3.text = widget.price3;
        priceController4.text = widget.price4;

        // Reset initial values for validation
        initialPrice1 = widget.price1;
        initialPrice2 = widget.price2;
        initialPrice3 = widget.price3;
        initialPrice4 = widget.price4;
      }
    }
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }

  double _buildPrice(String p1, String p2, String p3, String p4) {
    String formattedP4 = p4.length == 1 ? '00$p4' : p4.length == 2 ? '0$p4' : p4;
    String formattedP3 = p3.length == 1 ? '00$p3' : p3.length == 2 ? '0$p3' : p3;
    String formattedP2 = p2.length == 1 ? '00$p2' : p2.length == 2 ? '0$p2' : p2;
    String formattedP1 = p1.length == 1 ? '00$p1' : p1.length == 2 ? '0$p1' : p1;

    return double.parse('$formattedP4$formattedP3$formattedP2$formattedP1'.toEnglishDigit());
  }

  bool _validatePriceChange() {

    String oldP1 = initialPrice1 ?? widget.price1;
    String oldP2 = initialPrice2 ?? widget.price2;
    String oldP3 = initialPrice3 ?? widget.price3;
    String oldP4 = initialPrice4 ?? widget.price4;

    double oldPrice = _buildPrice(oldP1, oldP2, oldP3, oldP4);
    print("oldPrice::::::${oldPrice}");


    double newPrice = _buildPrice(
      priceController1.text,
      priceController2.text,
      priceController3.text,
      priceController4.text,
    );
    print("newPrice::::::${newPrice}");

    if (oldPrice == 0) return true;

    double percentageDifference = ((newPrice - oldPrice).abs() / oldPrice) * 100;

    print("percentageDifference::::::${percentageDifference}");

    if (percentageDifference > 5) {
      // ریست oldPrice
      setState(() {
        priceController1.text = oldP1;
        priceController2.text = oldP2;
        priceController3.text = oldP3;
        priceController4.text = oldP4;
      });
      EasyLoading.showError(
        'تغییر قیمت بیش از 5 درصد مجاز نیست',
        duration: Duration(seconds: 3),
        maskType: EasyLoadingMaskType.custom,
      );
      return false;
    }
    return true;
  }

  void _resetPricesToOldAndShowError(String message) {
    // در سناریوی خطای سرور (مثل کد 3006)، منظور از "حالت قبل"
    // آخرین قیمتی است که از سمت سرور/props آمده است، نه مقدار فوکوس قبلی.
    setState(() {
      priceController1.text = widget.price1;
      priceController2.text = widget.price2;
      priceController3.text = widget.price3;
      priceController4.text = widget.price4;
    });

    EasyLoading.showError(
      message,
      duration: Duration(seconds: 3),
      maskType: EasyLoadingMaskType.custom,
    );
  }

  Future<void> submitPrice({bool showSnackbar = true}) async {
    if (isSubmitting || isLoading) return;
    // Validate price change before submission
    if (!_validatePriceChange()) {
      return;
    }
    isSubmitting = true;
    setState(() => isLoading = true);
    //EasyLoading.show(status: 'منتظر بمانید...');
    try {
      double newPrice = _buildPrice(
        priceController1.text,
        priceController2.text,
        priceController3.text,
        priceController4.text,
      );
      final response = await productController.insertPriceItem(
        widget.id,
        /*double.parse(
          (
              "${priceController4.text.length==1 ? '00${priceController4.text}':priceController4.text.length==2 ? '0${priceController4.text}':priceController4.text}"
              "${priceController3.text.length==1 ? '00${priceController3.text}':priceController3.text.length==2 ? '0${priceController3.text}':priceController3.text}"
              "${priceController2.text.length==1 ? '00${priceController2.text}':priceController2.text.length==2 ? '0${priceController2.text}':priceController2.text}"
              "${priceController1.text.length==1 ? '00${priceController1.text}':priceController1.text.length==2 ? '0${priceController1.text}':priceController1.text}"
          ).toEnglishDigit(),
        ),*/
        newPrice,
        widget.mesghalDifferent,
        widget.itemUnitId,
        showSnackbar: showSnackbar,
      );
      // Handle server-side validation errors based on info.code (e.g., 3006)
      if (response != null) {
        final infos = response['infos'];
        if (infos is List && infos.isNotEmpty) {
          final rawInfo = infos.first;
          if (rawInfo is Map<String, dynamic>) {
            final dynamic code = rawInfo['code'];
            final String description = rawInfo['description']?.toString() ?? '';

            if (code == 3006) {
              _resetPricesToOldAndShowError(description);
              return;
            }
          }
        }
      }
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
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: isDesktop ?
      Row(
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
                    widget.refrence==null ? WidgetStatePropertyAll(AppColor.primaryColor) : WidgetStatePropertyAll(AppColor.iconViewColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  widget.refrence==null ?
                    submitPrice(showSnackbar: true):
                      SizedBox.shrink();
                },
                child: Text(
                  'تایید',
                  style: AppTextStyle.labelText,
                ),
      
              ),
            ),
            SizedBox(width: 3,),
            FocusTraversalOrder(
              order: const NumericFocusOrder(4),
              child: SizedBox(
                height: 35,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 1),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    controller: priceController1,
                    focusNode: focusNode1,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyle.labelText,
                    onFieldSubmitted: (value) => submitPrice(showSnackbar: true),
                    onTap: () {
                      priceController1.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: priceController1.text.length,
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
            ),
            SizedBox(width: 1,),
            FocusTraversalOrder(
              order: const NumericFocusOrder(3),
              child: SizedBox(
                height: 35,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 1),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    controller: priceController2,
                    focusNode: focusNode2,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyle.labelText,
                    onFieldSubmitted: (value) => submitPrice(),
                    onTap: () {
                      priceController2.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: priceController2.text.length,
                      );
                    },
                    textInputAction: TextInputAction.search,
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
            ),
            SizedBox(width: 1,),
            FocusTraversalOrder(
              order: const NumericFocusOrder(2),
              child: SizedBox(
                height: 35,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 1),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    controller: priceController3,
                    focusNode: focusNode3,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyle.labelText,
                    onFieldSubmitted: (value) => submitPrice(),
                    /*onTap: () {
                      priceController3.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: priceController3.text.length,
                      );
                    },*/
                    textInputAction: TextInputAction.search,
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
            ),
            SizedBox(width: 1,),
            FocusTraversalOrder(
              order: const NumericFocusOrder(1),
              child: SizedBox(
                height: 35,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 1),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    controller: priceController4,
                    focusNode: focusNode4,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyle.labelText,
                    onFieldSubmitted: (value) => submitPrice(),
                    onTap: () {
                      priceController4.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: priceController4.text.length,
                      );
                    },
                    textInputAction: TextInputAction.search,
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
            ),
          ],
        ):
      Column(
        children: [
          Row(
            children: [
              FocusTraversalOrder(
                order: const NumericFocusOrder(4),
                child: SizedBox(
                  height: 40,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3,bottom: 1),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      controller: priceController1,
                      focusNode: focusNode1,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTextStyle.labelText,
                      onFieldSubmitted: (value) => submitPrice(showSnackbar: true),
                      onTap: () {
                        priceController1.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: priceController1.text.length,
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
              ),
              SizedBox(width: 1,),
              FocusTraversalOrder(
                order: const NumericFocusOrder(3),
                child: SizedBox(
                  height: 40,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3,bottom: 1),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      controller: priceController2,
                      focusNode: focusNode2,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTextStyle.labelText,
                      onFieldSubmitted: (value) => submitPrice(),
                      onTap: () {
                        priceController2.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: priceController2.text.length,
                        );
                      },
                      textInputAction: TextInputAction.search,
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
              ),
              SizedBox(width: 1,),
              FocusTraversalOrder(
                order: const NumericFocusOrder(2),
                child: SizedBox(
                  height: 40,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3,bottom: 1),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      controller: priceController3,
                      focusNode: focusNode3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTextStyle.labelText,
                      onFieldSubmitted: (value) => submitPrice(),
                      /*onTap: () {
                          priceController3.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: priceController3.text.length,
                          );
                        },*/
                      textInputAction: TextInputAction.search,
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
              ),
              SizedBox(width: 1,),
              FocusTraversalOrder(
                order: const NumericFocusOrder(1),
                child: SizedBox(
                  height: 40,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3,bottom: 1),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      controller: priceController4,
                      focusNode: focusNode4,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTextStyle.labelText,
                      onFieldSubmitted: (value) => submitPrice(),
                      onTap: () {
                        priceController4.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: priceController4.text.length,
                        );
                      },
                      textInputAction: TextInputAction.search,
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
              ),
            ],
          ),
          SizedBox(height: 5,),
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
                  widget.refrence==null ? WidgetStatePropertyAll(AppColor.primaryColor) : WidgetStatePropertyAll(AppColor.iconViewColor),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
              onPressed: () {
                widget.refrence==null ?
                submitPrice(showSnackbar: true):
                SizedBox.shrink();
              },
              child: Text(
                'تایید',
                style: AppTextStyle.labelText,
              ),

            ),
          ),
        ],
      ),
    );

  }
}
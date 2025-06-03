import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/auth.controller.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  var controller=Get.find<AuthController>() ;
  final _textEditingController = TextEditingController();
  late Timer _timer;
  int _start = 90;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Material(
      color: Colors.transparent,
      child: AlertDialog(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('فراموشی رمز عبور',
            style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor)),
        content: SizedBox(
          height: Get.height * 0.5,width: Get.width * 0.3,
          child: Column(
            children: [
              controller.isForget.value==false?
              Column(
                children: [
                  const SizedBox(height: 24),
                  // وارد کردن شماره موبایل
                  TextFormField(
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: isDesktop ? 14 : 12,
                    ),
                    textDirection: TextDirection.rtl,
                    controller: controller.mobileController,
                    autofillHints: [AutofillHints.username],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 20 : 16,
                        horizontal: 16,
                      ),
                      labelText: 'شماره موبایل',
                      labelStyle: TextStyle(color: AppColor.textColor),
                      hintText: '09xxxxxxxxx',
                      hintStyle: TextStyle(color: AppColor.textColor.withAlpha(50)),

                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.phone_android_rounded),
                      prefixIconColor: AppColor.textColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),

                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'لطفا شماره موبایل را وارد کنید';
                      }
                      return null;
                    },
                  ),
                ],
              ):
              Column(
                children: [
                  const SizedBox(height: 24),
                  const SizedBox(height: 30),
                  Text(
                    "کد تایید ارسال شده را وارد نمایید",
                    style: context.textTheme.titleMedium!
                        .copyWith(
                        color:
                        AppColor.textColor,fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // Text(
                  //   "09120353798",
                  //   style: context.textTheme.titleMedium!
                  //       .copyWith(
                  //       color:
                  //       AppColor.textColor,fontSize: 18),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 40,
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      onCompleted: (value) {
                        controller.code.value = value;
                      },
                      enableActiveFill: true,

                      //  backgroundColor: AppColor.textColor,
                      controller: _textEditingController,
                      keyboardType: TextInputType.number,
                      mainAxisAlignment: MainAxisAlignment.center,
                      autoDisposeControllers: false,
                      appContext: context,
                      length: 5,
                      autoFocus: false,
                      animationType: AnimationType.slide,
                      showCursor: true,
                      pinTheme: PinTheme(
                        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
                        inactiveColor: AppColor.backGroundColor1,
                        selectedColor: AppColor.secondary2Color,
                        activeColor: AppColor.secondary2Color,
                        inactiveFillColor: AppColor.appBarColor,
                        activeFillColor:AppColor.secondary3Color,
                        selectedFillColor: AppColor.appBarColor,
                        borderWidth: 0,
                        fieldWidth: 60,
                        fieldHeight: 60,
                        shape: PinCodeFieldShape.box,
                        errorBorderColor: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onChanged: (String value) {},
                    ),
                  ),
                  _start==0? GestureDetector(
                    onTap: (){
                      setState(() {
                        _start=90;
                        startTimer();
                      });
                    },
                    child: Text(" ارسال دوباره کد ...",
                      style: context.textTheme.bodyMedium!.copyWith(color: AppColor.textColor,fontSize: 13),),
                  ): Text("$_start ثانیه ",
                    style: context.textTheme.titleMedium!.copyWith(color: AppColor.textColor,fontSize: 16),),
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('انصراف',
                style: TextStyle(color: AppColor.primaryColor)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('دریافت کد',
                style: TextStyle(color: Colors.white)),
            onPressed: ()  {
              controller.isForget.value?controller.forgetPasswordVerify(context):controller.forgetPasswordMobile();
              setState(() {


              });
            },
          ),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/auth/controller/auth.controller.dart';


class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () async {
            // خروج از اپلیکیشن
            await FlutterExitApp.exitApp();
          },
          child: Text(
            'خروج',
            style: AppTextStyle.bodyText.copyWith(
              color: Colors.red, fontSize: 14,fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      backgroundColor: AppColor.backGroundColor,

      body: SafeArea(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Container(
              width: Get.width,
              height: Get.height * .38,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: Image
                          .asset('assets/images/logo.png')
                          .image),
              ),
            ),
            ],
                ),*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('صفحه ورود',
                      style: AppTextStyle.mediumTitleText),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1, left: 17, right: 17),
                  child: Divider(color: AppColor.buttonColor, height: 1,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 15),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                                hintText: 'لطفا شماره موبایل خود را وارد کنید',
                                hintStyle: AppTextStyle.bodyText,
                                labelStyle: AppTextStyle.labelText,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                              ),
                              //validator: (value) {},
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 30),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                                hintText: 'لطفا پسورد خود را وارد کنید',
                                hintStyle: AppTextStyle.bodyText,
                                labelStyle: AppTextStyle.labelText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                                ),
                              ),
                              //validator: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttonColor,
                minimumSize: Size(150, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              onPressed: (){
                  Get.toNamed('/home');
                },
              child: Text('ورود',style: AppTextStyle.bodyText,
              ),
            ),
              ],

            ),
          )
      ),
    );
  }
}

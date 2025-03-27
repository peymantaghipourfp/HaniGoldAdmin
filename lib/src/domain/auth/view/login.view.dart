import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/auth/controller/auth.controller.dart';


class LoginView extends GetView<AuthController> {
   LoginView({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/svg/exit.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                AppColor.accentColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => FlutterExitApp.exitApp(),
          ),
        ],
      ),
      backgroundColor: AppColor.backGroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // هدر
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),
                      Text(
                        'به سیستم مدیریت هانی گلد خوش آمدید',
                        style: AppTextStyle.smallTitleText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Login Form
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                    'ورود به حساب کاربری',
                    style: AppTextStyle.largeBodyTextBold.copyWith(fontSize: 18)
                  ),
                  const SizedBox(height: 32),

                  // وارد کردن شماره موبایل
                  TextFormField(
                    style: AppTextStyle.bodyText,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
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

                    const SizedBox(height: 24),

                    // وارد کردن پسورد
                    TextFormField(
                      style: AppTextStyle.bodyText,
                      textDirection: TextDirection.rtl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'رمز عبور',
                        labelStyle: TextStyle(color: AppColor.textColor),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        prefixIconColor: AppColor.textColor,

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفا رمز عبور را وارد کنید';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // فراموشی پسورد
                    /*Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'رمز عبور را فراموش کرده‌اید؟',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),*/

                    const SizedBox(height: 32),

                    // دکمه ورود
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: AppColor.buttonColor,
                        ),
                        onPressed: () {
                          Get.toNamed('/home');
                          /*if (formKey.currentState!.validate()) {
                            Get.toNamed('/home');
                          }*/
                        },
                        child: Text(
                          'ورود',
                          style: AppTextStyle.mediumTitleText,
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

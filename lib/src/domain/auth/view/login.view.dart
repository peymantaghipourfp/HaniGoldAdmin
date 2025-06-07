import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/auth/controller/auth.controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'forget_password.view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final formKey = GlobalKey<FormState>();
  var controller=Get.find<AuthController>() ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: isDesktop ? null : AppBar(
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
            child: ResponsiveRowColumn(
              layout: isDesktop
                  ? ResponsiveRowColumnType.ROW
                  : ResponsiveRowColumnType.COLUMN,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              rowMainAxisAlignment: MainAxisAlignment.center,
              children: [
                // هدر
                if(isDesktop) ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          'به سیستم مدیریت حانی گلد خوش آمدید',
                          style: AppTextStyle.smallTitleText.copyWith(fontSize: isDesktop ? 24 : 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // Login Form
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: isDesktop
                        ? const EdgeInsets.all(40)
                        : const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(!isDesktop) Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  Text(
                                    'به سیستم مدیریت حانی گلد خوش آمدید',
                                    style: AppTextStyle.smallTitleText,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                                'ورود به حساب کاربری',
                                style: AppTextStyle.largeBodyTextBold.copyWith(fontSize: 18)
                            ),
                            const SizedBox(height: 32),

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

                            const SizedBox(height: 24),

                            // وارد کردن پسورد
                            TextFormField(
                              style: AppTextStyle.bodyText.copyWith(
                                fontSize: isDesktop ? 14 : 12,
                              ),
                              textDirection: TextDirection.rtl,
                              controller: controller.passwordController,
                              autofillHints: [AutofillHints.password],
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: isDesktop ? 20 : 16,
                                  horizontal: 16,
                                ),
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Get.dialog(
                                      ForgetPasswordPage());
                                  setState(() {

                                  });
                                },
                                child: Text(
                                  'رمز عبور را فراموش کرده‌اید؟',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),

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
                                  // if (formKey.currentState!.validate()) {
                                  //   controller.login();
                                  // }
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
                    ),
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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/routes/route_page.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  EasyLoading.init();
  configLoading();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse,PointerDeviceKind.touch,PointerDeviceKind.stylus,PointerDeviceKind.trackpad,},
      ),
      builder: (context, child) {
        child = ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 500, name: MOBILE,),
            const Breakpoint(start: 501, end: 700, name: TABLET),
            const Breakpoint(start: 701, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
        return EasyLoading.init()(context, child);
      },

      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: AppColor.backGroundColor),
        scaffoldBackgroundColor: AppColor.backGroundColor1,
        iconTheme: IconThemeData(color: AppColor.textColor),
          scrollbarTheme: ScrollbarThemeData().copyWith(
            thumbColor: WidgetStateProperty.all(AppColor.dividerColor),
          )
      ),
      debugShowCheckedModeBanner: false,
      getPages: RoutePage.routePage,
      initialRoute: '/splash',
      textDirection: TextDirection.rtl,
      locale: const Locale("fa","IR"),
      supportedLocales: [
        Locale("fa", "IR"),
        Locale("en", ""),
      ],
      fallbackLocale: Locale("fa", "IR"),
      localizationsDelegates: [
        PersianMaterialLocalizations.delegate,
        PersianCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColor.accentColor
    ..backgroundColor = AppColor.secondary3Color
    ..indicatorColor = AppColor.backGroundColor1
    ..textColor = AppColor.backGroundColor1
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..textStyle=AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor1,fontWeight: FontWeight.bold)
    ..userInteractions = true
    ..dismissOnTap = false;
}

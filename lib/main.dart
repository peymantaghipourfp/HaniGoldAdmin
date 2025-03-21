import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/routes/route_page.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{
  runApp(const MyApp());
  await GetStorage.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: AppColor.backGroundColor),
        scaffoldBackgroundColor: AppColor.backGroundColor,
        iconTheme: IconThemeData(color: AppColor.textColor),
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


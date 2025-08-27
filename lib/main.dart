import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/config/routes/route_page.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:hanigold_admin/src/widget/zoom_wrapper.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  EasyLoading.init();
  configLoading();
  await Get.putAsync(() async => SocketService(),permanent: true);
  Get.put(HomeController(), permanent: true);
  // Initialize web tab service for right-click functionality
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize socket connection for new tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSocketForNewTab();
    });
  }

  Future<void> _initializeSocketForNewTab() async {
    try {
      final box = GetStorage();
      final userId = box.read('id');
      final token = box.read('Authorization');

      // Only initialize socket if user is logged in
      if (userId != null && token != null) {
        final socketService = Get.find<SocketService>();
        await socketService.initializeForNewTab();
      } else {
        print('User not logged in, skipping socket initialization');
      }
    } catch (e) {
      print('Error initializing socket for new tab: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes for socket connection
    final socketService = Get.find<SocketService>();
    switch (state) {
      case AppLifecycleState.resumed:
        socketService.onAppLifecycleChanged('resumed');
        break;
      case AppLifecycleState.paused:
        socketService.onAppLifecycleChanged('paused');
        break;
      case AppLifecycleState.inactive:
        socketService.onAppLifecycleChanged('inactive');
        break;
      case AppLifecycleState.detached:
        socketService.onAppLifecycleChanged('detached');
        break;
      case AppLifecycleState.hidden:
      // Handle hidden state if needed
        break;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse,PointerDeviceKind.touch,PointerDeviceKind.stylus,PointerDeviceKind.trackpad,},
      ),
      builder: (context, child) {
        final responsiveChild = ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 500, name: MOBILE,),
            const Breakpoint(start: 501, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
        final easyLoadingChild = EasyLoading.init()(context, responsiveChild);
        return ZoomWrapper(child: easyLoadingChild);
      },

      theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: AppColor.backGroundColor),
          scaffoldBackgroundColor: AppColor.backGroundColor1,
          iconTheme: IconThemeData(color: AppColor.textColor),
          scrollbarTheme: ScrollbarThemeData().copyWith(
            thumbColor: WidgetStateProperty.all(AppColor.dividerColor),
          ),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.white.withOpacity(0.4),
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

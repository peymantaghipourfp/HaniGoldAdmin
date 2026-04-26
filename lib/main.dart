import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/config/logger/app_logger.dart';
import 'package:hanigold_admin/src/config/routes/route_page.dart';
import 'package:hanigold_admin/src/config/tear_off_context.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:hanigold_admin/src/widget/zoom_wrapper.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  EasyLoading.init();
  configLoading();
  await Get.putAsync(() async => SocketService(),permanent: true);
  Get.put(HomeController(), permanent: true);

  String initialRoute = '/splash';
  for (final arg in args) {
    if (arg.startsWith('--route=')) {
      initialRoute = arg.substring('--route='.length);
      break;
    }
  }

  // Parse tear-off args so the new window displays only that tab.
  for (final arg in args) {
    if (arg == '--tear-off') {
      tearOffRoute = initialRoute;
      break;
    }
  }
  for (final arg in args) {
    if (arg.startsWith('--tab-title=')) {
      tearOffTitle = arg.substring('--tab-title='.length);
      break;
    }
  }
  for (final arg in args) {
    if (arg.startsWith('--tab-icon=')) {
      tearOffIconCodePoint = int.tryParse(arg.substring('--tab-icon='.length));
      break;
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialRoute = '/splash'});

  final String initialRoute;

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
        AppLogger.w('User not logged in, skipping socket initialization');
      }
    } catch (e,s) {
      AppLogger.e('Error initializing socket for new tab:',e,s);
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
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
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
      ),

      theme: ThemeData(
          fontFamily: "IranSansR",
          appBarTheme: AppBarTheme(backgroundColor: AppColor.backGroundColor),
          scaffoldBackgroundColor: AppColor.backGroundColor1,
          iconTheme: IconThemeData(color: AppColor.textColor),
          scrollbarTheme: ScrollbarThemeData().copyWith(
            thumbColor: WidgetStateProperty.all(AppColor.secondaryColor.withAlpha(200)),
          ),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.white.withAlpha(100),
          ),
      ),
      debugShowCheckedModeBanner: false,
      getPages: RoutePage.routePage,
      initialRoute: widget.initialRoute,
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
    ..errorWidget = Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.errorColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.error,
        color: AppColor.appBarColor,
        size: 38,
      ),
    )
    ..indicatorColor = AppColor.backGroundColor1
    ..textColor = AppColor.backGroundColor1
    ..maskColor = AppColor.secondary200Color.withAlpha(60)
    ..textStyle=AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor1,fontWeight: FontWeight.bold)
    ..userInteractions = true
    ..dismissOnTap = true;
}

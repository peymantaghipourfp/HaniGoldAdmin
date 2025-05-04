import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/splash/controller/splash.controller.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import 'package:get/get.dart';

import '../../../widget/background_image.widget.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});
  final SplashController splashController=Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondaryColor),),
                      SizedBox(height: 10,),
                      Text('در حال بارگذاری ...',style: AppTextStyle.smallTitleText,),
                      SizedBox(height: 30,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

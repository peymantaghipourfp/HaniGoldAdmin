

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';



class ErrPage extends StatelessWidget {

  const ErrPage({super.key, this.callback, this.title, this.des});

  final VoidCallback? callback;
  final String? title;
  final String? des;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/error.svg',
            width: 100,
            height: 100,
            colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            title ?? 'خطا در دریافت اطلاعات',
            style: AppTextStyle.madiumbodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            des ?? 'برای دریافت مجدد اطلاعات مجددا تلاش کنید',
            style: AppTextStyle.bodyText,
          ),
          const SizedBox(
            height: 20,
          ),
          if (callback != null)
            GestureDetector(onTap:callback, child: Text('تلاش مجدد',
            style: AppTextStyle.madiumbodyText.copyWith(color: Colors.blueAccent),))
        ],
      ),
    );
  }

}


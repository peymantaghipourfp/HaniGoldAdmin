
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/const/app_text_style.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key, this.title, this.des,this.tryText, this.child, this.body,this.callback});

  final String? title;
  final String? des;
  final String? tryText;
  final Widget? child;
  final Widget? body;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: body ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*SvgPicture.asset(
                              'assets/svg/empty.svg',
                              width: 100,
                              height: 100,
                colorFilter: ColorFilter.mode(AppColor.textColor, BlendMode.srcIn),
                            ),*/
              const SizedBox(
                height: 15,
              ),
              Text(
                title ?? 'اطلاعاتی وجود ندارد',
                style: AppTextStyle.mediumBodyText.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                des ?? 'برای درخواست شما اطلاعاتی یافت نشد!',
                style: AppTextStyle.bodyText,
              ),
              SizedBox(height: 10,),
              if (callback != null)
                GestureDetector(onTap:callback, child: Text(tryText ?? 'تلاش مجدد',
                  style: context.textTheme.titleMedium!.copyWith(color: Colors.blueAccent),)),
              const SizedBox(
                height: 10,
              ),
              if (child != null) child!
            ],
          ),
    );
  }
}

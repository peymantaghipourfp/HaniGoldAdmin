
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/const/app_color.dart';
import '../config/const/app_text_style.dart';

class CustomAppbar1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  const CustomAppbar1({
    required this.title,
    this.onBackTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return AppBar(
      centerTitle: true,
      actions: [
        if(scaffold.hasDrawer)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: AppColor.textColor),
                  onPressed: () => Get.back(),
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () => Get.offAllNamed('/home'),
                ),
              ],
            ),
          )
      ],
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', width: 120,height: 40,),
          Expanded(
            child: Center(
              child: Text(title,style: AppTextStyle.smallTitleText,),
            ),
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.secondaryColor, AppColor.backGroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      iconTheme: IconThemeData(color: AppColor.textColor,),
      elevation: 4,
      shadowColor: AppColor.secondaryColor.withOpacity(0.1),
      leading:
      (scaffold.hasDrawer)
          ? IconButton(
        icon: Icon(Icons.menu, color: AppColor.textColor),
        onPressed: () => scaffold.openDrawer(),
      ) :
      IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor),
          onPressed: onBackTap
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
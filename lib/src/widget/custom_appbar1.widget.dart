
import 'package:flutter/material.dart';

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
    return AppBar(
      centerTitle: true,
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
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor),
          onPressed: onBackTap
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
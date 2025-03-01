import 'package:flutter/material.dart';

import '../config/const/app_color.dart';
import '../config/const/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final TextStyle titleTextStyle;
  final bool centerTitle;
  final VoidCallback? onBackTap;

  // Constructor to accept customization options
  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = AppColor.appBarColor,
    this.iconColor = AppColor.textColor,
    this.titleTextStyle = AppTextStyle.smallTitleText,
    this.centerTitle = true,
    this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: iconColor),
      title: Text(
        title,
        style: titleTextStyle,
      ),
      centerTitle: centerTitle,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: onBackTap, // Default behavior if onBackTap is null
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
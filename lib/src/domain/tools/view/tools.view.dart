import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

import '../../../config/const/app_color.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        title: Text('تنظیمات',style: AppTextStyle.smallTitleText,),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppColor.textColor
        ),
      ),
    );
  }
}

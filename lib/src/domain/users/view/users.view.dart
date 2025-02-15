import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

import '../../../config/const/app_color.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        title: Text('کاربران',style: AppTextStyle.smallTitleText,),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppColor.textColor
        ),
      ),
    );
  }
}

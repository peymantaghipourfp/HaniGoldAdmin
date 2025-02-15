import 'package:flutter/material.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        title: Text('محصولات',style: AppTextStyle.smallTitleText,),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppColor.textColor
        ),
      ),
    );
  }
}

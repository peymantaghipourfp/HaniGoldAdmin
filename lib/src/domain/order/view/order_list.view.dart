
import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.textColor),
        title: Text('سفارشات',style: AppTextStyle.smallTitleText,),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Padding(
                padding: EdgeInsets.all(16.0),
              child: Column(
                children: [

                ],
              ),
            ),
          )
      ),
    );
  }
}

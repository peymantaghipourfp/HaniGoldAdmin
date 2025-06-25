import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/widget/side_menu.widget.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: Get.height*0.85,
      color: AppColor.backGroundColor.withOpacity(0),
      child: const Drawer(
        shadowColor:
            Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
        ),
        ),
        backgroundColor: AppColor.backGroundColor,
        child: SideMenu(),
      ),
    );
  }
}
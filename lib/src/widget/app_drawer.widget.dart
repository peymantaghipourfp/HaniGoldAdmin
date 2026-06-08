import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/side_menu_fix.widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: Get.height * 0.85,
      child: const Drawer(
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: SideMenuFix(),
      ),
    );
  }
}

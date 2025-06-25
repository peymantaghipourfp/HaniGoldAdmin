import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MoreView extends GetView<HomeController> {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'بیشتر',
        onBackTap: () => Get.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return ResponsiveRowColumn(
              layout: ResponsiveRowColumnType.COLUMN,
              columnSpacing: 5,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //پنل ریالی
                _buildMenuItem(context, 'rialPanel', 'پنل ریالی', [
                  _buildSubMenuItem(
                      'واریزی‌ها', () => Get.toNamed('/depositsList')),
                  _buildSubMenuItem('لیست درخواست برداشت',
                          () => Get.toNamed('/withdrawsList')),
                  _buildSubMenuItem('ایجاد درخواست برداشت',
                          () => Get.toNamed('/withdrawCreate')),
                ]),
                //دریافت و پرداخت
                _buildMenuItem(context, 'inventory', 'دریافت و پرداخت', [
                  _buildSubMenuItem('لیست دریافت و پرداخت',
                          () => Get.toNamed('/inventoryList')),
                  _buildSubMenuItem('دریافت و پرداخت جدید',
                          () => Get.toNamed('/inventoryCreate')),
                ]),
                //حواله
                _buildMenuItem(context, 'remittance', 'حواله', [
                  _buildSubMenuItem(
                      'لیست حواله', () => Get.toNamed('/remittance')),
                  _buildSubMenuItem(
                      'ایجاد حواله', () => Get.toNamed('/insertRemittance')),
                ]),
                //آزمایشگاه
                _buildMenuItem(context, 'laboratory', 'آزمایشگاه', [
                  _buildSubMenuItem(
                      'لیست آزمایشگاه', () => Get.toNamed('/laboratory')),
                ]),
                //تنظیمات
                _buildMenuItem(context, 'tools', 'تنظیمات', [
                  _buildSubMenuItem('خروج از برنامه', () {
                    Get.defaultDialog(
                        title: "خروج",
                        titleStyle: TextStyle(color: AppColor.textColor),
                        middleText: "آیا می خواهید از برنامه خارج شوید",
                        middleTextStyle: TextStyle(color: AppColor.textColor),
                        backgroundColor: AppColor.secondaryColor,
                        textCancel: "خیر",
                        onCancel: () => Get.back(),
                        textConfirm: "بله",
                        onConfirm: () => FlutterExitApp.exitApp());
                  }),
                ]),
              ],
            );
          }),
        ),
      ),
    );
  }

  ResponsiveRowColumnItem _buildMenuItem(BuildContext context, String menuName,
      String title, List<Widget> children) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return ResponsiveRowColumnItem(
      rowFlex: 1,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                constraints: isDesktop
                    ? BoxConstraints(maxWidth: 550)
                    : BoxConstraints(maxWidth: 350),
                padding: isDesktop
                    ? const EdgeInsets.symmetric(horizontal: 80)
                    : const EdgeInsets.only(right: 15),
                child: TextButton(
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all(5),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                        BorderSide(width: 1, color: AppColor.secondaryColor),
                      ),
                    ),
                    backgroundColor:
                    WidgetStatePropertyAll(AppColor.secondaryColor),
                  ),
                  onPressed: () {
                    controller.toggleSubMenu(menuName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            title,
                            style: AppTextStyle.bodyText,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Icon(
                          color: AppColor.textColor,
                          controller.isSubMenuOpen(menuName)
                              ? Icons.expand_more
                              : Icons.expand_less),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            child: controller.isSubMenuOpen(menuName)
                ? Column(children: children)
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubMenuItem(String title, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListTile(
        horizontalTitleGap: 5,
        minTileHeight: 10,
        title: Text(
          title,
          style: AppTextStyle.bodyText,
        ),
        leading: Icon(Icons.circle, size: 15, color: AppColor.circleColor),
        onTap: onTap,
      ),
    );
  }
}
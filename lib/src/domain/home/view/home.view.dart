import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:hanigold_admin/src/domain/home/widget/custom_text_button.widget.dart';
import 'package:hanigold_admin/src/domain/home/widget/desktop_layout.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar:
      AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor),
          onPressed: () => Get.toNamed('/login'), // Default behavior if onBackTap is null
        ),*/
        //iconTheme: IconThemeData(color: AppColor.textColor),
        //leadingWidth: 60,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 120,height: 40,),
            const Spacer(),
            userProfile(),
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
      ),
      body: SafeArea(
          child:isDesktop ? buildDesktopLayout() : Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              Obx(() {
                return ResponsiveRowColumn(
                  layout: ResponsiveRowColumnType.COLUMN,
                  columnSpacing: 5,
                  rowCrossAxisAlignment: CrossAxisAlignment.center,
                  rowMainAxisAlignment: MainAxisAlignment.center,
                  columnCrossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    //سفارشات
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('orders');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'سفارشات',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.isSubMenuOpen('orders')?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //نمایش زیر مجموعه سفارشات
                    ResponsiveRowColumnItem(
                      rowFlex:2,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('orders')
                            ? Column(
                                children: [
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: ListTile(
                                      horizontalTitleGap: 5,
                                      minTileHeight: 10,
                                      title: Text(
                                        'سفارشات',
                                        style: AppTextStyle.bodyText,
                                      ),
                                      leading: Icon(Icons.circle,
                                          size: 15,
                                          color: AppColor.circleColor),
                                      onTap: () {
                                        Get.toNamed('/orderList');
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: ListTile(
                                      horizontalTitleGap: 5,
                                      minTileHeight: 10,
                                      title: Text(
                                        'ایجاد سفارش جدید',
                                        style: AppTextStyle.bodyText,
                                      ),
                                      leading: Icon(Icons.circle,
                                          size: 15,
                                          color: AppColor.circleColor),
                                      onTap: () {
                                        Get.toNamed('/orderCreate');
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                    ),
                    //محصولات
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('products');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'محصولات',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.isSubMenuOpen('products')?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //نمایش زیر مجموعه محصولات
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('products')
                            ? Column(
                                children: [
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: ListTile(
                                      horizontalTitleGap: 5,
                                      minTileHeight: 10,
                                      title: Text(
                                        'بروزرسانی قیمت محصولات',
                                        style: AppTextStyle.bodyText,
                                      ),
                                      leading: Icon(Icons.circle,
                                          size: 15,
                                          color: AppColor.circleColor),
                                      onTap: () {
                                        Get.toNamed('/productUpdatePrice');
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ),
                    //پنل ریالی
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('rialPanel');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'پنل ریالی',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                    controller.activeSubMenu.value=='rialPanel'?
                                        Icons.expand_more:
                                        Icons.expand_less
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    // نمایش زیر مجموعه پنل ریالی
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('rialPanel')
                            ? Column(
                                children: [
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: ListTile(
                                      horizontalTitleGap: 5,
                                      minTileHeight: 10,
                                      title: Text(
                                        'واریزی‌ها',
                                        style: AppTextStyle.bodyText,
                                      ),
                                      leading: Icon(Icons.circle,
                                          size: 15,
                                          color: AppColor.circleColor),
                                      onTap: () {
                                        Get.toNamed('/depositsList');
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: ListTile(
                                      horizontalTitleGap: 5,
                                      minTileHeight: 10,
                                      title: Text(
                                        'لیست درخواست برداشت',
                                        style: AppTextStyle.bodyText,
                                      ),
                                      leading: Icon(Icons.circle,
                                          size: 15,
                                          color: AppColor.circleColor),
                                      onTap: () {
                                        Get.toNamed('/withdrawsList');
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: ListTile(
                                      horizontalTitleGap: 5,
                                      minTileHeight: 10,
                                      title: Text(
                                        'ایجاد درخواست برداشت',
                                        style: AppTextStyle.bodyText,
                                      ),
                                      leading: Icon(Icons.circle,
                                          size: 15,
                                          color: AppColor.circleColor),
                                      onTap: () {
                                        Get.toNamed('/withdrawCreate');
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ),
                    //تراز
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('balance');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'تراز معاملاتی',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.activeSubMenu.value=='balance'?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    // نمایش تراز معاملاتی
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('balance')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'تراز معاملاتی',
                                  style: AppTextStyle.bodyText,
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  Get.toNamed('/tradingBalance');
                                },
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),
                    //کاربران
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('users');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'کاربران',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.activeSubMenu.value=='users'?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    // نمایش زیر مجموعه کاربران
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('users')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'مانده کاربران',
                                  style: AppTextStyle.bodyText,
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  Get.toNamed('/listUserInfoTransaction');
                                },
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),
                    // نمایش زیر مجموعه کاربران
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('users')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'لیست اکانت ها',
                                  style: AppTextStyle.bodyText,
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  Get.toNamed('/userList');
                                },
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),
                    // نمایش زیر مجموعه کاربران
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('users')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'لیست کاربران',
                                  style: AppTextStyle.bodyText,
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  Get.toNamed('/personList');
                                },
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),
                    // نمایش زیر مجموعه کاربران
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('users')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'افزودن اکانت جدید',
                                  style: AppTextStyle.bodyText,
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  Get.toNamed("/insertUser",parameters: {"id":0.toString()});
                                },
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),
                    //دریافت و پرداخت
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('inventory');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'دریافت و پرداخت',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.activeSubMenu.value=='inventory'?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //نمایش زیرمجموعه دریافت و پرداخت
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('inventory')
                            ? Column(
                                children: [
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: AnimatedSize(
                                      duration: Duration(milliseconds: 800),
                                      curve: Curves.easeInOut,
                                      child: ListTile(
                                        horizontalTitleGap: 5,
                                        minTileHeight: 10,
                                        title: Text(
                                          'لیست دریافت و پرداخت',
                                          style: AppTextStyle.bodyText,
                                        ),
                                        leading: Icon(Icons.circle,
                                            size: 15,
                                            color: AppColor.circleColor),
                                        onTap: () {
                                          Get.toNamed('/inventoryList');
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: AnimatedSize(
                                      duration: Duration(milliseconds: 800),
                                      curve: Curves.easeInOut,
                                      child: ListTile(
                                        horizontalTitleGap: 5,
                                        minTileHeight: 10,
                                        title: Text(
                                          'دریافت و پرداخت جدید',
                                          style: AppTextStyle.bodyText,
                                        ),
                                        leading: Icon(Icons.circle,
                                            size: 15,
                                            color: AppColor.circleColor),
                                        onTap: () {
                                          Get.toNamed('/inventoryCreate');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ),
                    //حواله
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('remittance');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'حواله',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.activeSubMenu.value=='remittance'?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //نمایش زیرمجموعه حواله
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('remittance')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: AnimatedSize(
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                child: ListTile(
                                  horizontalTitleGap: 5,
                                  minTileHeight: 10,
                                  title: Text(
                                    'لیست حواله',
                                    style: AppTextStyle.bodyText,
                                  ),
                                  leading: Icon(Icons.circle,
                                      size: 15,
                                      color: AppColor.circleColor),
                                  onTap: () {
                                    Get.toNamed('/remittance');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: AnimatedSize(
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                child: ListTile(
                                  horizontalTitleGap: 5,
                                  minTileHeight: 10,
                                  title: Text(
                                    'ایجاد حواله',
                                    style: AppTextStyle.bodyText,
                                  ),
                                  leading: Icon(Icons.circle,
                                      size: 15,
                                      color: AppColor.circleColor),
                                  onTap: () {
                                    Get.toNamed('/insertRemittance');
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),

                    //آزمایشگاه
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('laboratory');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'آزمایشگاه',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.activeSubMenu.value=='laboratory'?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //نمایش زیرمجموعه آزمایشگاه
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('laboratory')
                            ? Column(
                                children: [
                                  Container(
                                    padding: isDesktop
                                        ? const EdgeInsets.symmetric(horizontal: 80)
                                        : const EdgeInsets.symmetric(horizontal: 24),
                                    child: ListTile(
                                      horizontalTitleGap: 5,
                                      minTileHeight: 10,
                                      title: Text(
                                        'لیست آزمایشگاه',
                                        style: AppTextStyle.bodyText.copyWith(fontSize: 14),
                                      ),
                                      leading: Icon(Icons.circle,
                                          size: 15,
                                          color: AppColor.circleColor),
                                      onTap: () {
                                        Get.toNamed('/laboratory');
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ),

                    //تراکنش ها
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('transaction');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'تراکنش ها',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.activeSubMenu.value=='transaction'?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //لیست تراکنش های کاربران
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('transaction')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'لیست تراکنش های کاربران',
                                  style: AppTextStyle.bodyText.copyWith(fontSize: 14),
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  Get.toNamed('/transactionList');
                                },
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),

                    //تنظیمات
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: Row(
                        children: [
                          Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 550) : BoxConstraints(maxWidth: 350),
                            padding: isDesktop
                                ? const EdgeInsets.symmetric(horizontal: 80)
                                : const EdgeInsets.only(right: 15),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(5),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: AppColor.secondaryColor),
                                  ),
                                ),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                              ),
                              onPressed: () {
                                controller.toggleSubMenu('tools');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'تنظیمات',
                                        style: AppTextStyle.bodyText,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Icon(color: AppColor.textColor,
                                      controller.activeSubMenu.value=='tools'?
                                      Icons.expand_more:
                                      Icons.expand_less
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    //نمایش زیرمجموعه تنظیمات
                    ResponsiveRowColumnItem(
                      rowFlex:1,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 350), // سرعت انیمیشن
                        curve: Curves.easeInOut, // نوع حرکت انیمیشن
                        child: controller.isSubMenuOpen('tools')
                            ? Column(
                          children: [
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'خروج از برنامه',
                                  style: AppTextStyle.bodyText.copyWith(fontSize: 14),
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  Get.defaultDialog(
                                      title:"خروج",
                                      titleStyle: TextStyle(color: AppColor.textColor),
                                      middleText: "آیا می خواهید از برنامه خارج شوید",
                                      middleTextStyle: TextStyle(color: AppColor.textColor),
                                      backgroundColor: AppColor.secondaryColor,
                                      textCancel: "خیر",
                                      onCancel: () => Get.toNamed('/home'),
                                      textConfirm: "بله",
                                      onConfirm: () =>  FlutterExitApp.exitApp()
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 80)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minTileHeight: 10,
                                title: Text(
                                  'تغییر رمز عبور',
                                  style: AppTextStyle.bodyText.copyWith(fontSize: 14),
                                ),
                                leading: Icon(Icons.circle,
                                    size: 15,
                                    color: AppColor.circleColor),
                                onTap: () {
                                  return _showChangePassword();
                                },
                              ),
                            ),
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ),
                  ],
                );
              }),
            ),

        ),

    );
  }
  Widget userProfile() {
    return Row(
      children: [
        Icon(Icons.account_circle, color: AppColor.textColor, size: 30),
        const SizedBox(width: 10),
        Text(
          'مدیر سیستم',
          style: AppTextStyle.bodyText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  void _showChangePassword() {
    final HomeController controller = Get.find<HomeController>();
    final formKey = GlobalKey<FormState>();
    Get.dialog(
      Form(
        key: formKey,
        child: AlertDialog(
          backgroundColor: AppColor.secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('تغییر رمز عبور',
              style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor)),
          content: SizedBox(
            height: Get.height * 0.5,
            child: Column(
              children: [
                const SizedBox(height: 24),
                TextFormField(
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 13,
                  ),
                  textDirection: TextDirection.rtl,
                  controller: controller.passwordOldController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    labelText: 'رمز عبور قبلی',
                    labelStyle: TextStyle(color: AppColor.textColor),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    prefixIconColor: AppColor.textColor,
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا رمز عبور را وارد کنید';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // وارد کردن پسورد
                TextFormField(
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 13,
                  ),
                  textDirection: TextDirection.rtl,
                  controller: controller.passwordController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    labelText: 'رمز عبور جدید',
                    labelStyle: TextStyle(color: AppColor.textColor),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    prefixIconColor: AppColor.textColor,
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا رمز عبور را وارد کنید';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 13,
                  ),
                  textDirection: TextDirection.rtl,
                  controller: controller.retypePasswordController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    labelText: 'تکرار رمز عبور جدید',
                    labelStyle: TextStyle(color: AppColor.textColor),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    prefixIconColor: AppColor.textColor,
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا رمز عبور را وارد کنید';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child:
              Text('انصراف', style: TextStyle(color: AppColor.primaryColor)),
              onPressed: () {
                Get.back();
                controller.clearChangePasswordForm();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('تغییر رمز', style: TextStyle(color: Colors.white)),
              onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.changePassword();
                    controller.clearChangePasswordForm();
                    Get.back();
                  }
              },
            ),
          ],
        ),
      ),
    );
  }
}

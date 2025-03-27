import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:hanigold_admin/src/domain/home/widget/custom_text_button.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar.widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: CustomAppBar(title: 'خانه', onBackTap: () => Get.toNamed('/login'),),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              /*ListView.separated(
                        itemBuilder: (context, index) {
                          final button=controller.homeListView[index];
                          return CustomTextButton(
                              text: button['text'],
                              onPressed: () => Get.toNamed(button['route']),
                            backgroundColor: AppColor.backGroundColor,
                          );
                        },
                        separatorBuilder: (context, index) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Divider(
                            height: 2,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        itemCount: controller.homeListView.length
                    ),*/
              Obx(() {
                return Column(
                  children: [
                    //سفارشات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.90,
                          padding: EdgeInsets.only(bottom: 7),
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
                    //نمایش زیر مجموعه سفارشات
                    AnimatedSize(
                      duration: Duration(milliseconds: 350), // سرعت انیمیشن
                      curve: Curves.easeInOut, // نوع حرکت انیمیشن
                      child: controller.isSubMenuOpen('orders')
                          ? Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 20),
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
                                /*Container(
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
                                ),*/
                              ],
                            )
                          : SizedBox(),
                    ),

                    //محصولات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.90,
                          padding: EdgeInsets.only(bottom: 7),
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
                    //نمایش زیر مجموعه محصولات
                    AnimatedSize(
                      duration: Duration(milliseconds: 350), // سرعت انیمیشن
                      curve: Curves.easeInOut, // نوع حرکت انیمیشن
                      child: controller.isSubMenuOpen('products')
                          ? Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 20),
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
                    //پنل ریالی
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.90,
                          padding: EdgeInsets.only(bottom: 7),
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
                    // نمایش زیر مجموعه پنل ریالی
                    AnimatedSize(
                      duration: Duration(milliseconds: 350), // سرعت انیمیشن
                      curve: Curves.easeInOut, // نوع حرکت انیمیشن
                      child: controller.isSubMenuOpen('rialPanel')
                          ? Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 20),
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
                                  padding: EdgeInsets.only(right: 20),
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
                                  padding: EdgeInsets.only(right: 20),
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
                    //دریافت و پرداخت
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.90,
                          padding: EdgeInsets.only(bottom: 7),
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
                    //نمایش زیرمجموعه دریافت و پرداخت
                    AnimatedSize(
                      duration: Duration(milliseconds: 350), // سرعت انیمیشن
                      curve: Curves.easeInOut, // نوع حرکت انیمیشن
                      child: controller.isSubMenuOpen('inventory')
                          ? Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 20),
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
                                  padding: EdgeInsets.only(right: 20),
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
                    //تنظیمات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.90,
                          padding: EdgeInsets.only(bottom: 7),
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
                    //نمایش زیرمجموعه تنظیمات
                    AnimatedSize(
                      duration: Duration(milliseconds: 350), // سرعت انیمیشن
                      curve: Curves.easeInOut, // نوع حرکت انیمیشن
                      child: controller.isSubMenuOpen('tools')
                          ? Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 20),
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
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

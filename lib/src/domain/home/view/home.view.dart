import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(title: 'خانه'),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    ListView.separated(
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
                          /*child: Divider(
                            height: 2,
                            color: AppColor.secondaryColor,
                          ),*/
                        ),
                        itemCount: controller.homeListView.length
                    ),
        /*                  Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(AppColor.backGroundColor),
                        ),
                            onPressed: () {
                            Get.toNamed('orderList');
                            },
                            child: Text('سفارشات',style: AppTextStyle.smallTitleText,),
                        ),
                      ],
                    ),
                    Divider(
                      height: 2,
                      color: AppColor.secondaryColor,
                    ),
                    Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColor.backGroundColor),
                          ),
                          onPressed: () {

                          },
                          child: Text('محصولات',style: AppTextStyle.smallTitleText,),
                        ),
                      ],
                    ),
                    Divider(
                      height: 2,
                      color: AppColor.secondaryColor,
                    ),*/
              ),
            ),
        ),
      ),
    );
  }
}

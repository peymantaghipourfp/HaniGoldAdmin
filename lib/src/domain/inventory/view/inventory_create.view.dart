import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../widget/inventory_create_payment_tab.widget.dart';
import '../widget/inventory_create_receive_tab.widget.dart';

class InventoryCreateView extends StatefulWidget {
  const InventoryCreateView({super.key});

  @override
  State<InventoryCreateView> createState() => _InventoryCreateViewState();
}

class _InventoryCreateViewState extends State<InventoryCreateView> with TickerProviderStateMixin {
  InventoryCreateReceiveController inventoryCreateReceiveController = Get.find<InventoryCreateReceiveController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar:isDesktop ? AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor),
          onPressed: () => Get.back(), // Default behavior if onBackTap is null
        ),
        title:Center(child: Text('دریافت و پرداخت جدید',style:AppTextStyle.smallTitleText ,)) ,
      ) :
      CustomAppBar(title: 'دریافت و پرداخت جدید',
        onBackTap: () => Get.back(),
      ),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ResponsiveRowColumn(
              layout: ResponsiveRowColumnType.COLUMN,
              columnSpacing: 15,
              rowSpacing: 20,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 ResponsiveRowColumnItem(
                   rowFlex: 1,
                   child: Expanded(
                     child: DefaultTabController(
                                  length: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: isDesktop ? 600 : double.infinity
                                        ),
                                        child: TabBar(
                                          labelStyle: AppTextStyle.bodyText.copyWith(
                                              fontSize: 13, fontWeight: FontWeight.bold),
                                          labelColor: AppColor.textColor,
                                          dividerColor: AppColor.backGroundColor,
                                          overlayColor: WidgetStatePropertyAll(
                                              AppColor.textColor),
                                          unselectedLabelColor: AppColor.textColor.withAlpha(
                                              120),
                                          indicatorColor: AppColor.primaryColor,
                                          tabs: [
                                            Tab(text: "دریافت"),
                                            Tab(text: "پرداخت"),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: isDesktop ? 600 : double.infinity
                                            ),
                                            child: TabBarView(
                                                children: [
                                                  // TabBar 1 دریافت
                                                  InventoryCreateReceiveTabWidget(),

                                                  // TabBar 2 پرداخت
                                                  InventoryCreatePaymentTabWidget(),
                                                ]
                                            ),
                                          ),
                                      )
                                    ],
                                  )
                              ),
                   ),
                 ),

              ],
            ),
          ),
      ),
    );
  }
}



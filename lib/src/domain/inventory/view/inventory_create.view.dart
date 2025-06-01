import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_layout.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:hanigold_admin/src/widget/background_image.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../widget/inventory_create_payment_tab.widget.dart';
import '../widget/inventory_create_receive_tab.widget.dart';

class InventoryCreateView extends StatefulWidget {
  const InventoryCreateView({super.key});

  @override
  State<InventoryCreateView> createState() => _InventoryCreateViewState();
}

class _InventoryCreateViewState extends State<InventoryCreateView>
    with TickerProviderStateMixin {
  InventoryCreateLayoutController inventoryCreateLayoutController = Get.find<InventoryCreateLayoutController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Obx(() {
      return Scaffold(
        appBar: isDesktop ?
        CustomAppbar1(
          title: 'دریافت و پرداخت جدید', onBackTap: () => Get.back(),)
            :
        CustomAppBar(title: 'دریافت و پرداخت جدید',
          onBackTap: () => Get.back(),
        ),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: ResponsiveRowColumn(
                    layout: isDesktop
                        ? ResponsiveRowColumnType.ROW
                        : ResponsiveRowColumnType.COLUMN,
                    columnSpacing: 30,
                    rowSpacing: 20,
                    rowCrossAxisAlignment: CrossAxisAlignment.start,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(isMobile)
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child:
                          inventoryCreateLayoutController.isLoadingBalance.value==false &&  inventoryCreateLayoutController.balanceList.isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryCreateLayoutController.balanceList,
                            size: 400,),
                        ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 700),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          /*decoration: BoxDecoration(
                            color: AppColor.backGroundColor1,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),*/
                          child: SizedBox(
                            width: Get.width * 0.9,
                            height: Get.height,
                            child: Column(
                              children: [
                                Expanded(
                                  child: DefaultTabController(
                                      length: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: isDesktop
                                                    ? 600
                                                    : double.infinity
                                            ),
                                            child: TabBar(
                                              onTap: (value) {

                                              },
                                              labelStyle: AppTextStyle.bodyText
                                                  .copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                              labelColor: AppColor.textColor,
                                              dividerColor: AppColor
                                                  .backGroundColor,
                                              overlayColor: WidgetStatePropertyAll(
                                                  AppColor.backGroundColor1),
                                              unselectedLabelColor: AppColor
                                                  .textColor.withAlpha(
                                                  120),
                                              indicatorColor: AppColor
                                                  .primaryColor,
                                              tabs: [
                                                Tab(text: "دریافت"),
                                                Tab(text: "پرداخت"),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: isDesktop
                                                      ? 600
                                                      : double.infinity
                                              ),
                                              child: TabBarView(

                                                  children: [
                                                    // TabBar 1 دریافت
                                                    InventoryCreateReceiveTabWidget(callBack: (int id) {
                                                      setState(() {
                                                        inventoryCreateLayoutController.getBalanceList(id);
                                                      });
                                                    },),

                                                    // TabBar 2 پرداخت
                                                    InventoryCreatePaymentTabWidget(callBack: (int id) {
                                                      setState(() {
                                                        inventoryCreateLayoutController.getBalanceList(id);
                                                      });
                                                    },),
                                                  ]
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(isDesktop)
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child:
                          inventoryCreateLayoutController.isLoadingBalance.value==false &&  inventoryCreateLayoutController.balanceList.isEmpty ?
                              SizedBox() :
                          inventoryCreateLayoutController.isLoadingBalance.value==true &&  inventoryCreateLayoutController.balanceList.isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryCreateLayoutController.balanceList,
                            size: 400,),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
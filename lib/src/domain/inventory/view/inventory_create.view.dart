
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_layout.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:hanigold_admin/src/widget/background_image.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../widget/total_balance_gold_value.widget.dart';
import '../controller/inventory_create_payment.controller.dart';
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
  final InventoryCreateReceiveController _receiveController = Get.find<InventoryCreateReceiveController>();
  final InventoryCreatePaymentController _paymentController = Get.find<InventoryCreatePaymentController>();
  int _currentTabIndex = 0;

  void _handleTabChange(int newIndex) {
    if (newIndex == _currentTabIndex) return;
    // Clear the previous tab's transient state
    if (_currentTabIndex == 0) {
      _receiveController.resetFieldsForTab(_currentTabIndex);
    } else {
      _paymentController.resetFieldsForTab(_currentTabIndex);
    }
    setState(() {
      _currentTabIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    return Obx(() {
      return Scaffold(
        appBar:
        CustomAppbar1(
          title: 'دریافت و پرداخت جدید', onBackTap: () => Get.toNamed('/home'),),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
              child: isMobile
                  ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12
                  ),
                  child: ResponsiveRowColumn(
                    layout: ResponsiveRowColumnType.COLUMN,
                    columnSpacing: 16,
                    rowSpacing: 16,
                    rowCrossAxisAlignment: CrossAxisAlignment.start,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child:
                        inventoryCreateLayoutController.tooltipTotalBalanceModel.value == null ?
                        // Empty state when no user is selected
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.secondaryColor,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ' تراز کاربر ',
                                    style: AppTextStyle.labelText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 10.0, color: Colors.white, thickness: 0.5),
                            ],
                          ),
                        )
                            :
                        inventoryCreateLayoutController.isLoadingTooltipBalance.value ?
                        Center(child: CircularProgressIndicator(),)
                            :
                        TotalBalanceGoldValue(
                            totalBalanceGoldValue: inventoryCreateLayoutController.tooltipTotalBalanceModel.value!,
                            size: double.infinity),
                      ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: 400,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16),
                          child: SizedBox(
                            height: Get.height * 0.7, // Provide bounded height
                            child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity
                                      ),
                                      child: TabBar(
                                        onTap: (value) {
                                          _handleTabChange(value);
                                          inventoryCreateLayoutController.getTooltipTotalBalance(0);
                                        },

                                        labelStyle: AppTextStyle.bodyText.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                            maxWidth: double.infinity
                                        ),
                                        child: TabBarView(

                                            children: [
                                              // TabBar 1 دریافت
                                              InventoryCreateReceiveTabWidget(callBack: (int id) {
                                                setState(() {
                                                  inventoryCreateLayoutController.getTooltipTotalBalance(id);
                                                });
                                              },),

                                              // TabBar 2 پرداخت
                                              InventoryCreatePaymentTabWidget(callBack: (int id) {
                                                setState(() {
                                                  inventoryCreateLayoutController.getTooltipTotalBalance(id);
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
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 40,
                      vertical: 20
                  ),
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
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop ? 700 : double.infinity,
                            minHeight: 500,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 40,
                              vertical: 20),
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
                                                _handleTabChange(value);
                                                inventoryCreateLayoutController.getTooltipTotalBalance(0);
                                              },
                                              labelStyle: AppTextStyle.bodyText.copyWith(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                                        inventoryCreateLayoutController.getTooltipTotalBalance(id);
                                                      });
                                                    },),

                                                    // TabBar 2 پرداخت
                                                    InventoryCreatePaymentTabWidget(callBack: (int id) {
                                                      setState(() {
                                                        inventoryCreateLayoutController.getTooltipTotalBalance(id);
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
                          inventoryCreateLayoutController.tooltipTotalBalanceModel.value == null ?
                          // Empty state when no user is selected
                          Container(
                            width: 400,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.secondaryColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' تراز کاربر ',
                                      style: AppTextStyle.labelText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 10.0, color: Colors.white, thickness: 0.5),
                              ],
                            ),
                          )
                              :
                          inventoryCreateLayoutController.isLoadingTooltipBalance.value ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          TotalBalanceGoldValue(
                            totalBalanceGoldValue: inventoryCreateLayoutController.tooltipTotalBalanceModel.value!,
                            size: 400,),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton:isMobile ? SizedBox.shrink() : FloatingActionButton(
          onPressed: () {
            Get.dialog(const ChatDialog());
          },
          backgroundColor: AppColor.primaryColor,
          child: Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../controller/user_info_transaction.controller.dart';

class ListUserInfoTransactionView extends GetView<UserInfoTransactionController> {
  const ListUserInfoTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: 'مانده کاربران',
        onBackTap: () => Get.toNamed("/home"),
      ),
      drawer: const AppDrawer(),
      body:Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageState.loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : controller.state.value == PageState.list
                ? SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //فیلد جستجو
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      height: 41,
                      child: TextFormField(
                        // onChanged: (value){
                        //   Future.delayed(const Duration(milliseconds: 3000), () {
                        //     controller.getListTransactionInfo();
                        //   });
                        // },
                        controller: controller.searchController,
                        style: AppTextStyle.labelText,
                        textInputAction: TextInputAction.search,
                        // onFieldSubmitted: (value) async {
                        //   // Future.delayed(const Duration(milliseconds: 700), () {
                        //      controller.getListTransactionInfo();
                        //   // });
                        // },
                        onEditingComplete: () async {
                          if (controller.searchController.text.isNotEmpty) {
                            await controller.getListTransactionInfoPager();
                          }else {
                            controller.clearSearch();
                          }
                      },

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          hintText: "جستجو ... ",
                          hintStyle: AppTextStyle.labelText,

                          prefixIcon: IconButton(
                              onPressed: () async {
                                controller.getListTransactionInfoPager();
                              },
                              icon: Icon(
                                Icons.search,
                                color: AppColor.textColor,
                                size: 30,
                              )),
                            suffixIcon: IconButton(
                              onPressed: controller.clearSearch,
                              icon: Icon(Icons.close, color: AppColor.textColor),
                            )
                        ),
                      ),
                    ),
                    // خروجی اکسل
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets
                                      .symmetric(
                                      horizontal: 15,
                                      vertical: 7
                                  ),
                                ),
                                fixedSize: WidgetStatePropertyAll(
                                    Size(100, 30)),
                                elevation: WidgetStatePropertyAll(
                                    5),
                                backgroundColor:
                                WidgetStatePropertyAll(
                                    AppColor
                                        .secondary3Color),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .circular(
                                            5)))),
                            onPressed: () {
                              controller.getListUserInfoTransactionExcel();
                              Get.back();
                            },
                            child: Text(
                              'خروجی اکسل',
                              style: AppTextStyle
                                  .labelText,
                            ),
                            //onPressed: () => orderController.getOrderExcel(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 70),
                      color:
                      AppColor.appBarColor.withOpacity(0.5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller:
                        controller.scrollController,
                        physics: ClampingScrollPhysics(),
                        child: Row(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  DataTable(
                                    columns:
                                    buildDataColumns(),
                                    sortColumnIndex: controller
                                        .sortColumnIndex
                                        .value,
                                    sortAscending: controller
                                        .sortAscending
                                        .value,
                                    border: TableBorder.symmetric(inside: BorderSide(color: AppColor.textColor,width: 0.3),
                                      outside: BorderSide(color: AppColor.textColor,width: 0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    dividerThickness: 0.3,
                                    rows: buildDataRows(
                                        context),
                                    dataRowMaxHeight: 80,
                                    //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                    //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                    headingRowHeight: 60,
                                    columnSpacing: 30,
                                    horizontalMargin: 5,
                                  ),
                                  // Footer Section
                                  Obx(() => controller.listTransactionInfoFooter.isNotEmpty
                                      ? Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color:AppColor.appBarColor.withOpacity(0.5),),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color:AppColor.appBarColor.withOpacity(0.5),),
                                            child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                // ریال بستانکار
                                                _buildFooterItem(
                                                  title: "ریال بستانکار",
                                                  positiveValue: controller.listTransactionInfoFooter
                                                      .where((item) => item.unitName == "ریال")
                                                      .fold(0.0, (sum, item) => sum! + (item.totalPositiveBalance ?? 0)),
                                                  color: AppColor.primaryColor,
                                                  unit: "ریال",
                                                ),
                                                SizedBox(width: 20),
                                                // ریال بدهکار
                                                _buildFooterItem(
                                                  title: "ریال بدهکار",
                                                  negativeValue: controller.listTransactionInfoFooter
                                                      .where((item) => item.unitName == "ریال")
                                                      .fold(0.0, (sum, item) => sum! + (item.totalNegativeBalance ?? 0)),
                                                  color: AppColor.accentColor,
                                                  unit: "ریال",
                                                ),
                                                SizedBox(width: 20),
                                                // طلا بستانکار
                                                Row(
                                                  children: [
                                                    _buildFooterItem(
                                                      title: "طلا بستانکار",
                                                      positiveValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "گرم")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalPositiveBalance ?? 0)),
                                                      color: AppColor.primaryColor,
                                                      unit: "گرم",
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        Get.defaultDialog(
                                                          confirm: Column(
                                                            children: controller.listTransactionInfoFooter.map((e)=>e.unitName=="گرم" && e.totalPositiveBalance! > 0 ? Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  e.itemName??"",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ), Text(
                                                                  "${e.totalPositiveBalance??0} گرم ",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ),
                                                              ],
                                                            ):SizedBox()).toList(),
                                                          ),
                                                          middleText: "لیست مانده طلای بستانکار",
                                                          middleTextStyle: context
                                                              .textTheme.bodyMedium!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 13),
                                                          title: "جزییات",
                                                          titleStyle: context
                                                              .textTheme.titleSmall!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 14),
                                                          backgroundColor: AppColor.textColor,
                                                          radius: 7,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              horizontal: 20, vertical: 20),


                                                        );
                                                      },
                                                      child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                                                          colorFilter: ColorFilter.mode(
                                                            AppColor.textColor,
                                                            BlendMode.srcIn,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                // طلا بدهکار
                                                Row(
                                                  children: [
                                                    _buildFooterItem(
                                                      title: "طلا بدهکار",
                                                      negativeValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "گرم")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalNegativeBalance ?? 0)),
                                                      color: AppColor.accentColor,
                                                      unit: "گرم",
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        Get.defaultDialog(
                                                          confirm: Column(
                                                            children: controller.listTransactionInfoFooter.map((e)=>e.unitName=="گرم" && e.totalNegativeBalance! < 0 ? Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  e.itemName??"",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ), Text(
                                                                  "${e.totalNegativeBalance??0} گرم ",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ),
                                                              ],
                                                            ):SizedBox()).toList(),
                                                          ),
                                                          middleText: "لیست مانده طلای بدهکار",
                                                          middleTextStyle: context
                                                              .textTheme.bodyMedium!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 13),
                                                          title: "جزییات",
                                                          titleStyle: context
                                                              .textTheme.titleSmall!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 14),
                                                          backgroundColor: AppColor.textColor,
                                                          radius: 7,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              horizontal: 20, vertical: 20),


                                                        );
                                                      },
                                                      child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                                                          colorFilter: ColorFilter.mode(
                                                            AppColor.textColor,
                                                            BlendMode.srcIn,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                // سکه بستانکار
                                                Row(
                                                  children: [
                                                    _buildFooterItem(
                                                      title: "سکه بستانکار",
                                                      positiveValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "عدد")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalPositiveBalance ?? 0)),
                                                      color: AppColor.primaryColor,
                                                      unit: "عدد",
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        Get.defaultDialog(
                                                          confirm: Column(
                                                            children: controller.listTransactionInfoFooter.map((e)=>e.unitName=="عدد" && e.totalPositiveBalance! > 0 ? Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  e.itemName??"",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ), Text(
                                                                  "${e.totalPositiveBalance??0} عدد ",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ),
                                                              ],
                                                            ):SizedBox()).toList(),
                                                          ),
                                                          middleText: "لیست مانده سکه بستانکار",
                                                          middleTextStyle: context
                                                              .textTheme.bodyMedium!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 13),
                                                          title: "جزییات",
                                                          titleStyle: context
                                                              .textTheme.titleSmall!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 14),
                                                          backgroundColor: AppColor.textColor,
                                                          radius: 7,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              horizontal: 20, vertical: 20),


                                                        );
                                                      },
                                                      child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                                                          colorFilter: ColorFilter.mode(
                                                            AppColor.textColor,
                                                            BlendMode.srcIn,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                // سکه بدهکار
                                                Row(
                                                  children: [
                                                    _buildFooterItem(
                                                      title: "سکه بدهکار",
                                                      negativeValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "عدد")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalNegativeBalance ?? 0)),
                                                      color: AppColor.accentColor,
                                                      unit: "عدد",
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        Get.defaultDialog(
                                                          confirm: Column(
                                                            children: controller.listTransactionInfoFooter.map((e)=>e.unitName=="عدد" && e.totalNegativeBalance! < 0 ? Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  e.itemName??"",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ), Text(
                                                                  "${e.totalNegativeBalance??0} عدد ",
                                                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                                                ),
                                                              ],
                                                            ):SizedBox()).toList(),
                                                          ),
                                                          middleText: "لیست مانده سکه بدهکار",
                                                          middleTextStyle: context
                                                              .textTheme.bodyMedium!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 13),
                                                          title: "جزییات",
                                                          titleStyle: context
                                                              .textTheme.titleSmall!
                                                              .copyWith(
                                                              color: AppColor.backGroundColor,
                                                              fontSize: 14),
                                                          backgroundColor: AppColor.textColor,
                                                          radius: 7,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              horizontal: 20, vertical: 20),


                                                        );
                                                      },
                                                      child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                                                          colorFilter: ColorFilter.mode(
                                                            AppColor.textColor,
                                                            BlendMode.srcIn,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                // ارز بستانکار
                                                Column(
                                                  children: [
                                                    _buildFooterItem(
                                                      title: "ارز بستانکار",
                                                      positiveValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "دلار")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalPositiveBalance ?? 0)),
                                                      color: AppColor.primaryColor,
                                                      unit: "دلار",
                                                    ),
                                                    _buildFooterItem(
                                                      title: "",
                                                      positiveValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "یورو")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalPositiveBalance ?? 0)),
                                                      color: AppColor.primaryColor,
                                                      unit: "یورو",
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                // ارز بدهکار
                                                Column(
                                                  children: [
                                                    _buildFooterItem(
                                                      title: "ارز بدهکار",
                                                      negativeValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "دلار")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalNegativeBalance ?? 0)),
                                                      color: AppColor.accentColor,
                                                      unit: "دلار",
                                                    ),
                                                    SizedBox(height: 2,),
                                                    _buildFooterItem(
                                                      title: "",
                                                      positiveValue: controller.listTransactionInfoFooter
                                                          .where((item) => item.unitName == "یورو")
                                                          .fold(0.0, (sum, item) => sum! + (item.totalNegativeBalance ?? 0)),
                                                      color: AppColor.primaryColor,
                                                      unit: "یورو",
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                                                                ),
                                                                              ),
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppColor.backGroundColor1.withOpacity(0.5),),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppColor.appBarColor.withOpacity(0.5),),
                                                    child:  Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // ریال خالص
                                                          _buildNetFooterItem(
                                                            title: "ریال خالص",
                                                            netValue: controller.listTransactionInfoFooter
                                                                .where((item) => item.unitName == "ریال")
                                                                .fold(0.0, (sum, item) => sum + ((item.totalPositiveBalance ?? 0) + (item.totalNegativeBalance ?? 0))),
                                                            unit: "ریال",
                                                          ),
                                                          SizedBox(width: 50),
                                                          // طلا خالص
                                                          _buildNetFooterItem(
                                                            title: "طلا خالص",
                                                            netValue: controller.listTransactionInfoFooter
                                                                .where((item) => item.unitName == "گرم")
                                                                .fold(0.0, (sum, item) => sum + ((item.totalPositiveBalance ?? 0) + (item.totalNegativeBalance ?? 0))),
                                                            unit: "گرم",
                                                          ),
                                                          SizedBox(width: 50),
                                                          // Individual Coin Types
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: controller.listTransactionInfoFooter
                                                                  .where((item) => item.unitName == "عدد")
                                                                  .map((item) {
                                                                final netValue = (item.totalPositiveBalance ?? 0) + (item.totalNegativeBalance ?? 0);
                                                                if (netValue == 0.0) return SizedBox();
                                                                return Padding(
                                                                  padding: EdgeInsets.only(bottom: 8),
                                                                  child: _buildNetFooterItem(
                                                                    title: item.itemName ?? "سکه",
                                                                    netValue: netValue,
                                                                    unit: "عدد",
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                          SizedBox(width: 50),
                                                          // Individual Currency Types
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: controller.listTransactionInfoFooter
                                                                  .where((item) => item.itemGroupName == "ارز")
                                                                  .map((item) {
                                                                final netValue = (item.totalPositiveBalance ?? 0) + (item.totalNegativeBalance ?? 0);
                                                                if (netValue == 0.0) return SizedBox();
                                                                return Padding(
                                                                  padding: EdgeInsets.only(bottom: 8),
                                                                  child: _buildNetFooterItem(
                                                                    title: "" ?? "ارز",
                                                                    netValue: netValue,
                                                                    unit: item.unitName,
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                  ),
                                                  Container(
                                                    width: Get.width*0.2,
                                                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppColor.appBarColor.withOpacity(0.5),),
                                                    child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "مجموع کل:",
                                                          style: AppTextStyle.labelText.copyWith(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        _buildNetFooterItem(
                                                          title: "مجموع کل",
                                                          netValue: controller.listTransactionInfoFooter.fold(0.0, (sum, item) =>
                                                          sum + ((item.totalPositiveBalance ?? 0) + (item.totalNegativeBalance ?? 0))
                                                          ),
                                                          unit: "ریال",
                                                        ),
                                                      ],
                                                    ),

                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Center(
              child: ErrPage(
                callback: () {
                  controller.clearSearch();
                  controller.getListTransactionInfoPager();
                },
                title: "خطا در لیست کاربران",
                des: 'برای دریافت لیست کاربران مجددا تلاش کنید',
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Pagination
              controller.paginated.value!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: controller.paginated.value?.totalCount??0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)):SizedBox(),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
    ));
  }
  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('ردیف',
                  style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('نام',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center,
      ),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 120),
              child: Row(
                children: [
                  Text('مانده ریالی',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بستانکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('مانده ریالی',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بدهکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('مانده طلا',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بستانکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('مانده طلا',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بدهکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('مانده سکه',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بستانکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('مانده سکه',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بدهکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('مانده ارز',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بستانکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('مانده ارز',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                  SizedBox(width: 5,),
                  Text('(بدهکار)',
                      style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('تراز کل',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),


    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.listTransactionInfo
        .map((trans) => DataRow(
      cells: [
        DataCell(
            Center(
          child: Text(
            "${trans.rowNum}",
            style: AppTextStyle.bodyText,
          ),
        )),
        DataCell(Center(
          child: GestureDetector(
            onTap: (){
              Get.toNamed("/userInfoTransaction",parameters: {"accountId":trans.accountId.toString()});
              // /controller.getInfo(trans.accountId);
            },
            child: Text(
                "${trans.accountName} ",
                style: AppTextStyle.bodyText
                    .copyWith(color: AppColor.textColor, fontSize: 11,decoration: TextDecoration.underline,decorationColor: AppColor.textColor,decorationThickness: 3),),
          ),
        )),

        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : Column(
                  children: trans.balances
                      .map((e) => Container(
                    child: e.unitName == "ریال" && e.balance! >0
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .primaryColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString().seRagham(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color:  AppColor
                                  .primaryColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .primaryColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        SizedBox(width: 120,),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ))),
        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances .isEmpty
                    ? SizedBox()
                    : Column(
                  children: trans.balances
                      .map((e) => Container(
                    child: e.unitName == "ریال" && e.balance! <0
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString().seRagham(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color:  AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        SizedBox(width: 120,),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ))),

        DataCell(Center(
            child:
            trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" ? sum + item.balance!:sum + 0)>0 ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم"  ? sum + item.balance!:sum + 0) == 0?
                SizedBox(width: 150,):
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                          child: Row(
                                            children: [
                          Text(" طلای آبشده ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:  AppColor
                                      .primaryColor,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                          Text(
                            trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" ? sum + item.balance!:sum + 0).toStringAsFixed(3),
                            style: AppTextStyle.bodyText
                                .copyWith(
                                fontSize: 11,
                                color:  AppColor
                                    .primaryColor,
                                fontWeight:
                                FontWeight.bold),
                            textDirection:
                            TextDirection.ltr,
                          ),
                          Text(" گرم ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:  AppColor
                                      .primaryColor,
                                  fontWeight:
                                  FontWeight.bold)
                            //  textDirection: TextDirection.ltr,
                          ),
                                            ],
                                          ),
                        ),
                    GestureDetector(
                      onTap: (){
                        Get.defaultDialog(
                          confirm: Column(
                            children: trans.balances.map((e)=>e.unitName=="گرم" ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.itemName??"",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                ), Text(
                                  "${e.balance??0} گرم ",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                ),
                              ],
                            ):SizedBox()).toList(),
                          ),
                          middleText: "لیست مانده طلای بستانکار",
                          middleTextStyle: context
                              .textTheme.bodyMedium!
                              .copyWith(
                              color: AppColor.backGroundColor,
                              fontSize: 13),
                          title: "جزییات",
                          titleStyle: context
                              .textTheme.titleSmall!
                              .copyWith(
                              color: AppColor.backGroundColor,
                              fontSize: 14),
                          backgroundColor: AppColor.textColor,
                          radius: 7,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),


                        );
                      },
                      child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                          colorFilter: ColorFilter.mode(
                            AppColor.textColor,
                            BlendMode.srcIn,
                          )),
                    ),
                  ],
                ),


              ],
            ):
                SizedBox.shrink(),
        ),
        ),
        DataCell(Center(
            child:
            trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" ? sum + item.balance!:sum + 0)<0 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" ? sum + item.balance!:sum + 0) == 0?
                SizedBox(width: 150,):
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          Text(" طلای آبشده ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:  AppColor
                                      .accentColor,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                          Text(
                            trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" ? sum + item.balance!:sum + 0).toStringAsFixed(3),
                            style: AppTextStyle.bodyText
                                .copyWith(
                                fontSize: 11,
                                color:  AppColor
                                    .accentColor
                                ,
                                fontWeight:
                                FontWeight.bold),
                            textDirection:
                            TextDirection.ltr,
                          ),
                          Text(" گرم ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:  AppColor
                                      .accentColor,
                                  fontWeight:
                                  FontWeight.bold)
                            //  textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.defaultDialog(
                          confirm: Column(
                            children: trans.balances.map((e)=>e.unitName=="گرم" ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.itemName??"",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                ), Text(
                                  "${e.balance??0} گرم",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                ),
                              ],
                            ):SizedBox()).toList(),
                          ),
                          middleText: "لیست مانده طلای بدهکار",
                          middleTextStyle: context
                              .textTheme.bodyMedium!
                              .copyWith(
                              color: AppColor.backGroundColor,
                              fontSize: 13),
                          title: "جزییات",
                          titleStyle: context
                              .textTheme.titleSmall!
                              .copyWith(
                              color: AppColor.backGroundColor,
                              fontSize: 14),
                          backgroundColor: AppColor.textColor,
                          radius: 7,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),


                        );
                      },
                      child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                          colorFilter: ColorFilter.mode(
                            AppColor.textColor,
                            BlendMode.srcIn,
                          )),
                    ),
                  ],
                ),

              ],
            ):
                SizedBox.shrink(),
        ),
        ),

        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : Column(
                  children: trans.balances
                      .map((e) => Container(
                    child: e.unitName == "عدد" && e.balance! >0
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: AppColor
                                    .primaryColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 11,
                              color:  AppColor
                                  .primaryColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .primaryColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        SizedBox(width: 120,),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ))),
        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : Column(
                  children: trans.balances
                      .map((e) => Container(
                    child: e.unitName == "عدد" && e.balance! < 0
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        SizedBox(width: 120,),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ))),


        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : Column(
                  children: trans.balances
                      .map((e) => Container(
                    child: e.unitName == "دلار" && e.balance! > 0
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .primaryColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color:  AppColor
                                  .primaryColor
                                 ,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .primaryColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        SizedBox(width: 120,),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ))),
        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : Column(
                  children: trans.balances
                      .map((e) => Container(
                    child: e.unitName == "دلار" && e.balance! < 0
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color:  AppColor
                                  .accentColor
                              ,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:  AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : Row(
                          children: [
                            SizedBox(width: 120,),
                          ],
                        ),
                  ))
                      .toList(),
                ),
              ],
            ))),

        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Column(
                 children: [
                   Row(

                     children: [
                       SvgPicture.asset(
                           'assets/svg/scales.svg',
                           height: 15,
                           colorFilter:
                           ColorFilter
                               .mode(
                             trans.currencyValue>0?  AppColor
                                 .primaryColor:AppColor
                                 .accentColor,
                             BlendMode
                                 .srcIn,
                           )),
                       SizedBox(width: 5,),
                       Text(trans.currencyValue.toStringAsFixed(0).seRagham(),
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 10,
                               color:trans.currencyValue>0?  AppColor
                                   .primaryColor:AppColor
                                   .accentColor,
                               fontWeight:
                               FontWeight
                                   .bold)),

                       Text(" ریال ",
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 8,
                               color:trans.currencyValue>0?  AppColor
                                   .primaryColor:AppColor
                                   .accentColor,
                               fontWeight:
                               FontWeight
                                   .bold)),

                       SizedBox(width: 5,)
                     ],
                   ),
                   Container(
                     margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                     height: 0.5,color: AppColor.textColor,
                   ),
                   Row(
                     children: [
                       Text(" معادل آبشده : ",
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 9,
                               color:AppColor
                                   .textColor,
                               fontWeight:
                               FontWeight
                                   .bold)),
                       Text(" ${trans.goldValue.toStringAsFixed(3)} ",
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 9,
                               color:AppColor
                                   .textColor,
                               fontWeight:
                               FontWeight
                                   .bold)),

                       Text(" گرم ",
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 8,
                               color:AppColor
                                   .textColor,
                               fontWeight:
                               FontWeight
                                   .bold)),
                     ],
                   ),
                   SizedBox(height: 5,),
                   Row(
                     children: [
                       Text(" معادل سکه : ",
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 9,
                               color:AppColor
                                   .textColor,
                               fontWeight:
                               FontWeight
                                   .bold)),
                       Text(" ${trans.coinValue.toStringAsFixed(3)} ",
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 9,
                               color:AppColor
                                   .textColor,
                               fontWeight:
                               FontWeight
                                   .bold)),

                       Text(" عدد ",
                           style: AppTextStyle
                               .bodyText
                               .copyWith(
                               fontSize: 8,
                               color:AppColor
                                   .textColor,
                               fontWeight:
                               FontWeight
                                   .bold)),
                     ],
                   ),
                 ],
                ),
              ],
            ))),
      ],
    ))
        .toList();
  }

  Widget _buildFooterItem({
    required String title,
    double? positiveValue,
    double? negativeValue,
    required Color color,
    String? unit,
  }) {
    final value = positiveValue ?? negativeValue ?? 0.0;

    // Don't display if value is zero
    if (value == 0.0) {
      return SizedBox();
    }

    String formattedValue;
    if (unit == "ریال") {
      // For Rial, use seRagham formatting
      formattedValue = value.toStringAsFixed(3).seRagham();
    } else if(unit == "گرم") {
      // For other units, use 3 decimal places
      formattedValue = value.toStringAsFixed(3);
    }else{
      formattedValue = value.toString();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedValue,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.ltr,
              ),
              if (unit != null) ...[
                SizedBox(width: 4),
                Text(
                  unit,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetFooterItem({
    required String title,
    required double netValue,
    String? unit,
  }) {
    // Don't display if net value is zero
    if (netValue == 0.0) {
      return SizedBox();
    }

    // Determine color based on net value
    final color = netValue > 0 ? AppColor.primaryColor : AppColor.accentColor;

    String formattedValue;
    if (unit == "ریال") {
      // For Rial, use seRagham formatting
      formattedValue = netValue.toStringAsFixed(3).seRagham();
    } else if(unit == "گرم") {
      // For other units, use 3 decimal places
      formattedValue = netValue.toStringAsFixed(3);
    }else{
      formattedValue = netValue.toString();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedValue,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.ltr,
              ),
              if (unit != null) ...[
                SizedBox(width: 4),
                Text(
                  unit,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

}

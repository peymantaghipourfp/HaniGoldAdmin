import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/user_info_transaction.controller.dart';

class ListUserInfoTransactionView extends GetView<UserInfoTransactionController> {
  const ListUserInfoTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppBar(
        title: 'مانده کاربران',
        onBackTap: () => Get.back(),
      ),
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
                        controller.getListTransactionInfo();
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
                                controller.getListTransactionInfo();
                              },
                              icon: Icon(
                                Icons.search,
                                color: AppColor.textColor,
                                size: 30,
                              )),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
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
                                  sortColumnIndex: controller.sortIndex.value,
                                  sortAscending:
                                  controller.sort.value,
                                  border: TableBorder.symmetric(
                                      inside: BorderSide(
                                          color: AppColor
                                              .textFieldColor,
                                          width: 0.5)),
                                  dividerThickness: 0.3,
                                  rows: buildDataRows(
                                      context),
                                  dataRowMaxHeight: 100,
                                  //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                  //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                  headingRowHeight: 60,
                                  columnSpacing: 20,
                                  horizontalMargin: 0,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Center(
              child: Text(
                'خطا در سمت سرور رخ داده',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
             alignment: Alignment.bottomCenter,
              child: buildPaginationControls()),
        ],
      ),
    ));
  }
  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('ردیف',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            print(columnIndex);
            controller.setSort(columnIndex,ascending);

            controller.onSortColum(columnIndex, ascending);
          },
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('نام',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
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
          headingRowAlignment: MainAxisAlignment.center),
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
          headingRowAlignment: MainAxisAlignment.center),

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" &&item.balance! > 0 ? sum + item.balance!:sum + 0) == 0?
                SizedBox(width: 120,):
                Row(
                  children: [
                    SizedBox(
                      width: 130,
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
                            trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" &&item.balance! >0 ? sum + item.balance!:sum + 0).toStringAsFixed(3),
                            style: AppTextStyle.bodyText
                                .copyWith(
                                fontSize: 11,
                                color:  AppColor
                                    .primaryColor
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
                            children: trans.balances.map((e)=>e.unitName=="گرم" && e.balance! > 0 ? Row(
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
            ))),
        DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances.isEmpty
                    ? SizedBox()
                    : trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" &&item.balance! <0 ? sum + item.balance!:sum + 0) == 0?
                SizedBox(width: 120,):
                Row(
                  children: [
                    SizedBox(
                      width: 130,
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
                            trans.balances.fold(0.0, (sum, item) => item.unitName=="گرم" &&item.balance! <0 ? sum + item.balance!:sum + 0).toStringAsFixed(3),
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
                            children: trans.balances.map((e)=>e.unitName=="گرم" && e.balance! < 0? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.itemName??"",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                ), Text(
                                  "${e.balance??0} عدد",
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
                       Text(" ${trans.currencyValue} ".seRagham(),
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

                       SizedBox(width: 20,)
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

  Widget buildPaginationControls() {
    return Obx(() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: controller.currentPageIndex.value > 1
                ? controller.previousPage
                : null,
          ),
          Text(
            'صفحه ${controller.currentPageIndex.value}',
            style: AppTextStyle.bodyText,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed:
            controller.hasMore.value ? controller.nextPage : null,
          ),
        ],
      ),
    ));
  }


}

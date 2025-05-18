import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/pager_widget.dart';
import '../controller/user_list.controller.dart';
import 'package:syncfusion_flutter_core/theme.dart';
class UserListView extends GetView<UserListController> {
   UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppBar(
        title: 'لیست کاربران',
        onBackTap: () => Get.toNamed("/home"),
      ),
      body:Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageStateUser.loading
                ? Center(
              child: SizedBox(
                  height: Get.height ,
                  width: Get.width,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 50,width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircularProgressIndicator(),
                          )),
                    ],
                  )),
            )
                : controller.state.value == PageStateUser.list
                ? SizedBox(
              height: Get.height *0.85,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //فیلد جستجو
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: AppColor.circleColor.withOpacity(0.5),
                      alignment: Alignment.center,

                      height: 80,
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
                         // controller.getListTransactionInfo();
                        },

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          hintText: "جستجو ... ",
                          hintStyle: AppTextStyle.labelText,

                          prefixIcon: IconButton(
                              onPressed: () async {
                               // controller.getListTransactionInfo();
                              },
                              icon: Icon(
                                Icons.search,
                                color: AppColor.textColor,
                                size: 30,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      color: AppColor.circleColor.withOpacity(0.5),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: AppColor.secondary3Color
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,color: AppColor.textColor,size: 21,),
                                          Text(
                                            'ایجاد کاربری جدید',
                                            style: AppTextStyle.labelText.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: AppColor.secondary3Color
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/fileExcel.svg',
                                              height: 23,
                                              colorFilter:
                                              ColorFilter
                                                  .mode(
                                                AppColor
                                                    .textColor,
                                                BlendMode
                                                    .srcIn,
                                              )),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          Text(
                                            'خروجی اکسل',
                                            style: AppTextStyle
                                                .labelText
                                                .copyWith(
                                                fontSize: isDesktop
                                                    ? 12
                                                    : 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: AppColor.textColor)

                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svg/filter3.svg',
                                          height: 17,
                                          colorFilter:
                                          ColorFilter
                                              .mode(
                                            AppColor
                                                .textColor,
                                            BlendMode
                                                .srcIn,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'فیلتر',
                                        style: AppTextStyle
                                            .labelText
                                            .copyWith(
                                            fontSize: isDesktop
                                                ? 12
                                                : 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

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
                                                width: 0.5),outside: BorderSide(
                                            color: AppColor
                                                .textFieldColor,
                                            width: 0.5),borderRadius: BorderRadius.circular(8)),
                                        dividerThickness: 0.3,
                                        rows: buildDataRows(
                                            context),
                                        dataRowMaxHeight: 52,
                                        //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                        //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                        headingRowHeight: 50,
                                        columnSpacing: 90,
                                        horizontalMargin: 60,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              controller.paginated!=null?   Container(
                height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.circleColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: controller.paginated!.totalCount??0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)):SizedBox(),
            ],
          ),
        ],
      ),
    ));
  }
  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50,),
              child: Text('ردیف',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            print(columnIndex);
            controller.setSort(columnIndex,ascending);

            controller.onSortColum(columnIndex, ascending);
          },
          label: Text('نام',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Row(
            children: [
              Text('موبایل',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Row(
            children: [
              Text('وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Row(
            children: [
              Text('نقش',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Row(
            children: [
              Text('تاریخ ثبت نام',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Row(
            children: [
              Text('عملیات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Row(
            children: [
              Text('تایید / رد',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),


    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.accountList
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
            //  Get.toNamed("/userInfoTransaction",parameters: {"accountId":trans.accountId.toString()});
              // /controller.getInfo(trans.accountId);
            },
            child: Text(
              "${trans.name}",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 12,),),
          ),
        )),

        DataCell(
            Center(
              child: SizedBox(
                child: Text(
                  trans.contactInfo??"",
                  style: AppTextStyle.bodyText,
                ),
              ),
            )),
        DataCell(Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6,vertical: 3),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(5)),
               color: trans.status==1?AppColor.primaryColor:AppColor.accentColor
             ),
              child:Text(
             trans.status==1?   "تایید شده":"رد شده ",
                style: AppTextStyle.bodyText.copyWith(fontSize: 9),
              ) ,

            ))),

        DataCell(
            Center(
              child: SizedBox(
                child: Text(
                  "-",
                  style: AppTextStyle.bodyText,
                ),
              ),
            )),
        DataCell(Center(
            child:Row(
              children: [
                Text(
                  "${trans.startDate?.toPersianDate(twoDigits: true,showTime: true,timeSeprator: ' - ')}",
                  style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,
                ),
              ],
            ) ,)),

        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 15,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: AppColor.secondary3Color
                  ),
                  child:Text(
                    "فاکتور",
                    style: AppTextStyle.bodyText.copyWith(fontSize: 10),
                  ) ,

                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: AppColor.secondary2Color
                  ),
                  child:Text(
                    "فاکتور جدید",
                    style: AppTextStyle.bodyText.copyWith(fontSize: 10),
                  ) ,

                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/close-circle1.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset('assets/svg/check-mark-circle.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.primaryColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),



      ],
    ))
        .toList();
  }

  // Widget buildPaginationControls() {
  //   return Obx(() => Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         IconButton(
  //           icon: Icon(Icons.chevron_left),
  //           onPressed: controller.currentPageIndex.value > 1
  //               ? controller.previousPage
  //               : null,
  //         ),
  //         Text(
  //           'صفحه ${controller.currentPageIndex.value}',
  //           style: AppTextStyle.bodyText,
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.chevron_right),
  //           onPressed:
  //           controller.hasMore.value ? controller.nextPage : null,
  //         ),
  //       ],
  //     ),
  //   ));
  // }

  // Widget buildPaginationControls() {
  //   return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child:   SizedBox(
  //         height: 60,
  //         child:controller.paginated!=null? SfDataPagerTheme(
  //           data: SfDataPagerThemeData(
  //             itemColor: Colors.transparent,
  //             selectedItemColor: AppColor.secondary3Color,
  //             backgroundColor: AppColor.textFieldColor,
  //             itemTextStyle:  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.textColor),
  //             disabledItemTextStyle: AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.secondaryColor.withOpacity(0.5)),
  //             selectedItemTextStyle: AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.textColor),
  //             itemBorderColor: AppColor.textColor
  //           ),
  //           child: SfDataPager(
  //             controller:controller.dataPagerController ,
  //             onPageNavigationEnd:(value){
  //               print(value+1);
  //                controller.isChangePage(value+1);
  //             },
  //             onPageNavigationStart: (value){
  //              // print(value);
  //              // controller.getUserList();
  //             },
  //             delegate: DataPagerDelegate(),
  //             direction: Axis.horizontal, pageCount: (controller.paginated!.totalCount!/10).toDouble(),
  //           ),
  //         ):SizedBox(),
  //       )
  //   );
  // }



}



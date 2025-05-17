import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/user_list.controller.dart';

class UserListView extends GetView<UserListController> {
  const UserListView({super.key});

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
              child: CircularProgressIndicator(),
            )
                : controller.state.value == PageStateUser.list
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
                  Text('موبایل',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('وضعیت',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('نقش',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('تاریخ ثبت نام',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('عملیات',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Row(
                children: [
                  Text('تایید / رد',
                      style: AppTextStyle.labelText.copyWith(fontSize: 11)),
                ],
              )),
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
              "${trans.firstName} ${trans.lastName}",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11,decoration: TextDecoration.underline,decorationColor: AppColor.textColor,decorationThickness: 3),),
          ),
        )),

        DataCell(
            Center(
              child: Text(
                trans.contactInfo??"",
                style: AppTextStyle.bodyText,
              ),
            )),
        DataCell(Center(
            child: Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(5)),
               color: trans.status==1?AppColor.primaryColor:AppColor.accentColor
             ),
              child:Text(
             trans.status==1?   "تایید شده":"رد شده ",
                style: AppTextStyle.bodyText,
              ) ,

            ))),

        DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "- ",
                  style: AppTextStyle.bodyText,
                ) ,
              ],

            ))),
        DataCell(Center(
            child:Text(
              "",
              style: AppTextStyle.bodyText,
            ) ,)),

        DataCell(Center(
          child:Text(
            "",
            style: AppTextStyle.bodyText,
          ) ,)),
        DataCell(Center(
          child:Text(
            "",
            style: AppTextStyle.bodyText,
          ) ,)),


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

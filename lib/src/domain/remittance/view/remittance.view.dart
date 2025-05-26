import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/remittance.controller.dart';

class RemittanceView extends GetView<RemittanceController> {
  const RemittanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
          appBar: CustomAppbar1(
            title: 'لیست حواله',
            onBackTap: () => Get.offNamed('/home'),
          ),
          body: Stack(
            children: [
              BackgroundImageTotal(),
              SafeArea(
                child: controller.state.value == PageState.loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.state.value == PageState.list
                        ? SizedBox(
                          height: Get.height,width: Get.width,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  //فیلد جستجو
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    color: AppColor.appBarColor.withOpacity(0.5),
                                    alignment: Alignment.center,
                                    height: 80,
                                    child: TextFormField(
                                      controller: controller.searchController,
                                      style: AppTextStyle.labelText,
                                      textInputAction: TextInputAction.search,
                                      onFieldSubmitted: (value) async {},
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        filled: true,
                                        fillColor: AppColor.textFieldColor,
                                        hintText: "جستجو ... ",
                                        hintStyle: AppTextStyle.labelText,
                                        prefixIcon: IconButton(
                                            onPressed: () async {},
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
                                    color: AppColor.appBarColor.withOpacity(0.5),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  // ایجاد حواله
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        padding: isDesktop ?
                                                        WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12,vertical: 17)):
                                                        WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10,vertical: 14)),
                                                        elevation: WidgetStatePropertyAll(5),
                                                        backgroundColor:
                                                        WidgetStatePropertyAll(AppColor.secondary3Color),
                                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5)))),
                                                    onPressed: () async {
                                                      Get.toNamed("/insertRemittance",);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'ایجاد حواله',
                                                          style: AppTextStyle.labelText.copyWith(
                                                            fontSize:isDesktop ? 12 : 10,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width:isDesktop ? 15 : 5,),
                                                  Row(
                                                    children: [
                                                      // خروجی اکسل
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                            padding:isDesktop ? WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23,vertical: 19)) :
                                                            WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 21,vertical: 17)),
                                                            // elevation: WidgetStatePropertyAll(5),
                                                            backgroundColor:
                                                            WidgetStatePropertyAll(AppColor.secondary3Color),
                                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5)))),
                                                        onPressed: () {
                                                          controller.exportToExcel();
                                                        },
                                                        child: Text(
                                                          'خروجی اکسل',
                                                          style: AppTextStyle.labelText,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      // خروجی pdf
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                            padding:isDesktop ? WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23,vertical: 19)):
                                                            WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 21,vertical: 17)),
                                                            // elevation: WidgetStatePropertyAll(5),
                                                            backgroundColor:
                                                            WidgetStatePropertyAll(AppColor.secondary3Color),
                                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5)))),
                                                        onPressed: () {
                                                          controller.exportToPdf();
                                                        },
                                                        child: Text(
                                                          'خروجی pdf',
                                                          style: AppTextStyle.labelText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // فیلتر
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
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                  
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          controller: controller.scrollController,
                                          physics: ClampingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    DataTable(
                                                      columns: buildDataColumns(),
                                                      dividerThickness: 0.3,
                                                      rows: buildDataRows(context),
                                                      border: TableBorder.symmetric(
                                                          inside: BorderSide(color: AppColor.textColor,width: 0.3),
                                                          outside: BorderSide(color: AppColor.textColor,width: 0.3),
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      dataRowMaxHeight: 90,
                                                      //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                                      //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                                      headingRowHeight: 60,
                                                      columnSpacing: 25,
                                                      horizontalMargin: 6,
                                                    ),
                                                    buildPaginationControls(),
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
            ],
          ),
        ));
  }

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('ردیف', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('تاریخ',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام ثبت کننده',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Column(
                children: [
                  Text('بدهکار ',
                      style: AppTextStyle.labelText
                          .copyWith(color: AppColor.accentColor, fontSize: 12)),
                  SvgPicture.asset('assets/svg/refresh.svg',
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColor.textColor,
                        BlendMode.srcIn,
                      )),
                  Text(' بستانکار',
                      style: AppTextStyle.labelText.copyWith(
                          color: AppColor.primaryColor, fontSize: 12)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('محصول',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مقدار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('شرح',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده ریالی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده طلایی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده سکه',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('عملیات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.remittanceList.map((remittance) {
      //print(" تسسسسسسسست ${inventory.inventoryDetails?.first.itemUnit?.name}");
      return DataRow(
        cells: [
          // ردیف
          DataCell(
              Center(
                child:
                Row(
                  children: [
                    // رجیستر
                    Checkbox(
                      value: remittance.registered ?? false,
                      onChanged: (value) async{
                        if (value != null) {
                          //EasyLoading.show(status: 'لطفا منتظر بمانید');
                          await controller.updateRegistered(
                              remittance.id!,
                              value
                          );
                        }
                        controller.fetchRemittanceList();
                        //EasyLoading.dismiss();
                      },
                    ),
                    SizedBox(width: 5,),
                    Text("${remittance.rowNum}",
                      style:
                      AppTextStyle.bodyText,
                    ),
                  ],
                ),
              ),
          ),
          // تاریخ
          DataCell(Center(
            child: Text(
              remittance.date?.toPersianDate(showTime: true) ?? 'نامشخص',
              style: AppTextStyle.bodyText,
              textDirection: TextDirection.ltr,
            ),
          )),
          DataCell(Center(
            child: Text(
              remittance.createdBy?.name ?? 'نامشخص',
              style: AppTextStyle.bodyText,
            ),
          )),
          DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${remittance.walletPayer?.account?.name ?? 'نامشخص'} ",
                    style: AppTextStyle.bodyText
                        .copyWith(color: AppColor.accentColor, fontSize: 12)),
                SvgPicture.asset('assets/svg/refresh.svg',
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
                Text(" ${remittance.walletReciept?.account?.name ?? 'نامشخص'}",
                    style: AppTextStyle.bodyText
                        .copyWith(color: AppColor.primaryColor, fontSize: 12)),
              ],
            ),
          )),
          DataCell(Center(
            child: Row(
              children: [
                Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${remittance.item?.icon}',
                  width: 35,
                  height: 35,),
                SizedBox(width: 5,),
                Text(
                  remittance.item?.name ?? 'نامشخص',
                  style: AppTextStyle.bodyText.copyWith(
                      color: AppColor.secondary2Color,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ),
          )),
          DataCell(Center(
            child: Text(
              remittance.item?.itemUnit?.id == 1
                  ? "${remittance.quantity} عدد "
                  : remittance.item?.itemUnit?.id == 2
                      ? "${remittance.quantity} گرم "
                      : "${remittance.quantity.toString().seRagham()} ریال ",
              style: AppTextStyle.bodyText,
            ),
          )),
          DataCell(Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: remittance.status == 1
                      ? AppColor.secondary2Color
                      : remittance.status == 1
                          ? AppColor.accentColor
                          : AppColor.textFieldColor,
                  borderRadius: BorderRadius.circular(7)),
              child: Text(
                remittance.status == 1
                    ? "تایید شده"
                    : remittance.status == 0
                        ? "تایید نشده"
                        : "نامشخص",
                style: AppTextStyle.bodyText
                    .copyWith(color: AppColor.textColor, fontSize: 12),
              ),
            ),
          )),
          DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " از : ",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor, fontSize: 10),
                    ),
                    Text(
                      " ${remittance.walletPayer?.account?.name??"نامشخص"}",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.accentColor, fontSize: 10),
                    ),
                    Text(
                      " به : ",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor, fontSize: 10),
                    ),
                    Text(
                      " ${remittance.walletReciept?.account?.name??"نامشخص"}",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.primaryColor, fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      remittance.item?.itemUnit?.id == 1
                          ? "${remittance.quantity} عدد "
                          : remittance.item?.itemUnit?.id == 2
                              ? "${remittance.quantity} گرم "
                              : "${remittance.quantity.toString().seRagham()} ریال ",
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                    ),
                    Text(
                      "  ",
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.secondary2Color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                    ),
                    Text(
                      remittance.item?.name ?? 'نامشخص',
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.secondary2Color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'توضیحات : ',
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                    ),
                    Text(remittance.description ?? 'نامشخص',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10)),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      remittance.date?.toPersianDate(showTime: true) ??
                          'نامشخص',
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.iconViewColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ],
            ),
          )),
          DataCell(Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              remittance.balancePayer==null?SizedBox() :Column(
                children: remittance.balancePayer!
                    .map((e) => Container(
                          child: e.unitName == "ریال"
                              ? Row(
                                  children: [
                                    Text(
                                      " ${e.itemName} ",
                                      style: AppTextStyle.bodyText.copyWith(
                                          fontSize: 12,
                                          color: AppColor.accentColor),
                                    ),
                                    Text(
                                      e.balance.toString(),
                                      style: AppTextStyle.bodyText.copyWith(
                                          fontSize: 12,
                                          color: AppColor.accentColor),
                                      textDirection: TextDirection.ltr,
                                    ),
                                    Text(
                                      " ${e.unitName} ",
                                      style: AppTextStyle.bodyText.copyWith(
                                          fontSize: 12,
                                          color: AppColor.accentColor),
                                    //  textDirection: TextDirection.ltr,
                                    ),

                                  ],
                                )
                              : SizedBox(),
                        ))
                    .toList(),
              ),
              remittance.balanceReciept==null?SizedBox() : Column(
                children: remittance.balanceReciept!
                    .map((e) => Container(
                  child: e.unitName == "ریال"
                      ? Row(
                    children: [
                      Text(
                        " ${e.itemName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                      ),
                      Text(
                        e.balance.toString(),
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        " ${e.unitName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                        //  textDirection: TextDirection.ltr,
                      ),

                    ],
                  )
                      : SizedBox(),
                ))
                    .toList(),
              ),
            ],
          ))),
          DataCell(Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              remittance.balancePayer==null?SizedBox() : Column(
                children: remittance.balancePayer!
                    .map((e) => Container(
                  child: e.unitName == "گرم"
                      ? Row(
                    children: [
                      Text(
                        " ${e.itemName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.accentColor),
                      ),
                      Text(
                        e.balance.toString(),
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.accentColor),
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        " ${e.unitName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.accentColor),
                        //  textDirection: TextDirection.ltr,
                      ),

                    ],
                  )
                      : SizedBox(),
                ))
                    .toList(),
              ),
              remittance.balanceReciept==null?SizedBox() :  Column(
                children: remittance.balanceReciept!
                    .map((e) => Container(
                  child: e.unitName == "گرم"
                      ? Row(
                    children: [
                      Text(
                        " ${e.itemName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                      ),
                      Text(
                        e.balance.toString(),
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        " ${e.unitName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                        //  textDirection: TextDirection.ltr,
                      ),

                    ],
                  )
                      : SizedBox(),
                ))
                    .toList(),
              ),
            ],
          ))),
          DataCell(Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              remittance.balancePayer==null?SizedBox() :  Column(
                children: remittance.balancePayer!
                    .map((e) => Container(
                  child: e.unitName == "عدد"
                      ? Row(
                    children: [
                      Text(
                        " ${e.itemName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.accentColor),
                      ),
                      Text(
                        e.balance.toString(),
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.accentColor),
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        " ${e.unitName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.accentColor),
                        //  textDirection: TextDirection.ltr,
                      ),

                    ],
                  )
                      : SizedBox(),
                ))
                    .toList(),
              ),
              remittance.balanceReciept==null?SizedBox() : Column(
                children: remittance.balanceReciept!
                    .map((e) => Container(
                  child: e.unitName == "عدد"
                      ? Row(
                    children: [
                      Text(
                        " ${e.itemName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                      ),
                      Text(
                        e.balance.toString(),
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        " ${e.unitName} ",
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor),
                        //  textDirection: TextDirection.ltr,
                      ),

                    ],
                  )
                      : SizedBox(),
                ))
                    .toList(),
              ),
            ],
          ))),

          DataCell(Center(
              child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              SvgPicture.asset('assets/svg/edit.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.iconViewColor,
                    BlendMode.srcIn,
                  )),
              SizedBox(
                width: 30,
              ),
              SvgPicture.asset('assets/svg/trash-bin.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.accentColor,
                    BlendMode.srcIn,
                  )),
              SizedBox(
                width: 20,
              ),
            ],
          ))),
        ],
      );
    }).toList();
  }

  Widget buildPaginationControls() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: controller.currentPage.value > 1
                    ? controller.previousPage
                    : null,
              ),
              Text(
                'صفحه ${controller.currentPage.value}',
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

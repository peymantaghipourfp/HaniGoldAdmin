import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../controller/user_info_date_transaction.controller.dart';

class ListUserInfoDateTransactionView extends GetView<UserInfoDateTransactionController> {
  const ListUserInfoDateTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: 'مانده کاربران (تاریخ)',
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
                controller:isDesktop ? null : controller.scrollControllerMobile,
                child: Column(
                  children: [
                    //فیلد جستجو
                    isDesktop ? SizedBox.shrink() :
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
                            await controller.getListTransactionInfoDatePager();
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
                                  controller.getListTransactionInfoDatePager();
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
                    /*Padding(
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
                            onPressed: () async {
                              controller.clearFilter();
                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel:
                                  MaterialLocalizations
                                      .of(context)
                                      .modalBarrierDismissLabel,
                                  barrierColor:
                                  Colors.black45,
                                  transitionDuration:
                                  const Duration(
                                      milliseconds:
                                      200),
                                  pageBuilder: (BuildContext
                                  buildContext,
                                      Animation animation,
                                      Animation
                                      secondaryAnimation) {
                                    return Center(
                                      child: Material(
                                        color: Colors
                                            .transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  8),
                                              color: AppColor
                                                  .backGroundColor),
                                          width: isDesktop
                                              ? Get.width *
                                              0.2
                                              : Get.width *
                                              0.5,
                                          height: isDesktop
                                              ? Get.height *
                                              0.5
                                              : Get.height *
                                              0.7,
                                          padding:
                                          EdgeInsets
                                              .all(20),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .all(
                                                    8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .end,
                                                  children: [
                                                    Expanded(
                                                      child:
                                                      Center(
                                                        child:
                                                        Text(
                                                          'خروجی اکسل',
                                                          style: AppTextStyle.labelText.copyWith(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: AppColor
                                                    .textColor,
                                                height: 0.2,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    10),
                                                child:
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                      8,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'نام حساب',
                                                          style: AppTextStyle.labelText.copyWith(fontSize: 11, fontWeight: FontWeight.normal, color: AppColor.textColor),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        IntrinsicHeight(
                                                          child: TextFormField(
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            controller: controller.nameFilterController,
                                                            style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                            textAlign: TextAlign.start,
                                                            keyboardType: TextInputType.text,
                                                            decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
                                                              isDense: true,
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(6),
                                                              ),
                                                              filled: true,
                                                              fillColor: AppColor.textFieldColor,
                                                              errorMaxLines: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                      8,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                    20,
                                                    vertical:
                                                    10),
                                                width: double
                                                    .infinity,
                                                height: 40,
                                                child:
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23)),
                                                      // elevation: WidgetStatePropertyAll(5),
                                                      backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor), borderRadius: BorderRadius.circular(5)))),
                                                  onPressed:
                                                      () async {
                                                    controller.getListUserInfoTransactionExcel();
                                                    Get.back();
                                                  },
                                                  child: controller
                                                      .isLoading
                                                      .value
                                                      ? CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                  )
                                                      : Text(
                                                    'خروجی اکسل',
                                                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              'خروجی اکسل',
                              style: AppTextStyle
                                  .labelText,
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    isDesktop ?
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30, top: 5,bottom: 30),
                      padding: EdgeInsets.only(left: 20,right: 20, top: 5, bottom: 40),
                      color: AppColor.backGroundColor1.withAlpha(150),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller:
                        controller.scrollController,
                        physics: ClampingScrollPhysics(),
                        child: Row(
                          children: [
                            SingleChildScrollView(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric( vertical: 5),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 400,
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
                                                await controller.getListTransactionInfoDatePager();
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
                                                      controller.getListTransactionInfoDatePager();
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
                                        SizedBox(width: 10),
                                        Row(mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            OutlinedButton.icon(
                                                onPressed: () async {
                                                  showGeneralDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      barrierLabel: MaterialLocalizations.of(context)
                                                          .modalBarrierDismissLabel,
                                                      barrierColor: Colors.black45,
                                                      transitionDuration: const Duration(milliseconds: 200),
                                                      pageBuilder: (BuildContext buildContext,
                                                          Animation animation,
                                                          Animation secondaryAnimation) {
                                                        return Center(
                                                          child: Material(
                                                            color: Colors.transparent,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: AppColor.backGroundColor
                                                              ),
                                                              width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                                                              height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                                              padding: EdgeInsets.all(20),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Center(
                                                                              child: Text(
                                                                                'فیلتر',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.normal,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 50,height: 27,
                                                                            child: ElevatedButton(
                                                                              style: ButtonStyle(
                                                                                  padding: WidgetStatePropertyAll(
                                                                                      EdgeInsets.symmetric(horizontal: 2,vertical: 1)),
                                                                                  // elevation: WidgetStatePropertyAll(5),
                                                                                  backgroundColor:
                                                                                  WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                                                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                                      borderRadius: BorderRadius.circular(5)))),
                                                                              onPressed: () async {
                                                                                controller.clearFilter();
                                                                                controller.getListTransactionInfoDatePager();
                                                                                Get.back();
                                                                              },
                                                                              child: Text(
                                                                                'حذف فیلتر',
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 9 : 8),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      color: AppColor.textColor,height: 0.2,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(height: 8,),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'از تاریخ',
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                                    fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets.only(bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextFormField(
                                                                                    validator: (value){
                                                                                      if(value==null || value.isEmpty){
                                                                                        return 'لطفا تاریخ را انتخاب کنید';
                                                                                      }
                                                                                      return null;
                                                                                    },
                                                                                    controller: controller.dateStartController,
                                                                                    readOnly: true,
                                                                                    style: AppTextStyle.labelText,
                                                                                    decoration: InputDecoration(
                                                                                      suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      filled: true,
                                                                                      fillColor: AppColor.textFieldColor,
                                                                                      errorMaxLines: 1,
                                                                                    ),
                                                                                    onTap: () async {
                                                                                      Jalali? pickedDate = await showPersianDatePicker(
                                                                                        context: context,
                                                                                        initialDate: Jalali.now(),
                                                                                        firstDate: Jalali(1400,1,1),
                                                                                        lastDate: Jalali(1450,12,29),
                                                                                        initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                        initialDatePickerMode: PersianDatePickerMode.day,
                                                                                        locale: Locale("fa","IR"),
                                                                                      );
                                                                                      Gregorian gregorian= pickedDate!.toGregorian();
                                                                                      controller.startDateFilter.value =
                                                                                      "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                      controller.dateStartController.text =
                                                                                      "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'تا تاریخ',
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                                    fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets.only(bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextFormField(
                                                                                    validator: (value){
                                                                                      if(value==null || value.isEmpty){
                                                                                        return 'لطفا تاریخ را انتخاب کنید';
                                                                                      }
                                                                                      return null;
                                                                                    },
                                                                                    controller: controller.dateEndController,
                                                                                    readOnly: true,
                                                                                    style: AppTextStyle.labelText,
                                                                                    decoration: InputDecoration(
                                                                                      suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      filled: true,
                                                                                      fillColor: AppColor.textFieldColor,
                                                                                      errorMaxLines: 1,
                                                                                    ),
                                                                                    onTap: () async {
                                                                                      Jalali? pickedDate = await showPersianDatePicker(
                                                                                        context: context,
                                                                                        initialDate: Jalali.now(),
                                                                                        firstDate: Jalali(1400,1,1),
                                                                                        lastDate: Jalali(1450,12,29),
                                                                                        initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                        initialDatePickerMode: PersianDatePickerMode.day,
                                                                                        locale: Locale("fa","IR"),
                                                                                      );
                                                                                      // DateTime date=DateTime.now();
                                                                                      Gregorian gregorian= pickedDate!.toGregorian();
                                                                                      controller.endDateFilter.value =
                                                                                      "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                      controller.dateEndController.text =
                                                                                      "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                    //Spacer(),
                                                                    Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                                      width: double.infinity,
                                                                      height: 40,
                                                                      child: ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            padding: WidgetStatePropertyAll(
                                                                                EdgeInsets.symmetric(horizontal: 23)),
                                                                            // elevation: WidgetStatePropertyAll(5),
                                                                            backgroundColor:
                                                                            WidgetStatePropertyAll(AppColor.appBarColor),
                                                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                                borderRadius: BorderRadius.circular(5)))),
                                                                        onPressed: () async {
                                                                          controller.getListTransactionInfoDatePager();
                                                                          Get.back();

                                                                        },
                                                                        child: controller.isLoading.value?
                                                                        CircularProgressIndicator(
                                                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                        ) :
                                                                        Text(
                                                                          'فیلتر',
                                                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                icon: SvgPicture.asset(
                                                    'assets/svg/filter3.svg',
                                                    height: 17,
                                                    colorFilter:
                                                    ColorFilter
                                                        .mode(
                                                      controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor:  AppColor
                                                          .textColor,
                                                      BlendMode
                                                          .srcIn,
                                                    )),
                                                label: Text(
                                                  'فیلتر',
                                                  style: AppTextStyle
                                                      .labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10,color: controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
                                                ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
                                    dataRowMaxHeight: double.infinity,
                                    //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                    headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                    headingRowHeight: 35,
                                    columnSpacing: 30,
                                    horizontalMargin: 5,
                                  ),
                                  // Footer Section
                                  /*Obx(() => controller.listTransactionInfoFooter.isNotEmpty
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
                                      : SizedBox()),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):
                    _buildMobileTransactionList(context),
                  ],
                ),
              ),
            )
                :controller.listTransactionInfo.isEmpty
                ? SizedBox(
              height: Get.height * 0.9,
              width: Get.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/empty.svg',
                      height: 80,
                      colorFilter: ColorFilter.mode(
                        AppColor.textColor.withOpacity(0.5),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      controller.hasActiveFilters()
                          ? 'نتیجه فیلتر خالی است'
                          : 'هیچ تراکنشی یافت نشد',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 16,
                        color: AppColor.textColor.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      controller.hasActiveFilters()
                          ? 'لطفاً فیلترهای خود را تغییر دهید'
                          : 'تراکنش‌ی در این تاریخ موجود نیست',
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: 12,
                        color: AppColor.textColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black45,
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder: (BuildContext buildContext,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColor.backGroundColor
                                    ),
                                    width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                                    height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                    padding: EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      'فیلتر',
                                                      style: AppTextStyle.labelText.copyWith(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,height: 27,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        padding: WidgetStatePropertyAll(
                                                            EdgeInsets.symmetric(horizontal: 2,vertical: 1)),
                                                        // elevation: WidgetStatePropertyAll(5),
                                                        backgroundColor:
                                                        WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                            borderRadius: BorderRadius.circular(5)))),
                                                    onPressed: () async {
                                                      controller.clearFilter();
                                                      controller.getListTransactionInfoDatePager();
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      'حذف فیلتر',
                                                      style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 9 : 8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: AppColor.textColor,height: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 8,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'از تاریخ',
                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                          fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                    ),
                                                    Container(
                                                      //height: 50,
                                                      padding: EdgeInsets.only(bottom: 5),
                                                      child: IntrinsicHeight(
                                                        child: TextFormField(
                                                          validator: (value){
                                                            if(value==null || value.isEmpty){
                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                            }
                                                            return null;
                                                          },
                                                          controller: controller.dateStartController,
                                                          readOnly: true,
                                                          style: AppTextStyle.labelText,
                                                          decoration: InputDecoration(
                                                            suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            filled: true,
                                                            fillColor: AppColor.textFieldColor,
                                                            errorMaxLines: 1,
                                                          ),
                                                          onTap: () async {
                                                            Jalali? pickedDate = await showPersianDatePicker(
                                                              context: context,
                                                              initialDate: Jalali.now(),
                                                              firstDate: Jalali(1400,1,1),
                                                              lastDate: Jalali(1450,12,29),
                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                              locale: Locale("fa","IR"),
                                                            );
                                                            Gregorian gregorian= pickedDate!.toGregorian();
                                                            controller.startDateFilter.value =
                                                            "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                            controller.dateStartController.text =
                                                            "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'تا تاریخ',
                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                          fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                    ),
                                                    Container(
                                                      //height: 50,
                                                      padding: EdgeInsets.only(bottom: 5),
                                                      child: IntrinsicHeight(
                                                        child: TextFormField(
                                                          validator: (value){
                                                            if(value==null || value.isEmpty){
                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                            }
                                                            return null;
                                                          },
                                                          controller: controller.dateEndController,
                                                          readOnly: true,
                                                          style: AppTextStyle.labelText,
                                                          decoration: InputDecoration(
                                                            suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            filled: true,
                                                            fillColor: AppColor.textFieldColor,
                                                            errorMaxLines: 1,
                                                          ),
                                                          onTap: () async {
                                                            Jalali? pickedDate = await showPersianDatePicker(
                                                              context: context,
                                                              initialDate: Jalali.now(),
                                                              firstDate: Jalali(1400,1,1),
                                                              lastDate: Jalali(1450,12,29),
                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                              locale: Locale("fa","IR"),
                                                            );
                                                            // DateTime date=DateTime.now();
                                                            Gregorian gregorian= pickedDate!.toGregorian();
                                                            controller.endDateFilter.value =
                                                            "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                            controller.dateEndController.text =
                                                            "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          //Spacer(),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                            width: double.infinity,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(horizontal: 23)),
                                                  // elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.appBarColor),
                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                      borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () async {
                                                controller.getListTransactionInfoDatePager();
                                                Get.back();
                                              },
                                              child: controller.isLoading.value?
                                              CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                              ) :
                                              Text(
                                                'فیلتر',
                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text('تلاش مجدد',
                        style: AppTextStyle.bodyText.copyWith(
                            fontSize: 16,
                            color: AppColor.accentColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ) :
            Center(
              child: ErrPage(
                callback: () {
                  controller.clearSearch();
                  controller.getListTransactionInfoDatePager();
                },
                title: "خطا در لیست کاربران",
                des: 'برای دریافت لیست کاربران مجددا تلاش کنید',
              ),
            ),
          ),
          isDesktop ?
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Pagination
              controller.paginated.value!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  //color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: controller.paginated.value?.totalCount??0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)):SizedBox(),
            ],
          ):SizedBox.shrink(),
        ],
      ),
      floatingActionButton: isDesktop ? FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ) : SizedBox.shrink(),
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
        label: Row(
          children: [
            Text('مانده ریالی',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            SizedBox(width: 5,),
            Text('(بستانکار)',
                style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('مانده ریالی',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            SizedBox(width: 5,),
            Text('(بدهکار)',
                style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),

      DataColumn(
        label: Row(
          children: [
            Text('مانده طلا',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            SizedBox(width: 5,),
            Text('(بستانکار)',
                style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('مانده طلا',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            SizedBox(width: 5,),
            Text('(بدهکار)',
                style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),

      DataColumn(
        label: Row(
          children: [
            Text('مانده سکه',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            SizedBox(width: 5,),
            Text('(بستانکار)',
                style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('مانده سکه',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            SizedBox(width: 5,),
            Text('(بدهکار)',
                style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),

      DataColumn(
          label: Row(
            children: [
              Text('مانده ارز',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
              SizedBox(width: 5,),
              Text('(بستانکار)',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Row(
            children: [
              Text('مانده ارز',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
              SizedBox(width: 5,),
              Text('(بدهکار)',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
        label: Row(
          children: [
            Text('تراز کل بس',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('تراز کل بد',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.listTransactionInfo.asMap().entries.map((entry) {
      final index = entry.key;
      final trans = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: WidgetStateProperty.all(rowColor),
        cells: [
          DataCell(
              Center(
                child: Text(
                  "${trans.rowNum}",
                  style: AppTextStyle.bodyText,
                ),
              )),
          DataCell(Center(
            /*child: GestureDetector(
            onTap: (){
              Get.toNamed("/userInfoGoldTransaction",parameters: {"accountId":trans.accountId.toString()});
              // /controller.getInfo(trans.accountId);
            },*/
            child: Text(
              "${trans.accountName} ",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),),
            //),
          )),
          // مانده ریالی بستانکار
          DataCell(Center(
            child:
            (trans.cashBalanceBes ?? 0)>0 ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.cashBalanceBes==0
                    ? SizedBox()
                    :
                Row(
                  children: [
                    SizedBox(
                      //width: 150,
                      child: Row(
                        children: [
                          Text(" وجه نقد ",
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
                            trans.cashBalanceBes!.toStringAsFixed(0).seRagham(),
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
                          Text(" ریال ",
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
                            children: trans.balances!.map((e)=>e.unitName=="ریال" ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.itemName??"",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                ), Text(
                                  "${e.balance?.toStringAsFixed(0).seRagham() ?? 0} ریال ",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ):SizedBox()).toList(),
                          ),
                          middleText: "لیست مانده ریال بستانکار",
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
          // مانده ریالی بدهکار
          DataCell(Center(
            child:
            (trans.cashBalanceBed ?? 0)<0 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.cashBalanceBed==0
                    ? SizedBox()
                    :
                Row(
                  children: [
                    SizedBox(
                      //width: 150,
                      child: Row(
                        children: [
                          Text(" وجه نقد ",
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
                            "-${trans.cashBalanceBed?.abs().toStringAsFixed(0).seRagham() ?? ""}",
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
                          Text(" ریال ",
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
                            children: trans.balances!.map((e)=>e.unitName=="ریال" ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.itemName??"",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor),
                                ), Text(
                                  "-${e.balance?.abs().toStringAsFixed(0).seRagham() ?? 0} ریال ",
                                  style: AppTextStyle.labelText.copyWith(fontSize:  12,color: AppColor.backGroundColor,),
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ):SizedBox()).toList(),
                          ),
                          middleText: "لیست مانده ریال بدهکار",
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
          // مانده طلا بستانکار
          DataCell(Center(
            child:
            (trans.goldBalanceBes ?? 0)>0 ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.goldBalanceBes==0
                    ? SizedBox()
                    :
                Row(
                  children: [
                    SizedBox(
                      //width: 150,
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
                            trans.goldBalanceBes!.toStringAsFixed(3),
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
                            children: trans.balances!.map((e)=>e.unitName=="گرم" ? Row(
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
          // مانده طلا بدهکار
          DataCell(Center(
            child:
            (trans.goldBalanceBed ?? 0)<0 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.goldBalanceBed==0
                    ? SizedBox()
                    :
                Row(
                  children: [
                    SizedBox(
                      //width: 150,
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
                            "-${trans.goldBalanceBed?.abs().toStringAsFixed(3) ?? ""}",
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
                            children: trans.balances!.map((e)=>e.unitName=="گرم" ? Row(
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
          // مانده سکه بستانکار
          DataCell(Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.coinBalanceBes==0
                      ? SizedBox()
                      : Column(
                      children: [
                        Row(
                          children: [
                            Text(" تمام سکه ",
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
                              trans.coinBalanceBes?.toDisplayString() ?? "",
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
                            Text(" عدد ",
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
                        Row(
                          children: [
                            Text(" نیم سکه ",
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
                              trans.halfCoinBalanceBes?.toDisplayString() ?? "",
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
                            Text(" عدد ",
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
                        Row(
                          children: [
                            Text(" ربع سکه ",
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
                              trans.quarterCoinBalanceBes?.toDisplayString() ?? "",
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
                            Text(" عدد ",
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
                      ]
                  ),
                ],
              ))),
          // مانده سکه بدهکار
          DataCell(Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.coinBalanceBed==0
                      ? SizedBox()
                      : Column(
                      children: [
                        Row(
                          children: [
                            Text(" تمام سکه ",
                                style: AppTextStyle
                                    .bodyText
                                    .copyWith(
                                    fontSize: 9,
                                    color: AppColor
                                        .accentColor,
                                    fontWeight:
                                    FontWeight
                                        .bold)),
                            Text(
                              "-${trans.coinBalanceBed?.abs().toDisplayString()}",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  fontSize: 11,
                                  color:  AppColor
                                      .accentColor,
                                  fontWeight:
                                  FontWeight.bold),
                              textDirection:
                              TextDirection.ltr,
                            ),
                            Text(" عدد ",
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
                        Row(
                          children: [
                            Text(" نیم سکه ",
                                style: AppTextStyle
                                    .bodyText
                                    .copyWith(
                                    fontSize: 9,
                                    color: AppColor
                                        .accentColor,
                                    fontWeight:
                                    FontWeight
                                        .bold)),
                            Text(
                              "-${trans.halfCoinBalanceBed?.abs().toDisplayString()}",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  fontSize: 11,
                                  color:  AppColor
                                      .accentColor,
                                  fontWeight:
                                  FontWeight.bold),
                              textDirection:
                              TextDirection.ltr,
                            ),
                            Text(" عدد ",
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
                        Row(
                          children: [
                            Text(" ربع سکه ",
                                style: AppTextStyle
                                    .bodyText
                                    .copyWith(
                                    fontSize: 9,
                                    color: AppColor
                                        .accentColor,
                                    fontWeight:
                                    FontWeight
                                        .bold)),
                            Text(
                              "-${trans.quarterCoinBalanceBed?.abs().toDisplayString()}",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  fontSize: 11,
                                  color:  AppColor
                                      .accentColor,
                                  fontWeight:
                                  FontWeight.bold),
                              textDirection:
                              TextDirection.ltr,
                            ),
                            Text(" عدد ",
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
                      ]
                  ),
                ],
              ))),
          // مانده ارز بستانکار
          DataCell(Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.balances!.isEmpty
                      ? SizedBox()
                      : Column(
                    children: trans.balances
                    !.map((e) => Container(
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
                            e.balance?.toDisplayString() ?? "",
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
          // مانده ارز بدهکار
          DataCell(Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.balances!.isEmpty
                      ? SizedBox()
                      : Column(
                    children: trans.balances
                    !.map((e) => Container(
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
                            e.balance?.toDisplayString() ?? "",
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
          // تراز کل بستانکار
          DataCell(Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (trans.currencyValueBes ?? 0) > 0 ?
                  Column(
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          SvgPicture.asset(
                              'assets/svg/scales.svg',
                              height: 15,
                              colorFilter:
                              ColorFilter
                                  .mode(
                                AppColor
                                    .primaryColor,
                                BlendMode
                                    .srcIn,
                              )),
                          SizedBox(width: 5,),
                          Text(trans.currencyValueBes?.toStringAsFixed(0).seRagham() ?? "",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 10,
                                  color:AppColor
                                      .primaryColor,
                                  fontWeight:
                                  FontWeight
                                      .bold)),

                          Text(" ریال ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 8,
                                  color:AppColor.primaryColor,
                                  fontWeight:
                                  FontWeight
                                      .bold)),

                          SizedBox(width: 5,)
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
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
                          (trans.goldValue ?? 0) <0 ?
                          Text("-${trans.goldValue?.abs().toStringAsFixed(3) ?? ""} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold),textDirection:
                            TextDirection.ltr,):
                          Text(" ${trans.goldValue?.toStringAsFixed(3) ?? ""} ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:AppColor
                                      .primaryColor,
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
                          (trans.coinValue ?? 0) <0 ?
                          Text("-${trans.coinValue?.abs().toStringAsFixed(3) ?? ""} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold),textDirection:
                            TextDirection.ltr,):
                          Text(" ${trans.coinValue?.toStringAsFixed(3) ?? ""} ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:AppColor
                                      .primaryColor,
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
                      SizedBox(height: 5,),
                    ],
                  ):SizedBox.shrink(),
                ],
              ))),
          // تراز کل بدهکار
          DataCell(Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (trans.currencyValueBed ?? 0) < 0 ?
                  Column(
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          SvgPicture.asset(
                              'assets/svg/scales.svg',
                              height: 15,
                              colorFilter:
                              ColorFilter
                                  .mode(AppColor
                                  .accentColor,
                                BlendMode
                                    .srcIn,
                              )),
                          SizedBox(width: 5,),
                          Text("-${trans.currencyValueBed?.abs().toStringAsFixed(0).seRagham() ?? ""}",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                              fontSize: 10,
                              color:AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight
                                  .bold,),textDirection:
                            TextDirection.ltr,),
                          Text(" ریال ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 8,
                                  color:AppColor
                                      .accentColor,
                                  fontWeight:
                                  FontWeight
                                      .bold)),

                          SizedBox(width: 5,)
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
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
                          (trans.goldValue ?? 0) <0 ?
                          Text("-${trans.goldValue?.abs().toStringAsFixed(3) ?? ""} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold),textDirection:
                            TextDirection.ltr,):
                          Text(" ${trans.goldValue?.toStringAsFixed(3) ?? ""} ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:AppColor
                                      .primaryColor,
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
                          (trans.coinValue ?? 0) <0 ?
                          Text("-${trans.coinValue?.abs().toStringAsFixed(3) ?? ""} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color:AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold),textDirection:
                            TextDirection.ltr,):
                          Text(" ${trans.coinValue?.toStringAsFixed(3) ?? ""} ",
                              style: AppTextStyle
                                  .bodyText
                                  .copyWith(
                                  fontSize: 9,
                                  color:AppColor
                                      .primaryColor,
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
                      SizedBox(height: 5,),
                    ],
                  ):SizedBox.shrink(),
                ],
              ))),
        ],
      );
    }
    ).toList();
  }

  Widget _buildMobileTransactionList(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black45,
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder: (BuildContext buildContext,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColor.backGroundColor
                                    ),
                                    width:Get.height * 0.65,
                                    height:Get.height * 0.7,
                                    padding: EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      'فیلتر',
                                                      style: AppTextStyle.labelText.copyWith(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,height: 27,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        padding: WidgetStatePropertyAll(
                                                            EdgeInsets.symmetric(horizontal: 2,vertical: 1)),
                                                        // elevation: WidgetStatePropertyAll(5),
                                                        backgroundColor:
                                                        WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                            borderRadius: BorderRadius.circular(5)))),
                                                    onPressed: () async {
                                                      controller.currentPage.value = 1;
                                                      controller.itemsPerPage.value= 25;
                                                      controller.clearFilter();
                                                      controller.getListTransactionInfoDatePager();
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      'حذف فیلتر',
                                                      style: AppTextStyle.labelText.copyWith(fontSize: 8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: AppColor.textColor,height: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 8,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'از تاریخ',
                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                          fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                    ),
                                                    Container(
                                                      //height: 50,
                                                      padding: EdgeInsets.only(bottom: 5),
                                                      child: IntrinsicHeight(
                                                        child: TextFormField(
                                                          validator: (value){
                                                            if(value==null || value.isEmpty){
                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                            }
                                                            return null;
                                                          },
                                                          controller: controller.dateStartController,
                                                          readOnly: true,
                                                          style: AppTextStyle.labelText,
                                                          decoration: InputDecoration(
                                                            suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            filled: true,
                                                            fillColor: AppColor.textFieldColor,
                                                            errorMaxLines: 1,
                                                          ),
                                                          onTap: () async {
                                                            Jalali? pickedDate = await showPersianDatePicker(
                                                              context: context,
                                                              initialDate: Jalali.now(),
                                                              firstDate: Jalali(1400,1,1),
                                                              lastDate: Jalali(1450,12,29),
                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                              locale: Locale("fa","IR"),
                                                            );
                                                            Gregorian gregorian= pickedDate!.toGregorian();
                                                            controller.startDateFilter.value =
                                                            "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                            controller.dateStartController.text =
                                                            "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'تا تاریخ',
                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                          fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                    ),
                                                    Container(
                                                      //height: 50,
                                                      padding: EdgeInsets.only(bottom: 5),
                                                      child: IntrinsicHeight(
                                                        child: TextFormField(
                                                          validator: (value){
                                                            if(value==null || value.isEmpty){
                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                            }
                                                            return null;
                                                          },
                                                          controller: controller.dateEndController,
                                                          readOnly: true,
                                                          style: AppTextStyle.labelText,
                                                          decoration: InputDecoration(
                                                            suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            filled: true,
                                                            fillColor: AppColor.textFieldColor,
                                                            errorMaxLines: 1,
                                                          ),
                                                          onTap: () async {
                                                            Jalali? pickedDate = await showPersianDatePicker(
                                                              context: context,
                                                              initialDate: Jalali.now(),
                                                              firstDate: Jalali(1400,1,1),
                                                              lastDate: Jalali(1450,12,29),
                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                              locale: Locale("fa","IR"),
                                                            );
                                                            // DateTime date=DateTime.now();
                                                            Gregorian gregorian= pickedDate!.toGregorian();
                                                            controller.endDateFilter.value =
                                                            "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                            controller.dateEndController.text =
                                                            "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                          //Spacer(),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                            width: double.infinity,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(horizontal: 23)),
                                                  // elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.appBarColor),
                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                      borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () async {
                                                controller.currentPage.value = 1;
                                                controller.itemsPerPage.value= 25;
                                                controller.getListTransactionInfoDatePager();
                                                Get.back();

                                              },
                                              child: controller.isLoading.value?
                                              CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                              ) :
                                              Text(
                                                'فیلتر',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: SvgPicture.asset(
                          'assets/svg/filter3.svg',
                          height: 26,
                          colorFilter:
                          ColorFilter
                              .mode(
                            controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.filterColor:  AppColor
                                .textColor,
                            BlendMode
                                .srcIn,
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildMobileSortHeader()),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            itemCount: controller.listTransactionInfo.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index){
              final trans = controller.listTransactionInfo[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.appBarColor.withAlpha(200),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.textColor.withOpacity(0.3)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              trans.accountName ?? "",
                              style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: AppColor.textColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        Text("${trans.rowNum}", style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor.withOpacity(0.8))),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(height: 0.5,color: AppColor.dividerColor),
                    SizedBox(height: 8),
                    // Rial balances
                    if((trans.cashBalanceBes ?? 0) > 0)
                      _mobileLine("مانده وجه نقد (بس)",
                          "${trans.cashBalanceBes!.toStringAsFixed(0).seRagham()}", AppColor.primaryColor,"ریال"),
                    if((trans.cashBalanceBed ?? 0) < 0)
                      _mobileLine("مانده وجه نقد (بد)",
                          "-${trans.cashBalanceBed!.abs().toStringAsFixed(0).seRagham()}", AppColor.accentColor,"ریال"),
                    // Gold balances
                    if((trans.goldBalanceBes ?? 0) > 0)
                      _mobileLine("مانده آبشده (بس)",
                          "${trans.goldBalanceBes!.toStringAsFixed(3)}", AppColor.primaryColor,"گرم"),
                    if((trans.goldBalanceBed ?? 0) < 0)
                      _mobileLine("مانده آبشده (بد)",
                          "-${trans.goldBalanceBed!.abs().toStringAsFixed(3)}", AppColor.accentColor,"گرم"),
                    // Coin balances
                    if((trans.coinBalanceBes ?? 0) != 0 || (trans.halfCoinBalanceBes ?? 0) != 0 || (trans.quarterCoinBalanceBes ?? 0) != 0)
                      _mobileLine("سکه بستانکار",
                          "تمام ${trans.coinBalanceBes?.toDisplayString()} / نیم ${trans.halfCoinBalanceBes?.toDisplayString()} / ربع ${trans.quarterCoinBalanceBes?.toDisplayString()}", AppColor.primaryColor,"عدد"),
                    if((trans.coinBalanceBed ?? 0) != 0 || (trans.halfCoinBalanceBed ?? 0) != 0 || (trans.quarterCoinBalanceBed ?? 0) != 0)
                      _mobileLine("سکه بدهکار",
                          "-تمام ${(trans.coinBalanceBed??0).abs().toDisplayString()}- / نیم ${(trans.halfCoinBalanceBed??0).abs().toDisplayString()}- / ربع ${(trans.quarterCoinBalanceBed??0).abs().toDisplayString()}", AppColor.accentColor,"عدد"),
                    // Currency sample (USD)
                    if((trans.balances??[]).any((e)=> e.unitName=="دلار" && (e.balance??0)>0))
                      _mobileLine("ارز بستانکار",
                          "${(trans.balances??[]).where((e)=>e.unitName=="دلار").fold<double>(0, (p, e)=> p + (e.balance??0))}", AppColor.primaryColor,"دلار"),
                    if((trans.balances??[]).any((e)=> e.unitName=="دلار" && (e.balance??0)<0))
                      _mobileLine("ارز بدهکار",
                          "-${(trans.balances??[]).where((e)=>e.unitName=="دلار").fold<double>(0, (p, e)=> p + (e.balance??0).abs())}", AppColor.accentColor,"دلار"),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColor.backGroundColor.withAlpha(60),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.textColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          if((trans.currencyValueBes ?? 0) > 0)
                            _mobileLineWithIcon("تراز کل بس",
                                "${trans.currencyValueBes!.toStringAsFixed(0).seRagham()}",
                                'assets/svg/scales.svg', AppColor.primaryColor,"ریال"),
                          if((trans.currencyValueBed ?? 0) < 0)
                            _mobileLineWithIcon("تراز کل بد",
                                "-${trans.currencyValueBed!.abs().toStringAsFixed(0).seRagham()}",
                                'assets/svg/scales.svg', AppColor.accentColor,"ریال"),
                          if((trans.goldValue ?? 0) != 0)
                            _mobileLine("معادل آبشده",
                                (trans.goldValue ?? 0) < 0 ? "-${trans.goldValue!.abs().toStringAsFixed(3)}" : "${trans.goldValue!.toStringAsFixed(3)}",
                                (trans.goldValue ?? 0) < 0 ? AppColor.accentColor : AppColor.primaryColor,"گرم"),
                          if((trans.coinValue ?? 0) != 0)
                            _mobileLine("معادل سکه",
                                (trans.coinValue ?? 0) < 0 ? "-${trans.coinValue!.abs().toStringAsFixed(3)}" : "${trans.coinValue!.toStringAsFixed(3)}",
                                (trans.coinValue ?? 0) < 0 ? AppColor.accentColor : AppColor.primaryColor,"عدد"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Obx(() {
            if (controller.isLoading.value && controller.listTransactionInfo.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!controller.hasMore.value && controller.listTransactionInfo.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  "همه تراکنش‌ها نمایش داده شد",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.textColor.withOpacity(0.7),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMobileSortHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,),
      decoration: BoxDecoration(
        color: AppColor.appBarColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.textColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            color: AppColor.textColor,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            'مرتب‌سازی:',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: controller.sortColumnIndex.value,
                isExpanded: true,
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 11,
                  color: AppColor.textColor,
                ),
                dropdownColor: AppColor.appBarColor,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColor.textColor,
                ),
                items: [
                  DropdownMenuItem(
                    value: 2,
                    child: Text('ریال بستانکار'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('ریال بدهکار'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text('طلا بستانکار'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('طلا بدهکار'),
                  ),
                  DropdownMenuItem(
                    value: 6,
                    child: Text('سکه بستانکار'),
                  ),
                  DropdownMenuItem(
                    value: 7,
                    child: Text('سکه بدهکار'),
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text('تراز کل بستانکار'),
                  ),
                  DropdownMenuItem(
                    value: 11,
                    child: Text('تراز کل بدهکار'),
                  ),
                ],
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    controller.onSort(newValue, !controller.sortAscending.value);
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 8),
          // Sort direction toggle button
          GestureDetector(
            onTap: () {
              if (controller.sortColumnIndex.value != null) {
                controller.onSort(controller.sortColumnIndex.value!, !controller.sortAscending.value);
              }
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: controller.sortColumnIndex.value != null
                    ? AppColor.primaryColor.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: controller.sortColumnIndex.value != null
                      ? AppColor.primaryColor
                      : AppColor.textColor.withAlpha(30),
                  width: 1,
                ),
              ),
              child: Icon(
                controller.sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: controller.sortColumnIndex.value != null
                    ? AppColor.primaryColor
                    : AppColor.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileLine(String label, String value, Color color , String itemName){
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppTextStyle.labelText.copyWith(fontSize: 11, color: AppColor.textColor))),
          SizedBox(width: 8),
          Text(value, style: AppTextStyle.labelText.copyWith(fontSize: 12, color: color, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
          SizedBox(width: 4),
          Text(itemName, style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget _mobileLineWithIcon(String label, String value, String asset, Color color,String itemName){
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SvgPicture.asset(asset, height: 14, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
          SizedBox(width: 6),
          Expanded(child: Text(label, style: AppTextStyle.labelText.copyWith(fontSize: 11, color: AppColor.textColor))),
          SizedBox(width: 8),
          Text(value, style: AppTextStyle.labelText.copyWith(fontSize: 12, color: color, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
          SizedBox(width: 4),
          Text(itemName, style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  /*Widget _buildFooterItem({
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
      formattedValue = value.toStringAsFixed(0).seRagham();
    } else if(unit == "گرم") {
      // For other units, use 3 decimal places
      formattedValue = value.toStringAsFixed(3);
    }else{
      formattedValue = value.toStringAsFixed(3);
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
  }*/

}

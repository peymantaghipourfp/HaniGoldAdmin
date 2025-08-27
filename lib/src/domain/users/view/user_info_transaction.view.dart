
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/transaction/widgets/balance_dialog_id.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../controller/user_info_detail_transaction.controller.dart';
import '../widgets/balance.widget.dart';
import '../widgets/tabel_info.widget.dart';

import 'package:flutter/services.dart';

class UserInfoTransactionView extends StatefulWidget {
  const UserInfoTransactionView({super.key});

  @override
  State<UserInfoTransactionView> createState() => _UserInfoTransactionViewState();
}

class _UserInfoTransactionViewState extends State<UserInfoTransactionView> {
  final UserInfoDetailTransactionController controller=Get.find<UserInfoDetailTransactionController>();
  final GlobalKey _balanceKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'جزییات تراکنش کاربر',
        onBackTap: () => Get.offNamed("/listUserInfoTransaction"),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageStateDe.loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : controller.state.value == PageStateDe.list
                ? SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isDesktop
                        ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(7),
                          color: AppColor.backGroundColor
                              .withOpacity(0.3)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                     children: [
                                    Flexible(
                                      child: Text(
                                        ' حساب کاربری ${controller.headerInfoUserTransactionModel?.accountName ?? ""}',
                                        style: AppTextStyle
                                            .labelText
                                            .copyWith(
                                            fontSize:
                                            isDesktop
                                                ? 14
                                                : 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  /*Container(
                                    width: 80,
                                    height: 35,
                                    padding: EdgeInsets
                                        .symmetric(
                                        horizontal: 10,
                                        vertical: 7),
                                    margin: EdgeInsets
                                        .symmetric(
                                        horizontal: 10,
                                        vertical: 0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            7),
                                        color: AppColor
                                            .primaryColor),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/edit.svg',
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
                                          width: 2,
                                        ),
                                        Text(
                                          'ویرایش',
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
                                  Container(
                                    width: 90,
                                    height: 35,
                                    padding: EdgeInsets
                                        .symmetric(
                                        horizontal: 10,
                                        vertical: 7),
                                    margin: EdgeInsets
                                        .symmetric(
                                        horizontal: 5,
                                        vertical: 0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            7),
                                        color: AppColor
                                            .secondary2Color),
                                    child: Row(
                                      children: [
                                        // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                        //     colorFilter: ColorFilter.mode(
                                        //       AppColor.textColor,
                                        //       BlendMode.srcIn,
                                        //     )),
                                        // SizedBox(width: 5,),
                                        Text(
                                          'صدور فاکتور',
                                          style: AppTextStyle
                                              .labelText
                                              .copyWith(
                                              fontSize: isDesktop
                                                  ? 12
                                                  : 10),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                ],
                              ),
                              SizedBox(
                                height: 10,
                                width: 15,
                              ),
                              Row(
                                children: [
                                  /*Container(
                                    width: 120,
                                    height: 35,
                                    padding: EdgeInsets
                                        .symmetric(
                                        horizontal: 10,
                                        vertical: 7),
                                    margin: EdgeInsets
                                        .symmetric(
                                        horizontal: 5,
                                        vertical: 0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            7),
                                        color: AppColor
                                            .accentColor),
                                    child: Row(
                                      children: [
                                        // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                        //     colorFilter: ColorFilter.mode(
                                        //       AppColor.textColor,
                                        //       BlendMode.srcIn,
                                        //     )),
                                        // SizedBox(width: 5,),
                                        Text(
                                          'صدور فاکتور جدید',
                                          style: AppTextStyle
                                              .labelText
                                              .copyWith(
                                              fontSize: isDesktop
                                                  ? 12
                                                  : 10),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                  // خروجی اکسل
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
                                      showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: MaterialLocalizations
                                              .of(context)
                                              .modalBarrierDismissLabel,
                                          barrierColor: Colors
                                              .black45,
                                          transitionDuration: const Duration(
                                              milliseconds: 200),
                                          pageBuilder: (
                                              BuildContext buildContext,
                                              Animation animation,
                                              Animation secondaryAnimation) {
                                            return Center(
                                              child: Material(
                                                color: Colors
                                                    .transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          8),
                                                      color: AppColor
                                                          .backGroundColor
                                                  ),
                                                  width: isDesktop
                                                      ? Get
                                                      .width *
                                                      0.2
                                                      : Get
                                                      .height *
                                                      0.5,
                                                  height: isDesktop
                                                      ? Get
                                                      .height *
                                                      0.5
                                                      : Get
                                                      .height *
                                                      0.7,
                                                  padding: EdgeInsets
                                                      .all(
                                                      20),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              'خروجی اکسل',
                                                              style: AppTextStyle
                                                                  .labelText
                                                                  .copyWith(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight
                                                                    .normal,
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
                                                            horizontal: 10),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                                height: 8),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  'از تاریخ',
                                                                  style: AppTextStyle
                                                                      .labelText
                                                                      .copyWith(
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight
                                                                          .normal,
                                                                      color: AppColor
                                                                          .textColor),
                                                                ),
                                                                Container(
                                                                  //height: 50,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      bottom: 5),
                                                                  child: IntrinsicHeight(
                                                                    child: TextFormField(
                                                                      validator: (
                                                                          value) {
                                                                        if (value ==
                                                                            null ||
                                                                            value
                                                                                .isEmpty) {
                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      controller: controller
                                                                          .dateStartController,
                                                                      readOnly: true,
                                                                      style: AppTextStyle
                                                                          .labelText,
                                                                      decoration: InputDecoration(
                                                                        suffixIcon: Icon(
                                                                            Icons
                                                                                .calendar_month,
                                                                            color: AppColor
                                                                                .textColor),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              10),
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: AppColor
                                                                            .textFieldColor,
                                                                        errorMaxLines: 1,
                                                                      ),
                                                                      onTap: () async {
                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                          context: context,
                                                                          initialDate: Jalali
                                                                              .now(),
                                                                          firstDate: Jalali(
                                                                              1400,
                                                                              1,
                                                                              1),
                                                                          lastDate: Jalali(
                                                                              1450,
                                                                              12,
                                                                              29),
                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                              .calendar,
                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                              .day,
                                                                          locale: Locale(
                                                                              "fa",
                                                                              "IR"),
                                                                        );
                                                                        Gregorian gregorian = pickedDate!
                                                                            .toGregorian();
                                                                        controller
                                                                            .startDateFilter
                                                                            .value =
                                                                        "${gregorian
                                                                            .year}-${gregorian
                                                                            .month
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}-${gregorian
                                                                            .day
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}";

                                                                        controller
                                                                            .dateStartController
                                                                            .text =
                                                                        "${pickedDate
                                                                            .year}/${pickedDate
                                                                            .month
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}/${pickedDate
                                                                            .day
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}";
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  'تا تاریخ',
                                                                  style: AppTextStyle
                                                                      .labelText
                                                                      .copyWith(
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight
                                                                          .normal,
                                                                      color: AppColor
                                                                          .textColor),
                                                                ),
                                                                Container(
                                                                  //height: 50,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      bottom: 5),
                                                                  child: IntrinsicHeight(
                                                                    child: TextFormField(
                                                                      validator: (
                                                                          value) {
                                                                        if (value ==
                                                                            null ||
                                                                            value
                                                                                .isEmpty) {
                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      controller: controller
                                                                          .dateEndController,
                                                                      readOnly: true,
                                                                      style: AppTextStyle
                                                                          .labelText,
                                                                      decoration: InputDecoration(
                                                                        suffixIcon: Icon(
                                                                            Icons
                                                                                .calendar_month,
                                                                            color: AppColor
                                                                                .textColor),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              10),
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: AppColor
                                                                            .textFieldColor,
                                                                        errorMaxLines: 1,
                                                                      ),
                                                                      onTap: () async {
                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                          context: context,
                                                                          initialDate: Jalali
                                                                              .now(),
                                                                          firstDate: Jalali(
                                                                              1400,
                                                                              1,
                                                                              1),
                                                                          lastDate: Jalali(
                                                                              1450,
                                                                              12,
                                                                              29),
                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                              .calendar,
                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                              .day,
                                                                          locale: Locale(
                                                                              "fa",
                                                                              "IR"),
                                                                        );
                                                                        // DateTime date=DateTime.now();
                                                                        Gregorian gregorian = pickedDate!
                                                                            .toGregorian();
                                                                        controller
                                                                            .endDateFilter
                                                                            .value =
                                                                        "${gregorian
                                                                            .year}-${gregorian
                                                                            .month
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}-${gregorian
                                                                            .day
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}";

                                                                        controller
                                                                            .dateEndController
                                                                            .text =
                                                                        "${pickedDate
                                                                            .year}/${pickedDate
                                                                            .month
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}/${pickedDate
                                                                            .day
                                                                            .toString()
                                                                            .padLeft(
                                                                            2,
                                                                            '0')}";
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                        width: double
                                                            .infinity,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              padding: WidgetStatePropertyAll(
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 23,
                                                                      vertical: 19)),
                                                              // elevation: WidgetStatePropertyAll(5),
                                                              backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  AppColor
                                                                      .appBarColor),
                                                              shape: WidgetStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: AppColor
                                                                              .textColor),
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          5)))),
                                                          onPressed: () async {
                                                            controller.getUserInfoTransactionDetailExcel();
                                                            Get.back();
                                                          },
                                                          child: controller
                                                              .isLoading
                                                              .value
                                                              ?
                                                          CircularProgressIndicator(
                                                            valueColor: AlwaysStoppedAnimation<
                                                                Color>(
                                                                AppColor
                                                                    .textColor),
                                                          )
                                                              :
                                                          Text(
                                                            'ثبت',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                fontSize: isDesktop
                                                                    ? 12
                                                                    : 10),
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
                                    //onPressed: () => controller.getOrderExcel(),
                                  ),
                                  SizedBox(width: 5,),
                                  // خروجی pdf
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 15,vertical: 7
                                          ),
                                        ),
                                        elevation: WidgetStatePropertyAll(5),
                                        fixedSize: WidgetStatePropertyAll(Size(100,30)),
                                        backgroundColor:
                                        WidgetStatePropertyAll(AppColor.secondary3Color),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)))),
                                    onPressed: () {
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
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'خروجی pdf',
                                                              style: AppTextStyle.labelText.copyWith(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.normal,
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
                                                            SizedBox(height: 8),
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
                                                      Spacer(),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                        width: double.infinity,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              padding: WidgetStatePropertyAll(
                                                                  EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                              // elevation: WidgetStatePropertyAll(5),
                                                              backgroundColor:
                                                              WidgetStatePropertyAll(AppColor.appBarColor),
                                                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                  borderRadius: BorderRadius.circular(5)))),
                                                          onPressed: () async {
                                                            controller.exportToPdf(controller.id.value.toString());
                                                            Get.back();
                                                          },
                                                          child: controller.isLoading.value?
                                                          CircularProgressIndicator(
                                                            valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                          ) :
                                                          Text(
                                                            'ثبت',
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
                                      'خروجی pdf',
                                      style: AppTextStyle.labelText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),

                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20),
                            height: 0.8,
                            width: Get.width,
                            color: AppColor.textColor,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                    AppColor
                                        .textFieldColor,
                                    backgroundImage: AssetImage(
                                        "assets/images/boy.png"),
                                  ),
                                  Container(
                                    // width: 300,
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  child:
                                                  Text(
                                                    'نام : ',
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12

                                                            : 10,
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  child:
                                                  Text(
                                                    'شماره : ',
                                                    style: AppTextStyle
                                                        .labelText
                                                        .copyWith(fontSize: isDesktop ? 12 : 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  child:
                                                  Text(
                                                    'نقش : ',
                                                    style: AppTextStyle
                                                        .labelText
                                                        .copyWith(fontSize: isDesktop ? 12 : 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  child:
                                                  Text(
                                                    'تاریخ عضویت : ',
                                                    style: AppTextStyle
                                                        .labelText
                                                        .copyWith(fontSize: isDesktop ? 12 : 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  child:
                                                  Text(
                                                    'بیعانه : ',
                                                    style: AppTextStyle
                                                        .labelText
                                                        .copyWith(fontSize: isDesktop ? 12 : 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  child:
                                                  Text(
                                                    'آدرس : ',
                                                    style: AppTextStyle
                                                        .labelText
                                                        .copyWith(fontSize: isDesktop ? 12 : 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          7),
                                                      color:
                                                      AppColor.textColor),
                                                  child:
                                                  Text(
                                                    controller.headerInfoUserTransactionModel?.accountName ??
                                                        "",
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10,
                                                        color:
                                                        AppColor.backGroundColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          7),
                                                      color:
                                                      AppColor.textColor),
                                                  child:
                                                  Text(
                                                    controller.headerInfoUserTransactionModel?.tell ??
                                                        "",
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10,
                                                        color:
                                                        AppColor.backGroundColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          7),
                                                      color:
                                                      AppColor.textColor),
                                                  child:
                                                  Text(
                                                    controller.headerInfoUserTransactionModel?.accountGroup ??
                                                        "",
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10,
                                                        color:
                                                        AppColor.backGroundColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          7),
                                                      color:
                                                      AppColor.textColor),
                                                  child:
                                                  Text(
                                                    controller.headerInfoUserTransactionModel!.startDate !=
                                                        null
                                                        ? controller.headerInfoUserTransactionModel!.startDate!.toPersianDate().toString()
                                                        :
                                                    "",
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10,
                                                        color:
                                                        AppColor.backGroundColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          7),
                                                      color:
                                                      AppColor.textColor),
                                                  child:
                                                  Text(
                                                    controller.headerInfoUserTransactionModel?.deposit ??
                                                        "",
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10,
                                                        color:
                                                        AppColor.accentColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          7),
                                                      color:
                                                      AppColor.textColor),
                                                  child:
                                                  Text(
                                                    controller.headerInfoUserTransactionModel?.address ??
                                                        "",
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10,
                                                        color:
                                                        AppColor.backGroundColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/svg/camera.svg',
                                      height: 24,
                                      colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                                    ),
                                    tooltip: 'گرفتن اسکرین شات',
                                    onPressed: () => controller.captureBalanceScreenshot(context, _balanceKey),
                                  ),
                                  RepaintBoundary(
                                    key: _balanceKey,
                                    child: BalanceWidget(title: "${controller.headerInfoUserTransactionModel?.accountName} ${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
                                      listBalance:
                                      controller.balanceList,
                                      size: Get.width * 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceAround,
                            children: [
                              TabelInfoWidget(
                                list: controller.headerInfoUserTransactionModel!.inventorys??[],
                                title: 'دریافت و پرداخت',
                                title1: 'دریافت',
                                title2: 'پرداخت',
                                typeSel1: 'receive',
                                typeSel2: 'payment',
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              TabelInfoWidget(
                                list: controller
                                    .headerInfoUserTransactionModel!
                                    .orders??[],
                                title: 'خرید و فروش',
                                title1: 'خرید',
                                title2: 'فروش',
                                typeSel1: 'buy',
                                typeSel2: 'sell',
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              TabelInfoWidget(
                                list: controller
                                    .headerInfoUserTransactionModel!
                                    .remmitances??[],
                                title: 'حواله',
                                title1: 'حواله',
                                title2: 'رسید',
                                typeSel1: 'issue',
                                typeSel2: 'reciept',
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                        : Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(7),
                          color: AppColor.backGroundColor),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ' حساب کاربری ${controller.headerInfoUserTransactionModel?.accountName ?? ""}',
                                        style: AppTextStyle
                                            .labelText
                                            .copyWith(
                                            fontSize:
                                            isDesktop
                                                ? 14
                                                : 13),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      /*Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 35,
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10,
                                                vertical:
                                                7),
                                            margin: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10,
                                                vertical:
                                                0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    7),
                                                color: AppColor
                                                    .primaryColor),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/svg/edit.svg',
                                                    height:
                                                    17,
                                                    colorFilter:
                                                    ColorFilter.mode(
                                                      AppColor
                                                          .textColor,
                                                      BlendMode
                                                          .srcIn,
                                                    )),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  'ویرایش',
                                                  style: AppTextStyle
                                                      .labelText
                                                      .copyWith(
                                                      fontSize: isDesktop ? 12 : 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            height: 35,
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10,
                                                vertical:
                                                7),
                                            margin: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                5,
                                                vertical:
                                                0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    7),
                                                color: AppColor
                                                    .secondary2Color),
                                            child: Row(
                                              children: [
                                                // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                                //     colorFilter: ColorFilter.mode(
                                                //       AppColor.textColor,
                                                //       BlendMode.srcIn,
                                                //     )),
                                                // SizedBox(width: 5,),
                                                Text(
                                                  'صدور فاکتور',
                                                  style: AppTextStyle
                                                      .labelText
                                                      .copyWith(
                                                      fontSize: isDesktop ? 12 : 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),*/
                                      SizedBox(
                                        height: 10,
                                          width: 10,
                                      ),
                                      Row(
                                        children: [
                                          /*Container(
                                            width: 100,
                                            height: 35,
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10,
                                                vertical:
                                                7),
                                            margin: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                5,
                                                vertical:
                                                0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    7),
                                                color: AppColor
                                                    .accentColor),
                                            child: Row(
                                              children: [
                                                // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                                //     colorFilter: ColorFilter.mode(
                                                //       AppColor.textColor,
                                                //       BlendMode.srcIn,
                                                //     )),
                                                // SizedBox(width: 5,),
                                                Text(
                                                  'صدور فاکتور جدید',
                                                  style: AppTextStyle
                                                      .labelText
                                                      .copyWith(
                                                      fontSize: isDesktop ? 12 : 10),
                                                ),
                                              ],
                                            ),
                                          ),*/
                                          // خروجی اکسل
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
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel: MaterialLocalizations
                                                      .of(context)
                                                      .modalBarrierDismissLabel,
                                                  barrierColor: Colors
                                                      .black45,
                                                  transitionDuration: const Duration(
                                                      milliseconds: 200),
                                                  pageBuilder: (
                                                      BuildContext buildContext,
                                                      Animation animation,
                                                      Animation secondaryAnimation) {
                                                    return Center(
                                                      child: Material(
                                                        color: Colors
                                                            .transparent,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  8),
                                                              color: AppColor
                                                                  .backGroundColor
                                                          ),
                                                          width: isDesktop
                                                              ? Get
                                                              .width *
                                                              0.2
                                                              : Get
                                                              .height *
                                                              0.5,
                                                          height: isDesktop
                                                              ? Get
                                                              .height *
                                                              0.5
                                                              : Get
                                                              .height *
                                                              0.7,
                                                          padding: EdgeInsets
                                                              .all(
                                                              20),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .all(
                                                                    8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text(
                                                                      'خروجی اکسل',
                                                                      style: AppTextStyle
                                                                          .labelText
                                                                          .copyWith(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight
                                                                            .normal,
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
                                                                    horizontal: 10),
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        height: 8),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                          'از تاریخ',
                                                                          style: AppTextStyle
                                                                              .labelText
                                                                              .copyWith(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight
                                                                                  .normal,
                                                                              color: AppColor
                                                                                  .textColor),
                                                                        ),
                                                                        Container(
                                                                          //height: 50,
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              bottom: 5),
                                                                          child: IntrinsicHeight(
                                                                            child: TextFormField(
                                                                              validator: (
                                                                                  value) {
                                                                                if (value ==
                                                                                    null ||
                                                                                    value
                                                                                        .isEmpty) {
                                                                                  return 'لطفا تاریخ را انتخاب کنید';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              controller: controller
                                                                                  .dateStartController,
                                                                              readOnly: true,
                                                                              style: AppTextStyle
                                                                                  .labelText,
                                                                              decoration: InputDecoration(
                                                                                suffixIcon: Icon(
                                                                                    Icons
                                                                                        .calendar_month,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10),
                                                                                ),
                                                                                filled: true,
                                                                                fillColor: AppColor
                                                                                    .textFieldColor,
                                                                                errorMaxLines: 1,
                                                                              ),
                                                                              onTap: () async {
                                                                                Jalali? pickedDate = await showPersianDatePicker(
                                                                                  context: context,
                                                                                  initialDate: Jalali
                                                                                      .now(),
                                                                                  firstDate: Jalali(
                                                                                      1400,
                                                                                      1,
                                                                                      1),
                                                                                  lastDate: Jalali(
                                                                                      1450,
                                                                                      12,
                                                                                      29),
                                                                                  initialEntryMode: PersianDatePickerEntryMode
                                                                                      .calendar,
                                                                                  initialDatePickerMode: PersianDatePickerMode
                                                                                      .day,
                                                                                  locale: Locale(
                                                                                      "fa",
                                                                                      "IR"),
                                                                                );
                                                                                Gregorian gregorian = pickedDate!
                                                                                    .toGregorian();
                                                                                controller
                                                                                    .startDateFilter
                                                                                    .value =
                                                                                "${gregorian
                                                                                    .year}-${gregorian
                                                                                    .month
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}-${gregorian
                                                                                    .day
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}";

                                                                                controller
                                                                                    .dateStartController
                                                                                    .text =
                                                                                "${pickedDate
                                                                                    .year}/${pickedDate
                                                                                    .month
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}/${pickedDate
                                                                                    .day
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}";
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height: 8),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                          'تا تاریخ',
                                                                          style: AppTextStyle
                                                                              .labelText
                                                                              .copyWith(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight
                                                                                  .normal,
                                                                              color: AppColor
                                                                                  .textColor),
                                                                        ),
                                                                        Container(
                                                                          //height: 50,
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              bottom: 5),
                                                                          child: IntrinsicHeight(
                                                                            child: TextFormField(
                                                                              validator: (
                                                                                  value) {
                                                                                if (value ==
                                                                                    null ||
                                                                                    value
                                                                                        .isEmpty) {
                                                                                  return 'لطفا تاریخ را انتخاب کنید';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              controller: controller
                                                                                  .dateEndController,
                                                                              readOnly: true,
                                                                              style: AppTextStyle
                                                                                  .labelText,
                                                                              decoration: InputDecoration(
                                                                                suffixIcon: Icon(
                                                                                    Icons
                                                                                        .calendar_month,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10),
                                                                                ),
                                                                                filled: true,
                                                                                fillColor: AppColor
                                                                                    .textFieldColor,
                                                                                errorMaxLines: 1,
                                                                              ),
                                                                              onTap: () async {
                                                                                Jalali? pickedDate = await showPersianDatePicker(
                                                                                  context: context,
                                                                                  initialDate: Jalali
                                                                                      .now(),
                                                                                  firstDate: Jalali(
                                                                                      1400,
                                                                                      1,
                                                                                      1),
                                                                                  lastDate: Jalali(
                                                                                      1450,
                                                                                      12,
                                                                                      29),
                                                                                  initialEntryMode: PersianDatePickerEntryMode
                                                                                      .calendar,
                                                                                  initialDatePickerMode: PersianDatePickerMode
                                                                                      .day,
                                                                                  locale: Locale(
                                                                                      "fa",
                                                                                      "IR"),
                                                                                );
                                                                                // DateTime date=DateTime.now();
                                                                                Gregorian gregorian = pickedDate!
                                                                                    .toGregorian();
                                                                                controller
                                                                                    .endDateFilter
                                                                                    .value =
                                                                                "${gregorian
                                                                                    .year}-${gregorian
                                                                                    .month
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}-${gregorian
                                                                                    .day
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}";

                                                                                controller
                                                                                    .dateEndController
                                                                                    .text =
                                                                                "${pickedDate
                                                                                    .year}/${pickedDate
                                                                                    .month
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}/${pickedDate
                                                                                    .day
                                                                                    .toString()
                                                                                    .padLeft(
                                                                                    2,
                                                                                    '0')}";
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                    horizontal: 20,
                                                                    vertical: 10),
                                                                width: double
                                                                    .infinity,
                                                                height: 40,
                                                                child: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      padding: WidgetStatePropertyAll(
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 23,
                                                                              vertical: 19)),
                                                                      // elevation: WidgetStatePropertyAll(5),
                                                                      backgroundColor:
                                                                      WidgetStatePropertyAll(
                                                                          AppColor
                                                                              .appBarColor),
                                                                      shape: WidgetStatePropertyAll(
                                                                          RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                  color: AppColor
                                                                                      .textColor),
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  5)))),
                                                                  onPressed: () async {
                                                                    controller.getUserInfoTransactionDetailExcel();
                                                                    Get.back();
                                                                  },
                                                                  child: controller
                                                                      .isLoading
                                                                      .value
                                                                      ?
                                                                  CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                        Color>(
                                                                        AppColor
                                                                            .textColor),
                                                                  )
                                                                      :
                                                                  Text(
                                                                    'ثبت',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                        fontSize: isDesktop
                                                                            ? 12
                                                                            : 10),
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
                                            //onPressed: () => controller.getOrderExcel(),
                                          ),
                                          SizedBox(width: 3,),
                                          // خروجی pdf
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                padding: WidgetStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15,vertical: 7
                                                  ),
                                                ),
                                                elevation: WidgetStatePropertyAll(5),
                                                fixedSize: WidgetStatePropertyAll(Size(100,30)),
                                                backgroundColor:
                                                WidgetStatePropertyAll(AppColor.secondary3Color),
                                                shape: WidgetStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)))),
                                            onPressed: () {
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
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'خروجی pdf',
                                                                      style: AppTextStyle.labelText.copyWith(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.normal,
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
                                                                    SizedBox(height: 8),
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
                                                              Spacer(),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                                width: double.infinity,
                                                                height: 40,
                                                                child: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      padding: WidgetStatePropertyAll(
                                                                          EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                                      // elevation: WidgetStatePropertyAll(5),
                                                                      backgroundColor:
                                                                      WidgetStatePropertyAll(AppColor.appBarColor),
                                                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                          borderRadius: BorderRadius.circular(5)))),
                                                                  onPressed: () async {
                                                                    controller.exportToPdf(controller.id.value.toString());
                                                                    Get.back();
                                                                  },
                                                                  child: controller.isLoading.value?
                                                                  CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                  ) :
                                                                  Text(
                                                                    'ثبت',
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
                                              'خروجی pdf',
                                              style: AppTextStyle.labelText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20),
                              height: 0.8,
                              width: Get.width,
                              color: AppColor.textColor,
                            ),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                      AppColor
                                          .textFieldColor,
                                      backgroundImage:
                                      AssetImage(
                                          "assets/images/boy.png"),
                                    ),
                                    Container(
                                      // width: 300,
                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          20),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    child:
                                                    Text(
                                                      'نام : ',
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop ? 12 : 10,
                                                          fontWeight: FontWeight.normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    child:
                                                    Text(
                                                      'شماره : ',
                                                      style: AppTextStyle
                                                          .labelText
                                                          .copyWith(fontSize: isDesktop ? 12 : 10),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    child:
                                                    Text(
                                                      'نقش : ',
                                                      style: AppTextStyle
                                                          .labelText
                                                          .copyWith(fontSize: isDesktop ? 12 : 10),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    child:
                                                    Text(
                                                      'تاریخ عضویت : ',
                                                      style: AppTextStyle
                                                          .labelText
                                                          .copyWith(fontSize: isDesktop ? 12 : 10),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    child:
                                                    Text(
                                                      'بیعانه : ',
                                                      style: AppTextStyle
                                                          .labelText
                                                          .copyWith(fontSize: isDesktop ? 12 : 10),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    child:
                                                    Text(
                                                      'آدرس : ',
                                                      style: AppTextStyle
                                                          .labelText
                                                          .copyWith(fontSize: isDesktop ? 12 : 10),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(7),
                                                        color: AppColor.textColor),
                                                    child:
                                                    Text(
                                                      controller.headerInfoUserTransactionModel?.accountName ??
                                                          "",
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop ? 12 : 10,
                                                          color: AppColor.backGroundColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(7),
                                                        color: AppColor.textColor),
                                                    child:
                                                    Text(
                                                      controller.headerInfoUserTransactionModel?.tell ??
                                                          "",
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop ? 12 : 10,
                                                          color: AppColor.backGroundColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(7),
                                                        color: AppColor.textColor),
                                                    child:
                                                    Text(
                                                      controller.headerInfoUserTransactionModel?.accountGroup ??
                                                          "",
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop ? 12 : 10,
                                                          color: AppColor.backGroundColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(7),
                                                        color: AppColor.textColor),
                                                    child:
                                                    Text(
                                                      // controller.headerInfoUserTransactionModel!.startDate!.toPersianDate().toString(),
                                                      "",
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop ? 12 : 10,
                                                          color: AppColor.backGroundColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(7),
                                                        color: AppColor.textColor),
                                                    child:
                                                    Text(
                                                      controller.headerInfoUserTransactionModel?.deposit ??
                                                          "",
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop ? 12 : 10,
                                                          color: AppColor.accentColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(7),
                                                        color: AppColor.textColor),
                                                    child:
                                                    Text(
                                                      controller.headerInfoUserTransactionModel?.address ??
                                                          "",
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop ? 12 : 10,
                                                          color: AppColor.backGroundColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/svg/camera.svg',
                                        height: 24,
                                        colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                                      ),
                                      tooltip: 'گرفتن اسکرین شات',
                                      onPressed: () => controller.captureBalanceScreenshot(context, _balanceKey),
                                    ),
                                    RepaintBoundary(
                                      key: _balanceKey,
                                      child: BalanceWidget(title:"${controller.headerInfoUserTransactionModel?.accountName} ${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
                                        listBalance: controller
                                            .balanceList,
                                        size: Get.width * 0.75,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    TabelInfoWidget(
                                      list: controller
                                          .headerInfoUserTransactionModel!
                                          .inventorys!,
                                      title:
                                      'دریافت و پرداخت',
                                      title1: 'دریافت',
                                      title2: 'پرداخت',
                                      typeSel1: 'receive',
                                      typeSel2: 'payment',
                                    ),
                                    // / SizedBox(width: 30,),
                                    TabelInfoWidget(
                                      list: controller
                                          .headerInfoUserTransactionModel!
                                          .orders!,
                                      title: 'خرید و فروش',
                                      title1: 'خرید',
                                      title2: 'فروش',
                                      typeSel1: 'buy',
                                      typeSel2: 'sell',
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                ),
                                TabelInfoWidget(
                                  list: controller
                                      .headerInfoUserTransactionModel!
                                      .remmitances!,
                                  title: 'حواله',
                                  title1: 'حواله',
                                  title2: 'رسید',
                                  typeSel1: 'issue',
                                  typeSel2: 'reciept',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    controller.transactionInfoList.isEmpty
                        ? SizedBox(
                      height: Get.height * 0.9,
                      width: Get.width,
                          child: Center(
                                                child: CircularProgressIndicator(),
                                              ),
                        )
                        : Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
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
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // فیلتر
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 23,
                                                vertical: 12)),
                                        // elevation: WidgetStatePropertyAll(5),
                                        backgroundColor:
                                        WidgetStatePropertyAll(
                                            AppColor.appBarColor
                                                .withOpacity(
                                                0.5)),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: AppColor
                                                        .textColor),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    5)))),
                                    onPressed: () async {
                                      showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: MaterialLocalizations
                                              .of(context)
                                              .modalBarrierDismissLabel,
                                          barrierColor: Colors
                                              .black45,
                                          transitionDuration: const Duration(
                                              milliseconds: 200),
                                          pageBuilder: (
                                              BuildContext buildContext,
                                              Animation animation,
                                              Animation secondaryAnimation) {
                                            return Center(
                                              child: Material(
                                                color: Colors
                                                    .transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          8),
                                                      color: AppColor
                                                          .backGroundColor
                                                  ),
                                                  width: isDesktop
                                                      ? Get
                                                      .width * 0.2
                                                      : Get
                                                      .height *
                                                      0.5,
                                                  height: isDesktop
                                                      ? Get
                                                      .height *
                                                      0.5
                                                      : Get
                                                      .height *
                                                      0.7,
                                                  padding: EdgeInsets
                                                      .all(20),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .all(
                                                              8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'فیلتر',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight
                                                                          .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 50,
                                                                height: 27,
                                                                child: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      padding: WidgetStatePropertyAll(
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 2,
                                                                              vertical: 1)),
                                                                      // elevation: WidgetStatePropertyAll(5),
                                                                      backgroundColor:
                                                                      WidgetStatePropertyAll(
                                                                          AppColor
                                                                              .accentColor
                                                                              .withOpacity(
                                                                              0.5)),
                                                                      shape: WidgetStatePropertyAll(
                                                                          RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                  color: AppColor
                                                                                      .textColor),
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  5)))),
                                                                  onPressed: () async {
                                                                    controller.clearFilter();
                                                                    controller.getTransactionInfoListPager(controller.id.value.toString());
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    'حذف فیلتر',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                        fontSize: isDesktop
                                                                            ? 9
                                                                            : 8),
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
                                                              horizontal: 10),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 8,),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    'از تاریخ',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight
                                                                            .normal,
                                                                        color: AppColor
                                                                            .textColor),
                                                                  ),
                                                                  Container(
                                                                    //height: 50,
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        bottom: 5),
                                                                    child: IntrinsicHeight(
                                                                      child: TextFormField(
                                                                        validator: (
                                                                            value) {
                                                                          if (value ==
                                                                              null ||
                                                                              value
                                                                                  .isEmpty) {
                                                                            return 'لطفا تاریخ را انتخاب کنید';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: controller
                                                                            .dateStartController,
                                                                        readOnly: true,
                                                                        style: AppTextStyle
                                                                            .labelText,
                                                                        decoration: InputDecoration(
                                                                          suffixIcon: Icon(
                                                                              Icons
                                                                                  .calendar_month,
                                                                              color: AppColor
                                                                                  .textColor),
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                10),
                                                                          ),
                                                                          filled: true,
                                                                          fillColor: AppColor
                                                                              .textFieldColor,
                                                                          errorMaxLines: 1,
                                                                        ),
                                                                        onTap: () async {
                                                                          Jalali? pickedDate = await showPersianDatePicker(
                                                                            context: context,
                                                                            initialDate: Jalali
                                                                                .now(),
                                                                            firstDate: Jalali(
                                                                                1400,
                                                                                1,
                                                                                1),
                                                                            lastDate: Jalali(
                                                                                1450,
                                                                                12,
                                                                                29),
                                                                            initialEntryMode: PersianDatePickerEntryMode
                                                                                .calendar,
                                                                            initialDatePickerMode: PersianDatePickerMode
                                                                                .day,
                                                                            locale: Locale(
                                                                                "fa",
                                                                                "IR"),
                                                                          );
                                                                          Gregorian gregorian = pickedDate!
                                                                              .toGregorian();
                                                                          controller
                                                                              .startDateFilter
                                                                              .value =
                                                                          "${gregorian
                                                                              .year}-${gregorian
                                                                              .month
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}-${gregorian
                                                                              .day
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}";

                                                                          controller
                                                                              .dateStartController
                                                                              .text =
                                                                          "${pickedDate
                                                                              .year}/${pickedDate
                                                                              .month
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}/${pickedDate
                                                                              .day
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}";
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 8),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    'تا تاریخ',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight
                                                                            .normal,
                                                                        color: AppColor
                                                                            .textColor),
                                                                  ),
                                                                  Container(
                                                                    //height: 50,
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        bottom: 5),
                                                                    child: IntrinsicHeight(
                                                                      child: TextFormField(
                                                                        validator: (
                                                                            value) {
                                                                          if (value ==
                                                                              null ||
                                                                              value
                                                                                  .isEmpty) {
                                                                            return 'لطفا تاریخ را انتخاب کنید';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: controller
                                                                            .dateEndController,
                                                                        readOnly: true,
                                                                        style: AppTextStyle
                                                                            .labelText,
                                                                        decoration: InputDecoration(
                                                                          suffixIcon: Icon(
                                                                              Icons
                                                                                  .calendar_month,
                                                                              color: AppColor
                                                                                  .textColor),
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                10),
                                                                          ),
                                                                          filled: true,
                                                                          fillColor: AppColor
                                                                              .textFieldColor,
                                                                          errorMaxLines: 1,
                                                                        ),
                                                                        onTap: () async {
                                                                          Jalali? pickedDate = await showPersianDatePicker(
                                                                            context: context,
                                                                            initialDate: Jalali
                                                                                .now(),
                                                                            firstDate: Jalali(
                                                                                1400,
                                                                                1,
                                                                                1),
                                                                            lastDate: Jalali(
                                                                                1450,
                                                                                12,
                                                                                29),
                                                                            initialEntryMode: PersianDatePickerEntryMode
                                                                                .calendar,
                                                                            initialDatePickerMode: PersianDatePickerMode
                                                                                .day,
                                                                            locale: Locale(
                                                                                "fa",
                                                                                "IR"),
                                                                          );
                                                                          // DateTime date=DateTime.now();
                                                                          Gregorian gregorian = pickedDate!
                                                                              .toGregorian();
                                                                          controller
                                                                              .endDateFilter
                                                                              .value =
                                                                          "${gregorian
                                                                              .year}-${gregorian
                                                                              .month
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}-${gregorian
                                                                              .day
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}";

                                                                          controller
                                                                              .dateEndController
                                                                              .text =
                                                                          "${pickedDate
                                                                              .year}/${pickedDate
                                                                              .month
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}/${pickedDate
                                                                              .day
                                                                              .toString()
                                                                              .padLeft(
                                                                              2,
                                                                              '0')}";
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                        //  Spacer(),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                              horizontal: 20,
                                                              vertical: 10),
                                                          width: double
                                                              .infinity,
                                                          height: 40,
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                padding: WidgetStatePropertyAll(
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 23,
                                                                        vertical: 19)),
                                                                // elevation: WidgetStatePropertyAll(5),
                                                                backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    AppColor
                                                                        .appBarColor),
                                                                shape: WidgetStatePropertyAll(
                                                                    RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: AppColor
                                                                                .textColor),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            5)))),
                                                            onPressed: () async {
                                                              controller.getTransactionInfoListPager(controller.id.value.toString());
                                                              Get.back();
                                                            },
                                                            child: controller
                                                                .isLoading
                                                                .value
                                                                ?
                                                            CircularProgressIndicator(
                                                              valueColor: AlwaysStoppedAnimation<
                                                                  Color>(
                                                                  AppColor
                                                                      .textColor),
                                                            )
                                                                :
                                                            Text(
                                                              'فیلتر',
                                                              style: AppTextStyle
                                                                  .labelText
                                                                  .copyWith(
                                                                  fontSize: isDesktop
                                                                      ? 12
                                                                      : 10),
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
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/filter3.svg',
                                            height: 17,
                                            colorFilter:
                                            ColorFilter
                                                .mode(
                                              controller
                                                  .dateStartController
                                                  .text !=
                                                  "" ||
                                                  controller
                                                      .dateEndController
                                                      .text != ""
                                                  ? AppColor
                                                  .accentColor
                                                  : AppColor
                                                  .textColor,
                                              BlendMode
                                                  .srcIn,
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'فیلتر',
                                          style: AppTextStyle
                                              .labelText
                                              .copyWith(
                                              fontSize: isDesktop
                                                  ? 12
                                                  : 10,
                                              color:
                                              controller
                                                  .dateStartController
                                                  .text !=
                                                  "" ||
                                                  controller
                                                      .dateEndController
                                                      .text != ""
                                                  ? AppColor
                                                  .accentColor
                                                  : AppColor
                                                  .textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DataTable(
                                    columns:
                                    buildDataColumns(),
                                    sortColumnIndex: controller.sortIndex.value,
                                    sortAscending: controller.sort.value,
                                    border: TableBorder.symmetric(inside: BorderSide(color: AppColor.textColor,width: 0.3),
                                      outside: BorderSide(color: AppColor.textColor,width: 0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    dividerThickness: 0.3,
                                    rows: buildDataRows(
                                        context),
                                    dataRowMaxHeight: 120,
                                    //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                    //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                    headingRowHeight: 70,
                                    columnSpacing: 30,
                                    horizontalMargin: 0,

                                  ),

                                ],
                              ),
                            ),
                          ],
                                                ),
                                              ),
                        ),

                    SizedBox(height: 50,)
                  ],
                ),
              ),
            )
                :
            ErrPage(
              callback: () {
                controller.clearFilter();
                controller.getTransactionInfoListPager(controller.id.value.toString());
              },
              title: "خطا در دریافت لیست تراکنش ها",
              des: 'برای دریافت لیست تراکنش ها مجددا تلاش کنید',
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              controller.paginated.value != null ? Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child: PagerWidget(
                    countPage: controller.paginated.value
                        ?.totalCount ?? 0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)) : SizedBox(),
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
              child: Text('نوع',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
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
              child: Text('تاریخ',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            print(ascending);
            controller.setSort(columnIndex,ascending);

            controller.onSortColum(columnIndex, ascending);
          },
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('شرح',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مقدار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('عملیات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده ریالی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده طلایی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده سکه',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مستندات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.transactionInfoList
        .map((trans) => DataRow(
      cells: [
        // نوع
        DataCell(
          Center(
            child: RotatedBox(
              quarterTurns: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: trans.type == "reciept" ||
                        trans.type == "receive" ||
                        trans.type == "buy"
                        ? AppColor.primaryColor
                        : AppColor.accentColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        trans.type == "issue"
                            ? ' حواله ${trans.item?.name ?? ""}'
                            : trans.type == "receive"
                            ? ' دریافت ${trans.item?.name ?? ""}'
                            : trans.type == "payment"
                            ? ' پرداخت ${trans.item?.name ?? ""}'
                            : trans.type == "sell"
                            ? ' فروش ${trans.item?.name ?? ""}'
                            : trans.type == "buy"
                            ? ' خرید ${trans.item?.name ?? ""}'
                            : trans.type == "deposit"
                            ? ' واریز ${trans.item?.name ?? ""}'
                            : trans.type == "withdraw"
                            ? ' برداشت ${trans.item?.name ?? ""}'
                            : trans.type == "reciept"
                            ? ' برگشت ${trans.item?.name ?? ""}'
                            : trans.type == "toTransfer" || trans.type == "fromTransfer"
                            ? ' ولت ${trans.item?.name ?? ""}'
                            : "",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        DataCell(Center(
          child: Text(
            "${trans.rowNum ?? 0}",
            style: AppTextStyle.bodyText,
          ),
        )),
        DataCell(Center(
          child: Text(
            "${trans.date?.toPersianDate(showTime: true) ?? 'نامشخص'} ",
            style: AppTextStyle.bodyText
                .copyWith(color: AppColor.textColor, fontSize: 10),textDirection: TextDirection.ltr,),
        )),
        // شرح
        DataCell(SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 5, vertical: 3),
            child: Center(
              child: trans.details!.isEmpty
                  ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  trans.type=="fromTransfer" ?
                  Column(
                    children: [
                      Row(
                        children: [
                          SelectableText(
                            " از ولت ",
                            style: AppTextStyle.bodyText.copyWith(
                                color: AppColor.textColor,
                                fontSize: 12),
                          ),
                          SelectableText(
                            " ${trans.wallet?.account?.name ?? ""} ",
                            style: AppTextStyle.bodyText.copyWith(
                                color: AppColor.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ) :
                  SizedBox(),
                  trans.type=="toTransfer" ?
                  Column(
                    children: [
                      Row(
                        children: [
                          SelectableText(
                            " به ولت ",
                            style: AppTextStyle.bodyText.copyWith(
                                color: AppColor.textColor,
                                fontSize: 12),
                          ),
                          SelectableText(
                            " ${trans.wallet?.account?.name ?? ""} ",
                            style: AppTextStyle.bodyText.copyWith(
                                color: AppColor.accentColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ) :
                  SizedBox(),
                  trans.toWallet?.account?.name != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText(
                        " از : ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontSize: 10),
                      ),
                      trans.type=='reciept'?
                      SelectableText(
                        " ${trans.toWallet?.account?.name ?? ""} ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ):
                      SelectableText(
                        " ${trans.wallet?.account?.name ?? ""} ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      SelectableText(
                        " به : ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontSize: 10),
                      ),
                      trans.type=='reciept'?
                      SelectableText(
                        " ${trans.wallet?.account?.name ?? ""} ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ):
                      SelectableText(
                        " ${trans.toWallet?.account?.name ?? ""} ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                      : SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText(
                        trans.item?.itemUnit?.id == 1
                            ? " ${trans.amount} "
                            : trans.item?.itemUnit?.id == 2
                            ? "${trans.amount} "
                            : "${trans.amount.toString().seRagham()}  ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10),
                        textDirection: TextDirection.ltr,
                      ),
                      SelectableText(
                        trans.item?.itemUnit?.id == 1
                            ? " عدد "
                            : trans.item?.itemUnit?.id == 2
                            ? " گرم "
                            : trans.item?.itemUnit?.id == 4
                            ? "دلار"
                            : trans.item?.itemUnit?.id == 5
                            ? "یورو"
                            : " ریال ",
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SelectableText(
                        trans.item?.name ?? 'نامشخص',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.secondary2Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  trans.price != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText(
                        'به مظنه :  ',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.iconViewColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10),
                      ),
                      SelectableText(
                          "${trans.mesghalPrice ?? 0}".seRagham() +
                              "  ریال  ",
                          style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ],
                  )
                      : SizedBox(),
                  trans.totalPrice != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText(
                        ' قیمت کل :  ',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.iconViewColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 10),
                      ),
                      SelectableText(
                          "${trans.totalPrice ?? 0}"
                              .seRagham() +
                              "  ریال  ",
                          style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12)),
                    ],
                  )
                      : SizedBox(),
                  Container(
                    height: 0.6,
                    color: AppColor.textColor,
                    margin: EdgeInsets.symmetric(
                        vertical: 5, horizontal: 20),
                  ),
                  trans.description != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText(
                        'توضیحات : ',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.iconViewColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10),
                      ),
                      SelectableText(trans.description ?? 'نامشخص',
                          style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 10)),
                    ],
                  )
                      : SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText(
                        trans.date?.toPersianDate(showTime: true) ??
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
              )
                  :
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: trans.details!
                    .map((e) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.textColor),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SelectableText(
                                  "وزن ترازو : ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .appBarColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                SelectableText(
                                  "${e.weight ?? 0} گرم ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SelectableText(
                                  "عیار : ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .appBarColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                SelectableText(
                                  "${e.carat ?? 0} ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SelectableText(
                                  "وزن : ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .appBarColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                SelectableText(
                                  "${e.quantity ?? 0} گرم ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SelectableText(
                                  "ناخالصی : ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .appBarColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                SelectableText(
                                  "${e.impurity ?? 0} گرم ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SelectableText(
                                  "آزمایشگاه : ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .appBarColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                SelectableText(
                                  "${e.laboratoryName ?? ""} ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SelectableText(
                                  "شماره آزمایشگاه : ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .appBarColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                SelectableText(
                                  "${e.receiptNumber ?? ""} ",
                                  style: AppTextStyle.bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                ))
                    .toList(),
              ),
            ),
          ),
        )),
        // مقدار
        DataCell(Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                trans.item?.itemUnit?.id == 1
                    ? "${trans.amount} "
                    : trans.item?.itemUnit?.id == 2
                    ? "${trans.amount.toString().seRagham()} "
                    : "${trans.amount.toString().seRagham()} ",
                style: AppTextStyle.bodyText.copyWith(
                    color: trans.amount!>0 ? AppColor.primaryColor :AppColor.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                textDirection: TextDirection.ltr,
              ),
              Text(
                trans.item?.itemUnit?.id == 1
                    ? " عدد "
                    : trans.item?.itemUnit?.id == 2
                    ? " گرم "
                    : trans.item?.itemUnit?.id == 4
                    ? "دلار"
                    : trans.item?.itemUnit?.id == 5
                    ? "یورو"
                    : " ریال ",
                style: AppTextStyle.bodyText.copyWith(
                    color: trans.amount!>0 ? AppColor.primaryColor :AppColor.accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        )),
        // عملیات
        DataCell(Center(
          child:
              //دکمه ادیت جزئیات
              OutlinedButton(
                onPressed: () async{
                  // Handle different transaction types with proper parameters
                  switch (trans.type) {
                    case "issue":
                    case "reciept":
                    // For remittance operations, use recordId
                    /*Get.toNamed('/updateRemittance', parameters: {"id": trans.recordId.toString()})
                        ?.then((_) {
                      // Refresh data after returning from edit page
                      controller.getTransactionInfoListPager(controller.id.value.toString());
                      controller.getBalanceList(controller.id.value);
                      controller.getHeaderTransaction(controller.id.value);
                    });*/
                    Get.snackbar(
                      'اطلاعات',
                      'عملیات پرداختی از این طریق امکان‌پذیر نیست',
                      titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                      messageText: Text('عملیات پرداختی از این طریق امکان‌پذیر نیست',
                          style: TextStyle(color: AppColor.textColor)),
                    );
                      break;
                    case "receive":
                      /*Get.toNamed('/inventoryDetailUpdateReceive', parameters: {
                        "id": trans.recordId.toString(),
                        "index": ""
                      })?.then((_) {
                        // Refresh data after returning from edit page
                        controller.getTransactionInfoListPager(controller.id.value.toString());
                        controller.getBalanceList(controller.id.value);
                        controller.getHeaderTransaction(controller.id.value);
                      });*/
                      Get.snackbar(
                        'اطلاعات',
                        'عملیات دریافتی از این طریق امکان‌پذیر نیست',
                        titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                        messageText: Text('عملیات دریافتی از این طریق امکان‌پذیر نیست',
                            style: TextStyle(color: AppColor.textColor)),
                      );
                      break;
                    case "payment":
                      /*Get.toNamed('/inventoryDetailUpdatePayment', parameters: {
                        "id": trans.recordId.toString(),
                        "index": ""
                      })?.then((_) {
                        // Refresh data after returning from edit page
                        controller.getTransactionInfoListPager(controller.id.value.toString());
                        controller.getBalanceList(controller.id.value);
                        controller.getHeaderTransaction(controller.id.value);
                      });*/
                      Get.snackbar(
                        'اطلاعات',
                        'عملیات پرداختی از این طریق امکان‌پذیر نیست',
                        titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                        messageText: Text('عملیات پرداختی از این طریق امکان‌پذیر نیست',
                            style: TextStyle(color: AppColor.textColor)),
                      );
                      break;
                    case "sell":
                    case "buy":
                    // For order operations, use recordId
                    Get.toNamed('/orderUpdate', parameters: {"id": trans.recordId.toString()})
                        ?.then((_) {
                      // Refresh data after returning from edit page
                      controller.getTransactionInfoListPager(controller.id.value.toString());
                      controller.getBalanceList(controller.id.value);
                      controller.getHeaderTransaction(controller.id.value);
                    });
                      break;
                    case "deposit":
                    // For deposit operations, use recordId
                      Get.toNamed('/depositUpdate', parameters: {"id": trans.recordId.toString()})
                          ?.then((_) {
                        // Refresh data after returning from edit page
                        controller.getTransactionInfoListPager(controller.id.value.toString());
                        controller.getBalanceList(controller.id.value);
                        controller.getHeaderTransaction(controller.id.value);
                      });
                      break;
                    case "withdraw":
                    // For withdraw operations, use recordId
                      Get.toNamed('/depositUpdate', parameters: {"id": trans.recordId.toString()})
                          ?.then((_) {
                        // Refresh data after returning from edit page
                        controller.getTransactionInfoListPager(controller.id.value.toString());
                        controller.getBalanceList(controller.id.value);
                        controller.getHeaderTransaction(controller.id.value);
                      });
                      break;
                    case "toTransfer":
                    case "fromTransfer":
                    // For transfer operations, show a message or handle differently
                      Get.snackbar(
                        'اطلاعات',
                        'عملیات انتقال ولت - ویرایش از این طریق امکان‌پذیر نیست',
                        titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                        messageText: Text('عملیات انتقال ولت - ویرایش از این طریق امکان‌پذیر نیست',
                            style: TextStyle(color: AppColor.textColor)),
                      );
                      break;
                    default:
                    // For unknown types, show error message
                      Get.snackbar(
                        'خطا',
                        'نوع تراکنش نامعتبر است',
                        titleText: Text('خطا', style: TextStyle(color: AppColor.accentColor)),
                        messageText: Text('نوع تراکنش نامعتبر است',
                            style: TextStyle(color: AppColor.accentColor)),
                      );
                      break;
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/svg/edit.svg', height: 20, width: 20,
                  colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor, BlendMode.srcIn),
                ),
              ),

        )),
        // مانده
        DataCell(
            Center(
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BalanceDialogId(
                          entityId: trans.id ?? 0,
                          entityName:'نامشخص',
                          isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 20,
                        color: AppColor.buttonColor,
                      ),
                      Text(' مانده',
                        style: AppTextStyle
                            .labelText
                            .copyWith(
                            color: AppColor.buttonColor, fontSize: 11,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            )
        ),

        /*DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances == null
                    ? SizedBox()
                    : Column(
                  children: trans.balances!
                      .map((e) => Container(
                    child: e.unitName == "ریال"
                        ? Row(
                      children: [
                        Text(
                          " ${e.itemName} ",
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 9,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                        ),
                        Text(
                          e.balance
                              .toString()
                              .seRagham(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
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
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : SizedBox(),
                  ))
                      .toList(),
                ),
              ],
            ))),*/
        /*DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances == null
                    ? SizedBox()
                    : Column(
                  children: trans.balances!
                      .map((e) => Container(
                    child: e.unitName == "گرم"
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
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
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : SizedBox(),
                  ))
                      .toList(),
                ),
              ],
            ))),*/
        /*DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances == null
                    ? SizedBox()
                    : Column(
                  children: trans.balances!
                      .map((e) => Container(
                    child: e.unitName == "عدد"
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
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
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : SizedBox(),
                  ))
                      .toList(),
                ),
              ],
            ))),*/

        /*DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(" 1 ",
                    style: AppTextStyle
                        .bodyText
                        .copyWith(
                        fontSize: 12,
                        color: AppColor.iconViewColor,
                        fontWeight:
                        FontWeight.bold)
                  //  textDirection: TextDirection.ltr,
                ),
                SizedBox(
                  width: 0,
                ),
                SvgPicture.asset('assets/svg/camera.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.iconViewColor,
                    BlendMode.srcIn,
                  ),height: 18,),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),*/
      ],
    ))
        .toList();
  }

  /*Widget buildPaginationControls() {
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
  }*/
}


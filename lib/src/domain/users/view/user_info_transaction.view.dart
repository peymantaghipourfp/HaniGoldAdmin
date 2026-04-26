
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/transaction/widgets/balance_dialog_id.widget.dart';
import 'package:hanigold_admin/src/domain/users/widgets/balance_user.widget.dart';
import 'package:hanigold_admin/src/domain/users/widgets/check_result.widget.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../controller/user_info_detail_transaction.controller.dart';
import '../widgets/tabel_info.widget.dart';

import 'package:flutter/services.dart';

import '../widgets/transaction_filter.widget.dart';

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
        //onBackTap: () => Get.offNamed("/listUserInfoTransaction"),
        onBackTap: () => Get.back(),
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
                controller:isDesktop ? null : controller.scrollControllerMobile,
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
                          color: AppColor.backGroundColor1
                              .withAlpha(150)),
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
                                width: 15,
                              ),
                              Row(
                                children: [
                                  // خروجی اکسل
                                  OutlinedButton.icon(
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
                                                                      )),
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
                                    label: Text(
                                      'خروجی اکسل',
                                      style: AppTextStyle
                                          .labelText.copyWith(color: AppColor.primaryColor,fontSize: 12),
                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/svg/excel.svg',
                                      height: 24,
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  // خروجی pdf
                                  OutlinedButton.icon(
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
                                                                  EdgeInsets.symmetric(horizontal: 23)),
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
                                    label: Text(
                                      'خروجی pdf',
                                      style: AppTextStyle.labelText.copyWith(color: AppColor.textAccentColor,fontSize: 12),
                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/svg/pdf.svg',
                                      height: 24,
                                    ),
                                  ),
                                  /*SizedBox(width: 5,),
                                  // صدور فاکتور جدید
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 15,vertical: 7
                                          ),
                                        ),
                                        elevation: WidgetStatePropertyAll(5),
                                        fixedSize: WidgetStatePropertyAll(Size(120,30)),
                                        backgroundColor:
                                        WidgetStatePropertyAll(AppColor.accentColor),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)))),
                                    onPressed: () {
                                      Get.toNamed('/invoicePreview', parameters: {
                                        'accountId': controller.id.value.toString(),
                                      });
                                    },
                                    child: Text(
                                      'صدور فاکتور جدید',
                                      style: AppTextStyle.labelText.copyWith(color: Colors.white),
                                    ),
                                  ),*/
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Column(
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
                                      SizedBox(height: 5,),
                                      GestureDetector(
                                        onTap: () async {
                                          await controller.checkAccountSocialStatus();
                                          if (controller.socialStatus.value != null) {
                                            Get.defaultDialog(
                                              backgroundColor: AppColor.backGroundColor,
                                              title: "ارسال مانده حساب",
                                              titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                              middleText: "آیا از ارسال مانده حساب مطمئن هستید؟",
                                              middleTextStyle: AppTextStyle.bodyText,
                                              confirm:
                                              Obx(() {
                                                final status = controller.socialStatus.value;
                                                final hasTelegram = status?.telegramStatus == true;
                                                final hasWhatsApp = status?.whatsappStatus == true;

                                                if (!hasTelegram && !hasWhatsApp) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Text(
                                                      'هیچ کانال ارتباطی فعال نیست',
                                                      style: AppTextStyle.bodyText.copyWith(
                                                        color: AppColor.errorColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  );
                                                }

                                                return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    if (hasTelegram)
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Get.back();
                                                          await controller.sendBalanceToTelegram();
                                                        },
                                                        child: SvgPicture.asset(
                                                          'assets/svg/telegram.svg',height: 24,
                                                          colorFilter: ColorFilter.mode(Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                        ),
                                                      ),
                                                    if (hasWhatsApp)
                                                      GestureDetector(
                                                        onTap: () {
                                                          // TODO: Implement WhatsApp send logic
                                                          Get.back();
                                                        },
                                                        child: SvgPicture.asset(
                                                          'assets/svg/whatsapp.svg',height: 24,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              }),
                                            );
                                          }
                                        },
                                        child: Tooltip(
                                          message: "ارسال مانده حساب",
                                          child: SvgPicture.asset(
                                            'assets/svg/send.svg',height: 22,
                                            colorFilter: ColorFilter.mode(AppColor.secondary3Color , BlendMode.srcIn),
                                          ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Container(
                                    width: Get.width*0.3,
                                    child: RepaintBoundary(
                                      key: _balanceKey,
                                      child: BalanceUserWidget(title: "${controller.headerInfoUserTransactionModel?.accountName} ${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
                                        listBalance:
                                        controller.balanceList,
                                        size: Get.width * 0.4,
                                      ),
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
                      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(7),
                          color: AppColor.backGroundColor),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColor.secondary2Color.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF64748B)),
                              ),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            ' حساب کاربری ${controller.headerInfoUserTransactionModel?.accountName ?? ""}',
                                            style: AppTextStyle
                                                .labelText
                                                .copyWith(
                                                fontSize:
                                                isDesktop
                                                    ? 14
                                                    : 13),
                                          ),
                                        ),
                                        // خروجی اکسل
                                        GestureDetector(
                                          onTap: () {
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
                                                                            )),
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
                                          child: SvgPicture.asset(
                                            'assets/svg/excel.svg',
                                            height: 30,
                                          ),
                                        ),
                                        SizedBox(width: 17,),
                                        // خروجی pdf
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
                                                                        EdgeInsets.symmetric(horizontal: 23)),
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
                                          child: SvgPicture.asset(
                                            'assets/svg/pdf.svg',
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
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
                                            /*SizedBox(width: 3,),
                                            // صدور فاکتور جدید
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15,vertical: 7
                                                    ),
                                                  ),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  fixedSize: WidgetStatePropertyAll(Size(120,30)),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.accentColor),
                                                  shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () {
                                                Get.toNamed('/invoicePreview', parameters: {
                                                  'accountId': controller.id.value.toString(),
                                                });
                                              },
                                              child: Text(
                                                'صدور فاکتور جدید',
                                                style: AppTextStyle.labelText.copyWith(color: Colors.white),
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20),
                              height: 0.8,
                              width: Get.width,
                              color: AppColor.textColor,
                            ),*/
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColor.secondary3Color.withAlpha(20),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF64748B)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      /*CircleAvatar(
                                        radius: 40,
                                        backgroundColor:
                                        AppColor
                                            .textFieldColor,
                                        backgroundImage:
                                        AssetImage(
                                            "assets/images/boy.png"),
                                      ),*/
                                      Container(
                                        // width: 300,
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
                                  Column(mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
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
                                          SizedBox(width: 15,),
                                          GestureDetector(
                                            onTap: () async {
                                              await controller.checkAccountSocialStatus();
                                              if (controller.socialStatus.value != null) {
                                                Get.defaultDialog(
                                                    backgroundColor: AppColor.backGroundColor,
                                                    title: "ارسال مانده حساب",
                                                    titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                    middleText: "آیا از ارسال مانده حساب مطمئن هستید؟",
                                                    middleTextStyle: AppTextStyle.bodyText,
                                                    confirm:
                                                    Obx(() {
                                                      final status = controller.socialStatus.value;
                                                      final hasTelegram = status?.telegramStatus == true;
                                                      final hasWhatsApp = status?.whatsappStatus == true;

                                                      if (!hasTelegram && !hasWhatsApp) {
                                                        return Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text(
                                                            'هیچ کانال ارتباطی فعال نیست',
                                                            style: AppTextStyle.bodyText.copyWith(
                                                              color: AppColor.errorColor,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          if (hasTelegram)
                                                            GestureDetector(
                                                              onTap: () async {
                                                                Get.back();
                                                                await controller.sendBalanceToTelegram();
                                                              },
                                                              child: SvgPicture.asset(
                                                                'assets/svg/telegram.svg',height: 24,
                                                                colorFilter: ColorFilter.mode(Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                              ),
                                                            ),
                                                          if (hasWhatsApp)
                                                            GestureDetector(
                                                              onTap: () {
                                                                // TODO: Implement WhatsApp send logic
                                                                Get.back();
                                                              },
                                                              child: SvgPicture.asset(
                                                                'assets/svg/whatsapp.svg',height: 24,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    })
                                                );
                                              }
                                            },
                                            child: Tooltip(
                                              message: "ارسال مانده حساب",
                                              child: SvgPicture.asset(
                                                'assets/svg/send.svg',height: 22,
                                                colorFilter: ColorFilter.mode(AppColor.secondary3Color , BlendMode.srcIn) ,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      RepaintBoundary(
                                        key: _balanceKey,
                                        child: BalanceUserWidget(title:" ${(controller.headerInfoUserTransactionModel?.accountName?.length ?? 0) > 27 ?
                                        controller.headerInfoUserTransactionModel?.accountName?.substring(0, 27) : controller.headerInfoUserTransactionModel?.accountName}"
                                            "${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
                                          listBalance: controller
                                              .balanceList,
                                          size: Get.width * 0.9,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            /*Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    TabelInfoWidget(
                                      list: controller.headerInfoUserTransactionModel?.inventorys ?? [],
                                      title:
                                      'دریافت و پرداخت',
                                      title1: 'دریافت',
                                      title2: 'پرداخت',
                                      typeSel1: 'receive',
                                      typeSel2: 'payment',
                                    ),
                                    // / SizedBox(width: 30,),
                                    TabelInfoWidget(
                                      list: controller.headerInfoUserTransactionModel?.orders ?? [],
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
                                  list: controller.headerInfoUserTransactionModel?.remmitances ?? [],
                                  title: 'حواله',
                                  title1: 'حواله',
                                  title2: 'رسید',
                                  typeSel1: 'issue',
                                  typeSel2: 'reciept',
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    controller.isOpenMore.value
                        ? SizedBox(
                      height: Get.height * 0.9,
                      width: Get.width,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ):
                    controller.transactionInfoList.isEmpty
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
                                  : 'تراکنش‌های طلا در این حساب موجود نیست',
                              style: AppTextStyle.bodyText.copyWith(
                                fontSize: 12,
                                color: AppColor.textColor.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(height: 15,),
                            GestureDetector(
                              onTap: () {
                                controller.clearFilter();
                                controller.getTransactionInfoListPager(controller.id.value.toString());
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
                    )
                        : isDesktop ?
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10, top: 0,bottom: 20),
                      padding: EdgeInsets.only(left: 10,right: 10, top: 0, bottom: 20),
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
                                  // تیک checkedAll و فیلتر
                                  Row(
                                    children: [
                                      // فیلتر
                                      TransactionFilterWidget(
                                        controller: controller,
                                        onFilterApplied: () {
                                          controller.getTransactionInfoListPager(controller.id.value.toString());
                                        },
                                        onFilterCleared: () {
                                          controller.getTransactionInfoListPager(controller.id.value.toString());
                                        },

                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          Get.defaultDialog(
                                              backgroundColor: AppColor.backGroundColor,
                                              title: "برداشتن تیک چک باکس",
                                              titleStyle: AppTextStyle.smallTitleText,
                                              middleText: "آیا از برداشتن تیک همه چک باکس ها مطمئن هستید؟",
                                              middleTextStyle: AppTextStyle.bodyText,
                                              confirm: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor: WidgetStatePropertyAll(
                                                          AppColor.primaryColor)),
                                                  onPressed: () {
                                                    Get.back();
                                                    controller.removeCheckedAll(
                                                        controller.id.value , false);
                                                  },
                                                  child: Text(
                                                    'اعمال تغییر',
                                                    style: AppTextStyle.bodyText,
                                                  ))
                                          );
                                        },
                                        label: Text(
                                          'حذف چک باکس',
                                          style: AppTextStyle
                                              .labelText.copyWith(color: AppColor.textColorSecondary.withAlpha(200),fontSize: 12),
                                        ),
                                        icon: Icon(Icons.check_box_outline_blank,color: AppColor.textColor.withAlpha(30),),
                                      ),
                                    ],
                                  ),
                                  /*ElevatedButton(
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
                                                                        )),
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
                                  ),*/
                                  SizedBox(
                                    height: 10,
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
                                    rows: buildDataRows(context),
                                    //dataRowMinHeight: 80,
                                    dataRowMaxHeight: double.infinity,
                                    //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                    headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                    headingRowHeight: 35,
                                    columnSpacing: 30,
                                    horizontalMargin: 5,
                                  ),

                                ],
                              ),
                            ),
                          ],
                                                ),
                                              ),
                        ) :
                    _buildMobileTransactionCards(context),

                    SizedBox(height: 50,)
                  ],
                ),
              ),
            )
                :
            ErrPage(
              callback: () {
                controller.getTransactionInfoListPager(controller.id.value.toString());
                controller.clearFilter();
              },
              title: "خطا در دریافت لیست تراکنش ها",
              des: 'برای دریافت لیست تراکنش ها مجددا تلاش کنید',
            ),
          ),
          isDesktop ?
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              controller.paginated.value != null ? Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  //color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child: PagerWidget(
                    countPage: controller.paginated.value
                        ?.totalCount ?? 0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)) : SizedBox(),
            ],
          ) : SizedBox.shrink(),
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
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('فاکتور',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            controller.setSort(columnIndex,ascending);

            controller.onSortColum(columnIndex, ascending);
          },
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('تاریخ',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('محصول',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
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
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('نتایج',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('تصویر',
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
    return controller.transactionInfoList.asMap().entries.map((entry) {
      final index = entry.key;
      final trans = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
          return DataRow(
            color: trans.checked==true ? WidgetStateProperty.all(AppColor.appBarColor.withAlpha(150)) : WidgetStateProperty.all(rowColor),
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
                              ? AppColor.primaryColor.withAlpha(100)
                              : AppColor.accentColor.withAlpha(100)
                      ),
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
                                  ? ' دریافت حواله ${trans.item?.name ?? ""}'
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
                child: Row(
                  children: [
                    // رجیستر
                    Checkbox(
                      value: trans.checked ?? false,
                      onChanged: (value) async{
                        if (value != null) {
                          //EasyLoading.show(status: 'لطفا منتظر بمانید');
                          await controller.updateChecked(
                              trans.id ?? 0,
                              value
                          );
                        }
                      },
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "${trans.rowNum ?? 0}",
                      style: AppTextStyle.bodyText,
                    ),
                  ],
                ),
              )),
              // صدور فاکتور
              DataCell(
                Row(
                  children: [
                    Tooltip(
                      message: "صدور فاکتور با مانده",
                      child: Center(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await controller.generateInvoiceForTransaction(trans);
                          },
                          label: Text(
                            'فاکتور با مانده',
                            style: AppTextStyle
                                .labelText.copyWith(color: AppColor.textColor,fontSize: 11),
                          ),
                          style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.all(3)),
                              shape:WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              backgroundColor: WidgetStateProperty.all(AppColor.secondary2Color.withGreen(150))
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4,),
                    Tooltip(
                      message: "صدور فاکتور بدون مانده",
                      child: Center(
                        child:
                        OutlinedButton.icon(
                          onPressed: () async {
                            await controller.generateInvoiceForTransactionWithoutBalance(trans);
                          },
                          label: Text(
                            'فاکتور',
                            style: AppTextStyle
                                .labelText.copyWith(color: AppColor.textColor,fontSize: 11),
                          ),
                          style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.all(3)),
                              shape:WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              backgroundColor: WidgetStateProperty.all(AppColor.secondary2Color.withGreen(110))
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Center(
                child: Text(
                  "${trans.date?.toPersianDate(showTime: true) ?? 'نامشخص'} ",
                  style: AppTextStyle.bodyText
                      .copyWith(color: AppColor.textColor, fontSize: 10),textDirection: TextDirection.ltr,),
              )),
              // محصول
              DataCell(Center(
                child: Text(
                  "${trans.item?.name ?? 'نامشخص'} ",
                  style: AppTextStyle.bodyText
                      .copyWith(color: AppColor.secondary2Color, fontSize: 12,fontWeight: FontWeight.bold,),),
              )),
              // شرح
              DataCell(
                Center(
                  child: trans.details!.isEmpty
                      ?
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
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
                                      fontSize: 11),
                                ),
                                SelectableText(
                                  " ${trans.wallet?.account?.name ?? ""} ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 12,
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
                                      fontSize: 11),
                                ),
                                SelectableText(
                                  " ${trans.wallet?.account?.name ?? ""} ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.accentColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ) :
                        SizedBox(),
                        trans.toWallet?.account?.name != null && trans.type=='reciept' ?
                        Row(
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
                                  color: AppColor.accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ):
                            SelectableText(
                              " ${trans.wallet?.account?.name ?? ""} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.primaryColor,
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
                                  color: AppColor.primaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ):
                            SelectableText(
                              " ${trans.toWallet?.account?.name ?? ""} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ) :
                        trans.toWallet?.account?.name != null && trans.type == "issue" ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              " از : ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10),
                            ),
                            trans.type=='issue'?
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
                            SelectableText(
                              " به : ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10),
                            ),
                            trans.type=='issue'?
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
                          ],
                        )
                        : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              trans.item?.itemUnit?.id == 1
                                  ? " ${trans.amount?.toDisplayString()} "
                                  : trans.item?.itemUnit?.id == 2
                                  ? "${trans.amount?.toDisplayString()} "
                                  : (trans.amount ?? 0 ) < 0 ? "-${trans.amount?.abs().toDisplayString().seRagham()}" : "${trans.amount?.toDisplayString().seRagham()}",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: (trans.amount ?? 0 ) < 0 ? AppColor.accentColor : (trans.amount ?? 0 ) > 0 ? AppColor.primaryColor : AppColor.textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11),
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
                                "${trans.mesghalPrice?.toDisplayString() ?? 0}".seRagham() +
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
                                "${trans.totalPrice ?? 0}".toString().split('.').first.seRagham() +
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
                    ),
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
                                    "${e.laboratoryId ?? ""} ",
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
              // مقدار
              DataCell(Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      trans.item?.itemUnit?.id == 1
                          ? "${trans.amount?.toDisplayString()} "
                          : trans.item?.itemUnit?.id == 2 && (trans.amount ?? 0) < 0
                          ? "-${trans.amount?.abs().toDisplayString().seRagham()} " :
                      trans.item?.itemUnit?.id == 2 && (trans.amount ?? 0) > 0
                          ? "${trans.amount?.toDisplayString().seRagham()} "
                          :trans.item?.itemUnit?.id == 3 && (trans.amount ?? 0) < 0 ?
                      "-${trans.amount?.abs().toStringAsFixed(0).seRagham()} "
                          :trans.item?.itemUnit?.id == 3 && (trans.amount ?? 0) > 0 ?
                      "${trans.amount?.toStringAsFixed(0).seRagham()} "
                          : "${trans.amount?.toDisplayString().seRagham()} ",
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
              // بررسی
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
                              return CheckResult(
                                id: trans.id ?? 0,
                                isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.library_add_check,
                              size: 20,
                              color: AppColor.dividerColor,
                            ),
                            Text(' بررسی',
                              style: AppTextStyle
                                  .labelText
                                  .copyWith(
                                  color: AppColor.dividerColor, fontSize: 11,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
              // تصاویر
              DataCell(Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Center(
                  child:
                  GestureDetector(
                    onTap: () async{
                      await controller.getImage(
                        trans.recId ?? "",trans.type == "payment" || trans.type == "receive" ? "Inventory" : trans.type == "issue" || trans.type == "reciept" ? "Remittance" :
                      trans.type == "deposit" ? "Deposit" : "",
                      );
                      _showImageGallery(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColor.iconViewColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.iconViewColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/picture.svg',
                            height: 16,
                            colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "تصاویر",
                            style: AppTextStyle.labelText.copyWith(
                              color: AppColor.iconViewColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),

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
          );
    }
        )
        .toList();
  }

  void _showImageGallery(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 200), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColor.backGroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: AppColor.primaryColor,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'گالری تصاویر',
                        style: AppTextStyle.smallTitleText.copyWith(
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close, color: AppColor.textColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Image viewer
                  SizedBox(
                    width: 500,
                    height: 500,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: controller.pageController,
                          itemCount: controller.imageList.length,
                          onPageChanged: (index) =>
                          controller.currentImagePage.value = index,
                          itemBuilder: (context, index) {
                            final attachment = controller.imageList[index];
                            return Column(
                              children: [
                                if (kIsWeb)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 50),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.download, color: AppColor.dividerColor),
                                          onPressed: () => controller.downloadImage(attachment),
                                        ),
                                      ],
                                    ),
                                  ),
                                Expanded(
                                  child: Image.network(
                                    "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$attachment",
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.error, color: Colors.red),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        // Navigation arrows
                        Obx(() => Positioned(
                          left: 10,
                          top: 0,
                          bottom: 0,
                          child: Visibility(
                            visible: controller.currentImagePage.value > 0,
                            child: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black54),
                                shape: WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(EdgeInsets.all(8)),
                              ),
                              icon: Icon(Icons.chevron_left, color: Colors.white, size: 40),
                              onPressed: () {
                                controller.pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        )),

                        Obx(() => Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Visibility(
                            visible: controller.currentImagePage.value <
                                (controller.imageList.length - 1),
                            child: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black54),
                                shape: WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(EdgeInsets.all(8)),
                              ),
                              icon: Icon(Icons.chevron_right, color: Colors.white, size: 40),
                              onPressed: () {
                                controller.pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),

                  // Page indicators
                  SizedBox(height: 16),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.imageList.length,
                          (index) => Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentImagePage.value == index
                              ? AppColor.primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  )),

                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("بستن", style: AppTextStyle.bodyText),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildMobileTransactionCards(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    if (controller.transactionInfoList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: AppColor.textColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                controller.hasActiveFilters()
                    ? 'نتیجه فیلتر خالی است'
                    : 'هیچ تراکنشی یافت نشد',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 16,
                  color: AppColor.textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  controller.clearFilter();
                  controller.getTransactionInfoListPager(controller.id.value.toString());
                },
                child: Text(
                  'تلاش مجدد',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 16,
                    color: AppColor.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 10 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TransactionFilterWidget(
                controller: controller,
                onFilterApplied: () {
                  controller.getTransactionInfoListPager(controller.id.value.toString());
                },
                onFilterCleared: () {
                  controller.getTransactionInfoListPager(controller.id.value.toString());
                },
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Get.defaultDialog(
                      backgroundColor: AppColor.backGroundColor,
                      title: "برداشتن تیک چک باکس",
                      titleStyle: AppTextStyle.smallTitleText,
                      middleText: "آیا از برداشتن تیک همه چک باکس ها مطمئن هستید؟",
                      middleTextStyle: AppTextStyle.bodyText,
                      confirm: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColor.primaryColor)),
                          onPressed: () {
                            Get.back();
                            controller.removeCheckedAll(
                                controller.id.value , false);
                          },
                          child: Text(
                            'اعمال تغییر',
                            style: AppTextStyle.bodyText,
                          ))
                  );
                },
                label: Text(
                  'حذف چک باکس',
                  style: AppTextStyle
                      .labelText.copyWith(color: AppColor.textColorSecondary.withAlpha(200),fontSize: 12),
                ),
                icon: Icon(Icons.check_box_outline_blank,color: AppColor.textColor.withAlpha(30),),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 10 : 2),
          ListView.builder(
            itemCount: controller.transactionInfoList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              final trans = controller.transactionInfoList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: trans.checked == true
                      ? AppColor.backGroundColor.withAlpha(200)
                      : AppColor.secondaryColor.withAlpha(200),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF64748B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${trans.rowNum ?? 0}",
                              style: AppTextStyle.bodyText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Checkbox(
                              value: trans.checked ?? false,
                              onChanged: (value) async {
                                if (value != null) {
                                  await controller.updateChecked(
                                    trans.id ?? 0,
                                    value,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        Text(
                          "${trans.date?.toPersianDate(showTime: true) ?? 'نامشخص'}",
                          style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontSize: 12,
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                        _buildTransactionTypeChip(trans.type),
                      ],
                    ),
                    Divider(color: AppColor.iconViewColor,height: 0.5,),
                    const SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColor.dividerColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              trans.item?.name ?? 'نامشخص',
                              style: AppTextStyle.bodyText.copyWith(
                                color: AppColor.secondary2Color,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Amount row (mirrors table logic)
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  _formatAmountValue(trans),
                                  style: AppTextStyle.bodyText.copyWith(
                                    color: (trans.amount ?? 0) > 0 ? AppColor.primaryColor : AppColor.accentColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _unitName(trans),
                                  style: AppTextStyle.bodyText.copyWith(
                                    color: (trans.amount ?? 0) > 0 ? AppColor.primaryColor : AppColor.accentColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildMobileDescriptionSection(trans),
                    const SizedBox(height: 8),
                    // Actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // صدور فاکتور (موبایل)
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.generateInvoiceForTransactionWithoutBalance(trans);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColor.secondary2Color.withAlpha(45),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColor.secondary2Color.withAlpha(100)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.receipt_long, size: 18, color: AppColor.secondary2Color),
                                          SizedBox(width: 6),
                                          Text(
                                            "فاکتور",
                                            style: AppTextStyle.labelText.copyWith(
                                              color: AppColor.secondary2Color,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.generateInvoiceForTransaction(trans);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColor.secondary2Color.withAlpha(25),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColor.secondary2Color.withAlpha(75)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.receipt_long, size: 18, color: AppColor.secondary2Color),
                                          SizedBox(width: 6),
                                          Text(
                                            "فاکتور با مانده",
                                            style: AppTextStyle.labelText.copyWith(
                                              color: AppColor.secondary2Color,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3,),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.getImage(
                                        trans.recId ?? "",
                                        trans.type == "payment" || trans.type == "receive"
                                            ? "Inventory"
                                            : trans.type == "issue" || trans.type == "reciept"
                                            ? "Remittance"
                                            : trans.type == "deposit"
                                            ? "Deposit"
                                            : "",
                                      );
                                      _showImageGallery(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColor.iconViewColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColor.iconViewColor.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/picture.svg',
                                            height: 16,
                                            colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "تصاویر",
                                            style: AppTextStyle.labelText.copyWith(
                                              color: AppColor.iconViewColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // مانده
                                  GestureDetector(
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
                                          size: 25,
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
                                  // بررسی
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CheckResult(
                                            id: trans.id ?? 0,
                                            isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.library_add_check,
                                          size: 25,
                                          color: AppColor.dividerColor,
                                        ),
                                        Text(' بررسی',
                                          style: AppTextStyle
                                              .labelText
                                              .copyWith(
                                              color: AppColor.dividerColor, fontSize: 11,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          /*OutlinedButton(
                            onPressed: () async {
                              switch (trans.type) {
                                case "issue":
                                case "reciept":
                                  Get.snackbar(
                                    'اطلاعات',
                                    'عملیات پرداختی از این طریق امکان‌پذیر نیست',
                                    titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                                    messageText: Text('عملیات پرداختی از این طریق امکان‌پذیر نیست', style: TextStyle(color: AppColor.textColor)),
                                  );
                                  break;
                                case "receive":
                                  Get.snackbar(
                                    'اطلاعات',
                                    'عملیات دریافتی از این طریق امکان‌پذیر نیست',
                                    titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                                    messageText: Text('عملیات دریافتی از این طریق امکان‌پذیر نیست', style: TextStyle(color: AppColor.textColor)),
                                  );
                                  break;
                                case "payment":
                                  Get.snackbar(
                                    'اطلاعات',
                                    'عملیات پرداختی از این طریق امکان‌پذیر نیست',
                                    titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                                    messageText: Text('عملیات پرداختی از این طریق امکان‌پذیر نیست', style: TextStyle(color: AppColor.textColor)),
                                  );
                                  break;
                                case "sell":
                                case "buy":
                                  Get.toNamed('/orderUpdate', parameters: {"id": trans.recordId.toString()})?.then((_) {
                                    controller.getTransactionInfoListPager(controller.id.value.toString());
                                    controller.getBalanceList(controller.id.value);
                                    controller.getHeaderTransaction(controller.id.value);
                                  });
                                  break;
                                case "deposit":
                                  Get.toNamed('/depositUpdate', parameters: {"id": trans.recordId.toString()})?.then((_) {
                                    controller.getTransactionInfoListPager(controller.id.value.toString());
                                    controller.getBalanceList(controller.id.value);
                                    controller.getHeaderTransaction(controller.id.value);
                                  });
                                  break;
                                case "withdraw":
                                  Get.toNamed('/depositUpdate', parameters: {"id": trans.recordId.toString()})?.then((_) {
                                    controller.getTransactionInfoListPager(controller.id.value.toString());
                                    controller.getBalanceList(controller.id.value);
                                    controller.getHeaderTransaction(controller.id.value);
                                  });
                                  break;
                                case "toTransfer":
                                case "fromTransfer":
                                  Get.snackbar(
                                    'اطلاعات',
                                    'عملیات انتقال ولت - ویرایش از این طریق امکان‌پذیر نیست',
                                    titleText: Text('اطلاعات', style: TextStyle(color: AppColor.textColor)),
                                    messageText: Text('عملیات انتقال ولت - ویرایش از این طریق امکان‌پذیر نیست', style: TextStyle(color: AppColor.textColor)),
                                  );
                                  break;
                                default:
                                  Get.snackbar(
                                    'خطا',
                                    'نوع تراکنش نامعتبر است',
                                    titleText: Text('خطا', style: TextStyle(color: AppColor.accentColor)),
                                    messageText: Text('نوع تراکنش نامعتبر است', style: TextStyle(color: AppColor.accentColor)),
                                  );
                                  break;
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/edit.svg',
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Obx(() {
            if (controller.isLoading.value && controller.transactionInfoList.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!controller.hasMore.value && controller.transactionInfoList.isNotEmpty) {
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

  Widget _buildTransactionTypeChip(String? type) {
    String typeText = '';
    Color chipColor = AppColor.textColor;

    switch (type) {
      case 'issue':
        typeText = 'حواله دریافتی';
        chipColor = const Color(0xFF3B82F6);
        break;
      case 'receive':
        typeText = 'دریافت';
        chipColor = const Color(0xFF10B981);
        break;
      case 'payment':
        typeText = 'پرداخت';
        chipColor = const Color(0xFFEF4444);
        break;
      case 'sell':
        typeText = 'فروش';
        chipColor = const Color(0xFFF59E0B);
        break;
      case 'buy':
        typeText = 'خرید';
        chipColor = const Color(0xFF10B981);
        break;
      case 'deposit':
        typeText = 'واریز';
        chipColor = const Color(0xFF8B5CF6);
        break;
      case 'withdraw':
        typeText = 'برداشت';
        chipColor = const Color(0xFFEF4444);
        break;
      case 'reciept':
        typeText = 'حواله پرداختی';
        chipColor = const Color(0xFF3B82F6);
        break;
      case 'toTransfer':
      case 'fromTransfer':
        typeText = 'انتقال ولت';
        chipColor = const Color(0xFF64748B);
        break;
      default:
        typeText = '';
        chipColor = AppColor.textColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        typeText,
        style: AppTextStyle.bodyText.copyWith(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _unitName(dynamic trans) {
    final id = trans.item?.itemUnit?.id;
    if (id == 1) return " عدد ";
    if (id == 2) return " گرم ";
    if (id == 4) return "دلار";
    if (id == 5) return "یورو";
    return " ریال ";
  }

  String _formatAmountValue(dynamic trans) {
    final unitId = trans.item?.itemUnit?.id;
    final amt = trans.amount ?? 0;
    if (unitId == 1) {
      return amt.toString();
    } else if (unitId == 2) {
      if (amt < 0) return "-${amt.abs().toString().seRagham()} ";
      if (amt > 0) return "${amt.toString().seRagham()} ";
    } else if (unitId == 3) {
      if (amt < 0) return "-${amt.abs().toString().seRagham()} ";
      if (amt > 0) return "${amt.toString().seRagham()} ";
    }
    return "${amt.toString().seRagham()} ";
  }

  Widget _buildMobileDescriptionSection(dynamic trans) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.textFieldColor.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF64748B)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // If details are empty, show high-level description rows
          if ((trans.details == null) || trans.details!.isEmpty) ...[
            if (trans.type == "fromTransfer")
              Row(
                children: [
                  SelectableText(
                    " از ولت ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 12),
                  ),
                  SelectableText(
                    " ${trans.wallet?.account?.name ?? ""} ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (trans.type == "toTransfer")
              Row(
                children: [
                  SelectableText(
                    " به ولت ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 12),
                  ),
                  SelectableText(
                    " ${trans.wallet?.account?.name ?? ""} ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (trans.toWallet?.account?.name != null && trans.type == 'reciept')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(" از : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.toWallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  SelectableText(" به : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.wallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            if (trans.toWallet?.account?.name != null && trans.type == 'issue')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(" از : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.wallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  SelectableText(" به : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.toWallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(
                  trans.item?.itemUnit?.id == 1
                      ? " ${trans.amount} "
                      : trans.item?.itemUnit?.id == 2
                      ? "${trans.amount} "
                      : trans.amount <0 ? "-${trans.amount.abs().toString().seRagham()}" : "${trans.amount.toString().seRagham()}",
                  style: AppTextStyle.bodyText.copyWith(color: trans.amount < 0 ? AppColor.accentColor : trans.amount > 0 ? AppColor.primaryColor : AppColor.textColor, fontWeight: FontWeight.w700, fontSize: 12),
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
                  style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontWeight: FontWeight.w700, fontSize: 10),
                ),
                const SizedBox(width: 5),
                SelectableText(
                  trans.item?.name ?? 'نامشخص',
                  style: AppTextStyle.bodyText.copyWith(color: AppColor.secondary2Color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (trans.price != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText('به مظنه :  ', style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor, fontWeight: FontWeight.w700, fontSize: 10)),
                  SelectableText("${trans.mesghalPrice ?? 0}".toString().split('.').first.seRagham() + "  ریال  ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            const SizedBox(height: 6),
            if (trans.totalPrice != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(' قیمت کل :  ', style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor, fontWeight: FontWeight.normal, fontSize: 10)),
                  SelectableText("${trans.totalPrice ?? 0}".toString().split('.').first.seRagham() + "  ریال  ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontWeight: FontWeight.normal, fontSize: 12)),
                ],
              ),
            Container(height: 0.6, color: AppColor.textColor, margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
            if (trans.description != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText('توضیحات : ', style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor, fontWeight: FontWeight.w700, fontSize: 10)),
                  Flexible(child: SelectableText(trans.description ?? 'نامشخص', style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor, fontWeight: FontWeight.w600, fontSize: 11))),
                ],
              ),
          ] else ...[
            // If details exist, render detail cards similar to desktop
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: trans.details.map<Widget>((e) => Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColor.secondary3Color.withAlpha(120),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(children: [
                        SelectableText("وزن ترازو : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.weight ?? 0} گرم ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("عیار : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.carat ?? 0} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("وزن : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.quantity ?? 0} گرم ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("ناخالصی : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.impurity ?? 0} گرم ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                    ]),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(children: [
                        SelectableText("آزمایشگاه : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.laboratoryName ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("شماره آزمایشگاه : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.laboratoryId ?? 0} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                    ]),
                  ],
                ),
              ))
                  .toList(),
            ),
          ]
        ],
      ),
    );
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


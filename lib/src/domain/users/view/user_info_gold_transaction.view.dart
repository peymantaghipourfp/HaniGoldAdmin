
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_info_detail_gold_transaction.controller.dart';
import 'package:hanigold_admin/src/domain/users/widgets/balance_user.widget.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
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
import '../../chat/widget/chat_dialog.widget.dart';
import '../widgets/gold_transaction_filter.widget.dart';
import '../widgets/tabel_info.widget.dart';

import 'package:flutter/services.dart';

class UserInfoGoldTransactionView extends StatefulWidget {
  const UserInfoGoldTransactionView({super.key});

  @override
  State<UserInfoGoldTransactionView> createState() => _UserInfoGoldTransactionViewState();
}

class _UserInfoGoldTransactionViewState extends State<UserInfoGoldTransactionView> {
  final UserInfoDetailGoldTransactionController controller=Get.find<UserInfoDetailGoldTransactionController>();
  final GlobalKey _balanceKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'جزییات تراکنش کاربر طلا',
        //onBackTap: () => Get.offNamed("/listUserInfoGoldTransaction"),
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
                                height: 10,width: 10,
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
                                                            controller.getGoldExcel();
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
                                                            controller.exportGetGoldPdf(controller.id.value.toString());
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
                                  SizedBox(width: 5,),
                                ],
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
                                list: controller.headerInfoUserTransactionModel?.inventorys??[],
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
                                    .headerInfoUserTransactionModel?.orders??[],
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
                                    .headerInfoUserTransactionModel?.remmitances??[],
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
                                                                  controller.getGoldExcel();
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
                                                                  controller.exportGetGoldPdf(controller.id.value.toString());
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
                                    /*Row(
                                      children: [
                                        Row(
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
                                        ),
                                        Row(
                                          children: [
                                            Container(
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
                                            ),
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
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
                                MainAxisAlignment.spaceBetween,
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
                                                Row(mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Container(
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
                                      list: controller
                                          .headerInfoUserTransactionModel?.inventorys ?? [],
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
                                          .headerInfoUserTransactionModel?.orders ?? [],
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
                                      .headerInfoUserTransactionModel?.remmitances ?? [],
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
                    controller.transactionInfoGoldList.isEmpty
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
                                controller.getTransactionInfoGoldListPager(controller.id.value.toString());
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
                        :
                    isDesktop ?
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
                                  // فیلتر
                                  Row(
                                    children: [
                                      GoldTransactionFilterWidget(
                                        controller: controller,
                                        onFilterApplied: () {
                                          controller.getTransactionInfoGoldListPager(controller.id.value.toString());
                                        },
                                        onFilterCleared: () {
                                          controller.getTransactionInfoGoldListPager(controller.id.value.toString());
                                        },

                                      ),
                                      SizedBox(width: 20,),
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
                                    rows: buildDataRows(
                                        context),
                                    dataRowMaxHeight: double.infinity,
                                    //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                    headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                    headingRowHeight: 30,
                                    columnSpacing: 12,
                                    horizontalMargin: 0,
                                  ),
                                  SizedBox(height: 50,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) :
                         _buildMobileTransactionCards(context),
                  ],
                ),
              ),
            )
                :
            ErrPage(
              callback: () {
                controller.getTransactionInfoGoldListPager(controller.id.value.toString());
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
          label: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 80),
                child: Text('ردیف',
                    style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('فاکتور',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('ساعت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            controller.setSort(columnIndex,ascending);

            controller.onSortColum(columnIndex, ascending);
          },
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('تاریخ',
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
              child: Text('شرح',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100),
                child: Text('وزن یا تعداد',
                    style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('طلا بدهکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.accentColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('طلا بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.primaryColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده طلایی',
                    style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.dividerColor,fontWeight: FontWeight.bold)),
              ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Text('تمام سکه بانکی بدهکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.accentColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Text('تمام سکه بانکی بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.primaryColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110),
              child: Text('مانده تمام سکه بانکی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.dividerColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('نیم / ربع بدهکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.accentColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('نیم / ربع بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.primaryColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده نیم / ربع',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.dividerColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('ریال بدهکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.accentColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('ریال بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.primaryColor,fontWeight: FontWeight.bold))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100),
                child: Text('مانده ریالی',
                    style: AppTextStyle.labelText.copyWith(fontSize: 11,color: AppColor.dividerColor,fontWeight: FontWeight.bold))),
          ),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('تصاویر',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/

    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.transactionInfoGoldList.asMap().entries.map((entry) {
      final index = entry.key;
      final trans = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: trans.checked==true ? WidgetStateProperty.all(AppColor.appBarColor.withAlpha(150)) : WidgetStateProperty.all(rowColor),
        cells: [
          // ردیف
          DataCell(Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  // رجیستر
                  Checkbox(
                    value: trans.checked ?? false,
                    onChanged: (value) async{
                      if (value != null) {
                        //EasyLoading.show(status: 'لطفا منتظر بمانید');
                        await controller.updateGoldChecked(
                            trans.id ?? 0,
                            value
                        );
                      }
                    },
                  ),
                  SizedBox(width: 5,),
                  SelectableText(
                    "${trans.rowNum ?? 0}",
                    style: AppTextStyle.bodyText,
                  ),
                ],
              ),
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
                        await controller.generateInvoiceForGoldTransaction(trans);
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
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await controller.generateInvoiceForGoldTransactionWithoutBalance(trans);
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
          // ساعت
          DataCell(Center(
            child: SelectableText(
              trans.date != null
                  ? "${trans.date!.hour.toString().padLeft(2, '0')}:${trans.date!.minute.toString().padLeft(2, '0')}:${trans.date!.second.toString().padLeft(2, '0')}"
                  : "نامشخص",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),textDirection: TextDirection.ltr,),
          )),
          // تاریخ
          DataCell(Center(
            child: SelectableText(
              "${trans.date?.toPersianDate() ?? 'نامشخص'} ",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),textDirection: TextDirection.ltr,),
          )),
          // عملیات
          DataCell(
            Center(
              child:
              Text(
                trans.type == "issue"
                    ? ' حواله دریافتی '
                    : trans.type == "receive"
                    ? ' دریافت '
                    : trans.type == "payment"
                    ? ' پرداخت '
                    : trans.type == "sell"
                    ? ' فروش '
                    : trans.type == "buy"
                    ? ' خرید '
                    : trans.type == "deposit"
                    ? ' واریز '
                    : trans.type == "withdraw"
                    ? ' برداشت '
                    : trans.type == "reciept"
                    ? ' حواله پرداختی '
                    : trans.type == "initial"
                    ? ' اول دوره '
                    : "",
                style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // شرح
          DataCell(
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: 3),
                child: Center(
                  child:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        trans.type=="initial" ?
                        Row(
                          children: [
                            SelectableText(
                              " ${trans.item?.name ?? ""} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.secondary3Color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ):SizedBox.shrink(),
                        trans.type=="sell" || trans.type=="buy" ?
                        Row(
                          children: [
                            SelectableText(
                              " ${trans.item?.name ?? ""} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.secondary3Color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5,),
                            trans.item?.itemUnit?.id==2 ?
                            SelectableText(
                              " وزن: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ): trans.item?.itemUnit?.id==1 ?
                            SelectableText(
                              " تعداد: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ):
                            SelectableText(
                              " مقدار: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            SelectableText(textDirection: TextDirection.ltr,
                              "${trans.amount?.toDisplayString() ?? ""}",
                              style: AppTextStyle.bodyText.copyWith(
                                  color:trans.amount!>0 ? AppColor.primaryColor :trans.amount!<0 ?AppColor.accentColor:AppColor.textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SelectableText(
                              "${trans.item?.itemUnit?.name}",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: trans.amount!>0 ? AppColor.primaryColor :trans.amount!<0 ?AppColor.accentColor:AppColor.textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5,),
                            SelectableText(
                              " قیمت: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            SelectableText(textDirection: TextDirection.ltr,
                              trans.mesghalPrice?.toStringAsFixed(0).seRagham(separator: ',') ?? "",
                              style: AppTextStyle.bodyText.copyWith(
                                color: AppColor.dividerColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ):SizedBox.shrink(),
                        trans.type=="receive" || trans.type=="payment" ?
                        Row(
                          children: [
                            SelectableText(
                              " ${trans.item?.name ?? ""} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.secondary3Color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5,),
                            trans.item?.itemUnit?.id==2 ?
                            Row(
                              children: [
                                SelectableText(
                                  " وزن: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  "${trans.detail?.weight ?? ""}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ): trans.item?.itemUnit?.id==1 ?
                            Row(
                              children: [
                                SelectableText(
                                  " تعداد: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(textDirection: TextDirection.ltr,
                                  "${trans.amount?.toDisplayString() ?? " "}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:trans.amount!>0 ? AppColor.primaryColor : trans.amount!<0 ? AppColor.accentColor :AppColor.textColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ):
                            Row(
                              children: [
                                SelectableText(
                                  " مقدار: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  trans.amount?.toStringAsFixed(0).seRagham() ?? "",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            trans.item?.id==1 || trans.item?.id==10 ||trans.item?.id==12 ||trans.item?.id==13 ||trans.item?.id==14 ||trans.item?.id==15 ||trans.item?.id==16?
                            Row(
                              children: [
                                SelectableText(
                                  " عیار: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  "${trans.detail?.carat ?? ""}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ) : SizedBox.shrink(),
                            SizedBox(width: 5,),
                            trans.item?.id==1 ?
                            Row(
                              children: [
                                SelectableText(
                                  " آز: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(textDirection: TextDirection.ltr,
                                  "${trans.detail?.name ?? ""}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ) : SizedBox.shrink(),
                            SizedBox(width: 5,),
                            trans.item?.id==1 ?
                            Row(
                              children: [
                                SelectableText(
                                  " ش ق: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(textDirection: TextDirection.ltr,
                                  trans.detail?.receiptNumber ?? "",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ) : SizedBox.shrink(),
                          ],
                        ):SizedBox.shrink(),
                        trans.type=="issue" ?
                        Row(
                          children: [
                            Row(
                              children: [
                                SelectableText(
                                  " از: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  "${trans.account?.name ?? ""}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.accentColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Row(
                              children: [
                                SelectableText(
                                  " به: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  trans.toAccount.name ?? "",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            SelectableText(
                              " ${trans.item?.name ?? ""} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.secondary3Color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5,),
                            trans.item?.itemUnit?.id==2 ?
                            SelectableText(
                              " وزن: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ): trans.item?.itemUnit?.id==1 ?
                            SelectableText(
                              " تعداد: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ):
                            SelectableText(
                              " مقدار: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            SelectableText(textDirection: TextDirection.ltr,
                              "-${trans.amount?.abs().toDisplayString().seRagham() ?? ""}",
                              style: AppTextStyle.bodyText.copyWith(
                                  color:trans.amount!>0 ? AppColor.primaryColor :trans.amount!<0 ?AppColor.accentColor:AppColor.textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SelectableText(
                              "${trans.item?.itemUnit?.name}",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: trans.amount!>0 ? AppColor.primaryColor :trans.amount!<0 ?AppColor.accentColor:AppColor.textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ):SizedBox.shrink(),
                        trans.type=="reciept" ?
                        Row(
                          children: [
                            Row(
                              children: [
                                SelectableText(
                                  " از: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  trans.toAccount.name ?? "",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.accentColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Row(
                              children: [
                                SelectableText(
                                  " به: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  "${trans.account?.name ?? ""}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            SelectableText(
                              " ${trans.item?.name ?? ""} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.secondary3Color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5,),
                            trans.item?.itemUnit?.id==2 ?
                            SelectableText(
                              " وزن: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ): trans.item?.itemUnit?.id==1 ?
                            SelectableText(
                              " تعداد: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ):
                            SelectableText(
                              " مقدار: ",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            SelectableText(textDirection: TextDirection.ltr,
                              "${trans.amount?.toDisplayString().seRagham() ?? ""}",
                              style: AppTextStyle.bodyText.copyWith(
                                  color:trans.amount!>0 ? AppColor.primaryColor :trans.amount!<0 ?AppColor.accentColor:AppColor.textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            SelectableText(
                              "${trans.item?.itemUnit?.name}",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: trans.amount!>0 ? AppColor.primaryColor :trans.amount!<0 ?AppColor.accentColor:AppColor.textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ):SizedBox.shrink(),
                        trans.type=="deposit" ?
                        Row(
                          children: [
                            Row(
                              children: [
                                SelectableText(
                                  " مبلغ: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  "${trans.amount?.toStringAsFixed(0).seRagham() ?? ""}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  " ریال ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Row(
                              children: [
                                SelectableText(
                                  "(${trans.description ?? ""})",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Row(
                              children: [
                                SelectableText(
                                  " ش پ: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  trans.trackingNumber ?? "",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ):SizedBox.shrink(),
                        trans.type=="withdraw" ?
                        Row(
                          children: [
                            Row(
                              children: [
                                SelectableText(
                                  " مبلغ: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(textDirection: TextDirection.ltr,
                                  "-${trans.amount?.abs().toStringAsFixed(0).seRagham() ?? ""}",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.accentColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  " ریال ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Row(
                              children: [
                                SelectableText(
                                  "(${trans.description ?? ""})",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Row(
                              children: [
                                SelectableText(
                                  " ش پ: ",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  trans.trackingNumber ?? "",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color:AppColor.dividerColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ):SizedBox.shrink(),
                        /*Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: trans.detail!
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
              ),*/
                      ]
                  ),
                ),
              ),
            ),
          ),
          // مقدار
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.item?.id==6 ?
                  SizedBox.shrink() :
                  SelectableText(
                    trans.item?.itemUnit?.id == 1 && trans.amount!>0
                        ? "${trans.amount?.toStringAsFixed(0).seRagham()}" :
                    trans.item?.itemUnit?.id == 1 && trans.amount!<0 ?
                    "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})"
                        : trans.item?.itemUnit?.id == 2 && trans.amount!>0
                        ? "${trans.amount?.toDisplayString().seRagham()} "
                        :trans.item?.itemUnit?.id == 2 && trans.amount!<0 ?
                    "(-${trans.amount?.abs().toDisplayString().seRagham()})"
                        :trans.item?.itemUnit?.id == 3 && trans.amount!>0 ?
                    "${trans.amount?.toStringAsFixed(0).seRagham()} " :
                    trans.item?.itemUnit?.id == 3 && trans.amount!<0 ?
                    "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})"
                        :"${trans.amount?.toStringAsFixed(2).seRagham()} ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.amount!>0 ? AppColor.primaryColor :AppColor.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  ),
                  /*Text(
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
                ),*/
                ],
              ),
            ),
          ),
          // طلا بدهکار
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.item?.itemUnit?.id==2 ?
                  SelectableText(
                    trans.item?.itemUnit?.id == 2 && trans.amount!<0
                        ? "(-${trans.amount?.abs().toStringAsFixed(3).seRagham()})" :
                    "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.amount!<0 ? AppColor.accentColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  ): SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // طلا بستانکار
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.item?.itemUnit?.id==2 ?
                  SelectableText(
                    trans.item?.itemUnit?.id == 2 && trans.amount!>0
                        ? "${trans.amount?.toStringAsFixed(3).seRagham()}" :
                    "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.amount!>0 ? AppColor.primaryColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  ): SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // مانده طلایی
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    trans.goldTotalRunning!<0
                        ? "(-${trans.goldTotalRunning?.abs().toStringAsFixed(3).seRagham()})" :
                    trans.goldTotalRunning!>0 ?
                    "${trans.goldTotalRunning?.toStringAsFixed(3).seRagham()}" : "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.goldTotalRunning!>0 ? AppColor.primaryColor : trans.goldTotalRunning!<0 ? AppColor.accentColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  )
                ],
              ),
            ),
          ),
          // تمام سکه بدهکار
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.item?.id==2 ?
                  SelectableText(
                    trans.item?.id == 2 && trans.amount!<0
                        ? "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})" :
                    "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.amount!<0 ? AppColor.accentColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  ): SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // تمام سکه بستانکار
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.item?.id==2 ?
                  SelectableText(
                    trans.item?.id == 2 && trans.amount!>0
                        ? "${trans.amount?.toStringAsFixed(0).seRagham()}" :
                    "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.amount!>0 ? AppColor.primaryColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  ): SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // مانده تمام سکه
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SelectableText(
                    trans.coinTotalRunning!<0
                        ? "(-${trans.coinTotalRunning?.abs().toStringAsFixed(0).seRagham()})" :
                    trans.coinTotalRunning!>0 ?
                    "${trans.coinTotalRunning?.toStringAsFixed(0).seRagham()}": "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.coinTotalRunning!>0 ? AppColor.primaryColor : trans.coinTotalRunning!<0 ? AppColor.accentColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
          ),
          // نیم ربع بدهکار
          DataCell(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    trans.item?.id==3 ?
                    SelectableText(
                      trans.item?.id == 3 && trans.amount!<0
                          ? "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})نیم " :
                      "",
                      style: AppTextStyle.bodyText.copyWith(
                          color: trans.amount!<0 ? AppColor.accentColor :AppColor.textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ): SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: 2,),
                (trans.item?.id == 3 || trans.item?.id == 4) && trans.amount!=null ?
                RotatedBox(quarterTurns: 1,
                    child: Divider(color: AppColor.dividerColor,height: 1,)): SizedBox.shrink(),
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    trans.item?.id==4 ?
                    SelectableText(
                      trans.item?.id == 4 && trans.amount!<0
                          ? "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})ربع " :
                      "",
                      style: AppTextStyle.bodyText.copyWith(
                          color: trans.amount!<0 ? AppColor.accentColor :AppColor.textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ): SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          // نیم ربع بستانکار
          DataCell(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    trans.item?.id==3 ?
                    SelectableText(
                      trans.item?.id == 3 && trans.amount!>0
                          ? "${trans.amount?.toStringAsFixed(0).seRagham()} نیم " :
                      "",
                      style: AppTextStyle.bodyText.copyWith(
                          color: trans.amount!>0 ? AppColor.primaryColor :AppColor.textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ): SizedBox.shrink(),
                  ],
                ),
                SizedBox(width: 2,),
                (trans.item?.id == 3 || trans.item?.id == 4) && trans.amount!=null ?
                RotatedBox(quarterTurns: 1,
                    child: Divider(color: AppColor.dividerColor,height: 1,)): SizedBox.shrink(),
                SizedBox(width: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    trans.item?.id==4 ?
                    SelectableText(
                      trans.item?.id == 4 && trans.amount!>0
                          ? "${trans.amount?.toStringAsFixed(0).seRagham()} ربع " :
                      "",
                      style: AppTextStyle.bodyText.copyWith(
                          color: trans.amount!>0 ? AppColor.primaryColor :AppColor.textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ): SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          // مانده نیم ربع
          DataCell(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      trans.halfCoinTotalRunning!<0
                          ? "(-${trans.halfCoinTotalRunning?.abs().toStringAsFixed(0).seRagham()})نیم " :
                      trans.halfCoinTotalRunning!>0 ?
                      "${trans.halfCoinTotalRunning?.toStringAsFixed(0).seRagham()} نیم " : "",
                      style: AppTextStyle.bodyText.copyWith(
                          color: trans.halfCoinTotalRunning!>0 ? AppColor.primaryColor : trans.halfCoinTotalRunning!<0 ? AppColor.accentColor :AppColor.textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
                SizedBox(width: 2,),
                trans.halfCoinTotalRunning!=null || trans.quarterCoinTotalRunning!=null ?
                RotatedBox(quarterTurns: 1,
                    child: Divider(color: AppColor.dividerColor,height: 1,)): SizedBox.shrink(),
                SizedBox(width: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      trans.quarterCoinTotalRunning!<0
                          ? "(-${trans.quarterCoinTotalRunning?.abs().toStringAsFixed(0).seRagham()}) ربع " :
                      trans.quarterCoinTotalRunning!>0 ?
                      "${trans.quarterCoinTotalRunning?.toStringAsFixed(0).seRagham()} ربع ":"",
                      style: AppTextStyle.bodyText.copyWith(
                          color: trans.quarterCoinTotalRunning!>0 ? AppColor.primaryColor : trans.quarterCoinTotalRunning!<0 ? AppColor.accentColor :AppColor.textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ریال بدهکار
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.item?.id==6 ?
                  SelectableText(
                    trans.item?.id == 6 && trans.amount!<0
                        ? "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})" :
                    "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.amount!<0 ? AppColor.accentColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  )
                      :trans.type=="sell" ?
                  SelectableText(
                    "(-${trans.totalPrice?.abs().toStringAsFixed(0).seRagham()})",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.type=="sell" ? AppColor.accentColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // ریال بستانکار
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  trans.item?.id==6 ?
                  SelectableText(
                    trans.item?.id == 6 && trans.amount!>0
                        ? "${trans.amount?.toStringAsFixed(0).seRagham()}" :
                    "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.amount!>0 ? AppColor.primaryColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  )
                      :trans.type=="buy" ?
                  SelectableText(
                    "${trans.totalPrice?.toStringAsFixed(0).seRagham()}",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.type=="buy" ? AppColor.primaryColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // ریال طلایی
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    trans.cashTotalRunning!<0
                        ? "(-${trans.cashTotalRunning?.abs().toStringAsFixed(0).seRagham()})" :
                    trans.cashTotalRunning!>0 ?
                    "${trans.cashTotalRunning?.toStringAsFixed(0).seRagham()}":"",
                    style: AppTextStyle.bodyText.copyWith(
                        color: trans.cashTotalRunning!>0 ? AppColor.primaryColor : trans.cashTotalRunning!<0 ? AppColor.accentColor :AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  )
                ],
              ),
            ),
          ),
          // مانده
          /*DataCell(
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
        ),*/
          // تصاویر
          /*DataCell(Padding(
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
        )),*/


        ],
      );
    }).toList();
  }

  /*void _showImageGallery(BuildContext context) {
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
  }*/

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

    Widget _buildMobileTransactionCards(BuildContext context) {
    if (controller.transactionInfoGoldList.isEmpty) {
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
                'هیچ تراکنشی یافت نشد',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 16,
                  color: AppColor.textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      child: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // فیلتر
          Row(
            children: [
              GoldTransactionFilterWidget(
                controller: controller,
                onFilterApplied: () {
                  controller.getTransactionInfoGoldListPager(controller.id.value.toString());
                },
                onFilterCleared: () {
                  controller.getTransactionInfoGoldListPager(controller.id.value.toString());
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
              SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 2),
          ListView.builder(
            itemCount: controller.transactionInfoGoldList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder:(ctx, index) {
              final trans = controller.transactionInfoGoldList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(top: 2,right: 15,left: 15,bottom: 12),
                decoration: BoxDecoration(
                  color: trans.checked == true
                      ? AppColor.backGroundColor.withAlpha(180)
                      : AppColor.secondaryColor.withAlpha(180),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF64748B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with checkbox and row number
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
                                  await controller.updateGoldChecked(
                                      trans.id ?? 0,
                                      value
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMobileCardItem(
                              'تاریخ: ',
                              trans.date?.toPersianDate() ?? 'نامشخص',
                              AppColor.textColor,
                            ),
                            SizedBox(width: 10,),
                            _buildMobileCardItem(
                              'ساعت: ',
                              trans.date != null
                                  ? "${trans.date!.hour.toString().padLeft(2, '0')}:${trans.date!.minute.toString().padLeft(2, '0')}:${trans.date!.second.toString().padLeft(2, '0')}"
                                  : "نامشخص",
                              AppColor.textColor,
                            ),
                          ],
                        ),
                        _buildTransactionTypeChip(trans.type),
                      ],
                    ),
                    Divider(color: AppColor.iconViewColor,height: 0.5,),
                    const SizedBox(height: 5),
                    // Transaction details based on type
                    trans.type=="receive" || trans.type=="payment" ?
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColor.textFieldColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "مقدار: ",
                            style:  AppTextStyle.bodyText,
                          ),
                          Text(
                            trans.item?.itemUnit?.id == 1 && trans.amount!>0
                                ? "${trans.amount?.toStringAsFixed(0).seRagham()}" :
                            trans.item?.itemUnit?.id == 1 && trans.amount!<0 ?
                            "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})"
                                : trans.item?.itemUnit?.id == 2 && trans.amount!>0
                                ? "${trans.amount?.toDisplayString().seRagham()} "
                                :trans.item?.itemUnit?.id == 2 && trans.amount!<0 ?
                            "(-${trans.amount?.abs().toDisplayString().seRagham()})"
                                :trans.item?.itemUnit?.id == 3 && trans.amount!>0 ?
                            "${trans.amount?.toStringAsFixed(0).seRagham()} " :
                            trans.item?.itemUnit?.id == 3 && trans.amount!<0 ?
                            "(-${trans.amount?.abs().toStringAsFixed(0).seRagham()})"
                                :"${trans.amount?.toStringAsFixed(2).seRagham()} ",
                            style: AppTextStyle.bodyText.copyWith(
                                color: trans.amount!>0 ? AppColor.primaryColor :AppColor.accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ):
                        SizedBox.shrink(),
                    _buildTransactionDetails(trans),
                    // Actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await controller.generateInvoiceForGoldTransaction(trans);
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
                          SizedBox(width: 4,),
                          GestureDetector(
                            onTap: () async {
                              await controller.generateInvoiceForGoldTransactionWithoutBalance(trans);
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
                        ],
                      ),
                    ),
                    // Description if available
                    if (trans.description != null && trans.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _buildMobileCardItem(
                          'توضیحات: ',
                          trans.description ?? "",
                          AppColor.dividerColor,
                        ),
                      ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColor.secondary3Color.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.textColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(trans.item?.itemUnit?.id == 2 && (trans.amount ?? 0) != 0)
                              Row(
                                children: [
                                  trans.item?.itemUnit?.id == 2 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) < 0 ?
                                  _buildMobileCardItemTotal( AppColor.textAccentColor,"طلا بدهکار: ",
                                      "(-${trans.amount!.abs().toString().seRagham()})",
                                      AppColor.accentColor )
                                      :
                                  trans.item?.itemUnit?.id == 2 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) > 0 ?
                                  _buildMobileCardItemTotal( AppColor.textPrimaryColor,"طلا بستانکار: ",
                                    trans.amount!.toString().seRagham(),
                                    AppColor.primaryColor,)
                                      : SizedBox.shrink(),
                                ],
                              ),
                              Row(
                                children: [
                                  trans.item?.id == 6 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) < 0 ?
                                  _buildMobileCardItemTotal( AppColor.textAccentColor,"ریال بدهکار: ",
                                      "(-${trans.amount!.abs().toStringAsFixed(0).seRagham()})",
                                      AppColor.accentColor )
                                      : trans.type=="sell" ?
                                  _buildMobileCardItemTotal( AppColor.textAccentColor,"ریال بدهکار: ",
                                      "(-${trans.totalPrice!.abs().toStringAsFixed(0).seRagham()})",
                                      AppColor.accentColor )
                                  : trans.item?.id == 6 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) > 0 ?
                                  _buildMobileCardItemTotal( AppColor.textPrimaryColor,"ریال بستانکار: ",
                                    trans.amount!.toStringAsFixed(0).seRagham(),
                                    AppColor.primaryColor,)
                                      : trans.type=="buy" ?
                                  _buildMobileCardItemTotal( AppColor.textPrimaryColor,"ریال بستانکار: ",
                                    trans.totalPrice!.toStringAsFixed(0).seRagham(),
                                    AppColor.primaryColor,)
                                  : SizedBox.shrink(),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(trans.item?.id==2 && (trans.amount ?? 0) != 0)
                                Row(
                                  children: [
                                    trans.item?.id==2 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) < 0 ?
                                    _buildMobileCardItemTotal( AppColor.textAccentColor,"تمام سکه بدهکار: ",
                                        "(-${trans.amount!.abs().toStringAsFixed(0).seRagham()})",
                                        AppColor.accentColor )
                                        :
                                    trans.item?.id==2 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) > 0 ?
                                    _buildMobileCardItemTotal( AppColor.textPrimaryColor,"تمام سکه بستانکار: ",
                                      trans.amount!.toStringAsFixed(0).seRagham(),
                                      AppColor.primaryColor,)
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              if(trans.item?.id==3 && (trans.amount ?? 0) != 0)
                                Row(
                                  children: [
                                    trans.item?.id==3 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) < 0 ?
                                    _buildMobileCardItemTotal( AppColor.textAccentColor,"نیم سکه بدهکار: ",
                                        "(-${trans.amount!.abs().toStringAsFixed(0).seRagham()})",
                                        AppColor.accentColor )
                                        :
                                    trans.item?.id==3 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) > 0 ?
                                    _buildMobileCardItemTotal( AppColor.textPrimaryColor,"نیم سکه بستانکار: ",
                                      trans.amount!.toStringAsFixed(0).seRagham(),
                                      AppColor.primaryColor,)
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              if(trans.item?.id==4 && (trans.amount ?? 0) != 0)
                                Row(
                                  children: [
                                    trans.item?.id==4 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) < 0 ?
                                    _buildMobileCardItemTotal( AppColor.textAccentColor,"ربع سکه بدهکار: ",
                                        "(-${trans.amount!.abs().toStringAsFixed(0).seRagham()})",
                                        AppColor.accentColor )
                                        :
                                    trans.item?.id==4 && (trans.amount ?? 0) != 0 && (trans.amount ?? 0) > 0 ?
                                    _buildMobileCardItemTotal( AppColor.textPrimaryColor,"ربع سکه بستانکار: ",
                                      trans.amount!.toStringAsFixed(0).seRagham(),
                                      AppColor.primaryColor,)
                                        : SizedBox.shrink(),
                                  ],
                                )
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColor.dividerColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.textColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if((trans.goldTotalRunning ?? 0) != 0)
                                Expanded(
                                  child: _buildMobileCardItemTotal(AppColor.dividerColor,"مانده طلایی: ",
                                      (trans.goldTotalRunning ?? 0) < 0 ? "(-${trans.goldTotalRunning!.abs().toStringAsFixed(3).seRagham()})" : trans.goldTotalRunning!.toStringAsFixed(3).seRagham(),
                                      (trans.goldTotalRunning ?? 0) < 0 ? AppColor.accentColor : AppColor.primaryColor,),
                                ),
                              if((trans.cashTotalRunning ?? 0) != 0)
                                _buildMobileCardItemTotal(AppColor.dividerColor,"مانده ریالی: ",
                                  (trans.cashTotalRunning ?? 0) < 0 ? "(-${trans.cashTotalRunning!.abs().toStringAsFixed(0).seRagham()})" : trans.cashTotalRunning!.toStringAsFixed(0).seRagham(),
                                  (trans.cashTotalRunning ?? 0) < 0 ? AppColor.accentColor : AppColor.primaryColor,),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if((trans.coinTotalRunning ?? 0) != 0)
                                _buildMobileCardItemTotal(AppColor.dividerColor,"مانده تمام سکه: ",
                                  (trans.coinTotalRunning ?? 0) < 0 ? "(-${trans.coinTotalRunning!.abs().toStringAsFixed(0)})" : trans.coinTotalRunning!.toStringAsFixed(0),
                                  (trans.coinTotalRunning ?? 0) < 0 ? AppColor.accentColor : AppColor.primaryColor,),
                              if((trans.halfCoinTotalRunning ?? 0) != 0)
                                _buildMobileCardItemTotal(AppColor.dividerColor,"مانده نیم: ",
                                    (trans.halfCoinTotalRunning ?? 0) < 0 ? "(-${trans.halfCoinTotalRunning!.abs().toStringAsFixed(0)})" : trans.halfCoinTotalRunning!.toStringAsFixed(0),
                                    (trans.halfCoinTotalRunning ?? 0) < 0 ? AppColor.accentColor : AppColor.primaryColor,),
                              if((trans.quarterCoinTotalRunning ?? 0) != 0)
                                _buildMobileCardItemTotal(AppColor.dividerColor,"مانده ربع: ",
                                  (trans.quarterCoinTotalRunning ?? 0) < 0 ? "(-${trans.quarterCoinTotalRunning!.abs().toStringAsFixed(0)})" : trans.quarterCoinTotalRunning!.toStringAsFixed(0),
                                  (trans.quarterCoinTotalRunning ?? 0) < 0 ? AppColor.accentColor : AppColor.primaryColor,),
                            ],
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Obx(() {
            if (controller.isLoading.value && controller.transactionInfoGoldList.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!controller.hasMore.value && controller.transactionInfoGoldList.isNotEmpty) {
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
        ]
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
      case 'initial':
        typeText = 'اول دوره';
        chipColor = const Color(0xFF6B7280);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        typeText,
        style: AppTextStyle.labelText.copyWith(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(dynamic trans) {
    switch (trans.type) {
      case 'initial':
        return _buildInitialTransactionDetails(trans);
      case 'sell':
      case 'buy':
        return _buildSellBuyTransactionDetails(trans);
      case 'receive':
      case 'payment':
        return _buildReceivePaymentTransactionDetails(trans);
      case 'issue':
        return _buildIssueTransactionDetails(trans);
      case 'reciept':
        return _buildReceiptTransactionDetails(trans);
      case 'deposit':
        return _buildDepositTransactionDetails(trans);
      case 'withdraw':
        return _buildWithdrawTransactionDetails(trans);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInitialTransactionDetails(dynamic trans) {
    return _buildMobileCardItem(
      'آیتم: ',
      trans.item?.name ?? "",
      AppColor.secondary3Color,
    );
  }

  Widget _buildSellBuyTransactionDetails(dynamic trans) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMobileCardItem(
                'آیتم: ',
                trans.item?.name ?? "",
                AppColor.secondary3Color,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                   _buildMobileCardItem(
                      trans.item?.itemUnit?.id == 2 ? 'وزن: ' :
                      trans.item?.itemUnit?.id == 1 ? 'تعداد: ' : 'مقدار: ',
                      (trans.amount ?? 0) < 0 ? "-${trans.amount?.abs().toString().seRagham() ?? "" }" : trans.amount?.toString().seRagham() ?? "",
                      (trans.amount ?? 0) > 0 ? AppColor.primaryColor :
                      (trans.amount ?? 0) < 0 ? AppColor.accentColor : AppColor.textColor,
                    ),
                  Text(
                    " ${trans.item?.itemUnit?.name ?? ""}",
                    style:  AppTextStyle.labelText,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                 _buildMobileCardItem(
                    'قیمت: ',
                    trans.mesghalPrice?.toString().seRagham() ?? "",
                    AppColor.dividerColor,
                  ),
                Text(
                  ' ریال',
                  style: AppTextStyle.bodyText,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildReceivePaymentTransactionDetails(dynamic trans) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildMobileCardItem(
                'آیتم: ',
                trans.item?.name ?? "",
                AppColor.secondary3Color,
              ),
            ),
            Expanded(
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   _buildMobileCardItem(
                      trans.item?.itemUnit?.id == 2 ? 'وزن: ' :
                      trans.item?.itemUnit?.id == 1 ? 'تعداد: ' : 'مقدار: ',
                     trans.item?.itemUnit?.id == 2 ? "${trans.detail?.weight ?? ""}" : trans.item?.itemUnit?.id == 1 ?
                     "${trans.amount ?? " "}" : trans.amount?.toString().seRagham() ?? "",
                      //(trans.amount ?? 0) < 0 ? "-${trans.amount?.abs().toString().seRagham() ?? ""}" : trans.amount?.toString().seRagham() ?? "",
                      (trans.amount ?? 0) > 0 ? AppColor.primaryColor :
                      (trans.amount ?? 0) < 0 ? AppColor.accentColor : AppColor.textColor,
                    ),
                  Text(
                    " ${trans.item?.itemUnit?.name ?? ""}",
                    style:  AppTextStyle.labelText,
                  ),
                ],
              ),
            ),
            if (trans.item?.id == 1 || trans.item?.id == 10 || trans.item?.id == 12 ||
                trans.item?.id == 13 || trans.item?.id == 14 || trans.item?.id == 15 || trans.item?.id == 16)
              Expanded(
                child: _buildMobileCardItem(
                  'عیار: ',
                  trans.detail?.carat?.toString() ?? "",
                  AppColor.dividerColor,
                ),
              ),
          ],
        ),
        if (trans.item?.id == 1) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildMobileCardItem(
                  'آز: ',
                  trans.detail?.name ?? "",
                  AppColor.dividerColor,
                ),
              ),
              Expanded(
                child: _buildMobileCardItem(
                  'ش ق: ',
                  trans.detail?.receiptNumber ?? "",
                  AppColor.dividerColor,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildIssueTransactionDetails(dynamic trans) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildMobileCardItem(
                'از: ',
                trans.account?.name ?? "",
                AppColor.accentColor,
              ),
            ),
             Expanded(
               child: _buildMobileCardItem(
                  'به: ',
                  trans.toAccount?.name ?? "",
                  AppColor.primaryColor,
                ),
             ),
          ],
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Expanded(
               child: _buildMobileCardItem(
                  'آیتم: ',
                  trans.item?.name ?? "",
                  AppColor.secondary3Color,
                ),
             ),
            Expanded(
              child: Row(
                children: [
                   _buildMobileCardItem(
                      trans.item?.itemUnit?.id == 2 ? 'وزن: ' :
                      trans.item?.itemUnit?.id == 1 ? 'تعداد: ' : 'مقدار: ',
                      "-${trans.amount?.abs().toString().seRagham() ?? ""}",
                      trans.amount! > 0 ? AppColor.primaryColor :
                      trans.amount! < 0 ? AppColor.accentColor : AppColor.textColor,
                    ),
                  Text(
                    " ${trans.item?.itemUnit?.name ?? ""}",
                    style:  AppTextStyle.labelText,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildReceiptTransactionDetails(dynamic trans) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildMobileCardItem(
                'از: ',
                trans.toAccount?.name ?? "",
                AppColor.accentColor,
              ),
            ),
            Expanded(
              child: _buildMobileCardItem(
                'به: ',
                trans.account?.name ?? "",
                AppColor.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildMobileCardItem(
                'آیتم: ',
                trans.item?.name ?? "",
                AppColor.secondary3Color,
              ),
            ),
             Expanded(
               child: Row(
                 children: [
                   _buildMobileCardItem(
                     trans.item?.itemUnit?.id == 2 ? 'وزن: ' :
                     trans.item?.itemUnit?.id == 1 ? 'تعداد: ' : 'مقدار: ',
                     trans.amount?.toString().seRagham() ?? "",
                     trans.amount! > 0 ? AppColor.primaryColor :
                     trans.amount! < 0 ? AppColor.accentColor : AppColor.textColor,
                   ),
                   Text(
                     " ${trans.item?.itemUnit?.name ?? ""}",
                     style:  AppTextStyle.labelText,
                   ),
                 ],
               ),
             )
          ],
        ),
      ],
    );
  }

  Widget _buildDepositTransactionDetails(dynamic trans) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
             _buildMobileCardItem(
                'مبلغ: ',
                trans.amount?.toString().seRagham() ?? "",
                AppColor.primaryColor,
              ),
             Expanded(
               child: Text(
                  ' ریال',
                  style: AppTextStyle.bodyText,
                ),
             ),
            if (trans.trackingNumber != null && trans.trackingNumber!.isNotEmpty)
              Expanded(
                child: _buildMobileCardItem(
                  'ش پ: ',
                  trans.trackingNumber!,
                  AppColor.dividerColor,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildWithdrawTransactionDetails(dynamic trans) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
             _buildMobileCardItem(
                'مبلغ: ',
                "-${trans.amount?.abs().toString().seRagham() ?? ""}",
                AppColor.accentColor,
              ),
            Expanded(
              child: Text(
                ' ریال',
                style: AppTextStyle.bodyText,
              ),
            ),
            if (trans.trackingNumber != null && trans.trackingNumber!.isNotEmpty)
              Expanded(
                child: _buildMobileCardItem(
                  'ش پ: ',
                  trans.trackingNumber!,
                  AppColor.dividerColor,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileCardItem(String label, String value, Color color) {
    return Row(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            color: const Color(0xFF94A3B8),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            value,
            style: AppTextStyle.labelText.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textDirection: value.contains(RegExp(r'[0-9]')) ? TextDirection.ltr : TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileCardItemTotal(Color color1,String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            color: color1,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.labelText.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textDirection: value.contains(RegExp(r'[0-9]')) ? TextDirection.ltr : TextDirection.rtl,
        ),
      ],
    );
  }

}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../controller/user_list.controller.dart';

class UserListView extends GetView<UserListController> {
  UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
          appBar: CustomAppbar1(
            title: 'لیست اکانت ها',
            onBackTap: () => Get.toNamed("/home"),
          ),
          body: Stack(
            children: [
              BackgroundImageTotal(),
              SafeArea(
                child: controller.state.value == PageStateUser.loading
                    ? Center(
                        child: SizedBox(
                            height: Get.height,
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: CircularProgressIndicator(),
                                    )),
                              ],
                            )),
                      )
                    : controller.state.value == PageStateUser.list
                        ? SizedBox(
                            height: Get.height * 0.85,
                            width: Get.width,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  //فیلد جستجو
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color:
                                        AppColor.appBarColor.withOpacity(0.5),
                                    alignment: Alignment.center,
                                    height: 80,
                                    child: TextFormField(
                                      // onChanged: (value){
                                      //   Future.delayed(const Duration(milliseconds: 5000), () {
                                      //     controller.getUserList();
                                      //   });
                                      // },
                                      controller:
                                          controller.nameFilterController,
                                      style: AppTextStyle.labelText,
                                      textInputAction: TextInputAction.search,
                                      // onFieldSubmitted: (value) async {
                                      //   // Future.delayed(const Duration(milliseconds: 700), () {
                                      //      controller.getListTransactionInfo();
                                      //   // });
                                      // },
                                      onEditingComplete: () async {
                                        controller.getUserList();
                                      },

                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        filled: true,
                                        fillColor: AppColor.textFieldColor,
                                        hintText: "جستجو ... ",
                                        hintStyle: AppTextStyle.labelText,
                                        prefixIcon: IconButton(
                                            onPressed: () async {
                                              controller.getUserList();
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
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 40),
                                    color:
                                        AppColor.appBarColor.withOpacity(0.5),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        padding:
                                                            WidgetStatePropertyAll(
                                                                EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        17)),
                                                        elevation:
                                                            WidgetStatePropertyAll(
                                                                5),
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                AppColor
                                                                    .secondary3Color),
                                                        shape: WidgetStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)))),
                                                    onPressed: () async {
                                                      Get.toNamed("/insertUser",
                                                          parameters: {
                                                            "id": 0.toString()
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.add,
                                                          color: AppColor
                                                              .textColor,
                                                          size: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'ایجاد کاربری جدید',
                                                          style: AppTextStyle
                                                              .labelText,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      // خروجی اکسل
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                            padding: WidgetStatePropertyAll(
                                                                EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        23,
                                                                    vertical:
                                                                        19)),
                                                            // elevation: WidgetStatePropertyAll(5),
                                                            backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    AppColor
                                                                        .secondary3Color),
                                                            shape: WidgetStatePropertyAll(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)))),
                                                        onPressed: () {
                                                          showGeneralDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              barrierLabel:
                                                                  MaterialLocalizations
                                                                          .of(
                                                                              context)
                                                                      .modalBarrierDismissLabel,
                                                              barrierColor:
                                                                  Colors
                                                                      .black45,
                                                              transitionDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              pageBuilder: (BuildContext
                                                                      buildContext,
                                                                  Animation
                                                                      animation,
                                                                  Animation
                                                                      secondaryAnimation) {
                                                                return Center(
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              8),
                                                                          color:
                                                                              AppColor.backGroundColor),
                                                                      width: isDesktop
                                                                          ? Get.width *
                                                                              0.2
                                                                          : Get.height *
                                                                              0.5,
                                                                      height: isDesktop
                                                                          ? Get.height *
                                                                              0.5
                                                                          : Get.height *
                                                                              0.7,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  'خروجی اکسل',
                                                                                  style: AppTextStyle.labelText.copyWith(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            color:
                                                                                AppColor.textColor,
                                                                            height:
                                                                                0.2,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 10),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(height: 8),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'از تاریخ',
                                                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.normal, color: AppColor.textColor),
                                                                                    ),
                                                                                    Container(
                                                                                      //height: 50,
                                                                                      padding: EdgeInsets.only(bottom: 5),
                                                                                      child: IntrinsicHeight(
                                                                                        child: TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
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
                                                                                              firstDate: Jalali(1400, 1, 1),
                                                                                              lastDate: Jalali(1450, 12, 29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                                                              locale: Locale("fa", "IR"),
                                                                                            );
                                                                                            Gregorian gregorian = pickedDate!.toGregorian();
                                                                                            controller.startDateFilter.value = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                            controller.dateStartController.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
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
                                                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.normal, color: AppColor.textColor),
                                                                                    ),
                                                                                    Container(
                                                                                      //height: 50,
                                                                                      padding: EdgeInsets.only(bottom: 5),
                                                                                      child: IntrinsicHeight(
                                                                                        child: TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
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
                                                                                              firstDate: Jalali(1400, 1, 1),
                                                                                              lastDate: Jalali(1450, 12, 29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                                                              locale: Locale("fa", "IR"),
                                                                                            );
                                                                                            // DateTime date=DateTime.now();
                                                                                            Gregorian gregorian = pickedDate!.toGregorian();
                                                                                            controller.endDateFilter.value = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                            controller.dateEndController.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
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
                                                                            margin:
                                                                                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                ElevatedButton(
                                                                              style: ButtonStyle(
                                                                                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23, vertical: 19)),
                                                                                  // elevation: WidgetStatePropertyAll(5),
                                                                                  backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                                                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor), borderRadius: BorderRadius.circular(5)))),
                                                                              onPressed: () async {
                                                                                controller.exportToExcel();
                                                                                Get.back();
                                                                              },
                                                                              child: controller.isLoading.value
                                                                                  ? CircularProgressIndicator(
                                                                                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                                    )
                                                                                  : Text(
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
                                                          'خروجی اکسل',
                                                          style: AppTextStyle
                                                              .labelText,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      // خروجی pdf
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                            padding: WidgetStatePropertyAll(
                                                                EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        23,
                                                                    vertical:
                                                                        19)),
                                                            // elevation: WidgetStatePropertyAll(5),
                                                            backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    AppColor
                                                                        .secondary3Color),
                                                            shape: WidgetStatePropertyAll(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)))),
                                                        onPressed: () {
                                                          showGeneralDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              barrierLabel:
                                                                  MaterialLocalizations
                                                                          .of(
                                                                              context)
                                                                      .modalBarrierDismissLabel,
                                                              barrierColor:
                                                                  Colors
                                                                      .black45,
                                                              transitionDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              pageBuilder: (BuildContext
                                                                      buildContext,
                                                                  Animation
                                                                      animation,
                                                                  Animation
                                                                      secondaryAnimation) {
                                                                return Center(
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              8),
                                                                          color:
                                                                              AppColor.backGroundColor),
                                                                      width: isDesktop
                                                                          ? Get.width *
                                                                              0.2
                                                                          : Get.height *
                                                                              0.5,
                                                                      height: isDesktop
                                                                          ? Get.height *
                                                                              0.5
                                                                          : Get.height *
                                                                              0.7,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
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
                                                                            color:
                                                                                AppColor.textColor,
                                                                            height:
                                                                                0.2,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 10),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(height: 8),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'از تاریخ',
                                                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.normal, color: AppColor.textColor),
                                                                                    ),
                                                                                    Container(
                                                                                      //height: 50,
                                                                                      padding: EdgeInsets.only(bottom: 5),
                                                                                      child: IntrinsicHeight(
                                                                                        child: TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
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
                                                                                              firstDate: Jalali(1400, 1, 1),
                                                                                              lastDate: Jalali(1450, 12, 29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                                                              locale: Locale("fa", "IR"),
                                                                                            );
                                                                                            Gregorian gregorian = pickedDate!.toGregorian();
                                                                                            controller.startDateFilter.value = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                            controller.dateStartController.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
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
                                                                                      style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.normal, color: AppColor.textColor),
                                                                                    ),
                                                                                    Container(
                                                                                      //height: 50,
                                                                                      padding: EdgeInsets.only(bottom: 5),
                                                                                      child: IntrinsicHeight(
                                                                                        child: TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
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
                                                                                              firstDate: Jalali(1400, 1, 1),
                                                                                              lastDate: Jalali(1450, 12, 29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode.day,
                                                                                              locale: Locale("fa", "IR"),
                                                                                            );
                                                                                            // DateTime date=DateTime.now();
                                                                                            Gregorian gregorian = pickedDate!.toGregorian();
                                                                                            controller.endDateFilter.value = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                            controller.dateEndController.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
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
                                                                            margin:
                                                                                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                ElevatedButton(
                                                                              style: ButtonStyle(
                                                                                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23, vertical: 19)),
                                                                                  // elevation: WidgetStatePropertyAll(5),
                                                                                  backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                                                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor), borderRadius: BorderRadius.circular(5)))),
                                                                              onPressed: () async {
                                                                                controller.exportToPdf();
                                                                                Get.back();
                                                                              },
                                                                              child: controller.isLoading.value
                                                                                  ? CircularProgressIndicator(
                                                                                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                                    )
                                                                                  : Text(
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
                                                          style: AppTextStyle
                                                              .labelText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        WidgetStatePropertyAll(
                                                            EdgeInsets.symmetric(
                                                                horizontal: 23,
                                                                vertical: 19)),
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
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)))),
                                                onPressed: () async {
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
                                                                      0.15
                                                                  : Get.height *
                                                                      0.5,
                                                              height: isDesktop
                                                                  ? Get.height *
                                                                      0.35
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
                                                                              'فیلتر',
                                                                              style: AppTextStyle.labelText.copyWith(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              27,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 2, vertical: 1)),
                                                                                // elevation: WidgetStatePropertyAll(5),
                                                                                backgroundColor: WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                                                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor), borderRadius: BorderRadius.circular(5)))),
                                                                            onPressed:
                                                                                () async {
                                                                              controller.clearFilter();
                                                                              controller.getUserList();
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'حذف فیلتر',
                                                                              style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 9 : 8),
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
                                                                              'نام',
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
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'شماره تماس',
                                                                              style: AppTextStyle.labelText.copyWith(fontSize: 11, fontWeight: FontWeight.normal, color: AppColor.textColor),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            IntrinsicHeight(
                                                                              child: TextFormField(
                                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                controller: controller.mobileFilterController,
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                                textAlign: TextAlign.center,
                                                                                keyboardType: TextInputType.phone,
                                                                                inputFormatters: [
                                                                                  FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                                                  TextInputFormatter.withFunction((oldValue, newValue) {
                                                                                    // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                                                                    String newText = newValue.text.replaceAll('٠', '0').replaceAll('١', '1').replaceAll('٢', '2').replaceAll('٣', '3').replaceAll('٤', '4').replaceAll('٥', '5').replaceAll('٦', '6').replaceAll('٧', '7').replaceAll('٨', '8').replaceAll('٩', '9');

                                                                                    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
                                                                                  }),
                                                                                ],
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
                                                                                8),
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
                                                                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23, vertical: 19)),
                                                                          // elevation: WidgetStatePropertyAll(5),
                                                                          backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor), borderRadius: BorderRadius.circular(5)))),
                                                                      onPressed:
                                                                          () async {
                                                                        controller
                                                                            .getUserList();
                                                                        Get.back();
                                                                      },
                                                                      child: controller
                                                                              .isLoading
                                                                              .value
                                                                          ? CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                            )
                                                                          : Text(
                                                                              'فیلتر',
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
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        'assets/svg/filter3.svg',
                                                        height: 17,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          controller.nameFilterController
                                                                          .text !=
                                                                      "" ||
                                                                  controller
                                                                          .mobileFilterController
                                                                          .text !=
                                                                      ""
                                                              ? AppColor
                                                                  .accentColor
                                                              : AppColor
                                                                  .textColor,
                                                          BlendMode.srcIn,
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'فیلتر',
                                                      style: AppTextStyle.labelText.copyWith(
                                                          fontSize: isDesktop
                                                              ? 12
                                                              : 10,
                                                          color: controller
                                                                          .nameFilterController
                                                                          .text !=
                                                                      "" ||
                                                                  controller
                                                                          .mobileFilterController
                                                                          .text !=
                                                                      ""
                                                              ? AppColor
                                                                  .accentColor
                                                              : AppColor
                                                                  .textColor),
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
                                                      sortColumnIndex:
                                                          controller
                                                              .sortIndex.value,
                                                      sortAscending:
                                                          controller.sort.value,
                                                      border: TableBorder.symmetric(
                                                          inside: BorderSide(
                                                              color: AppColor
                                                                  .textColor,
                                                              width: 0.3),
                                                          outside: BorderSide(
                                                              color: AppColor
                                                                  .textColor,
                                                              width: 0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
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
                            child: ErrPage(
                              callback: () {
                                controller.clearFilter();
                                controller.getUserList();
                              },
                              title: "خطا در دریافت لیست اکانت ها",
                              des: 'برای دریافت لیست اکانت ها مجددا تلاش کنید',
                            ),
                          ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  controller.paginated != null
                      ? Container(
                          height: 70,
                          margin: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: AppColor.appBarColor.withOpacity(0.5),
                          alignment: Alignment.bottomCenter,
                          child: PagerWidget(
                            countPage: controller.paginated!.totalCount ?? 0,
                            callBack: (int index) {
                              controller.isChangePage(index);
                            },
                          ))
                      : SizedBox(),
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
              constraints: BoxConstraints(
                maxWidth: 50,
              ),
              child: Text('ردیف',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            print(columnIndex);
            controller.setSort(columnIndex, ascending);

            controller.onSortColum(columnIndex, ascending);
          },
          label:
              Text('نام', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
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
              Text('نقش', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
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
                DataCell(Center(
                  child: Text(
                    "${trans.rowNum}",
                    style: AppTextStyle.bodyText,
                  ),
                )),
                DataCell(Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed("/userDetail",
                          parameters: {"accountId": trans.id.toString()});
                    },
                    child: Text(
                      "${trans.name}",
                      style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.secondary3Color,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.secondary3Color,
                        decorationThickness: 2,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )),
                DataCell(Center(
                  child: SizedBox(
                    child: Text(
                      trans.contactInfo ?? "",
                      style: AppTextStyle.bodyText,
                    ),
                  ),
                )),
                DataCell(Center(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: trans.status == 1
                          ? AppColor.primaryColor
                          : AppColor.accentColor),
                  child: Text(
                    trans.status == 1 ? "تایید شده" : "رد شده ",
                    style: AppTextStyle.bodyText.copyWith(fontSize: 9),
                  ),
                ))),
                DataCell(Center(
                  child: SizedBox(
                    child: Text(
                      "-",
                      style: AppTextStyle.bodyText,
                    ),
                  ),
                )),
                DataCell(Center(
                  child: Row(
                    children: [
                      Text(
                        "${trans.startDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: ' - ')}",
                        style: AppTextStyle.bodyText,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                )),
                DataCell(Center(
                    child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        print(trans.id.toString());
                        Get.toNamed(
                            "/"
                            "",
                            parameters: {"id": trans.id.toString()});
                      },
                      child: SvgPicture.asset('assets/svg/edit.svg',
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            AppColor.textColor,
                            BlendMode.srcIn,
                          )),
                    ),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    // SvgPicture.asset('assets/svg/trash-bin.svg',height: 20,
                    //     colorFilter: ColorFilter.mode(
                    //       AppColor.textColor,
                    //       BlendMode.srcIn,
                    //     )),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: AppColor.secondary3Color),
                      child: Text(
                        "فاکتور",
                        style: AppTextStyle.bodyText.copyWith(fontSize: 10),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: AppColor.secondary2Color),
                      child: Text(
                        "فاکتور جدید",
                        style: AppTextStyle.bodyText.copyWith(fontSize: 10),
                      ),
                    ),
                  ],
                ))),
                DataCell(Center(
                    child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.updateStatus(0, trans.id ?? 0);
                      },
                      child: SvgPicture.asset('assets/svg/close-circle1.svg',
                          colorFilter: ColorFilter.mode(
                            AppColor.accentColor,
                            BlendMode.srcIn,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.updateStatus(1, trans.id ?? 0);
                      },
                      child:
                          SvgPicture.asset('assets/svg/check-mark-circle.svg',
                              colorFilter: ColorFilter.mode(
                                AppColor.primaryColor,
                                BlendMode.srcIn,
                              )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ))),
              ],
            ))
        .toList();
  }
}

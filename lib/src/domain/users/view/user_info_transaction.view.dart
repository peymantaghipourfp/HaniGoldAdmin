import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/user_info_detail_transaction.controller.dart';
import '../controller/user_info_transaction.controller.dart';
import '../widgets/balance.widget.dart';
import '../widgets/tabel_info.widget.dart';

class UserInfoTransactionView extends StatefulWidget {
  const UserInfoTransactionView({super.key});

  @override
  State<UserInfoTransactionView> createState() => _UserInfoTransactionViewState();
}

class _UserInfoTransactionViewState extends State<UserInfoTransactionView> {
  var controller=Get.find<UserInfoDetailTransactionController>();
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'جزییات تراکنش کاربر',
        onBackTap: () => Get.offNamed("/listUserInfoTransaction"),
      ),
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
                                  Container(
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
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
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
                                  ),
                                  Container(
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
                                            .secondary2Color),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/fileExcel.svg',
                                            height: 20,
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
                              BalanceWidget(
                                listBalance:
                                controller.balanceList,
                                size: Get.width * 0.4,
                              )
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
                                        'حساب کاربری محمود نصرالهی',
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
                                      SizedBox(
                                        height: 10,
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
                                                    .secondary2Color),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/svg/fileExcel.svg',
                                                    height:
                                                    20,
                                                    colorFilter:
                                                    ColorFilter.mode(
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
                                                      fontSize: isDesktop ? 12 : 10),
                                                ),
                                              ],
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
                                BalanceWidget(
                                  listBalance: controller
                                      .balanceList,
                                  size: Get.width * 0.9,
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
                        : SingleChildScrollView(
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
                                  dataRowMaxHeight: 110,
                                  //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                  //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                  headingRowHeight: 70,
                                  columnSpacing: 40,
                                  horizontalMargin: 0,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50,)
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
              child: Text('مانده ریالی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده طلایی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده سکه',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مستندات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.transactionInfoList
        .map((trans) => DataRow(
      cells: [
        // تاریخ
        DataCell(Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              // margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: trans.type == "reciept" ||
                      trans.type == "receive" ||
                      trans.type == "buy"
                      ? AppColor.primaryColor
                      : AppColor.accentColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trans.type == "issue"
                        ? ' پرداخت ${trans.item?.name ?? ""}'
                        : trans.type == "receive"
                        ? ' دریافت ${trans.item?.name ?? ""}'
                        : trans.type == "sell"
                        ? ' فروش ${trans.item?.name ?? ""}'
                        : trans.type == "buy"
                        ? ' خرید ${trans.item?.name ?? ""}'
                        : trans.type == "deposit"
                        ? ' پرداخت ${trans.item?.name ?? ""}'
                        : trans.type == "withdraw"
                        ? ' پرداخت ${trans.item?.name ?? ""}'
                        : trans.type == "reciept"
                        ? ' دریافت ${trans.item?.name ?? ""}'
                        : " پرداخت ${trans.item?.name ?? ""}",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        )),
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
        DataCell(Center(
          child: trans.details!.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              trans.toWallet?.account?.name != null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " از : ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 10),
                  ),
                  Text(
                    " ${trans.wallet?.account?.name ?? ""} ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " به : ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 10),
                  ),
                  Text(
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
                  Text(
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
                  Text(
                    trans.item?.itemUnit?.id == 1
                        ? " عدد "
                        : trans.item?.itemUnit?.id == 2
                        ? " گرم "
                        : " ریال ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
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
                  Text(
                    'به مظنه :  ',
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.iconViewColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                  ),
                  Text(
                      "${trans.price ?? 0}".seRagham() +
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
                  Text(
                    ' قیمت کل :  ',
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.iconViewColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 10),
                  ),
                  Text(
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
                  Text(
                    'توضیحات : ',
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.iconViewColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                  ),
                  Text(trans.description ?? 'نامشخص',
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
                  Text(
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
              : Column(
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
                          Text(
                            "وزن ترازو : ",
                            style: AppTextStyle.bodyText
                                .copyWith(
                                color: AppColor
                                    .appBarColor,
                                fontSize: 10,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          Text(
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
                          Text(
                            "عیار : ",
                            style: AppTextStyle.bodyText
                                .copyWith(
                                color: AppColor
                                    .appBarColor,
                                fontSize: 10,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          Text(
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
                          Text(
                            "وزن : ",
                            style: AppTextStyle.bodyText
                                .copyWith(
                                color: AppColor
                                    .appBarColor,
                                fontSize: 10,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          Text(
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
                          Text(
                            "ناخالصی : ",
                            style: AppTextStyle.bodyText
                                .copyWith(
                                color: AppColor
                                    .appBarColor,
                                fontSize: 10,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          Text(
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
                          Text(
                            "آزمایشگاه : ",
                            style: AppTextStyle.bodyText
                                .copyWith(
                                color: AppColor
                                    .appBarColor,
                                fontSize: 10,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          Text(
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
                          Text(
                            "شماره آزمایشگاه : ",
                            style: AppTextStyle.bodyText
                                .copyWith(
                                color: AppColor
                                    .appBarColor,
                                fontSize: 10,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          Text(
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
        )),
        DataCell(Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                trans.item?.itemUnit?.id == 1
                    ? "${trans.amount} "
                    : trans.item?.itemUnit?.id == 2
                    ? "${trans.amount} "
                    : "${trans.amount.toString().seRagham()} ",
                style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.buttonColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
                textDirection: TextDirection.ltr,
              ),
              Text(
                trans.item?.itemUnit?.id == 1
                    ? " عدد "
                    : trans.item?.itemUnit?.id == 2
                    ? " گرم "
                    : " ریال ",
                style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.buttonColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        )),

        DataCell(Center(
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
            ))),
        DataCell(Center(
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
            ))),
        DataCell(Center(
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
            ))),

        DataCell(Center(
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


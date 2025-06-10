import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_detail.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/err_page.dart';
import '../controller/user_info_detail_transaction.controller.dart';
import '../controller/user_info_transaction.controller.dart';
import '../widgets/balance.widget.dart';
import '../widgets/tabel_info.widget.dart';

class UserDetailView extends StatefulWidget {
  const UserDetailView({super.key});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  var controller = Get.find<UserDetailController>();
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
          appBar: CustomAppbar1(
            title: 'جزییات اطلاعات کاربر',
            onBackTap: () => Get.back(),
          ),
          body: Stack(
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
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.secondaryColor),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'نام : ',
                                              style: AppTextStyle.labelText
                                                  .copyWith(fontSize: 13),
                                            ),
                                            Text(
                                              controller.accountModel.value
                                                      ?.name ??
                                                  "",
                                              style: AppTextStyle.labelText
                                                  .copyWith(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'گروه اکانت : ',
                                              style: AppTextStyle.labelText
                                                  .copyWith(fontSize: 13),
                                            ),
                                            Text(
                                              controller.accountModel.value
                                                      ?.accountGroup?.name ??
                                                  "",
                                              style: AppTextStyle.labelText
                                                  .copyWith(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'تاریخ ایجاد اکانت : ',
                                              style: AppTextStyle.labelText
                                                  .copyWith(fontSize: 12),
                                            ),
                                            Text(
                                              controller.accountModel.value!
                                                  .startDate!
                                                  .toPersianDate(),
                                              style: AppTextStyle.labelText
                                                  .copyWith(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.secondaryColor),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      children: [
                                        controller.accountModel.value!
                                                        .accountSubGroups !=
                                                    null &&
                                                controller
                                                    .accountModel
                                                    .value!
                                                    .accountSubGroups!
                                                    .isNotEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        AppColor.appBarColor),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 20),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "گروه های زیر مجموعه ای",
                                                          style: AppTextStyle
                                                              .labelText
                                                              .copyWith(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Column(
                                                      children: controller
                                                          .accountModel
                                                          .value!
                                                          .accountSubGroups!
                                                          .map(
                                                        (e) {
                                                          // / int color=0xff + int.parse(e.color!.replaceAll("#", ""));
                                                          return Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        20),
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Color(int.parse(e
                                                                        .color!
                                                                        .replaceAll(
                                                                            "#",
                                                                            "0xff"))))),
                                                            child: Column(
                                                              children: [
                                                                isDesktop
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "نام : ",
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                  Text(
                                                                                    e.name ?? "",
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: 20,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "میزان واریزی : ",
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                  Text(
                                                                                    "${e.deposit?.toInt()}".seRagham(),
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "تراز : ",
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                              ),
                                                                              Text(
                                                                                "${e.balance?.toInt()}".seRagham(),
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "نام : ",
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                  Text(
                                                                                    e.name ?? "",
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: 20,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "میزان واریزی : ",
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                  Text(
                                                                                    "${e.deposit?.toInt()}".seRagham(),
                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "تراز : ",
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                              ),
                                                                              Text(
                                                                                "${e.balance?.toInt()}".seRagham(),
                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 14),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                Container(
                                                                  color: AppColor
                                                                      .iconViewColor,
                                                                  height: 0.8,
                                                                  width:
                                                                      Get.width,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                ),
                                                                Column(
                                                                  //  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        GestureDetector(
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(6),
                                                                                color: controller.isChecked.value ? AppColor.secondaryColor : Color(int.parse(e.color!.replaceAll("#", "0xff"))),
                                                                                border: Border.all(color: controller.isChecked.value ? AppColor.secondaryColor : Color(int.parse(e.color!.replaceAll("#", "0xff"))))),
                                                                            width:
                                                                                150,
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.checklist_rtl,
                                                                                  color: AppColor.textColor,
                                                                                  size: 25,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Text(
                                                                                  "لیست کالا ها",
                                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 14, color: AppColor.textColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            controller.setChecked();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    controller
                                                                            .isChecked
                                                                            .value
                                                                        ? SizedBox(
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              scrollDirection: Axis.horizontal,
                                                                              child: Row(
                                                                                children: [
                                                                                  SingleChildScrollView(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        DataTable(
                                                                                          columns: [
                                                                                            DataColumn(
                                                                                                label: ConstrainedBox(
                                                                                                    constraints: BoxConstraints(
                                                                                                      maxWidth: 50,
                                                                                                    ),
                                                                                                    child: Text('نام کالا', style: AppTextStyle.labelText.copyWith(fontSize: 13, color: AppColor.primaryColor, fontWeight: FontWeight.bold))),
                                                                                                headingRowAlignment: MainAxisAlignment.center),
                                                                                            DataColumn(label: Text('کاهده خرید', style: AppTextStyle.labelText.copyWith(fontSize: 13, color: AppColor.primaryColor, fontWeight: FontWeight.bold)), headingRowAlignment: MainAxisAlignment.center),
                                                                                            DataColumn(
                                                                                                label: Row(
                                                                                                  children: [
                                                                                                    Text('افزاینده فروش', style: AppTextStyle.labelText.copyWith(fontSize: 13, color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                                                                                                  ],
                                                                                                ),
                                                                                                headingRowAlignment: MainAxisAlignment.center),
                                                                                          ],
                                                                                          border: TableBorder.symmetric(inside: BorderSide(color: AppColor.textColor, width: 0.3), outside: BorderSide(color: AppColor.textColor, width: 0.3), borderRadius: BorderRadius.circular(8)),
                                                                                          dividerThickness: 0.3,
                                                                                          rows: e.itemPrices!
                                                                                              .map((trans) => DataRow(
                                                                                                    cells: [
                                                                                                      DataCell(Center(
                                                                                                        child: Text(
                                                                                                          "${trans.itemName}",
                                                                                                          style: AppTextStyle.bodyText.copyWith(
                                                                                                            color: AppColor.textColor,
                                                                                                            fontSize: 13,
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                                      DataCell(Center(
                                                                                                        child: GestureDetector(
                                                                                                          onTap: () {},
                                                                                                          child: Text(
                                                                                                            "${trans.buyRange!.toInt()}".seRagham(),
                                                                                                            style: AppTextStyle.bodyText.copyWith(
                                                                                                              color: AppColor.textColor,
                                                                                                              fontSize: 13,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                                      DataCell(Center(
                                                                                                        child: SizedBox(
                                                                                                          child: Text(
                                                                                                            "${trans.salesRange!.toInt()}".seRagham(),
                                                                                                            style: AppTextStyle.bodyText.copyWith(
                                                                                                              color: AppColor.textColor,
                                                                                                              fontSize: 13,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                                    ],
                                                                                                  ))
                                                                                              .toList(),
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
                                                                          )
                                                                        : SizedBox(),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ],
                                                ))
                                            : SizedBox(),
                                        controller.accountModel.value!.childs !=
                                                    null &&
                                                controller.accountModel.value!
                                                    .childs!.isNotEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        AppColor.appBarColor),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 20),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 15),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "زیر مجموعه ها",
                                                          style: AppTextStyle
                                                              .labelText
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "تعداد : ",
                                                              style: AppTextStyle
                                                                  .labelText
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                            Text(
                                                              "${controller.accountModel.value?.childrenCount ?? 0}",
                                                              style: AppTextStyle
                                                                  .labelText
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: controller
                                                                      .isLoading
                                                                      .value
                                                                  ? AppColor
                                                                      .secondaryColor
                                                                  : AppColor
                                                                      .primaryColor,
                                                            ),
                                                            width: 160,
                                                            height: 40,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .checklist_rtl,
                                                                  color: AppColor
                                                                      .textColor,
                                                                  size: 25,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "لیست زیر مجموعه ها",
                                                                  style: AppTextStyle.labelText.copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      color: AppColor
                                                                          .textColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            controller
                                                                .setCheckedAccount();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    controller.isLoading.value
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              DataTable(
                                                                columns: [
                                                                  DataColumn(
                                                                      label: ConstrainedBox(
                                                                          constraints: BoxConstraints(
                                                                            maxWidth:
                                                                                50,
                                                                          ),
                                                                          child: Text('ردیف', style: AppTextStyle.labelText.copyWith(fontSize: 13, color: AppColor.primaryColor, fontWeight: FontWeight.bold))),
                                                                      headingRowAlignment: MainAxisAlignment.center),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'نام کاربر',
                                                                          style: AppTextStyle.labelText.copyWith(
                                                                              fontSize:
                                                                                  13,
                                                                              color: AppColor
                                                                                  .primaryColor,
                                                                              fontWeight: FontWeight
                                                                                  .bold)),
                                                                      headingRowAlignment:
                                                                          MainAxisAlignment
                                                                              .center),
                                                                  DataColumn(
                                                                      label:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              'موبایل',
                                                                              style: AppTextStyle.labelText.copyWith(fontSize: 13, color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      ),
                                                                      headingRowAlignment:
                                                                          MainAxisAlignment
                                                                              .center),
                                                                  DataColumn(
                                                                      label:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              'وضعیت',
                                                                              style: AppTextStyle.labelText.copyWith(fontSize: 13, color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      ),
                                                                      headingRowAlignment:
                                                                          MainAxisAlignment
                                                                              .center),
                                                                  DataColumn(
                                                                      label:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              'گروه',
                                                                              style: AppTextStyle.labelText.copyWith(fontSize: 13, color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      ),
                                                                      headingRowAlignment:
                                                                          MainAxisAlignment
                                                                              .center),
                                                                ],
                                                                border: TableBorder.symmetric(
                                                                    inside: BorderSide(
                                                                        color: AppColor
                                                                            .textColor,
                                                                        width:
                                                                            0.3),
                                                                    outside: BorderSide(
                                                                        color: AppColor
                                                                            .textColor,
                                                                        width:
                                                                            0.3),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                dividerThickness:
                                                                    0.3,
                                                                rows: controller
                                                                    .accountModel
                                                                    .value!
                                                                    .childs!
                                                                    .map((trans) =>
                                                                        DataRow(
                                                                          cells: [
                                                                            DataCell(Center(
                                                                              child: Text(
                                                                                "${trans.rowNum}",
                                                                                style: AppTextStyle.bodyText.copyWith(
                                                                                  color: AppColor.textColor,
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )),
                                                                            DataCell(Center(
                                                                              child: GestureDetector(
                                                                                onTap: () {},
                                                                                child: Text(
                                                                                  trans.name ?? "",
                                                                                  style: AppTextStyle.bodyText.copyWith(
                                                                                    color: AppColor.textColor,
                                                                                    fontSize: 13,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                            DataCell(Center(
                                                                              child: SizedBox(
                                                                                child: Text(
                                                                                  trans.contactInfo ?? "",
                                                                                  style: AppTextStyle.bodyText.copyWith(
                                                                                    color: AppColor.textColor,
                                                                                    fontSize: 13,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                            DataCell(Center(
                                                                                child: Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: trans.status == 1 ? AppColor.primaryColor : AppColor.accentColor),
                                                                              child: Text(
                                                                                trans.status == 1 ? "تایید شده" : "رد شده ",
                                                                                style: AppTextStyle.bodyText.copyWith(fontSize: 9),
                                                                              ),
                                                                            ))),
                                                                            DataCell(Center(
                                                                              child: SizedBox(
                                                                                child: Text(
                                                                                  trans.accountGroup?.name ?? "",
                                                                                  style: AppTextStyle.bodyText.copyWith(
                                                                                    color: AppColor.textColor,
                                                                                    fontSize: 13,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                          ],
                                                                        ))
                                                                    .toList(),
                                                                dataRowMaxHeight:
                                                                    52,
                                                                //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                                                //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                                                headingRowHeight:
                                                                    50,
                                                                columnSpacing:
                                                                    90,
                                                                horizontalMargin:
                                                                    60,
                                                              ),
                                                            ],
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ))
                                            : SizedBox(),
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
                                controller.getOneUser(controller.idUser.value);
                              },
                              title: "خطا در جزییات کاربران",
                              des: 'برای دریافت جزییات کاربران مجددا تلاش کنید',
                            ),
                          ),
              ),
            ],
          ),
        ));
  }
}

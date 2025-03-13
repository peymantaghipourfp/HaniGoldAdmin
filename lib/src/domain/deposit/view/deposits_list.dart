import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';

class DepositsListView extends StatelessWidget {
  DepositsListView({super.key});

  final DepositController depositController = Get.find<DepositController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'واریزی ها',
        onBackTap: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Column(
                children: [
                  // لیست سفارشات
                  Obx(() {
                    if (depositController.state.value == PageState.loading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (depositController.state.value == PageState.empty) {
                      return EmptyPage(
                        title: 'سفارشی وجود ندارد',
                        callback: () {
                          depositController.fetchDepositList();
                        },
                      );
                    } else if (depositController.state.value == PageState.list) {
                      // لیست واریزی ها
                      return Expanded(
                        child: SizedBox(
                          height: Get.height * 0.6,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: depositController.depositList.length,
                            itemBuilder: (context, index) {
                              var deposits = depositController.depositList[index];
                              return Card(
                                margin: EdgeInsets.fromLTRB(8, 5, 8, 10),
                                color: AppColor.secondaryColor,
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 8, right: 8, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ListTile(
                                        title: Column(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [

                                                //نام کاربر
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'نام کاربر',
                                                      style:
                                                          AppTextStyle.labelText,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      deposits.wallet?.account?.name ?? "",
                                                      style:
                                                          AppTextStyle.bodyText,
                                                    ),
                                                  ],
                                                ),

                                                //تاریخ درخواست
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'تاریخ درخواست',
                                                      style:
                                                          AppTextStyle.labelText,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      deposits.date != null
                                                          ? deposits.date!
                                                              .toPersianDate(
                                                                  twoDigits: true,
                                                                  showTime: true,
                                                                  timeSeprator:
                                                                      '-')
                                                          : 'تاریخ نامشخص',
                                                      style:
                                                          AppTextStyle.bodyText,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            //  ردیف دوم
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height: 4,
                                                ),

                                                //مبلغ
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'مبلغ: ',
                                                      style:
                                                          AppTextStyle.labelText,
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "${deposits.amount == null ? 0 : deposits.amount.toString().seRagham(separator: ',')} ریال",
                                                      style:
                                                          AppTextStyle.bodyText,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            // ردیف سوم آیکون ها
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                // آیکون مشاهده
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: SvgPicture.asset(
                                                        'assets/svg/eye1.svg',
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          AppColor.iconViewColor,
                                                          BlendMode.srcIn,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // تعیین وضعیت
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('وضعیت: ',style: AppTextStyle
                                                        .bodyText),
                                                    Text(
                                                      '${deposits.status == 0 ? 'نامشخص' : deposits.status == 1 ? 'تایید شده' : 'تایید نشده'} ',
                                                      style: AppTextStyle
                                                          .bodyText.copyWith(
                                                        color: deposits.status == 1
                                                            ? AppColor.primaryColor
                                                            : deposits.status == 2
                                                            ? AppColor.accentColor
                                                            : AppColor.textColor,
                                                      )
                                                      ,),
                                                  ],
                                                ),
                                                // Popup تعیین وضعیت
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                  child: PopupMenuButton<
                                                      int>(
                                                    splashRadius: 10,
                                                    tooltip: 'تعیین وضعیت',
                                                    onSelected: (value) async {
                                                      await depositController.updateStatusDeposit(deposits.id!, value);

                                                    },
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(
                                                              10.0)),
                                                    ),
                                                    color: AppColor
                                                        .backGroundColor,
                                                    constraints: BoxConstraints(
                                                      minWidth: 70,
                                                      maxWidth: 70,
                                                    ),
                                                    position: PopupMenuPosition
                                                        .under,
                                                    offset: const Offset(
                                                        0, 0),
                                                    itemBuilder: (
                                                        context) =>
                                                    [
                                                      PopupMenuItem<int>(
                                                        labelTextStyle: WidgetStateProperty
                                                            .all(
                                                            AppTextStyle
                                                                .madiumbodyText
                                                        ),
                                                        value: 1,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            depositController.isLoading.value
                                                                ?
                                                            CircularProgressIndicator(
                                                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                            ) :
                                                            Text('تایید',
                                                              style: AppTextStyle
                                                                  .madiumbodyText
                                                                  .copyWith(
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuDivider(),
                                                      PopupMenuItem<int>(
                                                        value: 2,
                                                        labelTextStyle: WidgetStateProperty
                                                            .all(
                                                            AppTextStyle
                                                                .madiumbodyText
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            depositController.isLoading.value
                                                                ?
                                                            CircularProgressIndicator(
                                                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                            ) :
                                                            Text('رد',
                                                              style: AppTextStyle
                                                                  .madiumbodyText
                                                                  .copyWith(
                                                                  color: AppColor
                                                                      .accentColor,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    child: Text(
                                                      'تعیین وضعیت',
                                                      style: AppTextStyle
                                                          .bodyText
                                                          .copyWith(
                                                          decoration: TextDecoration
                                                              .underline,
                                                          decorationColor: AppColor
                                                              .textColor
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        minVerticalPadding: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return ErrPage(
                      callback: () {
                        depositController.fetchDepositList();
                      },
                      title: "خطا در دریافت واریزی ها",
                      des: 'برای دریافت لیست واریزی ها مجددا تلاش کنید',
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

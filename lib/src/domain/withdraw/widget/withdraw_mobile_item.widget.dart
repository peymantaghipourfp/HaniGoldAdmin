import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../controller/withdraw.controller.dart';
import '../model/withdraw.model.dart';
import '../view/deposit_request_create.view.dart';
import '../view/deposit_request_update.view.dart';

class WithdrawMobileItem extends StatelessWidget {
  final WithdrawController withdrawController;
  final WithdrawModel withdraw;
  final int index;

  const WithdrawMobileItem({super.key, required this.withdrawController, required this.withdraw, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isExpanded = withdrawController.isItemExpanded(index);
      return Card(
        margin: const EdgeInsets.all(4),
        color: AppColor.secondaryColor,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Column(
                  children: [
                    // تاریخ و رفرنس
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          withdraw.status == 0
                              ? withdraw.requestDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص'
                              : withdraw.confirmDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
                          style: AppTextStyle.bodyText,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('رفرنس: ', style: AppTextStyle.labelText),
                            withdraw.refrenceId != null
                                ? Icon(Icons.check, color: AppColor.primaryColor, size: 20)
                                : Icon(Icons.close, color: AppColor.accentColor, size: 20)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 3),
                    SizedBox(width: 250, child: Divider(height: 1, color: AppColor.dividerColor)),
                    const SizedBox(height: 8),

                    // نام کاربر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('نام کاربر: ', style: AppTextStyle.labelText),
                        const SizedBox(height: 2),
                        Text(withdraw.wallet?.account?.name ?? "", style: AppTextStyle.bodyText),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // مبالغ
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('مبلغ درخواستی: ', style: AppTextStyle.labelText),
                              const SizedBox(width: 3),
                              Text("${withdraw.requestAmount?.toInt().toString().seRagham(separator: ',') ?? 0} ریال", style: AppTextStyle.bodyText),
                            ]),
                            Row(children: [
                              Text('مبلغ کل: ', style: AppTextStyle.labelText),
                              const SizedBox(width: 3),
                              Text("${withdraw.amount?.toInt().toString().seRagham(separator: ',')} ریال", style: AppTextStyle.bodyText),
                            ]),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('مبلغ مانده: ', style: AppTextStyle.labelText),
                            const SizedBox(width: 3),
                            Text(
                              "${withdraw.undividedAmount == null ? 0 : withdraw.undividedAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                              style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('مبلغ واریز شده: ', style: AppTextStyle.labelText),
                            const SizedBox(width: 3),
                            Text(
                              "${withdraw.paidAmount == null ? 0 : withdraw.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                              style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        withdraw.status == 2
                            ? Row(children: [
                          Text('دلیل رد: ', style: AppTextStyle.labelText),
                          const SizedBox(width: 3),
                          Text("`${withdraw.reasonRejection?.name}`" ?? "", style: AppTextStyle.bodyText),
                        ])
                            : const Text("")
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Divider(height: 1),
                    const SizedBox(height: 2),

                    // آیکون ها
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // تقسیم
                        GestureDetector(
                          onTap: () {
                            if (withdraw.undividedAmount == 0) {
                              Get.defaultDialog(
                                title: 'هشدار',
                                middleText: 'مبلغ باقیمانده برای تقسیم صفر است',
                                titleStyle: AppTextStyle.smallTitleText,
                                middleTextStyle: AppTextStyle.bodyText,
                                backgroundColor: AppColor.backGroundColor,
                                textCancel: 'بستن',
                              );
                            } else {
                              withdrawController.balanceList.clear();
                              showModalBottomSheet(
                                enableDrag: true,
                                context: context,
                                backgroundColor: AppColor.backGroundColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return InsertDepositRequestWidget(id: withdraw.id!, walletId: withdraw.wallet!.id!);
                                },
                              ).whenComplete(() {
                                withdrawController.clearList();
                              });
                              withdrawController.filterAccountListFunc(withdraw.wallet!.account!.id!.toInt());
                            }
                          },
                          child: Row(children: [
                            Text(' تقسیم', style: AppTextStyle.labelText.copyWith(color: AppColor.buttonColor)),
                            SvgPicture.asset('assets/svg/add.svg', colorFilter: ColorFilter.mode(AppColor.buttonColor, BlendMode.srcIn)),
                          ]),
                        ),
                        // حذف
                        GestureDetector(
                          onTap: () {
                            if (withdraw.depositRequestCount != 0 || withdraw.depositCount != 0) {
                              Get.defaultDialog(
                                title: 'هشدار',
                                middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                titleStyle: AppTextStyle.smallTitleText,
                                middleTextStyle: AppTextStyle.bodyText,
                                backgroundColor: AppColor.backGroundColor,
                                textCancel: 'بستن',
                              );
                            } else {
                              Get.defaultDialog(
                                backgroundColor: AppColor.backGroundColor,
                                title: "حذف درخواست برداشت",
                                titleStyle: AppTextStyle.smallTitleText,
                                middleText: "آیا از حذف درخواست برداشت مطمئن هستید؟",
                                middleTextStyle: AppTextStyle.bodyText,
                                confirm: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    withdrawController.deleteWithdraw(withdraw.id!, true);
                                  },
                                  child: Text('حذف', style: AppTextStyle.bodyText),
                                ),
                              );
                            }
                          },
                          child: Row(children: [
                            Text(' حذف', style: AppTextStyle.labelText.copyWith(color: AppColor.accentColor)),
                            SvgPicture.asset('assets/svg/trash-bin.svg', colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn)),
                          ]),
                        ),
                        // مشاهده
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/withdrawGetOne', parameters: {"id": withdraw.id.toString()});
                          },
                          child: Row(children: [
                            Text(' مشاهده', style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor)),
                            SvgPicture.asset('assets/svg/eye1.svg', colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn)),
                          ]),
                        ),
                        // ویرایش
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/withdrawUpdate', parameters: {"id": withdraw.id.toString()});
                          },
                          child: Row(children: [
                            Text(' ویرایش', style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor)),
                            SvgPicture.asset('assets/svg/edit.svg', colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn)),
                          ]),
                        ),
                      ],
                    ),

                    // وضعیت و تعیین وضعیت
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text('وضعیت: ', style: AppTextStyle.bodyText),
                          Text(
                            '${withdraw.status == 0 ? 'در انتظار' : withdraw.status == 1 ? 'تایید شده' : 'تایید نشده'} ',
                            style: AppTextStyle.bodyText.copyWith(
                              color: withdraw.status == 1
                                  ? AppColor.primaryColor
                                  : withdraw.status == 2
                                  ? AppColor.accentColor
                                  : AppColor.textColor,
                            ),
                          ),
                        ]),
                        withdraw.status == 0
                            ? const SizedBox.shrink()
                            : IconButton(
                          onPressed: () {
                            withdrawController.fetchDepositRequestList(withdraw.id!);
                            withdrawController.toggleItemExpansion(index);
                          },
                          icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: isExpanded ? AppColor.accentColor : AppColor.primaryColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: PopupMenuButton<int>(
                            splashRadius: 10,
                            tooltip: 'تعیین وضعیت',
                            onSelected: (value) async {
                              if (value == 2) {
                                if (withdraw.depositRequestCount != 0 || withdraw.depositCount != 0) {
                                  Get.defaultDialog(
                                    title: 'هشدار',
                                    middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                    titleStyle: AppTextStyle.smallTitleText,
                                    middleTextStyle: AppTextStyle.bodyText,
                                    backgroundColor: AppColor.backGroundColor,
                                    textCancel: 'بستن',
                                  );
                                } else {
                                  await withdrawController.showReasonRejectionDialog("WithdrawRequest");
                                  if (withdrawController.selectedReasonRejection.value == null) {
                                    return;
                                  }
                                  await withdrawController.updateStatusWithdraw(
                                    withdraw.id!,
                                    value,
                                    withdrawController.selectedReasonRejection.value!.id!,
                                  );
                                  withdrawController.getWithdrawListPager();
                                }
                              } else {
                                await withdrawController.updateStatusWithdraw(withdraw.id!, value, 0);
                                withdrawController.getWithdrawListPager();
                              }
                            },
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            color: AppColor.backGroundColor,
                            constraints: const BoxConstraints(minWidth: 70, maxWidth: 70),
                            position: PopupMenuPosition.under,
                            offset: const Offset(0, 0),
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                height: 18,
                                labelTextStyle: WidgetStateProperty.all(AppTextStyle.madiumbodyText),
                                value: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    withdrawController.isLoading.value
                                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor))
                                        : Text('تایید', style: AppTextStyle.madiumbodyText.copyWith(color: AppColor.primaryColor, fontSize: 14)),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<int>(
                                height: 18,
                                value: 2,
                                labelTextStyle: WidgetStateProperty.all(AppTextStyle.madiumbodyText),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    withdrawController.isLoading.value
                                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor))
                                        : Text('رد', style: AppTextStyle.madiumbodyText.copyWith(color: AppColor.accentColor, fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                            child: Text(
                              'تعیین وضعیت',
                              style: AppTextStyle.bodyText.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColor.textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    if (withdraw.status == 2)
                      Wrap(children: [
                        Text('به دلیل ', style: AppTextStyle.labelText),
                        Text("`${withdraw.reasonRejection?.name}`", style: AppTextStyle.bodyText),
                        Text('رد شد.', style: AppTextStyle.labelText),
                      ]),
                  ],
                ),
                minVerticalPadding: 5,
              ),

              // بخش درخواست‌های واریزی (expandable)
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: _DepositRequestListMobile(withdrawController: withdrawController, withdraw: withdraw),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DepositRequestListMobile extends StatelessWidget {
  final WithdrawController withdrawController;
  final WithdrawModel withdraw;
  const _DepositRequestListMobile({required this.withdrawController, required this.withdraw});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            withdrawController.isLoadingDepositRequestList.value
                ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor))
                : withdrawController.depositRequestList.isEmpty
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('هیچ شخصی جهت واریز مشخص نشده است', style: AppTextStyle.labelText),
                const SizedBox(width: 125),
                SizedBox(
                  width: 25,
                  height: 25,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        backgroundColor: AppColor.backGroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return InsertDepositRequestWidget(id: withdraw.id!);
                        },
                      ).whenComplete(() {
                        withdrawController.clearList();
                      });
                      withdrawController.filterAccountListFunc(withdraw.wallet!.account!.id!.toInt());
                    },
                    child: SvgPicture.asset('assets/svg/add.svg', colorFilter: ColorFilter.mode(AppColor.buttonColor, BlendMode.srcIn)),
                  ),
                ),
              ],
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: withdrawController.depositRequestList.length,
              itemBuilder: (context, index) {
                final depositRequests = withdrawController.depositRequestList[index];
                return ListTile(
                  title: Card(
                    color: AppColor.backGroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                color: depositRequests.status == 2
                                    ? AppColor.accentColor
                                    : depositRequests.status == 1
                                    ? AppColor.primaryColor
                                    : AppColor.secondaryColor,
                                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    depositRequests.status == 2
                                        ? 'تایید نشده'
                                        : depositRequests.status == 1
                                        ? 'تایید شده'
                                        : 'در انتظار',
                                    style: AppTextStyle.labelText,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(depositRequests.account!.name ?? "", style: AppTextStyle.bodyText),
                            const SizedBox(height: 2),
                            Row(children: [
                              Text('مبلغ کل:', style: AppTextStyle.bodyText),
                              const SizedBox(width: 4),
                              Text("${depositRequests.amount?.toInt().toString().seRagham(separator: ',')} ریال", style: AppTextStyle.bodyText),
                            ]),
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            Text('مبلغ واریز شده:', style: AppTextStyle.bodyText),
                            const SizedBox(width: 4),
                            Text("${depositRequests.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                                style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor)),
                          ]),
                          const SizedBox(height: 4),
                          if (depositRequests.status == 2)
                            Row(children: [
                              Text('دلیل رد: ', style: AppTextStyle.labelText),
                              const SizedBox(width: 3),
                              Text("`${depositRequests.reasonRejection?.name}`" ?? "", style: AppTextStyle.bodyText),
                            ]),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: PopupMenuButton<int>(
                              splashRadius: 10,
                              tooltip: 'تعیین وضعیت',
                              onSelected: (value) async {
                                if (value == 2) {
                                  if (depositRequests.depositCount != 0) {
                                    Get.defaultDialog(
                                      title: 'هشدار',
                                      middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                      titleStyle: AppTextStyle.smallTitleText,
                                      middleTextStyle: AppTextStyle.bodyText,
                                      backgroundColor: AppColor.backGroundColor,
                                      textCancel: 'بستن',
                                    );
                                  } else {
                                    await withdrawController.showReasonRejectionDialog("DepositRequest");
                                    if (withdrawController.selectedReasonRejection.value == null) {
                                      return;
                                    }
                                    await withdrawController.updateStatusDepositRequest(
                                      depositRequests.id!,
                                      value,
                                      withdrawController.selectedReasonRejection.value!.id!,
                                    );
                                    withdrawController.fetchDepositRequestList(withdraw.id!);
                                  }
                                } else {
                                  await withdrawController.updateStatusDepositRequest(
                                    depositRequests.id!,
                                    value,
                                    0,
                                  );
                                  withdrawController.fetchDepositRequestList(withdraw.id!);
                                }
                              },
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              color: AppColor.backGroundColor,
                              constraints: const BoxConstraints(minWidth: 70, maxWidth: 70),
                              position: PopupMenuPosition.under,
                              offset: const Offset(0, 0),
                              itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  height: 18,
                                  labelTextStyle: WidgetStateProperty.all(AppTextStyle.madiumbodyText),
                                  value: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      withdrawController.isLoading.value
                                          ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor))
                                          : Text('تایید', style: AppTextStyle.madiumbodyText.copyWith(color: AppColor.primaryColor, fontSize: 14)),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem<int>(
                                  height: 18,
                                  value: 2,
                                  labelTextStyle: WidgetStateProperty.all(AppTextStyle.madiumbodyText),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      withdrawController.isLoading.value
                                          ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor))
                                          : Text('رد', style: AppTextStyle.madiumbodyText.copyWith(color: AppColor.accentColor, fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                              child: Text('تعیین وضعیت', style: AppTextStyle.bodyText.copyWith(decoration: TextDecoration.underline, decorationColor: AppColor.textColor)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Divider(height: 1, color: AppColor.secondaryColor),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // add
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: GestureDetector(
                                  onTap: () {
                                    if (depositRequests.paidAmount! < depositRequests.amount!) {
                                      Get.toNamed('/depositCreate', arguments: depositRequests);
                                    } else {
                                      Get.defaultDialog(
                                        title: 'هشدار',
                                        middleText: 'مبلغ باقیمانده برای واریزی صفر است.',
                                        titleStyle: AppTextStyle.smallTitleText,
                                        middleTextStyle: AppTextStyle.bodyText,
                                        backgroundColor: AppColor.backGroundColor,
                                        textCancel: 'بستن',
                                      );
                                    }
                                  },
                                  child: SvgPicture.asset('assets/svg/add.svg', colorFilter: ColorFilter.mode(AppColor.buttonColor, BlendMode.srcIn)),
                                ),
                              ),
                              // delete
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: GestureDetector(
                                  onTap: () {
                                    if (depositRequests.depositCount != 0) {
                                      Get.defaultDialog(
                                        title: 'هشدار',
                                        middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                        titleStyle: AppTextStyle.smallTitleText,
                                        middleTextStyle: AppTextStyle.bodyText,
                                        backgroundColor: AppColor.backGroundColor,
                                        textCancel: 'بستن',
                                      );
                                    } else {
                                      Get.defaultDialog(
                                        backgroundColor: AppColor.backGroundColor,
                                        title: "حذف درخواست واریزی",
                                        titleStyle: AppTextStyle.smallTitleText,
                                        middleText: "آیا از حذف درخواست واریزی مطمئن هستید؟",
                                        middleTextStyle: AppTextStyle.bodyText,
                                        confirm: ElevatedButton(
                                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor)),
                                          onPressed: () {
                                            Get.back();
                                            withdrawController.deleteDepositRequest(withdraw.id!, depositRequests.id!, true);
                                          },
                                          child: Text('حذف', style: AppTextStyle.bodyText),
                                        ),
                                      );
                                    }
                                  },
                                  child: SvgPicture.asset('assets/svg/trash-bin.svg', colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn)),
                                ),
                              ),
                              // view
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/depositRequestGetOne', parameters: {"id": depositRequests.id.toString()});
                                  },
                                  child: SvgPicture.asset('assets/svg/eye1.svg', colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn)),
                                ),
                              ),
                              // edit
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: GestureDetector(
                                  onTap: () {
                                    withdrawController.setDepositRequestDetail(depositRequests);
                                    showModalBottomSheet(
                                      enableDrag: true,
                                      context: context,
                                      backgroundColor: AppColor.backGroundColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      builder: (context) {
                                        return UpdateDepositRequestWidget(withdrawId: withdraw.id!, depositRequest: depositRequests);
                                      },
                                    ).whenComplete(() {
                                      withdrawController.clearList();
                                    });
                                  },
                                  child: SvgPicture.asset('assets/svg/edit.svg', colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/deposit_request_create.view.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'deposit_request_update.view.dart';

class WithdrawsListView extends StatelessWidget {
  WithdrawsListView({super.key});

  final WithdrawController withdrawController = Get.find<WithdrawController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(title: 'لیست درخواست های برداشت',
        onBackTap: () => Get.offNamed('/home'),
      ),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: Get.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          //فیلد جستجو
                          Expanded(
                            child: SizedBox(
                              height: 41,
                              child: TextFormField(
                                controller: withdrawController.searchController,
                                style: AppTextStyle.labelText,
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    await withdrawController.searchAccounts(value);
                                    showSearchResults(context);
                                  } else {
                                    withdrawController.clearSearch();
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
                                        if (withdrawController.searchController.text
                                            .isNotEmpty) {
                                          await withdrawController.searchAccounts(
                                              withdrawController.searchController
                                                  .text
                                          );
                                          showSearchResults(context);
                                        } else {
                                          withdrawController.clearSearch();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.search, color: AppColor.textColor,
                                        size: 30,)
                                  ),
                                  suffixIcon: withdrawController.selectedAccountId
                                      .value > 0
                                      ? IconButton(
                                    onPressed: withdrawController.clearSearch,
                                    icon: Icon(
                                        Icons.close, color: AppColor.textColor),
                                  )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          //دکمه ایجاد درخواست برداشت جدید
                          ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 7)),
                                elevation: WidgetStatePropertyAll(5),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.buttonColor),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)))),
                            onPressed: () {
                              Get.toNamed('/withdrawCreate');
                            },
                            child: Text(
                              'ایجاد درخواست برداشت جدید',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (withdrawController.state.value == PageState.loading) {
                        return Center(child: CircularProgressIndicator());
                      } else
                      if (withdrawController.state.value == PageState.empty) {
                        return EmptyPage(
                          title: 'درخواستی وجود ندارد',
                          callback: () {
                            withdrawController.fetchWithdrawList();
                          },
                        );
                      } else if (withdrawController.state.value == PageState.list) {
                        return isDesktop ?
                        Expanded(
                                     child: SingleChildScrollView(
                                       scrollDirection: Axis.horizontal,
                                       child: Row(
                                         children: [
                                           SingleChildScrollView(
                                             child: Column(
                                               children: [
                                                 DataTable(
                                                   columns: buildDataColumns(),
                                                   rows: buildDataRows(context),
                                                   dataRowMaxHeight: double.infinity,
                                                   dividerThickness: 0.3,
                                                   border: TableBorder.symmetric(inside: BorderSide(color: AppColor.textFieldColor,width: 0.5)),
                                                   //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                                   //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                                   headingRowHeight: 40,
                                                   columnSpacing: 40,
                                                   horizontalMargin: 6,
                                                 ),
                                                 buildPaginationControls(),
                                               ],
                                             ),
                                           ),
                                           ...withdrawController.withdrawList.map((
                                               withdraw) {
                                             return buildExpandedContent(withdraw);
                                           })
                                         ],
                                       ),
                                     ),
                                   )
                            :
                        Expanded(
                          child: ListView.builder(
                            controller: withdrawController.scrollController,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: withdrawController.withdrawList.length +
                                (withdrawController.hasMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              print(withdrawController.withdrawList.length);
                              if (index >= withdrawController.withdrawList.length) {
                                return withdrawController.hasMore.value
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox.shrink();
                              }
                              var withdraws = withdrawController
                                  .withdrawList[index];
                              return
                                Obx(() {
                                  bool isExpanded = withdrawController
                                      .isItemExpanded(index);
                                  return Card(
                                    margin: EdgeInsets.all(isDesktop ? 12 : 8),
                                    color: AppColor.secondaryColor,
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          isDesktop ? 16 : 8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: Column(
                                              children: [

                                                //  تاریخ
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(withdraws.status == 0
                                                        ?
                                                    withdraws.requestDate
                                                        ?.toPersianDate(
                                                      twoDigits: true,
                                                      showTime: true,
                                                      timeSeprator: '-',) ??
                                                        'نامشخص'
                                                        :
                                                    withdraws.confirmDate
                                                        ?.toPersianDate(
                                                      twoDigits: true,
                                                      showTime: true,
                                                      timeSeprator: '-',) ??
                                                        'نامشخص'
                                                      ,
                                                      style:
                                                      AppTextStyle.bodyText,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                SizedBox(width: 100,
                                                  child: Divider(
                                                    height: 1, color: AppColor
                                                      .dividerColor,),),
                                                SizedBox(height: 8,),

                                                // نام کاربر و نام دارنده حساب
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('نام کاربر',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(height: 2,),
                                                        Text(withdraws.wallet
                                                            ?.account?.name
                                                            ?? "",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('نام دارنده حساب',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(height: 2,),
                                                        Text("${withdraws
                                                            .bankAccount
                                                            ?.ownerName ??
                                                            ""}""(${withdraws
                                                            .bankAccount?.bank
                                                            ?.name ?? ""})",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ),
                                                  ],

                                                ),
                                                SizedBox(height: 6,),

                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    //  مبلغ کل و مبلغ تایید نشده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('مبلغ کل: ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            SizedBox(width: 3,),
                                                            Text("${withdraws
                                                                .amount?.toInt()
                                                                .toString()
                                                                .seRagham(
                                                                separator: ',')} ریال",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'مبلغ تایید نشده: ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            SizedBox(width: 3,),
                                                            Text("${withdraws
                                                                .notConfirmedAmount ==
                                                                null ? 0 :
                                                            withdraws
                                                                .notConfirmedAmount
                                                                ?.toInt()
                                                                .toString()
                                                                .seRagham(
                                                                separator: ',')} ریال",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),

                                                    // مبلغ مانده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('مبلغ مانده: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(width: 3,),
                                                        Text("${withdraws
                                                            .undividedAmount ==
                                                            null ? 0 :
                                                        withdraws
                                                            .undividedAmount
                                                            ?.toInt()
                                                            .toString()
                                                            .seRagham(
                                                            separator: ',')} ریال",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),

                                                    // مبلغ واریز شده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('مبلغ واریز شده: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(width: 3,),
                                                        Text("${withdraws
                                                            .paidAmount == null
                                                            ? 0
                                                            : withdraws
                                                            .paidAmount?.toInt()
                                                            .toString()
                                                            .seRagham(
                                                            separator: ',')} ریال",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),
                                                    // دلیل رد
                                                    withdraws.status == 2 ?
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('دلیل رد: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(width: 3,),
                                                        Text("`${withdraws
                                                            .reasonRejection
                                                            ?.name}`" ?? "",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ) : Text(""),
                                                  ],
                                                ),
                                                SizedBox(height: 4,),
                                                Divider(height: 1,),
                                                SizedBox(height: 5,),

                                                //  آیکون ها
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    // آیکون اضافه کردن درخواست deposit request
                                                    GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          enableDrag: true,
                                                          context: context,
                                                          backgroundColor: AppColor
                                                              .backGroundColor,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .vertical(
                                                                top: Radius
                                                                    .circular(
                                                                    20)),
                                                          ),
                                                          builder: (context) {
                                                            return InsertDepositRequestWidget(
                                                              id: withdraws.id!,
                                                              walletId: withdraws
                                                                  .wallet!
                                                                  .id!,);
                                                          },
                                                        ).whenComplete(() {
                                                          withdrawController
                                                              .clearList();
                                                        }
                                                        );
                                                        withdrawController
                                                            .filterAccountListFunc(
                                                            withdraws.wallet!
                                                                .account!.id!
                                                                .toInt());
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' تقسیم',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                color: AppColor
                                                                    .buttonColor),),
                                                          SvgPicture.asset(
                                                              'assets/svg/add.svg',
                                                              colorFilter: ColorFilter
                                                                  .mode(AppColor
                                                                  .buttonColor,
                                                                BlendMode
                                                                    .srcIn,)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // آیکون حذف کردن
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (withdraws
                                                            .depositRequestCount !=
                                                            0 || withdraws
                                                            .depositCount !=
                                                            0) {
                                                          Get.defaultDialog(
                                                            title: 'هشدار',
                                                            middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                                            titleStyle: AppTextStyle
                                                                .smallTitleText,
                                                            middleTextStyle: AppTextStyle
                                                                .bodyText,
                                                            backgroundColor: AppColor
                                                                .backGroundColor,
                                                            textCancel: 'بستن',
                                                          );
                                                        } else {
                                                          Get.defaultDialog(
                                                              backgroundColor: AppColor
                                                                  .backGroundColor,
                                                              title: "حذف درخواست برداشت",
                                                              titleStyle: AppTextStyle
                                                                  .smallTitleText,
                                                              middleText: "آیا از حذف درخواست برداشت مطمئن هستید؟",
                                                              middleTextStyle: AppTextStyle
                                                                  .bodyText,
                                                              confirm: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor: WidgetStatePropertyAll(
                                                                          AppColor
                                                                              .primaryColor)),
                                                                  onPressed: () {
                                                                    Get
                                                                        .back();
                                                                    withdrawController
                                                                        .deleteWithdraw(
                                                                        withdraws
                                                                            .id!,
                                                                        true);
                                                                    //withdrawController.fetchWithdrawList();
                                                                  },
                                                                  child: Text(
                                                                    'حذف',
                                                                    style: AppTextStyle
                                                                        .bodyText,
                                                                  )));
                                                          //withdrawController.fetchWithdrawList();
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' حذف',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                color: AppColor
                                                                    .accentColor),),
                                                           SvgPicture
                                                                .asset(
                                                                'assets/svg/trash-bin.svg',
                                                                colorFilter: ColorFilter
                                                                    .mode(AppColor
                                                                    .accentColor,
                                                                  BlendMode
                                                                      .srcIn,)
                                                            ),

                                                        ],
                                                      ),
                                                    ),
                                                    // آیکون مشاهده
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed('/withdrawGetOne', parameters:{"id":withdraws.id.toString()});
                                                        //print(withdraws.id);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' مشاهده',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                color: AppColor
                                                                    .iconViewColor),),
                                                          SvgPicture.asset(
                                                              'assets/svg/eye1.svg',
                                                              colorFilter: ColorFilter
                                                                  .mode(AppColor
                                                                  .iconViewColor,
                                                                BlendMode
                                                                    .srcIn,)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // آیکون ویرایش
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (withdraws
                                                            .depositRequestCount !=
                                                            0 || withdraws
                                                            .depositCount !=
                                                            0) {
                                                          Get.defaultDialog(
                                                            title: 'هشدار',
                                                            middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                                                            titleStyle: AppTextStyle
                                                                .smallTitleText,
                                                            middleTextStyle: AppTextStyle
                                                                .bodyText,
                                                            backgroundColor: AppColor
                                                                .backGroundColor,
                                                            textCancel: 'بستن',
                                                          );
                                                        } else {
                                                          Get.toNamed(
                                                              '/withdrawUpdate',
                                                              arguments: withdraws);
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' ویرایش',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                color: AppColor
                                                                    .iconViewColor),),
                                                           SvgPicture
                                                                .asset(
                                                                'assets/svg/edit.svg',
                                                                colorFilter: ColorFilter
                                                                    .mode(AppColor
                                                                    .iconViewColor,
                                                                  BlendMode
                                                                      .srcIn,)
                                                            ),

                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // تعیین وضعیت
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    // وضعیت
                                                    Row(
                                                      children: [
                                                        Text('وضعیت: ',
                                                            style: AppTextStyle
                                                                .bodyText),
                                                        Text(
                                                          '${withdraws.status ==
                                                              0
                                                              ? 'نامشخص'
                                                              : withdraws
                                                              .status == 1
                                                              ? 'تایید شده'
                                                              : 'تایید نشده'} ',
                                                          style: AppTextStyle
                                                              .bodyText
                                                              .copyWith(
                                                            color: withdraws
                                                                .status == 1
                                                                ? AppColor
                                                                .primaryColor
                                                                : withdraws
                                                                .status == 2
                                                                ? AppColor
                                                                .accentColor
                                                                : AppColor
                                                                .textColor,
                                                          )
                                                          ,),
                                                      ],
                                                    ),

                                                    // دکمه نمایش لیست deposit request
                                                    IconButton(
                                                      onPressed: () {
                                                        withdrawController
                                                            .fetchDepositRequestList(
                                                            withdraws.id!);
                                                        withdrawController
                                                            .toggleItemExpansion(
                                                            index);
                                                      },
                                                      icon: Icon(
                                                        isExpanded ? Icons
                                                            .expand_less : Icons
                                                            .expand_more,
                                                        color: isExpanded ?
                                                        AppColor.accentColor :
                                                        AppColor.primaryColor,
                                                      ),
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
                                                        onSelected: (
                                                            value) async {
                                                          if (value == 2) {
                                                            await withdrawController
                                                                .showReasonRejectionDialog(
                                                                "WithdrawRequest");
                                                            if (withdrawController
                                                                .selectedReasonRejection
                                                                .value ==
                                                                null) {
                                                              return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                                            }
                                                            await withdrawController
                                                                .updateStatusWithdraw(
                                                              withdraws.id!,
                                                              value,
                                                              withdrawController
                                                                  .selectedReasonRejection
                                                                  .value!.id!,
                                                            );
                                                          } else {
                                                            await withdrawController
                                                                .updateStatusWithdraw(
                                                                withdraws.id!,
                                                                value, 0);
                                                          }
                                                          withdrawController
                                                              .fetchWithdrawList();
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
                                                          PopupMenuItem<int>(height: 18,
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
                                                                withdrawController
                                                                    .isLoading
                                                                    .value
                                                                    ?
                                                                CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                      Color>(
                                                                      AppColor
                                                                          .textColor),
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
                                                          PopupMenuItem<int>(height: 18,
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
                                                                withdrawController
                                                                    .isLoading
                                                                    .value
                                                                    ?
                                                                CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                      Color>(
                                                                      AppColor
                                                                          .textColor),
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
                                                            onTap: () async {

                                                              /*if (withdrawController.selectedReasonRejection.value != null) {
                                                                      await withdrawController.updateStatusWithdraw(withdraws.id!, 2,withdrawController.selectedReasonRejection.value?.id ?? 0);
                                                                    }*/
                                                            },
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

                                          // لیست deposit request
                                          AnimatedSize(
                                            duration: Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            child: isExpanded ?
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  SizedBox(height: 8,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      withdrawController
                                                          .isLoadingDepositRequestList
                                                          .value ?
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<
                                                            Color>(
                                                            AppColor.textColor),
                                                      ) : withdrawController
                                                          .depositRequestList
                                                          .isEmpty
                                                          ?
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'هیچ شخصی جهت واریز مشخص نشده است',
                                                              style: AppTextStyle
                                                                  .labelText),
                                                          SizedBox(width: 125,),
                                                          Container(
                                                            width: 25,
                                                            height: 25,
                                                            child: GestureDetector(

                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                  enableDrag: true,
                                                                  context: context,
                                                                  backgroundColor: AppColor
                                                                      .backGroundColor,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .vertical(
                                                                        top: Radius
                                                                            .circular(
                                                                            20)),
                                                                  ),
                                                                  builder: (
                                                                      context) {
                                                                    return InsertDepositRequestWidget(
                                                                        id: withdraws
                                                                            .id!);
                                                                  },
                                                                )
                                                                    .whenComplete(() {
                                                                  withdrawController
                                                                      .clearList();
                                                                }
                                                                );
                                                                withdrawController
                                                                    .filterAccountListFunc(
                                                                    withdraws
                                                                        .wallet!
                                                                        .account!
                                                                        .id!
                                                                        .toInt());
                                                              },

                                                              child: SvgPicture
                                                                  .asset(
                                                                  'assets/svg/add.svg',
                                                                  colorFilter: ColorFilter
                                                                      .mode(
                                                                    AppColor
                                                                        .buttonColor,
                                                                    BlendMode
                                                                        .srcIn,)
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                          :
                                                      // لیست deposit request مربوط به هر درخواست برداشت
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: ClampingScrollPhysics(),
                                                          itemCount: withdrawController
                                                              .depositRequestList
                                                              .length,
                                                          itemBuilder: (context,
                                                              index) {
                                                            var depositRequests = withdrawController
                                                                .depositRequestList[index];
                                                            return ListTile(
                                                              title: Card(
                                                                color: AppColor
                                                                    .backGroundColor,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 8,
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 8),
                                                                  child: Column(
                                                                    children: [

                                                                      // تاریخ و وضعیت
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  'تاریخ:',
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                              SizedBox(
                                                                                width: 4,),
                                                                              Text(
                                                                                depositRequests
                                                                                    .status ==
                                                                                    0
                                                                                    ?
                                                                                depositRequests
                                                                                    .date
                                                                                    ?.toPersianDate(
                                                                                    showTime: true,
                                                                                    twoDigits: true,
                                                                                    timeSeprator: '-') ??
                                                                                    ""
                                                                                    : depositRequests
                                                                                    .confirmDate
                                                                                    ?.toPersianDate(
                                                                                    showTime: true,
                                                                                    twoDigits: true,
                                                                                    timeSeprator: '-') ??
                                                                                    "",
                                                                                style: AppTextStyle
                                                                                    .bodyText,
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          // وضعیت
                                                                          Card(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  5),
                                                                            ),
                                                                            color: depositRequests
                                                                                .status ==
                                                                                2
                                                                                ? AppColor
                                                                                .accentColor
                                                                                : depositRequests
                                                                                .status ==
                                                                                1
                                                                                ? AppColor
                                                                                .primaryColor
                                                                                : AppColor
                                                                                .secondaryColor
                                                                            ,
                                                                            margin: EdgeInsets
                                                                                .symmetric(
                                                                                vertical: 0,
                                                                                horizontal: 5),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets
                                                                                  .all(
                                                                                  2),
                                                                              child: Text(
                                                                                  depositRequests
                                                                                      .status ==
                                                                                      2
                                                                                      ? 'تایید نشده'
                                                                                      : depositRequests
                                                                                      .status ==
                                                                                      1
                                                                                      ? 'تایید شده'
                                                                                      : 'نامشخص',
                                                                                  style: AppTextStyle
                                                                                      .labelText,
                                                                                  textAlign: TextAlign
                                                                                      .center),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,),
                                                                      // نام کاربر و مبلغ کل
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            depositRequests
                                                                                .account!
                                                                                .name ??
                                                                                "",
                                                                            style: AppTextStyle
                                                                                .bodyText,),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .spaceEvenly,
                                                                            children: [
                                                                              Text(
                                                                                  'مبلغ کل:',
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                              SizedBox(
                                                                                width: 4,),
                                                                              Text(
                                                                                "${depositRequests
                                                                                    .amount
                                                                                    ?.toInt()
                                                                                    .toString()
                                                                                    .seRagham(
                                                                                    separator: ',')} ریال",
                                                                                style: AppTextStyle
                                                                                    .bodyText,),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      SizedBox(
                                                                        height: 4,),

                                                                      // مبلغ واریز شده
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                              'مبلغ واریز شده:',
                                                                              style: AppTextStyle
                                                                                  .bodyText),
                                                                          SizedBox(
                                                                            width: 4,),
                                                                          Text(
                                                                            "${depositRequests
                                                                                .paidAmount
                                                                                ?.toInt()
                                                                                .toString()
                                                                                .seRagham(
                                                                                separator: ',')} ریال",
                                                                            style: AppTextStyle
                                                                                .bodyText,),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 4,),

                                                                      // دلیل رد
                                                                      depositRequests
                                                                          .status ==
                                                                          2 ?
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          Text(
                                                                            'دلیل رد: ',
                                                                            style: AppTextStyle
                                                                                .labelText,),
                                                                          SizedBox(
                                                                            width: 3,),
                                                                          Text(
                                                                            "`${depositRequests
                                                                                .reasonRejection
                                                                                ?.name}`" ??
                                                                                "",
                                                                            style: AppTextStyle
                                                                                .bodyText,),
                                                                        ],
                                                                      ) : Text(
                                                                          ""),
                                                                      //  تعیین وضعیت
                                                                      Container(
                                                                        alignment: Alignment
                                                                            .centerLeft,
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 0,
                                                                            vertical: 0),
                                                                        child: PopupMenuButton<
                                                                            int>(
                                                                          splashRadius: 10,
                                                                          tooltip: 'تعیین وضعیت',
                                                                          onSelected: (
                                                                              value) async {
                                                                            if (value ==
                                                                                2) {
                                                                              await withdrawController
                                                                                  .showReasonRejectionDialog(
                                                                                  "DepositRequest");
                                                                              if (withdrawController
                                                                                  .selectedReasonRejection
                                                                                  .value ==
                                                                                  null) {
                                                                                return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                                                              }
                                                                              await withdrawController
                                                                                  .updateStatusDepositRequest(
                                                                                depositRequests
                                                                                    .id!,
                                                                                value,
                                                                                withdrawController
                                                                                    .selectedReasonRejection
                                                                                    .value!
                                                                                    .id!,
                                                                              );
                                                                            } else {
                                                                              await withdrawController
                                                                                  .updateStatusDepositRequest(
                                                                                  depositRequests
                                                                                      .id!,
                                                                                  value,
                                                                                  0);
                                                                            }
                                                                            withdrawController
                                                                                .fetchDepositRequestList(
                                                                                withdraws
                                                                                    .id!);
                                                                          },
                                                                          shape: const RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
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
                                                                              0,
                                                                              0),
                                                                          itemBuilder: (
                                                                              context) =>
                                                                          [
                                                                            PopupMenuItem<
                                                                                int>(height: 18,
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
                                                                                  withdrawController
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
                                                                                    'تایید',
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
                                                                            PopupMenuItem<
                                                                                int>(height: 18,
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
                                                                                  withdrawController
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
                                                                                    'رد',
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

                                                                      SizedBox(
                                                                        height: 4,),
                                                                      Divider(
                                                                        height: 1,
                                                                        color: AppColor
                                                                            .secondaryColor,),
                                                                      SizedBox(
                                                                        height: 5,),

                                                                      // دکمه های مربوط به عملیات اضافه-حذف-مشاهده و ویرایش
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          // آیکون اضافه کردن
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                Get
                                                                                    .offNamed(
                                                                                    '/depositCreate',
                                                                                    arguments: depositRequests);
                                                                              },
                                                                              child: SvgPicture
                                                                                  .asset(
                                                                                  'assets/svg/add.svg',
                                                                                  colorFilter: ColorFilter
                                                                                      .mode(
                                                                                    AppColor
                                                                                        .buttonColor,
                                                                                    BlendMode
                                                                                        .srcIn,)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // آیکون حذف کردن
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                if (withdraws
                                                                                    .depositCount !=
                                                                                    0) {
                                                                                  Get
                                                                                      .defaultDialog(
                                                                                    title: 'هشدار',
                                                                                    middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                                                                    titleStyle: AppTextStyle
                                                                                        .smallTitleText,
                                                                                    middleTextStyle: AppTextStyle
                                                                                        .bodyText,
                                                                                    backgroundColor: AppColor
                                                                                        .backGroundColor,
                                                                                    textCancel: 'بستن',
                                                                                  );
                                                                                } else {
                                                                                  Get
                                                                                      .defaultDialog(
                                                                                      backgroundColor: AppColor
                                                                                          .backGroundColor,
                                                                                      title: "حذف درخواست واریزی",
                                                                                      titleStyle: AppTextStyle
                                                                                          .smallTitleText,
                                                                                      middleText: "آیا از حذف درخواست واریزی مطمئن هستید؟",
                                                                                      middleTextStyle: AppTextStyle
                                                                                          .bodyText,
                                                                                      confirm: ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                              backgroundColor: WidgetStatePropertyAll(
                                                                                                  AppColor
                                                                                                      .primaryColor)),
                                                                                          onPressed: () {
                                                                                            Get
                                                                                                .back();
                                                                                            withdrawController
                                                                                                .deleteDepositRequest(
                                                                                                depositRequests
                                                                                                    .id!,
                                                                                                true);
                                                                                            //withdrawController.fetchWithdrawList();
                                                                                          },
                                                                                          child: Text(
                                                                                            'حذف',
                                                                                            style: AppTextStyle
                                                                                                .bodyText,
                                                                                          )));
                                                                                  //withdrawController.fetchWithdrawList();
                                                                                }
                                                                              },
                                                                              child: SvgPicture
                                                                                  .asset(
                                                                                  'assets/svg/trash-bin.svg',
                                                                                  colorFilter: ColorFilter
                                                                                      .mode(
                                                                                    AppColor
                                                                                        .accentColor,
                                                                                    BlendMode
                                                                                        .srcIn,)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // آیکون مشاهده
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                Get.toNamed('/depositRequestGetOne', parameters:{"id":depositRequests.id.toString()});
                                                                              },
                                                                              child: SvgPicture
                                                                                  .asset(
                                                                                  'assets/svg/eye1.svg',
                                                                                  colorFilter: ColorFilter
                                                                                      .mode(
                                                                                    AppColor
                                                                                        .iconViewColor,
                                                                                    BlendMode
                                                                                        .srcIn,)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // آیکون ویرایش
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                if (withdraws
                                                                                    .depositCount !=
                                                                                    0) {
                                                                                  Get
                                                                                      .defaultDialog(
                                                                                    title: 'هشدار',
                                                                                    middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                                                                                    titleStyle: AppTextStyle
                                                                                        .smallTitleText,
                                                                                    middleTextStyle: AppTextStyle
                                                                                        .bodyText,
                                                                                    backgroundColor: AppColor
                                                                                        .backGroundColor,
                                                                                    textCancel: 'بستن',
                                                                                  );
                                                                                } else {
                                                                                  withdrawController.setDepositRequestDetail(depositRequests);
                                                                                  showModalBottomSheet(
                                                                                    enableDrag: true,
                                                                                    context: context,
                                                                                    backgroundColor: AppColor
                                                                                        .backGroundColor,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .vertical(
                                                                                          top: Radius
                                                                                              .circular(
                                                                                              20)),
                                                                                    ),
                                                                                    builder: (
                                                                                        context) {
                                                                                      return UpdateDepositRequestWidget(
                                                                                        withdrawId: withdraws
                                                                                            .id!,
                                                                                        depositRequest: depositRequests,
                                                                                      );
                                                                                    },
                                                                                  )
                                                                                      .whenComplete(() {
                                                                                    withdrawController
                                                                                        .clearList();
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: SvgPicture
                                                                                  .asset(
                                                                                  'assets/svg/edit.svg',
                                                                                  colorFilter: ColorFilter
                                                                                      .mode(
                                                                                    AppColor
                                                                                        .iconViewColor,
                                                                                    BlendMode
                                                                                        .srcIn,)
                                                                              ),
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
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                                : SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            },
                          ),
                        );
                      }
                      return ErrPage(
                        callback: () {
                          withdrawController.fetchWithdrawList();
                        },
                        title: "خطا در دریافت لیست درخواست ها",
                        des: 'برای دریافت درخواست ها مجددا تلاش کنید',
                      );
                    },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(backgroundColor: AppColor.backGroundColor,
            title: Text('انتخاب کنید', style: AppTextStyle.smallTitleText,),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: withdrawController.searchedAccounts.length,
                itemBuilder: (context, index) {
                  final account = withdrawController.searchedAccounts[index];
                  return ListTile(
                    title: Text(account.name ?? '',
                      style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                    onTap: () => withdrawController.selectAccount(account),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('بستن', style: AppTextStyle.bodyText,),
              ),
            ],
          ),
    );
  }

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('تاریخ', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('نام کاربر', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('دارنده حساب', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ کل', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ مانده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ واریز شده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ تایید نشده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('وضعیت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('درخواست ها', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('عملیات', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return withdrawController.withdrawList.map((withdraw) {
      final index=withdrawController.withdrawList.indexOf(withdraw);
      final isExpanded = withdrawController.isItemExpanded(index);
      return DataRow(
        color: WidgetStatePropertyAll(
            isExpanded
                ? AppColor.secondaryColor.withAlpha(140)
                : AppColor.backGroundColor1
        ),

        cells: [
          // تاریخ
          DataCell(
              Center(
                child: Text(
                            withdraw.status == 0
                  ? withdraw.requestDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص'
                  : withdraw.confirmDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
                            style: AppTextStyle.bodyText,
                          ),
              )),
          // نام کاربر
          DataCell(
              Center(
                child: Text(withdraw.wallet?.account?.name ?? "",
                style: AppTextStyle.bodyText),
              )),
          // دارنده حساب
          DataCell(
              Center(
                child: Text(
                "${withdraw.bankAccount?.ownerName} (${withdraw.bankAccount?.bank
                    ?.name})", style: AppTextStyle.bodyText),
              )),
          // مبلغ کل
          DataCell(
              Center(
                child: Text(
                "${withdraw.amount?.toInt().toString().seRagham(separator: ',')} ریال",
                style: AppTextStyle.bodyText
                          ),
              )),
          // مبلغ مانده
          DataCell(
              Center(
                child: Text(
                            "${withdraw.undividedAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                style: AppTextStyle.bodyText,),
              )),
          // مبلغ واریز شده
          DataCell(
              Center(
                child: Text(
                            "${withdraw.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                style: AppTextStyle.bodyText,),
              )),
          // مبلغ تایید نشده
          DataCell(
              Center(
                child: Text(
                "${withdraw.notConfirmedAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                style: AppTextStyle.bodyText
                          ),
              )),
          // وضعیت
          DataCell(
            Center(
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Text(
                        '${withdraw.status == 0 ? 'نامشخص' : withdraw.status == 1
                            ? 'تایید شده'
                            : 'تایید نشده'} ',
                        style: AppTextStyle
                            .bodyText.copyWith(
                          color: withdraw.status == 1
                              ? AppColor.primaryColor
                              : withdraw.status == 2
                              ? AppColor.accentColor
                              : AppColor.textColor,
                        ),
                      ),
                  SizedBox(height: 6,),
                  Container(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal: 0,
                        vertical: 0),
                    child: PopupMenuButton<
                        int>(
                      splashRadius: 10,
                      tooltip: 'تعیین وضعیت',
                      onSelected: (
                          value) async {
                        if (value == 2) {
                          await withdrawController
                              .showReasonRejectionDialog(
                              "WithdrawRequest");
                          if (withdrawController
                              .selectedReasonRejection
                              .value ==
                              null) {
                            return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                          }
                          await withdrawController
                              .updateStatusWithdraw(
                            withdraw.id!,
                            value,
                            withdrawController
                                .selectedReasonRejection
                                .value!.id!,
                          );
                        } else {
                          await withdrawController
                              .updateStatusWithdraw(
                              withdraw.id!,
                              value, 0);
                        }
                        withdrawController
                            .fetchWithdrawList();
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
                        PopupMenuItem<int>(height: 18,
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
                              withdrawController
                                  .isLoading
                                  .value
                                  ?
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<
                                    Color>(
                                    AppColor
                                        .textColor),
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
                        PopupMenuItem<int>(height: 18,
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
                              withdrawController
                                  .isLoading
                                  .value
                                  ?
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<
                                    Color>(
                                    AppColor
                                        .textColor),
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
                          onTap: () async {

                            /*if (withdrawController.selectedReasonRejection.value != null) {
                                                                        await withdrawController.updateStatusWithdraw(withdraws.id!, 2,withdrawController.selectedReasonRejection.value?.id ?? 0);
                                                                      }*/
                          },
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
                  SizedBox(height: 6,),
                  withdraw.status == 2 ?
                  Wrap(
                    children: [
                      Text('به دلیل ',
                        style: AppTextStyle
                            .labelText,),
                      Text("`${withdraw
                          .reasonRejection
                          ?.name}`",
                        style: AppTextStyle
                            .bodyText,),
                      Text('رد شد.',
                        style: AppTextStyle
                            .labelText,),
                    ],
                  ) : Text(""),
                ],
              ),
            ),
          ),
          // نمایش درخواست های واریزی
          DataCell(
            Center(
              child: IconButton(
                icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more),
                color: isExpanded ? AppColor.accentColor : AppColor.primaryColor,
                onPressed: () {
                  withdrawController.toggleItemExpansion(
                      withdrawController.withdrawList.indexOf(withdraw));
                  withdrawController.fetchDepositRequestList(withdraw.id!);
                },
              ),
            ),
          ),
          // آیکون های عملیات
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // آیکون تقسیم
                  GestureDetector(
                    onTap: () {
                      withdrawController.balanceList.clear();
                      showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        backgroundColor: AppColor
                            .backGroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .vertical(
                              top: Radius
                                  .circular(
                                  20)),
                        ),
                        builder: (context) {
                          return InsertDepositRequestWidget(
                            id: withdraw.id!,
                            walletId: withdraw
                                .wallet!
                                .id!,);
                        },
                      ).whenComplete(() {
                        withdrawController
                            .clearList();
                      }
                      );
                      withdrawController
                          .filterAccountListFunc(
                          withdraw.wallet!
                              .account!.id!
                              .toInt());
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' تقسیم',
                          style: AppTextStyle
                              .bodyText
                              .copyWith(
                              color: AppColor
                                  .buttonColor),),
                        SvgPicture.asset(
                            'assets/svg/add.svg',width: 25,height: 25,
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .buttonColor,
                              BlendMode
                                  .srcIn,)
                        ),
                      ],
                    ),
                  ),
                  // آیکون حذف کردن
                  GestureDetector(
                    onTap: () {
                      if (withdraw.depositRequestCount != 0 || withdraw.depositCount != 0) {
                        Get.defaultDialog(
                          title: 'هشدار',
                          middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                          titleStyle: AppTextStyle
                              .smallTitleText,
                          middleTextStyle: AppTextStyle
                              .bodyText,
                          backgroundColor: AppColor
                              .backGroundColor,
                          textCancel: 'بستن',
                        );
                      } else {
                        Get.defaultDialog(
                            backgroundColor: AppColor
                                .backGroundColor,
                            title: "حذف درخواست برداشت",
                            titleStyle: AppTextStyle
                                .smallTitleText,
                            middleText: "آیا از حذف درخواست برداشت مطمئن هستید؟",
                            middleTextStyle: AppTextStyle
                                .bodyText,
                            confirm: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColor
                                            .primaryColor)),
                                onPressed: () {
                                  Get.back();
                                  withdrawController.deleteWithdraw(withdraw.id!, true);
                                },
                                child: Text(
                                  'حذف',
                                  style: AppTextStyle
                                      .bodyText,
                                )));
                        //withdrawController.fetchWithdrawList();
                      }
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' حذف',
                          style: AppTextStyle
                              .bodyText
                              .copyWith(
                              color: AppColor
                                  .accentColor),),
                        SvgPicture
                            .asset(
                            'assets/svg/trash-bin.svg',width: 25,height: 25,
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .accentColor,
                              BlendMode
                                  .srcIn,)
                        ),

                      ],
                    ),
                  ),
                  // آیکون مشاهده
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/withdrawGetOne', parameters:{"id":withdraw.id.toString()});
                      //print(withdraws.id);
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' مشاهده',
                          style: AppTextStyle
                              .bodyText
                              .copyWith(
                              color: AppColor
                                  .iconViewColor),),
                        SvgPicture.asset(
                            'assets/svg/eye1.svg',width: 25,height: 25,
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .iconViewColor,
                              BlendMode
                                  .srcIn,)
                        ),
                      ],
                    ),
                  ),
                  // آیکون ویرایش
                  GestureDetector(
                    onTap: () {
                      if (withdraw
                          .depositRequestCount !=
                          0 || withdraw
                          .depositCount !=
                          0) {
                        Get.defaultDialog(
                          title: 'هشدار',
                          middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                          titleStyle: AppTextStyle
                              .smallTitleText,
                          middleTextStyle: AppTextStyle
                              .bodyText,
                          backgroundColor: AppColor
                              .backGroundColor,
                          textCancel: 'بستن',
                        );
                      } else {
                        Get.toNamed(
                            '/withdrawUpdate',
                            arguments: withdraw);
                      }
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' ویرایش',
                          style: AppTextStyle
                              .bodyText
                              .copyWith(
                              color: AppColor
                                  .iconViewColor),),
                        SvgPicture
                            .asset(
                            'assets/svg/edit.svg',width: 25,height: 25,
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .iconViewColor,
                              BlendMode
                                  .srcIn,)
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget buildExpandedContent(WithdrawModel withdraw) {
    return Obx(() {
      return AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: withdrawController.isItemExpanded(
            withdrawController.withdrawList.indexOf(withdraw))
            ? buildDepositRequestsTable(withdraw)
            : SizedBox.shrink(),
      );
    });
  }

  Widget buildDepositRequestsTable(WithdrawModel withdraw) {
    return Obx(() {
      if (withdrawController.isLoadingDepositRequestList.value) {
        return SizedBox(width: 300,
            child: Center(child: CircularProgressIndicator()));
      }
      return
          withdrawController
              .isLoadingDepositRequestList
              .value ?
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<
                Color>(
                AppColor.textColor),
          ) :
          withdrawController.depositRequestList.isEmpty ?
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                Text(
                    'هیچ شخصی جهت واریز مشخص نشده است', style: AppTextStyle.smallTitleText),
                SizedBox(width: 125,),
              ],
            ),
          ) :
          // لیست deposit request مربوط به هر درخواست برداشت
          SingleChildScrollView(
            child: Column(
              children: [
                Text('لیست درخواست‌های واریز', style: AppTextStyle.smallTitleText),
                SizedBox(
                  width: Get.width*0.2,
                  height: Get.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: withdrawController
                        .depositRequestList
                        .length,
                    itemBuilder: (context,
                        index) {
                      var depositRequests = withdrawController
                          .depositRequestList[index];
                      return
                        ListTile(
                        title: Card(
                          color: AppColor.secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets
                                .only(
                                top: 8,
                                left: 12,
                                right: 12,
                                bottom: 8),
                            child: Column(
                              children: [
            
                                // تاریخ و وضعیت
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            'تاریخ:',
                                            style: AppTextStyle
                                                .bodyText),
                                        SizedBox(
                                          width: 4,),
                                        Text(
                                          depositRequests
                                              .status ==
                                              0
                                              ?
                                          depositRequests
                                              .date
                                              ?.toPersianDate(
                                              showTime: true,
                                              twoDigits: true,
                                              timeSeprator: '-') ??
                                              ""
                                              : depositRequests
                                              .confirmDate
                                              ?.toPersianDate(
                                              showTime: true,
                                              twoDigits: true,
                                              timeSeprator: '-') ??
                                              "",
                                          style: AppTextStyle
                                              .bodyText,
                                        ),
                                      ],
                                    ),
            
                                    // وضعیت
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .circular(
                                            5),
                                      ),
                                      color: depositRequests
                                          .status ==
                                          2
                                          ? AppColor
                                          .accentColor
                                          : depositRequests
                                          .status ==
                                          1
                                          ? AppColor
                                          .primaryColor
                                          : AppColor
                                          .secondaryColor
                                      ,
                                      margin: EdgeInsets
                                          .symmetric(
                                          vertical: 0,
                                          horizontal: 5),
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .all(
                                            2),
                                        child: Text(
                                            depositRequests
                                                .status ==
                                                2
                                                ? 'تایید نشده'
                                                : depositRequests
                                                .status ==
                                                1
                                                ? 'تایید شده'
                                                : 'نامشخص',
                                            style: AppTextStyle
                                                .labelText,
                                            textAlign: TextAlign
                                                .center),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,),
                                // نام کاربر
                                Row(
                                  children: [
                                    Text(
                                      depositRequests
                                          .account!
                                          .name ??
                                          "",
                                      style: AppTextStyle
                                          .bodyText,),
                                  ],
                                ),
            
                                SizedBox(
                                  height: 4,),
                                // مبلغ کل
                                Row(
                                  children: [
                                    Text(
                                        'مبلغ کل:',
                                        style: AppTextStyle
                                            .bodyText),
                                    SizedBox(
                                      width: 4,),
            
                                    Text(
                                      "${depositRequests
                                          .amount
                                          ?.toInt()
                                          .toString()
                                          .seRagham(
                                          separator: ',')} ریال",
                                      style: AppTextStyle
                                          .bodyText,),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,),
                                // مبلغ واریز شده
                                Row(
                                  children: [
                                    Text(
                                        'مبلغ واریز شده:',
                                        style: AppTextStyle
                                            .bodyText),
                                    SizedBox(
                                      width: 4,),
                                    Text(
                                      "${depositRequests
                                          .paidAmount
                                          ?.toInt()
                                          .toString()
                                          .seRagham(
                                          separator: ',')} ریال",
                                      style: AppTextStyle
                                          .bodyText,),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,),
            
                                // دلیل رد
                                depositRequests
                                    .status ==
                                    2 ?
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    Text(
                                      'دلیل رد: ',
                                      style: AppTextStyle
                                          .labelText,),
                                    SizedBox(
                                      width: 3,),
                                    Text(
                                      "`${depositRequests
                                          .reasonRejection
                                          ?.name}`" ??
                                          "",
                                      style: AppTextStyle
                                          .bodyText,),
                                  ],
                                ) : Text(
                                    ""),
                                //  تعیین وضعیت
                                Container(
                                  alignment: Alignment
                                      .centerLeft,
                                  padding: const EdgeInsets
                                      .symmetric(
                                      horizontal: 0,
                                      vertical: 0),
                                  child: PopupMenuButton<
                                      int>(
                                    splashRadius: 10,
                                    tooltip: 'تعیین وضعیت',
                                    onSelected: (
                                        value) async {
                                      if (value ==
                                          2) {
                                        await withdrawController
                                            .showReasonRejectionDialog(
                                            "DepositRequest");
                                        if (withdrawController
                                            .selectedReasonRejection
                                            .value ==
                                            null) {
                                          return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                        }
                                        await withdrawController
                                            .updateStatusDepositRequest(
                                          depositRequests
                                              .id!,
                                          value,
                                          withdrawController
                                              .selectedReasonRejection
                                              .value!
                                              .id!,
                                        );
                                      } else {
                                        await withdrawController
                                            .updateStatusDepositRequest(
                                            depositRequests
                                                .id!,
                                            value,
                                            0);
                                      }
                                      withdrawController
                                          .fetchDepositRequestList(
                                          withdraw
                                              .id!);
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .all(
                                          Radius
                                              .circular(
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
                                        0,
                                        0),
                                    itemBuilder: (
                                        context) =>
                                    [
                                      PopupMenuItem<
                                          int>(height: 18,
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
                                            withdrawController
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
                                              'تایید',
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
                                      PopupMenuItem<
                                          int>(height: 18,
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
                                            withdrawController
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
                                              'رد',
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
            
                                SizedBox(
                                  height: 4,),
                                Divider(
                                  height: 1,
                                  color: AppColor
                                      .secondaryColor,),
                                SizedBox(
                                  height: 5,),
            
                                // دکمه های مربوط به عملیات اضافه-حذف-مشاهده و ویرایش
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    // آیکون اضافه کردن
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              '/depositCreate',
                                              arguments: depositRequests);
                                        },
                                        child: SvgPicture
                                            .asset(
                                            'assets/svg/add.svg',
                                            colorFilter: ColorFilter
                                                .mode(
                                              AppColor
                                                  .buttonColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                      ),
                                    ),
                                    // آیکون حذف کردن
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (depositRequests.depositCount != 0) {
                                            Get
                                                .defaultDialog(
                                              title: 'هشدار',
                                              middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                              titleStyle: AppTextStyle
                                                  .smallTitleText,
                                              middleTextStyle: AppTextStyle
                                                  .bodyText,
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              textCancel: 'بستن',
                                            );
                                          } else {
                                            Get
                                                .defaultDialog(
                                                backgroundColor: AppColor
                                                    .backGroundColor,
                                                title: "حذف درخواست واریزی",
                                                titleStyle: AppTextStyle
                                                    .smallTitleText,
                                                middleText: "آیا از حذف درخواست واریزی مطمئن هستید؟",
                                                middleTextStyle: AppTextStyle
                                                    .bodyText,
                                                confirm: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor: WidgetStatePropertyAll(
                                                            AppColor
                                                                .primaryColor)),
                                                    onPressed: () {
                                                      Get
                                                          .back();
                                                      withdrawController
                                                          .deleteDepositRequest(
                                                          depositRequests
                                                              .id!,
                                                          true);
                                                      //withdrawController.fetchWithdrawList();
                                                    },
                                                    child: Text(
                                                      'حذف',
                                                      style: AppTextStyle
                                                          .bodyText,
                                                    )));
                                            //withdrawController.fetchWithdrawList();
                                          }
                                        },
                                        child: SvgPicture
                                            .asset(
                                            'assets/svg/trash-bin.svg',
                                            colorFilter: ColorFilter
                                                .mode(
                                              AppColor
                                                  .accentColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                      ),
                                    ),
                                    // آیکون مشاهده
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/depositRequestGetOne', parameters:{"id":depositRequests.id.toString()});
                                        },
                                        child: SvgPicture
                                            .asset(
                                            'assets/svg/eye1.svg',
                                            colorFilter: ColorFilter
                                                .mode(
                                              AppColor
                                                  .iconViewColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                      ),
                                    ),
                                    // آیکون ویرایش
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (depositRequests
                                              .depositCount !=
                                              0) {
                                            Get
                                                .defaultDialog(
                                              title: 'هشدار',
                                              middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                                              titleStyle: AppTextStyle
                                                  .smallTitleText,
                                              middleTextStyle: AppTextStyle
                                                  .bodyText,
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              textCancel: 'بستن',
                                            );
                                          } else {
                                            withdrawController.setDepositRequestDetail(depositRequests);
                                            showModalBottomSheet(
                                              enableDrag: true,
                                              context: context,
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .vertical(
                                                    top: Radius
                                                        .circular(
                                                        20)),
                                              ),
                                              builder: (
                                                  context) {
                                                return UpdateDepositRequestWidget(
                                                  withdrawId: withdraw
                                                      .id!,
                                                  depositRequest: depositRequests,
                                                );
                                              },
                                            )
                                                .whenComplete(() {
                                              withdrawController
                                                  .clearList();
                                            });
                                          }
                                        },
                                        child: SvgPicture
                                            .asset(
                                            'assets/svg/edit.svg',
                                            colorFilter: ColorFilter
                                                .mode(
                                              AppColor
                                                  .iconViewColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
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
                ),
              ],
            ),
          );

    });
  }

  Widget buildPaginationControls() {
    return Obx(() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: withdrawController.currentPage.value > 1
                ? withdrawController.previousPage
                : null,
          ),
          Text(
            'صفحه ${withdrawController.currentPage.value}',
            style: AppTextStyle.bodyText,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: withdrawController.hasMore.value
                ? withdrawController.nextPage
                : null,
          ),
        ],
      ),
    ));
  }

}


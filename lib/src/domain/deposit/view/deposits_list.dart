import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/widget/background_image_total.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';

class DepositsListView extends StatelessWidget {
  DepositsListView({super.key});

  final DepositController depositController = Get.find<DepositController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(
        title: 'واریزی ها',
        onBackTap: () => Get.back(),
      ),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child:
                      Column(
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
                                      controller: depositController.searchController,
                                      style: AppTextStyle.labelText,
                                      textInputAction: TextInputAction.search,
                                      onFieldSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    await depositController.searchAccounts(value);
                                    showSearchResults(context);
                                  } else {
                                    depositController.clearSearch();
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
                                            onPressed: ()async{
                                              if (depositController.searchController.text.isNotEmpty) {
                                          await depositController.searchAccounts(
                                              depositController.searchController.text
                                          );
                                          showSearchResults(context);
                                        }else {
                                                depositController.clearSearch();
                                        }
                                            },
                                            icon: Icon(Icons.search,color: AppColor.textColor,size: 30,)
                                        ),
                                        suffixIcon: depositController.selectedAccountId.value > 0
                                      ? IconButton(
                                    onPressed: depositController.clearSearch,
                                    icon: Icon(Icons.close, color: AppColor.textColor),
                                  )
                                      : null,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          // لیست واریزی ها
                          Obx(() {
                            if (depositController.state.value == PageState.loading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (depositController.state.value == PageState.empty) {
                              return EmptyPage(
                                title: 'واریزی وجود ندارد',
                                callback: () {
                                  depositController.fetchDepositList();
                                },
                              );
                            } else if (depositController.state.value == PageState.list) {
                              // لیست واریزی ها
                              return
                                  Expanded(
                                    child: isDesktop ?
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                DataTable(
                                                  columns: buildDataColumns(),
                                                  rows: buildDataRows(context),
                                                  dataRowMaxHeight: 100,
                                                  //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                                  //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                                  headingRowHeight: 40,
                                                  horizontalMargin: 6,
                                                ),
                                                buildPaginationControls(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ) :

                                    Expanded(
                                      child: GridView.builder(
                                          controller: depositController.scrollController,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:  1,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          mainAxisExtent:  250,
                                        ),
                                          itemCount: depositController.depositList.length +
                                        (depositController.hasMore.value ? 1 : 0),
                                          itemBuilder: (context, index) {
                                            print(depositController.depositList.length);
                                            if (index >= depositController.depositList.length) {
                                              return depositController.hasMore.value
                                                  ? Center(child: CircularProgressIndicator())
                                                  : SizedBox.shrink();
                                            }
                                            var deposits = depositController.depositList[index];
                                            return Card(
                                              margin: EdgeInsets.all( 8),
                                              color: AppColor.secondaryColor,
                                              elevation: 10,
                                              child: Padding(
                                                padding: EdgeInsets.all( 8),
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
                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'نام کاربر: ',
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
                                                                  Row(
                                                                    children: [
                                                                      Text('الصاق تصویر ',style: AppTextStyle.labelText,),
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                          depositController.pickImage(deposits.recId.toString(), "image", "Deposit"),
                                                                        child: SvgPicture.asset('assets/svg/camera.svg',
                                                                          width: 25,
                                                                          height: 25,
                                                                          colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),

                                                              //تاریخ درخواست
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    'تاریخ درخواست: ',
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

                                                              // مبلغ و مشاهده درخواست
                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.center,
                                                                children: [

                                                                  // مبلغ
                                                                  Row(
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
                                                                        "${deposits.amount == null ? 0 : deposits.amount?.toInt().toString().seRagham(separator: ',')} ریال",
                                                                        style:
                                                                            AppTextStyle.bodyText,
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  // آیکون مشاهده
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Get.toNamed('/depositRequestGetOne',arguments: deposits.depositRequest?.id);
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Text('مشاهده درخواست ',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                        Container(
                                                                          width: 20,
                                                                          height: 20,
                                                                          child: SvgPicture.asset(
                                                                                'assets/svg/eye1.svg',
                                                                                colorFilter:
                                                                                ColorFilter.mode(
                                                                                  AppColor.iconViewColor,
                                                                                  BlendMode.srcIn,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 4,),
                                                              // دلیل رد
                                                              deposits.status==2 ?
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Text('دلیل رد: ',
                                                                    style: AppTextStyle
                                                                        .labelText,),
                                                                  SizedBox(width: 3,),
                                                                  Text("`${deposits.reasonRejection?.name}`" ?? "",
                                                                    style: AppTextStyle
                                                                        .bodyText,),
                                                                ],
                                                              ) : Text(""),
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
                                                                    if(value==2){
                                                                      await depositController.showReasonRejectionDialog("Deposit");
                                                                      if (depositController.selectedReasonRejection.value == null) {
                                                                        return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                                                      }
                                                                      await depositController.updateStatusDeposit(
                                                                        deposits.id!,
                                                                        value,
                                                                        depositController.selectedReasonRejection.value!.id!,
                                                                      );
                                                                    }else {
                                                                      await depositController.updateStatusDeposit(
                                                                          deposits.id!,
                                                                          value, 0);
                                                                    }
                                                                    depositController.fetchDepositList();
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
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                            children: [
                                                              // آیکون ویرایش
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (deposits.status==1){
                                                                    Get.defaultDialog(
                                                                      title: 'هشدار',
                                                                      middleText: 'به دلیل تایید واریزی قابل ویرایش نیست',
                                                                      titleStyle: AppTextStyle
                                                                          .smallTitleText,
                                                                      middleTextStyle: AppTextStyle
                                                                          .bodyText,
                                                                      backgroundColor: AppColor
                                                                          .backGroundColor,
                                                                      textCancel: 'بستن',
                                                                    );
                                                                  }else {
                                                                    Get.toNamed('/depositUpdate', arguments: deposits.id);
                                                                  }
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(' ویرایش',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                    SvgPicture.asset(
                                                                        'assets/svg/edit.svg',
                                                                        colorFilter: ColorFilter
                                                                            .mode(AppColor
                                                                            .iconViewColor,
                                                                          BlendMode.srcIn,)
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // آیکون حذف کردن
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (deposits.status==1){
                                                                    Get.defaultDialog(
                                                                      title: 'هشدار',
                                                                      middleText: 'به دلیل تایید واریزی قابل حذف نیست',
                                                                      titleStyle: AppTextStyle
                                                                          .smallTitleText,
                                                                      middleTextStyle: AppTextStyle
                                                                          .bodyText,
                                                                      backgroundColor: AppColor
                                                                          .backGroundColor,
                                                                      textCancel: 'بستن',
                                                                    );
                                                                  }else {
                                                                    Get.defaultDialog(
                                                                        backgroundColor: AppColor.backGroundColor,
                                                                        title: "حذف واریزی",
                                                                        titleStyle: AppTextStyle.smallTitleText,
                                                                        middleText: "آیا از حذف واریزی مطمئن هستید؟",
                                                                        middleTextStyle: AppTextStyle.bodyText,
                                                                        confirm: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                backgroundColor: WidgetStatePropertyAll(
                                                                                    AppColor.primaryColor)),
                                                                            onPressed: () {
                                                                              Get.back();
                                                                              depositController.deleteDeposit(
                                                                                  deposits.id!, true);
                                                                            },
                                                                            child: Text(
                                                                              'حذف',
                                                                              style: AppTextStyle.bodyText,
                                                                            )));
                                                                  }
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(' حذف',style: AppTextStyle.labelText.copyWith(color: AppColor.accentColor),),
                                                                    SvgPicture.asset(
                                                                        'assets/svg/trash-bin.svg',
                                                                        colorFilter: ColorFilter
                                                                            .mode(AppColor
                                                                            .accentColor,
                                                                          BlendMode.srcIn,)
                                                                    ),
                                                                  ],
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
        ],
      ),

    );
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(backgroundColor: AppColor.backGroundColor,
        title: Text('انتخاب کنید',style: AppTextStyle.smallTitleText,),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: depositController.searchedAccounts.length,
            itemBuilder: (context, index) {
              final account = depositController.searchedAccounts[index];
              return ListTile(
                title: Text(account.name ?? '',style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                onTap: () => depositController.selectAccount(account),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('بستن',style: AppTextStyle.bodyText,),
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
          child: Text('بابت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مشاهده در خواست', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('وضعیت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('الصاق تصویر', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('عملیات', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return depositController.depositList.map((deposit) {
      return DataRow(

        cells: [
          // تاریخ
          DataCell(
              Center(
                child: Text(
                  deposit.date != null
                      ? deposit.date?.toPersianDate(
                      twoDigits: true,
                      showTime: true,
                      timeSeprator:
                      '-') ?? ''
                      : 'تاریخ نامشخص',
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // نام کاربر
          DataCell(
              Center(
                child: Text(
                  deposit.wallet?.account?.name ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // بابت
          DataCell(
              Center(
                child: Text(
                  deposit.walletWithdraw?.account?.name ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // مبلغ
          DataCell(
              Center(
                child: Text(
                  "${deposit.amount == null ? 0 : deposit.amount?.toInt().toString().seRagham(separator: ',')} ریال",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // مشاهده درخواست
          DataCell(
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/depositRequestGetOne',arguments: deposit.depositRequest?.id);
                  },
                  child: Row(
                    children: [
                      Text('مشاهده درخواست ',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                      Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/svg/eye1.svg',
                          colorFilter:
                          ColorFilter.mode(
                            AppColor.iconViewColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          // وضعیت
          DataCell(
            Center(
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Text(
                    '${deposit.status == 0 ? 'نامشخص' : deposit.status == 1
                        ? 'تایید شده'
                        : 'تایید نشده'} ',
                    style: AppTextStyle
                        .bodyText.copyWith(
                      color: deposit.status == 1
                          ? AppColor.primaryColor
                          : deposit.status == 2
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
                      onSelected: (value) async {
                        if(value==2){
                          await depositController.showReasonRejectionDialog("Deposit");
                          if (depositController.selectedReasonRejection.value == null) {
                            return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                          }
                          await depositController.updateStatusDeposit(
                            deposit.id!,
                            value,
                            depositController.selectedReasonRejection.value!.id!,
                          );
                        }else {
                          await depositController.updateStatusDeposit(
                              deposit.id!,
                              value, 0);
                        }
                        depositController.fetchDepositList();
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
                  SizedBox(height: 6,),
                  deposit.status==2 ?
                  Wrap(
                    children: [
                      Text('به دلیل ',
                        style: AppTextStyle
                            .labelText,),
                      Text("`${deposit
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
          //الصاق تصویر
          DataCell(
            Center(
              child: GestureDetector(
                onTap: () =>
                    depositController.pickImageDesktop(deposit.recId.toString(), "image", "Deposit"),
                child: SvgPicture.asset('assets/svg/camera.svg',
                  width: 25,
                  height: 25,
                  colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),),
              )
            ),
          ),
          // آیکون های عملیات
          DataCell(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // آیکون ویرایش
                  GestureDetector(
                    onTap: () {
                      if (deposit.status==1){
                        Get.defaultDialog(
                          title: 'هشدار',
                          middleText: 'به دلیل تایید واریزی قابل ویرایش نیست',
                          titleStyle: AppTextStyle
                              .smallTitleText,
                          middleTextStyle: AppTextStyle
                              .bodyText,
                          backgroundColor: AppColor
                              .backGroundColor,
                          textCancel: 'بستن',
                        );
                      }else {
                        Get.toNamed('/depositUpdate', arguments: deposit.id);
                      }
                    },
                    child: Row(
                      children: [
                        Text(' ویرایش',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                        SvgPicture.asset(
                            'assets/svg/edit.svg',
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .iconViewColor,
                              BlendMode.srcIn,)
                        ),
                      ],
                    ),
                  ),
                  // آیکون حذف کردن
                  GestureDetector(
                    onTap: () {
                      if (deposit.status==1){
                        Get.defaultDialog(
                          title: 'هشدار',
                          middleText: 'به دلیل تایید واریزی قابل حذف نیست',
                          titleStyle: AppTextStyle
                              .smallTitleText,
                          middleTextStyle: AppTextStyle
                              .bodyText,
                          backgroundColor: AppColor
                              .backGroundColor,
                          textCancel: 'بستن',
                        );
                      }else {
                        Get.defaultDialog(
                            backgroundColor: AppColor.backGroundColor,
                            title: "حذف واریزی",
                            titleStyle: AppTextStyle.smallTitleText,
                            middleText: "آیا از حذف واریزی مطمئن هستید؟",
                            middleTextStyle: AppTextStyle.bodyText,
                            confirm: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColor.primaryColor)),
                                onPressed: () {
                                  Get.back();
                                  depositController.deleteDeposit(
                                      deposit.id!, true);
                                },
                                child: Text(
                                  'حذف',
                                  style: AppTextStyle.bodyText,
                                )));
                      }
                    },
                    child: Row(
                      children: [
                        Text(' حذف',style: AppTextStyle.labelText.copyWith(color: AppColor.accentColor),),
                        SvgPicture.asset(
                            'assets/svg/trash-bin.svg',
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .accentColor,
                              BlendMode.srcIn,)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget buildPaginationControls() {
    return Obx(() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: depositController.currentPage.value > 1
                ? depositController.previousPage
                : null,
          ),
          Text(
            'صفحه ${depositController.currentPage.value}',
            style: AppTextStyle.bodyText,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: depositController.hasMore.value
                ? depositController.nextPage
                : null,
          ),
        ],
      ),
    ));
  }
}

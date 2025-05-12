import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_getOne.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import 'deposit_request_create.view.dart';


class WithdrawGetOneView extends StatelessWidget {
  WithdrawGetOneView({super.key});

  final WithdrawGetOneController withdrawGetOneController = Get.find<WithdrawGetOneController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar1(title: 'مشاهده درخواست برداشت',
        onBackTap: ()=> Get.back()
      ),
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                    width: Get.width*0.6,
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Obx(() {
                          if (withdrawGetOneController.state.value == PageState.loading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          else if (withdrawGetOneController.state.value == PageState.empty) {
                            return EmptyPage(
                              title: 'درخواستی وجود ندارد',
                              callback: () {
                                withdrawGetOneController.fetchGetOneWithdraw(withdrawGetOneController.id.value);
                              },
                            );
                          }
                          else if (withdrawGetOneController.state.value == PageState.list) {
                            var getWithdraw = withdrawGetOneController.getOneWithdraw.value;
                            if (getWithdraw == null) {
                              return EmptyPage();
                            }
                            return Column(
                                children: [
                                  // اطلاعات درخواست برداشت

                                   Card(
                                      margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                      color: AppColor.secondaryColor,
                                      elevation: 5,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 10, right: 10, bottom: 10),
                                          child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child:
                                                  // اطلاعات درخواست برداشت
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('اطلاعات درخواست برداشت',
                                                        style: AppTextStyle.smallTitleText
                                                            .copyWith(fontSize: 13),
                                                      ),
                                                      SizedBox(
                                                        width: 150,height: 35,
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            Get.offNamed('/withdrawsList');
                                                          },
                                                          style: ButtonStyle(
                                                            shape: WidgetStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4),
                                                              ),
                                                            ),
                                                              side: WidgetStatePropertyAll(BorderSide(width: 1,color: AppColor.buttonColor))
                                                          ),
                                                          child: Text('لیست درخواست برداشت',
                                                            style: AppTextStyle.labelText.copyWith(color: AppColor.buttonColor,fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(height: 1, color: AppColor.dividerColor,),
                                                // تاریخ و وضعیت
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        getWithdraw.confirmDate?.toPersianDate(
                                                            showTime: true,
                                                            twoDigits: true,
                                                            timeSeprator: "-") ?? "",
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                      SizedBox(width: 40,),
                                                      Text(
                                                        'وضعیت: ',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        color: (getWithdraw.status == 0)
                                                            ? AppColor.accentColor
                                                            : AppColor.primaryColor,
                                                        margin: EdgeInsets.symmetric(
                                                            vertical: 0, horizontal: 5),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(2),
                                                          child: Text(
                                                              (getWithdraw.status == 0)
                                                                  ? 'تایید نشده'
                                                                  : 'تایید شده',
                                                              style: AppTextStyle.labelText,
                                                              textAlign: TextAlign.center),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // نام
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'نام: ${getWithdraw.wallet?.account?.name ?? ""}',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                      Text(
                                                        'شماره موبایل: ${getWithdraw.wallet?.account?.contactInfo ?? ""} ',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // مبلغ کل
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'مبلغ کل: ${getWithdraw.amount== null ? 0 :
                                                            getWithdraw.amount?.toInt().toString().seRagham(separator: ',') } ریال ',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // مبلغ تقسیم نشده
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'مبلغ تقسیم نشده: ',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                      Text(
                                                        '${getWithdraw.undividedAmount==null ? 0 :
                                                            getWithdraw.undividedAmount?.toInt().toString().seRagham(separator: ',') } ریال ',
                                                        style: AppTextStyle.bodyText.copyWith(
                                                            color: AppColor.accentColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // مبلغ تقسیم شده
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'مبلغ تقسیم شده: ${getWithdraw.dividedAmount==null ? 0 :
                                                            getWithdraw.dividedAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // مبلغ واریز شده
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10, bottom: 15),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'مبلغ واریز شده: ',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                      Text(
                                                        '${getWithdraw.paidAmount==null ? 0 :
                                                            getWithdraw.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                        style: AppTextStyle.bodyText.copyWith(
                                                            color: AppColor.primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  height: 1, color: AppColor.backGroundColor,
                                                ),
                                                // نام بانک و نام صاحب حساب
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'نام بانک: ${getWithdraw.bankAccount?.bank
                                                            ?.name ?? ""}',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                      Text(
                                                        'نام صاحب حساب: ${getWithdraw.bankAccount
                                                            ?.ownerName ?? ""}',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // شماره حساب
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'شماره حساب : ${getWithdraw.bankAccount
                                                            ?.number ?? ""}',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // شماره کارت
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'شماره کارت: ${getWithdraw.bankAccount
                                                            ?.cardNumber ?? ""}',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // شماره شبا
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'شماره شبا: ${getWithdraw.bankAccount
                                                            ?.sheba ?? ""}',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                      ),
                                    ),

                                   DefaultTabController(
                                          length: 2,
                                          child: Column(
                                            children: [
                                              TabBar(
                                                labelStyle: AppTextStyle.bodyText,
                                                labelColor: AppColor.textColor,
                                                dividerColor: AppColor.backGroundColor,
                                                overlayColor: WidgetStatePropertyAll(AppColor.backGroundColor1),
                                                unselectedLabelColor: AppColor.textColor.withAlpha(120),
                                                indicatorColor: AppColor.primaryColor,
                                                tabs: [
                                                  Tab(text: "واریزهای تقسیم شده"),
                                                  Tab(text: "مبالغ واریز شده"),
                                                ],
                                              ),

                                              SizedBox(height: Get.height*0.4,
                                                          child: TabBarView(
                                                            children: [
                                                              // TabBar 1 واریز های تقسیم شده
                                                              Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 8,),
                                                                        child: SizedBox(width:Get.width ,height: 40,
                                                                          child: Card(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.zero,bottomLeft: Radius.zero,topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                                                                              margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                                              color: AppColor.secondaryColor,
                                                                              elevation: 0,
                                                                              child:
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 10,top: 5,left: 10,bottom: 5),
                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text('واریزهای تقسیم شده',style: AppTextStyle.smallTitleText.copyWith(fontSize: 13),),

                                                                                    SizedBox(
                                                                                      width: 160,height: 40,
                                                                                      child: OutlinedButton(
                                                                                        onPressed: () {
                                                                                          int validIndex=withdrawGetOneController.withdrawList.isNotEmpty ? 0 : -1;
                                                                                          if(validIndex>=0){
                                                                                            withdrawGetOneController.filterAccountListFunc(
                                                                                                withdrawGetOneController.withdrawList[validIndex].wallet?.account?.id?.toInt() ?? 0);
                                                                                          }
                                                                                          showModalBottomSheet(
                                                                                            enableDrag: true,
                                                                                            context: context,
                                                                                            backgroundColor: AppColor.backGroundColor,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                                                            ),
                                                                                            builder: (context) {
                                                                                              return InsertDepositRequestWidget(id: withdrawGetOneController.id.value,walletId:withdrawGetOneController.getOneWithdraw.value?.wallet?.id ,);
                                                                                            },
                                                                                          ).whenComplete((){
                                                                                            withdrawGetOneController.fetchGetOneWithdraw(withdrawGetOneController.id.value);
                                                                                          });


                                                                                        },
                                                                                        style: ButtonStyle(
                                                                                            shape: WidgetStatePropertyAll(
                                                                                              RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(4),
                                                                                              ),
                                                                                            ),
                                                                                            side: WidgetStatePropertyAll(BorderSide(width: 1,color: AppColor.buttonColor))
                                                                                        ),
                                                                                        child: Text('+ اضافه کردن واریزی جدید',
                                                                                          style: AppTextStyle.labelText.copyWith(color: AppColor.buttonColor,fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )

                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Card(
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                      topRight: Radius.zero,
                                                                                      topLeft: Radius.zero,
                                                                                      bottomLeft: Radius.circular(10),
                                                                                      bottomRight: Radius.circular(10))),
                                                                              margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                                              color: AppColor.secondaryColor,
                                                                              elevation: 5,
                                                                              child:withdrawGetOneController.getOneWithdraw.value?.depositRequests != null ?
                                                                               ListView.builder(
                                                                                    shrinkWrap: true,
                                                                                   //physics: AlwaysScrollableScrollPhysics(),
                                                                                    itemCount: withdrawGetOneController.getOneWithdraw
                                                                                        .value?.depositRequests?.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      var getOneDepositRequest =
                                                                                      withdrawGetOneController.getOneWithdraw
                                                                                          .value?.depositRequests?[index];
                                                                                      return Column(
                                                                                        children: [
                                                                                          Card(
                                                                                            color: AppColor.secondaryColor,
                                                                                            elevation: 0,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                  top: 5,
                                                                                                  left: 7,
                                                                                                  right: 7,
                                                                                                  bottom: 5),
                                                                                              child: Column(
                                                                                                mainAxisAlignment:
                                                                                                MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  // تاریخ و وضعیت
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(top: 5),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment:
                                                                                                      MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          getOneDepositRequest?.date?.toPersianDate(
                                                                                                              showTime: true,
                                                                                                              twoDigits: true,
                                                                                                              timeSeprator:
                                                                                                              "-") ?? "",
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 40,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          'وضعیت: ',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        Card(
                                                                                                          shape:
                                                                                                          RoundedRectangleBorder(
                                                                                                            borderRadius:
                                                                                                            BorderRadius
                                                                                                                .circular(5),
                                                                                                          ),
                                                                                                          color:
                                                                                                          (getOneDepositRequest
                                                                                                              ?.status ==
                                                                                                              0)
                                                                                                              ? AppColor
                                                                                                              .accentColor
                                                                                                              : AppColor
                                                                                                              .primaryColor,
                                                                                                          margin:
                                                                                                          EdgeInsets.symmetric(
                                                                                                              vertical: 0,
                                                                                                              horizontal: 5),
                                                                                                          child: Padding(
                                                                                                            padding:
                                                                                                            const EdgeInsets
                                                                                                                .all(2),
                                                                                                            child: Text(
                                                                                                                (getOneDepositRequest
                                                                                                                    ?.status ==
                                                                                                                    0)
                                                                                                                    ? 'تایید نشده'
                                                                                                                    : 'تایید شده',
                                                                                                                style: AppTextStyle
                                                                                                                    .labelText,
                                                                                                                textAlign: TextAlign
                                                                                                                    .center),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  // نام و شماره موبایل
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(
                                                                                                        top: 10),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment:
                                                                                                      MainAxisAlignment
                                                                                                          .spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'نام: ${getOneDepositRequest?.account?.name ?? ""}',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          'شماره موبایل: ${getOneDepositRequest?.account?.contactInfo ?? ""} ',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  // مبلغ کل
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(
                                                                                                        top: 10),
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'مبلغ کل: ${getOneDepositRequest?.amount == null ? 0 : getOneDepositRequest?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  // مبلغ واریز شده و آیکون مشاهده
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(
                                                                                                        top: 10, bottom: 2),
                                                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'مبلغ واریز شده: ${getOneDepositRequest?.paidAmount == null ? 0 : getOneDepositRequest?.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        GestureDetector(
                                                                                                          onTap: () {
                                                                                                            Get.toNamed('/depositRequestGetOne',parameters:{"id":getOneDepositRequest!.id.toString()});
                                                                                                          },
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                              Text('مشاهده ',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                                                              SvgPicture.asset(
                                                                                                                  'assets/svg/eye1.svg',
                                                                                                                  colorFilter: ColorFilter
                                                                                                                      .mode(AppColor
                                                                                                                      .iconViewColor,
                                                                                                                    BlendMode.srcIn,)
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),

                                                                                                  // Divider
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(bottom: 0),
                                                                                                    child: Divider(
                                                                                                      height: 1,
                                                                                                      color: AppColor.backGroundColor,
                                                                                                    ),
                                                                                                  ),

                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    })
                                                                                  :
                                                                              Card(
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        topRight: Radius.zero,
                                                                                        topLeft: Radius.zero,
                                                                                        bottomLeft: Radius.circular(10),
                                                                                        bottomRight: Radius.circular(10))),
                                                                                margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                                                color: AppColor.secondaryColor,
                                                                                elevation: 5,
                                                                                child: EmptyPage(
                                                                                  title: 'تقسیم واریزی صورت نگرفته است',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                              // TabBar 2 مبالغ واریز شده
                                                              Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 8,),
                                                                        child: SizedBox(width:Get.width ,height: 40,
                                                                          child: Card(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.zero,bottomLeft: Radius.zero,topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                                                                              margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                                              color: AppColor.secondaryColor,
                                                                              elevation: 0,
                                                                              child:
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 10,top: 5,left: 10,bottom: 5),
                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text('مبالغ واریز شده',style: AppTextStyle.smallTitleText.copyWith(fontSize: 13),),
                                                                                  ],
                                                                                ),
                                                                              )

                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Card(
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                      topRight: Radius.zero,
                                                                                      topLeft: Radius.zero,
                                                                                      bottomLeft: Radius.circular(10),
                                                                                      bottomRight: Radius.circular(10))),
                                                                              margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                                              color: AppColor.secondaryColor,
                                                                              elevation: 5,
                                                                              child:withdrawGetOneController.getOneWithdraw.value?.deposits != null ?
                                                                               ListView.builder(
                                                                                    shrinkWrap: true,
                                                                                   //physics: AlwaysScrollableScrollPhysics(),
                                                                                    itemCount: withdrawGetOneController.getOneWithdraw.value?.deposits?.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      var getOneDeposit =
                                                                                      withdrawGetOneController.getOneWithdraw.value?.deposits?[index];
                                                                                      return Column(
                                                                                        children: [
                                                                                          Card(
                                                                                            color: AppColor.secondaryColor,
                                                                                            elevation: 0,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                  top: 5,
                                                                                                  left: 7,
                                                                                                  right: 7,
                                                                                                  bottom: 5),
                                                                                              child: Column(
                                                                                                mainAxisAlignment:
                                                                                                MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  // تاریخ و وضعیت
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(top: 5),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment:
                                                                                                      MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          getOneDeposit?.date?.toPersianDate(
                                                                                                              showTime: true,
                                                                                                              twoDigits: true,
                                                                                                              timeSeprator:
                                                                                                              "-") ?? "",
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 40,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          'وضعیت: ',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        Card(
                                                                                                          shape:
                                                                                                          RoundedRectangleBorder(
                                                                                                            borderRadius:
                                                                                                            BorderRadius
                                                                                                                .circular(5),
                                                                                                          ),
                                                                                                          color:
                                                                                                          (getOneDeposit?.status == 2)
                                                                                                              ? AppColor.accentColor
                                                                                                              : AppColor.primaryColor,
                                                                                                          margin:
                                                                                                          EdgeInsets.symmetric(
                                                                                                              vertical: 0,
                                                                                                              horizontal: 5),
                                                                                                          child: Padding(
                                                                                                            padding:
                                                                                                            const EdgeInsets
                                                                                                                .all(2),
                                                                                                            child: Text(
                                                                                                                (getOneDeposit?.status == 2)
                                                                                                                    ? 'تایید نشده'
                                                                                                                    : 'تایید شده',
                                                                                                                style: AppTextStyle
                                                                                                                    .labelText,
                                                                                                                textAlign: TextAlign
                                                                                                                    .center),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  // نام کاربر
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(
                                                                                                        top: 10),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment:
                                                                                                      MainAxisAlignment
                                                                                                          .spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'نام کاربر: ${getOneDeposit?.wallet?.account?.name ?? ""}',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),

                                                                                                  // مبلغ واریز شده و عکس
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(
                                                                                                        top: 10, bottom: 2),
                                                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'مبلغ واریز شده: ${getOneDeposit?.amount == null ? 0 : getOneDeposit?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        // نمایش عکس
                                                                                                        GestureDetector(
                                                                                                          onTap: () {
                                                                                                            if (getOneDeposit?.attachments == null ||
                                                                                                                getOneDeposit!.attachments!.isEmpty) {
                                                                                                              Get
                                                                                                                  .snackbar(
                                                                                                                  'پیغام',
                                                                                                                  'تصویری ثبت نشده است');
                                                                                                              return;
                                                                                                            }

                                                                                                            showDialog(
                                                                                                              context: context,
                                                                                                              builder: (
                                                                                                                  BuildContext context) {
                                                                                                                return Dialog(
                                                                                                                  backgroundColor: AppColor.backGroundColor,
                                                                                                                  shape: RoundedRectangleBorder(
                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                  ),
                                                                                                                  child: Container(
                                                                                                                    padding: EdgeInsets.all(8),
                                                                                                                    child: Column(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        SizedBox(
                                                                                                                          width: 500,
                                                                                                                          height: 500,
                                                                                                                          child: PageView.builder(
                                                                                                                            itemCount: getOneDeposit.attachments!.length,
                                                                                                                            itemBuilder: (context, index) {
                                                                                                                              final attachment = getOneDeposit.attachments![index];
                                                                                                                              return Image.network(
                                                                                                                                "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=${attachment.guidId}",
                                                                                                                                loadingBuilder: (context,
                                                                                                                                    child,
                                                                                                                                    loadingProgress) {
                                                                                                                                  if (loadingProgress ==
                                                                                                                                      null) {
                                                                                                                                    return child;
                                                                                                                                  }
                                                                                                                                  return Center(
                                                                                                                                    child: CircularProgressIndicator(),
                                                                                                                                  );
                                                                                                                                },
                                                                                                                                errorBuilder: (context, error, stackTrace) =>
                                                                                                                                    Icon(Icons.error,
                                                                                                                                        color: Colors.red),
                                                                                                                                fit: BoxFit.contain,
                                                                                                                              );
                                                                                                                            },
                                                                                                                          ),
                                                                                                                        ),

                                                                                                                        SizedBox(
                                                                                                                            height: 10),
                                                                                                                        TextButton(
                                                                                                                          onPressed: () =>
                                                                                                                              Get
                                                                                                                                  .back(),
                                                                                                                          child: Text(
                                                                                                                            "بستن",
                                                                                                                            style: AppTextStyle
                                                                                                                                .bodyText,),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                );
                                                                                                              },
                                                                                                            );
                                                                                                          },
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                'عکس (${getOneDeposit
                                                                                                                    ?.attachments
                                                                                                                    ?.length ??
                                                                                                                    0}) ',
                                                                                                                style: AppTextStyle
                                                                                                                    .bodyText
                                                                                                                    .copyWith(
                                                                                                                    color: AppColor
                                                                                                                        .iconViewColor
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                width: 25,
                                                                                                                height: 25,
                                                                                                                child: SvgPicture
                                                                                                                    .asset(
                                                                                                                  'assets/svg/picture.svg',
                                                                                                                  colorFilter: ColorFilter
                                                                                                                      .mode(
                                                                                                                    AppColor
                                                                                                                        .iconViewColor,
                                                                                                                    BlendMode
                                                                                                                        .srcIn,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),

                                                                                                  // Divider
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(bottom: 0),
                                                                                                    child: Divider(
                                                                                                      height: 1,
                                                                                                      color: AppColor.backGroundColor,
                                                                                                    ),
                                                                                                  ),

                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    })
                                                                               :
                                                                              Card(
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        topRight: Radius.zero,
                                                                                        topLeft: Radius.zero,
                                                                                        bottomLeft: Radius.circular(10),
                                                                                        bottomRight: Radius.circular(10))),
                                                                                margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                                                color: AppColor.secondaryColor,
                                                                                elevation: 5,
                                                                                child: EmptyPage(
                                                                                  title: 'مبلغ واریزی وجود ندارد',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            ],
                                                          ),
                                                        ),
                                            ],
                                          )
                                      ),
                                ],
                              );

                          }
                          return ErrPage(
                          callback: () {
                          withdrawGetOneController.fetchGetOneWithdraw(withdrawGetOneController.id.value);
                          },
                          title: "خطا در دریافت اطلاعات درخواست برداشت",
                          des: 'برای مشاهده درخواست برداشت مجددا تلاش کنید',
                          );
                        }),

                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

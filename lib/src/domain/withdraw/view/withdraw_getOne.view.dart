import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_getOne.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/app_drawer.widget.dart';
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
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(title: 'مشاهده درخواست برداشت',
        onBackTap: ()=> Get.back(),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child:
                isDesktop ?
                SizedBox(
                    width: Get.width*0.6,
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Obx(() {
                          if (withdrawGetOneController.state.value == PageState.loading) {
                            EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
                            return Center(child: CircularProgressIndicator());
                          }
                          else if (withdrawGetOneController.state.value == PageState.empty) {
                            EasyLoading.dismiss();
                            return EmptyPage(
                              title: 'درخواستی وجود ندارد',
                              callback: () {
                                withdrawGetOneController.fetchGetOneWithdraw(withdrawGetOneController.id.value);
                              },
                            );
                          }
                          else if (withdrawGetOneController.state.value == PageState.list) {
                            EasyLoading.dismiss();
                            var getWithdraw = withdrawGetOneController.getOneWithdraw.value;
                            if (getWithdraw == null) {
                              return EmptyPage();
                            }
                            return
                              SingleChildScrollView(
                                child: Column(
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
                                                              Get.toNamed('/withdrawsList');
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
                                                          getWithdraw.requestDate?.toPersianDate(
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
                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'نام بانک: ${getWithdraw.bank?.name ?? ""}',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        Text(
                                                          'نام صاحب حساب: ${getWithdraw.ownerName ?? ""}',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  // شماره حساب و شماره کارت
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Row(mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'شماره حساب : ${getWithdraw.number ?? ""}',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        Text(
                                                          'شماره کارت: ${getWithdraw.cardNumber ?? ""}',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(),
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
                                                          'شماره شبا: ${getWithdraw.sheba ?? ""}',
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
                                                                                        width: 180,height: 40,
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
                                                                                          child: Text('+ اضافه کردن درخواست واریزی',
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
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                  top: 5,
                                                                                                  left: 7,
                                                                                                  right: 7,
                                                                                                  bottom: 5),
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  // نام و شماره موبایل و  آیکون مشاهده
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
                                                                                                        GestureDetector(
                                                                                                          onTap: () {
                                                                                                            Get.toNamed('/depositRequestGetOne',parameters:{"id":getOneDepositRequest!.id.toString()});
                                                                                                          },
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                              SvgPicture.asset(
                                                                                                                  'assets/svg/eye1.svg',
                                                                                                                  colorFilter: ColorFilter
                                                                                                                      .mode(AppColor
                                                                                                                      .iconViewColor,
                                                                                                                    BlendMode.srcIn,)
                                                                                                              ),
                                                                                                              Text('مشاهده ',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  // مبلغ کل و مبلغ واریز شده
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(
                                                                                                        top: 10,bottom: 10),
                                                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'مبلغ کل: ${getOneDepositRequest?.amount == null ? 0 : getOneDepositRequest?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                        Expanded(
                                                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                'مبلغ واریز شده: ',
                                                                                                                style:
                                                                                                                AppTextStyle.bodyText,
                                                                                                              ),
                                                                                                              Text(
                                                                                                                '${getOneDepositRequest?.paidAmount == null ? 0 : getOneDepositRequest?.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                                                style:
                                                                                                                AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        //SizedBox(),
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
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(
                                                                                                  top: 6,
                                                                                                  left: 10,
                                                                                                  right: 7,
                                                                                                  bottom: 5),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: getOneDeposit?.registered ?? false,
                                                                                                    onChanged: (value) async{
                                                                                                      if (value != null) {
                                                                                                        //EasyLoading.show(status: 'لطفا منتظر بمانید');
                                                                                                        await withdrawGetOneController.updateRegistered(
                                                                                                            getOneDeposit!.id!,
                                                                                                            value
                                                                                                        );
                                                                                                      }
                                                                                                      //depositController.fetchDepositList();
                                                                                                      //EasyLoading.dismiss();
                                                                                                    },
                                                                                                  ),
                                                                                                  // نام کاربر
                                                                                                  Expanded(
                                                                                                    child: SizedBox(
                                                                                                      child: Text(
                                                                                                        'نام کاربر: ${getOneDeposit?.wallet?.account?.name ?? ""}',
                                                                                                        style:
                                                                                                        AppTextStyle.bodyText,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  // مبلغ واریز شده
                                                                                                  Expanded(
                                                                                                    child: SizedBox(
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'مبلغ: ',
                                                                                                            style:
                                                                                                            AppTextStyle.bodyText,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            ' ${getOneDeposit?.amount == null ? 0 : getOneDeposit?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                                            style:
                                                                                                            AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  // کد رهگیری
                                                                                                  Expanded(
                                                                                                    child: SizedBox(
                                                                                                      child: Text(
                                                                                                        'کد رهگیری: ${getOneDeposit?.trackingNumber ?? ""}',
                                                                                                        style:
                                                                                                        AppTextStyle.bodyText,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  // نمایش عکس
                                                                                                  GestureDetector(
                                                                                                    onTap: () async{
                                                                                                      await withdrawGetOneController.getImage(getOneDeposit?.recId ??"", "Deposit");
                                                                                                      Future.delayed(const Duration(milliseconds: 200), () {
                                                                                                        showDialog(
                                                                                                          context: context,
                                                                                                          builder: (BuildContext context) {
                                                                                                            return Dialog(
                                                                                                              backgroundColor: AppColor
                                                                                                                  .backGroundColor,
                                                                                                              shape: RoundedRectangleBorder(
                                                                                                                borderRadius: BorderRadius
                                                                                                                    .circular(
                                                                                                                    10),
                                                                                                              ),
                                                                                                              child: Container(
                                                                                                                padding: EdgeInsets
                                                                                                                    .all(
                                                                                                                    8),
                                                                                                                child: Column(
                                                                                                                  mainAxisSize: MainAxisSize
                                                                                                                      .min,
                                                                                                                  children: [
                                                                                                                    // نمایش اسلایدی عکس‌ها
                                                                                                                    SizedBox(
                                                                                                                      width: 500,
                                                                                                                      height: 500,
                                                                                                                      child: Stack(
                                                                                                                        children: [
                                                                                                                          PageView.builder(
                                                                                                                            controller: withdrawGetOneController
                                                                                                                                .pageController,
                                                                                                                            itemCount: withdrawGetOneController.imageList.length,
                                                                                                                            onPageChanged: (index) =>
                                                                                                                            withdrawGetOneController
                                                                                                                                .currentImagePage
                                                                                                                                .value =
                                                                                                                                index,
                                                                                                                            itemBuilder: (context,
                                                                                                                                index) {
                                                                                                                              final attachment = withdrawGetOneController.imageList[index];
                                                                                                                              return Column(
                                                                                                                                children: [
                                                                                                                                  if (kIsWeb)
                                                                                                                                    Padding(
                                                                                                                                      padding: const EdgeInsets.only(right: 50),
                                                                                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                        children: [
                                                                                                                                          IconButton(
                                                                                                                                            icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                                                                                                            onPressed: () => withdrawGetOneController.downloadImage(
                                                                                                                                              attachment,
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ],
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                  SizedBox(
                                                                                                                                    width: 450,
                                                                                                                                    height: 450,
                                                                                                                                    child: Image.network(
                                                                                                                                      "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$attachment",
                                                                                                                                      loadingBuilder: (context,
                                                                                                                                          child,
                                                                                                                                          loadingProgress) {
                                                                                                                                        if (loadingProgress ==
                                                                                                                                            null)
                                                                                                                                          return child;
                                                                                                                                        return Center(
                                                                                                                                          child: CircularProgressIndicator(),
                                                                                                                                        );
                                                                                                                                      },
                                                                                                                                      errorBuilder: (context,
                                                                                                                                          error,
                                                                                                                                          stackTrace) =>
                                                                                                                                          Icon(
                                                                                                                                              Icons
                                                                                                                                                  .error,
                                                                                                                                              color: Colors
                                                                                                                                                  .red),
                                                                                                                                      fit: BoxFit.contain,
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              );
                                                                                                                            },
                                                                                                                          ),
                                                                                                                          SizedBox(
                                                                                                                            height: 2,),
                                                                                                                          Obx(() {
                                                                                                                            return Positioned(
                                                                                                                                left: 10,
                                                                                                                                top: 0,
                                                                                                                                bottom: 0,
                                                                                                                                child: Visibility(
                                                                                                                                  visible: withdrawGetOneController
                                                                                                                                      .currentImagePage.value > 0,
                                                                                                                                  child: IconButton(
                                                                                                                                    style: ButtonStyle(
                                                                                                                                      backgroundColor: WidgetStateProperty
                                                                                                                                          .all(Colors.black54),
                                                                                                                                      shape: WidgetStateProperty.all(
                                                                                                                                          CircleBorder()),
                                                                                                                                      padding: WidgetStateProperty.all(
                                                                                                                                          EdgeInsets.all(8)),
                                                                                                                                    ),
                                                                                                                                    icon: Icon(Icons.chevron_left,
                                                                                                                                      color: Colors.white,
                                                                                                                                      size: 40,
                                                                                                                                      shadows: [
                                                                                                                                        Shadow(
                                                                                                                                          blurRadius: 10,
                                                                                                                                          color: Colors.black,
                                                                                                                                          offset: Offset(0, 0),
                                                                                                                                        )
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                    onPressed: () {
                                                                                                                                      withdrawGetOneController.pageController
                                                                                                                                          .previousPage(
                                                                                                                                        duration: Duration(
                                                                                                                                            milliseconds: 300),
                                                                                                                                        curve: Curves.easeInOut,
                                                                                                                                      );
                                                                                                                                    },
                                                                                                                                  ),
                                                                                                                                )
                                                                                                                            );
                                                                                                                          }),
                                                                                                                          Obx(() {
                                                                                                                            return Positioned(
                                                                                                                                right: 10,
                                                                                                                                top: 0,
                                                                                                                                bottom: 0,
                                                                                                                                child: Visibility(
                                                                                                                                  visible: withdrawGetOneController
                                                                                                                                      .currentImagePage.value <
                                                                                                                                      (withdrawGetOneController.imageList.length ?? 1) -
                                                                                                                                          1,
                                                                                                                                  child: IconButton(
                                                                                                                                    style: ButtonStyle(
                                                                                                                                      backgroundColor: WidgetStateProperty
                                                                                                                                          .all(Colors.black54),
                                                                                                                                      shape: WidgetStateProperty.all(
                                                                                                                                          CircleBorder()),
                                                                                                                                      padding: WidgetStateProperty.all(
                                                                                                                                          EdgeInsets.all(8)),
                                                                                                                                    ),
                                                                                                                                    icon: Icon(Icons.chevron_right,
                                                                                                                                      color: Colors.white,
                                                                                                                                      size: 40,
                                                                                                                                      shadows: [
                                                                                                                                        Shadow(
                                                                                                                                          blurRadius: 10,
                                                                                                                                          color: Colors.black,
                                                                                                                                          offset: Offset(0, 0),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                    onPressed: () {
                                                                                                                                      withdrawGetOneController.pageController
                                                                                                                                          .nextPage(
                                                                                                                                        duration: Duration(
                                                                                                                                            milliseconds: 300),
                                                                                                                                        curve: Curves.easeInOut,
                                                                                                                                      );
                                                                                                                                    },
                                                                                                                                  ),
                                                                                                                                )
                                                                                                                            );
                                                                                                                          }),
                                                                                                                          SizedBox(
                                                                                                                            height: 2,),
                                                                                                                          // نمایش نقاط راهنما
                                                                                                                          Obx(() =>
                                                                                                                              Row(
                                                                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                                                                    .center,
                                                                                                                                children: List
                                                                                                                                    .generate(
                                                                                                                                  withdrawGetOneController.imageList.length,
                                                                                                                                      (index) =>
                                                                                                                                      Container(
                                                                                                                                        width: 8,
                                                                                                                                        height: 8,
                                                                                                                                        margin: EdgeInsets
                                                                                                                                            .symmetric(
                                                                                                                                            horizontal: 4),
                                                                                                                                        decoration: BoxDecoration(
                                                                                                                                          shape: BoxShape
                                                                                                                                              .circle,
                                                                                                                                          color: withdrawGetOneController
                                                                                                                                              .currentImagePage
                                                                                                                                              .value ==
                                                                                                                                              index
                                                                                                                                              ? Colors
                                                                                                                                              .blue
                                                                                                                                              : Colors
                                                                                                                                              .grey,
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                ),
                                                                                                                              )),
                                                                                                                          SizedBox(
                                                                                                                              height: 10),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
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
                                                                                                      });
                                                                                                    },
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        SvgPicture.asset('assets/svg/picture.svg',height: 20,
                                                                                                            colorFilter: ColorFilter.mode(

                                                                                                              AppColor.textColor,

                                                                                                              BlendMode.srcIn,
                                                                                                            )),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  /*GestureDetector(
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
                                                                                                                        return Column(
                                                                                                                          children: [
                                                                                                                            if (kIsWeb)
                                                                                                                              Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                children: [
                                                                                                                                  IconButton(
                                                                                                                                    icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                                                                                                    onPressed: () => withdrawGetOneController.downloadImage(
                                                                                                                                      attachment.guidId!,
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                            SizedBox(
                                                                                                                              width: 450,
                                                                                                                              height: 450,
                                                                                                                              child: Image.network(
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
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ],
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
                                                                                                        Text(
                                                                                                          ' عکس (${getOneDeposit
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
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),*/
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
                                ),
                              );
                          }
                          EasyLoading.dismiss();
                          return ErrPage(
                          callback: () {
                          withdrawGetOneController.fetchGetOneWithdraw(withdrawGetOneController.id.value);
                          },
                          title: "خطا در دریافت اطلاعات درخواست برداشت",
                          des: 'برای مشاهده درخواست برداشت مجددا تلاش کنید',
                          );
                        }),

                    )
                )
                    :
                SizedBox(
                    width: Get.width*0.95,
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
                          return
                          SingleChildScrollView(
                            child: Column(
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
                                          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('اطلاعات درخواست برداشت',
                                                style: AppTextStyle.smallTitleText
                                                    .copyWith(fontSize: 13),
                                              ),
                                              SizedBox(height: 5,),
                                              SizedBox(
                                                width: 150,height: 30,
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
                                          child: Row(
                                            children: [
                                              Text(
                                                'نام: ${getWithdraw.wallet?.account?.name ?? ""}',
                                                style: AppTextStyle.bodyText,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // شماره موبایل
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
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
                                        // نام بانک
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                            children: [
                                              Text(
                                                'نام بانک: ${getWithdraw.bank?.name ?? ""}',
                                                style: AppTextStyle.bodyText,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // نام صاحب حساب
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                            children: [
                                              Text(
                                                'نام صاحب حساب: ${getWithdraw.ownerName ?? ""}',
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
                                                'شماره حساب : ${getWithdraw.number ?? ""}',
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
                                                'شماره کارت: ${getWithdraw.cardNumber ?? ""}',
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
                                                'شماره شبا: ${getWithdraw.sheba ?? ""}',
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
                                                    child: SizedBox(width:Get.width ,
                                                      child: Card(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.zero,bottomLeft: Radius.zero,topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                                                          margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                          color: AppColor.secondaryColor,
                                                          elevation: 0,
                                                          child:
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 10,top: 5,left: 10,bottom: 5),
                                                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('واریزهای تقسیم شده',style: AppTextStyle.smallTitleText.copyWith(fontSize: 13),),
                                                                SizedBox(height: 5,),
                                                                SizedBox(
                                                                  width: 160,height: 30,
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
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      top: 5,
                                                                      left: 7,
                                                                      right: 7,
                                                                      bottom: 5),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      // نام و آیکون مشاهده
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10),
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
                                                                            // شماره موبایل
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                  top: 4),
                                                                              child: Row(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    '${getOneDepositRequest?.account?.contactInfo ?? ""} ',
                                                                                    style:
                                                                                    AppTextStyle.bodyText,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                Get.toNamed('/depositRequestGetOne',parameters:{"id":getOneDepositRequest!.id.toString()});
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  SvgPicture.asset(
                                                                                      'assets/svg/eye1.svg',
                                                                                      colorFilter: ColorFilter
                                                                                          .mode(AppColor
                                                                                          .iconViewColor,
                                                                                        BlendMode.srcIn,)
                                                                                  ),
                                                                                  Text('مشاهده ',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // مبلغ کل
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top: 4),
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              'مبلغ کل: ${getOneDepositRequest?.amount == null ? 0 : getOneDepositRequest?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                              style:
                                                                              AppTextStyle.bodyText,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // مبلغ واریز شده
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top: 4),
                                                                        child:
                                                                        Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'مبلغ واریز شده: ',
                                                                              style:
                                                                              AppTextStyle.bodyText,
                                                                            ),
                                                                            Text(
                                                                              '${getOneDepositRequest?.paidAmount == null ? 0 : getOneDepositRequest?.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                              style:
                                                                              AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // Divider
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 4),
                                                                        child: Divider(
                                                                          height: 1,
                                                                          color: AppColor.backGroundColor,
                                                                        ),
                                                                      ),

                                                                    ],
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
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                    top: 6,
                                                                    left: 10,
                                                                    right: 7,),
                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      // نام کاربر
                                                                      SizedBox(
                                                                        child: Text(
                                                                          'نام کاربر: ${getOneDeposit?.wallet?.account?.name ?? ""}',
                                                                          style:
                                                                          AppTextStyle.bodyText,
                                                                        ),
                                                                      ),
                                                                      // کد رهگیری
                                                                      Row(
                                                                        children: [
                                                                          Text('کد رهگیری: ', style: AppTextStyle.labelText,
                                                                          ),
                                                                          SizedBox(width: 3,),
                                                                          Text("${getOneDeposit?.trackingNumber ?? 0}",
                                                                            style: AppTextStyle.bodyText,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 10,
                                                                      right: 7,
                                                                      bottom: 5),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      // مبلغ واریز شده
                                                                      SizedBox(
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              'مبلغ: ',
                                                                              style:
                                                                              AppTextStyle.bodyText,
                                                                            ),
                                                                            Text(
                                                                              ' ${getOneDeposit?.amount == null ? 0 : getOneDeposit?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                              style:
                                                                              AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),
                                                                            ),
                                                                          ],
                                                                        ),
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
                                                                                            return Column(
                                                                                              children: [
                                                                                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                      icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                                                                      onPressed: () => withdrawGetOneController.downloadImage(
                                                                                                        attachment.guidId!,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 450,
                                                                                                  height: 450,
                                                                                                  child: Image.network(
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
                                                                                                  ),
                                                                                                ),

                                                                                              ],
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
                                                                            Text(
                                                                              ' (${getOneDeposit
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
                            ),
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

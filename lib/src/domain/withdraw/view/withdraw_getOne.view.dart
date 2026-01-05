import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../home/widget/chat_dialog.widget.dart';
import 'deposit_request_create.view.dart';


class WithdrawGetOneView extends StatefulWidget {
  WithdrawGetOneView({super.key});

  @override
  State<WithdrawGetOneView> createState() => _WithdrawGetOneViewState();
}

class _WithdrawGetOneViewState extends State<WithdrawGetOneView> with TickerProviderStateMixin{
  late WithdrawGetOneController withdrawGetOneController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    withdrawGetOneController = Get.find<WithdrawGetOneController>();
    _tabController = TabController(length: 2, vsync: this);
    withdrawGetOneController.setTabController(_tabController);

    // Add listener to update currentTabIndex when user manually changes tabs
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        withdrawGetOneController.currentTabIndex.value = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  // Helper method to format card number with spaces every 4 digits
  String _formatCardNumber(String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) return "";

    // Remove any existing spaces and format with spaces every 4 digits
    String cleanNumber = cardNumber.replaceAll(' ', '');
    String formatted = '';

    for (int i = 0; i < cleanNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += cleanNumber[i];
    }

    return '\u202D$formatted';
  }

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
                    width: Get.width*0.8,
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
                                                  // تاریخ و وضعیت و موبایل و نام
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'نام: ${getWithdraw.wallet?.account?.name ?? ""}',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(width: 40,),
                                                        Text(
                                                          getWithdraw.requestDate?.toPersianDate(
                                                              showTime: true,
                                                              twoDigits: true,
                                                              timeSeprator: "-") ?? "",
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(width: 40,),
                                                        // وضعیت
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'وضعیت: ',
                                                              style: AppTextStyle.bodyText,
                                                            ),
                                                            Card(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    5),
                                                              ),
                                                              color: getWithdraw.status ==
                                                                  2
                                                                  ? AppColor
                                                                  .accentColor
                                                                  : getWithdraw
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
                                                                    getWithdraw
                                                                        .status ==
                                                                        2
                                                                        ? 'تایید نشده'
                                                                        : getWithdraw
                                                                        .status ==
                                                                        1
                                                                        ? 'تایید شده'
                                                                        : 'در انتظار',
                                                                    style: AppTextStyle
                                                                        .labelText,
                                                                    textAlign: TextAlign
                                                                        .center),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 40,),
                                                        // موبایل
                                                        Text(
                                                          'شماره موبایل: ${getWithdraw.wallet?.account?.contactInfo ?? ""} ',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text('تلگرام: ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            getWithdraw.allDepositSent == true ?
                                                            Icon(Icons.check,
                                                              color: AppColor
                                                                  .primaryColor,
                                                              size: 20,) :
                                                            Icon(Icons.close,
                                                              color: AppColor
                                                                  .accentColor,
                                                              size: 20,)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  //  مبلغ کل و مبلغ تقسیم نشده
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'مبلغ کل: ${getWithdraw.amount== null ? 0 :
                                                              getWithdraw.amount?.toInt().toString().seRagham(separator: ',') } ریال ',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(width: 40,),
                                                        Row(
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
                                                      ],
                                                    ),
                                                  ),
                                                  // مبلغ تقسیم شده و مبلغ واریز شده
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10 , bottom: 15),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'مبلغ تقسیم شده: ${getWithdraw.dividedAmount==null ? 0 :
                                                              getWithdraw.dividedAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(width: 40,),
                                                        Row(
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
                                                          'نام صاحب حساب: ${getWithdraw.ownerName ?? ""}',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(),
                                                        Text(
                                                          'نام بانک: ${getWithdraw.bank?.name ?? ""}',
                                                          style: AppTextStyle.bodyText,
                                                        ),
                                                        SizedBox(),
                                                        SizedBox(),
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
                                                          //'شماره کارت: ${getWithdraw.cardNumber ?? ""}',
                                                          'شماره کارت: ${_formatCardNumber(getWithdraw.cardNumber)}',
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

                                    Column(
                                              children: [
                                                TabBar(
                                                  controller: _tabController,
                                                  labelStyle: AppTextStyle.bodyText,
                                                  labelColor: AppColor.textColor,
                                                  dividerColor: AppColor.backGroundColor,
                                                  overlayColor: WidgetStatePropertyAll(AppColor.backGroundColor1),
                                                  unselectedLabelColor: AppColor.textColor.withAlpha(120),
                                                  indicatorColor: AppColor.primaryColor,
                                                  onTap: (index) {
                                                    withdrawGetOneController.currentTabIndex.value = index;
                                                  },
                                                  tabs: [
                                                    Tab(text: "واریزهای تقسیم شده"),
                                                    Tab(text: "مبالغ واریز شده"),
                                                  ],
                                                ),

                                                SizedBox(height: Get.height*0.6,
                                                            child: TabBarView(
                                                              controller: _tabController,
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
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment
                                                                                                              .end,
                                                                                                          children: [
                                                                                                            Text('تلگرام: ',
                                                                                                              style: AppTextStyle
                                                                                                                  .labelText,),
                                                                                                            getOneDepositRequest?.isSendTelegram == true ?
                                                                                                            Icon(Icons.check,
                                                                                                              color: AppColor
                                                                                                                  .primaryColor,
                                                                                                              size: 20,) :
                                                                                                            Icon(Icons.close,
                                                                                                              color: AppColor
                                                                                                                  .accentColor,
                                                                                                              size: 20,)
                                                                                                          ],
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
                                                                                                        // ارسال تلگرام
                                                                                                        Expanded(
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                            // ارسال تلگرام
                                                                                                            GestureDetector(
                                                                                                              onTap: () {
                                                                                                                getOneDepositRequest?.isSendTelegram == true ?
                                                                                                                Get.defaultDialog(
                                                                                                                    backgroundColor: AppColor.backGroundColor,
                                                                                                                    title: "ارسال مجدد",
                                                                                                                    titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                                                                                                    middleText: "آیا از ارسال مجدد درخواست واریزی مطمئن هستید؟",
                                                                                                                    middleTextStyle: AppTextStyle.bodyText,
                                                                                                                    confirm: ElevatedButton(
                                                                                                                        style: ButtonStyle(
                                                                                                                            backgroundColor: WidgetStatePropertyAll(
                                                                                                                                AppColor.primaryColor)),
                                                                                                                        onPressed: () {
                                                                                                                          Get.back();
                                                                                                                          withdrawGetOneController.sendTelegramDepositRequest(getOneDepositRequest?.id ?? 0);
                                                                                                                        },
                                                                                                                        child: Text(
                                                                                                                          'ارسال مجدد',
                                                                                                                          style: AppTextStyle.bodyText,
                                                                                                                        ))
                                                                                                                ) :
                                                                                                                Get.defaultDialog(
                                                                                                                    backgroundColor: AppColor.backGroundColor,
                                                                                                                    title: "ارسال به تلگرام",
                                                                                                                    titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                                                                                    middleText: "آیا از ارسال درخواست واریزی مطمئن هستید؟",
                                                                                                                    middleTextStyle: AppTextStyle.bodyText,
                                                                                                                    confirm: ElevatedButton(
                                                                                                                        style: ButtonStyle(
                                                                                                                            backgroundColor: WidgetStatePropertyAll(
                                                                                                                                AppColor.primaryColor)),
                                                                                                                        onPressed: () {
                                                                                                                          Get.back();
                                                                                                                          withdrawGetOneController.sendTelegramDepositRequest(getOneDepositRequest?.id ?? 0);
                                                                                                                        },
                                                                                                                        child: Text(
                                                                                                                          'ارسال',
                                                                                                                          style: AppTextStyle.bodyText,
                                                                                                                        ))
                                                                                                                );
                                                                                                              },
                                                                                                              child: Tooltip(
                                                                                                                message: getOneDepositRequest?.isSendTelegram == true ?  "ارسال مجدد درخواست واریزی به تلگرام" : "ارسال درخواست واریزی به تلگرام",
                                                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                  children: [
                                                                                                                    Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: getOneDepositRequest?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                                                                                                    SvgPicture.asset(
                                                                                                                      'assets/svg/telegram.svg',height: 20,
                                                                                                                      colorFilter: ColorFilter.mode(getOneDepositRequest?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        // وضعیت
                                                                                                        Card(
                                                                                                          shape: RoundedRectangleBorder(
                                                                                                            borderRadius: BorderRadius
                                                                                                                .circular(
                                                                                                                5),
                                                                                                          ),
                                                                                                          color: getOneDepositRequest?.status ==
                                                                                                              2
                                                                                                              ? AppColor
                                                                                                              .accentColor
                                                                                                              : getOneDepositRequest
                                                                                                              ?.status ==
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
                                                                                                                getOneDepositRequest
                                                                                                                    ?.status ==
                                                                                                                    2
                                                                                                                    ? 'تایید نشده'
                                                                                                                    : getOneDepositRequest
                                                                                                                    ?.status ==
                                                                                                                    1
                                                                                                                    ? 'تایید شده'
                                                                                                                    : 'در انتظار',
                                                                                                                style: AppTextStyle
                                                                                                                    .labelText,
                                                                                                                textAlign: TextAlign
                                                                                                                    .center),
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
                                                                          child: SizedBox(width:Get.width ,
                                                                            child: Card(
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.zero,bottomLeft: Radius.zero,topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                                                                                margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                                                color: AppColor.secondaryColor,
                                                                                elevation: 0,
                                                                                child:
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 10,top: 5,left: 10,bottom: 5),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text('مبالغ واریز شده',style: AppTextStyle.smallTitleText.copyWith(fontSize: 13),),
                                                                                          Row(
                                                                                            children: [
                                                                                              // Filter button
                                                                                              Obx(() {
                                                                                                final hasFilters = withdrawGetOneController.hasActiveDepositFilters();
                                                                                                return hasFilters
                                                                                                    ? IconButton(
                                                                                                  onPressed: () {
                                                                                                    withdrawGetOneController.clearDepositFilters();
                                                                                                  },
                                                                                                  icon: Icon(Icons.clear, color: AppColor.accentColor, size: 20),
                                                                                                  tooltip: 'پاک کردن فیلترها',
                                                                                                )
                                                                                                    : SizedBox.shrink();
                                                                                              }),
                                                                                              IconButton(
                                                                                                onPressed: () {
                                                                                                  showModalBottomSheet(
                                                                                                    enableDrag: true,
                                                                                                    context: context,
                                                                                                    backgroundColor: AppColor.backGroundColor,
                                                                                                    shape: RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                                                                    ),
                                                                                                    builder: (context) {
                                                                                                      return _buildDepositFilterBottomSheet();
                                                                                                    },
                                                                                                  );
                                                                                                },
                                                                                                icon: Icon(Icons.filter_list, color: AppColor.primaryColor, size: 20),
                                                                                                tooltip: 'فیلتر',
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      // Filter summary
                                                                                      Obx(() {
                                                                                        final hasFilters = withdrawGetOneController.hasActiveDepositFilters();
                                                                                        return hasFilters
                                                                                            ? Padding(
                                                                                          padding: const EdgeInsets.only(top: 5),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Icon(Icons.filter_alt, color: AppColor.primaryColor, size: 16),
                                                                                              SizedBox(width: 5),
                                                                                              Text(
                                                                                                'فیلتر فعال',
                                                                                                style: AppTextStyle.labelText.copyWith(color: AppColor.primaryColor),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                            : SizedBox.shrink();
                                                                                      }),
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
                                                                                    Obx(() => ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                     //physics: AlwaysScrollableScrollPhysics(),
                                                                                          itemCount: withdrawGetOneController.hasActiveDepositFilters()
                                                                                          ? withdrawGetOneController.filteredDeposits.length
                                                                                              : withdrawGetOneController.getOneWithdraw.value?.deposits?.length ?? 0,
                                                                                      itemBuilder: (context, index) {
                                                                                          var getOneDeposit = withdrawGetOneController.hasActiveDepositFilters()
                                                                                          ? withdrawGetOneController.filteredDeposits[index]
                                                                                              : withdrawGetOneController.getOneWithdraw.value?.deposits?[index];
                                                                                        return Column(
                                                                                          children: [
                                                                                            Container(color: getOneDeposit?.registered==true ? AppColor.primaryColor.withAlpha(40) : getOneDeposit?.status==4 ? AppColor.accentColor.withAlpha(40): AppColor.secondaryColor,
                                                                                              padding: const EdgeInsets.only(
                                                                                                  top: 6,
                                                                                                  left: 10,
                                                                                                  right: 7,
                                                                                                  bottom: 5),
                                                                                              child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                     SizedBox(
                                                                                                        child: Text(
                                                                                                          ' ${getOneDeposit?.rowNum ?? ""}',
                                                                                                          style:
                                                                                                          AppTextStyle.bodyText,
                                                                                                        ),
                                                                                                      ),
                                                                                                    Checkbox(
                                                                                                      value: getOneDeposit?.registered ?? false,
                                                                                                      onChanged: (value) async{
                                                                                                        if (value != null) {
                                                                                                          //EasyLoading.show(status: 'لطفا منتظر بمانید');
                                                                                                          await withdrawGetOneController.updateRegistered(getOneDeposit?.id ?? 0,
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
                                                                                                              AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold,fontSize: 13),
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
                                                                                                    // اضافه واریزی
                                                                                                    Expanded(
                                                                                                      child: SizedBox(
                                                                                                        child: Row(
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              'اضافه واریزی: ',
                                                                                                              style:
                                                                                                              AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold,fontSize: 13),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              ' ${getOneDeposit?.extraAmount == null ? 0 : getOneDeposit?.extraAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                                              style:
                                                                                                              AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    // کد رهگیری
                                                                                                    Expanded(
                                                                                                      child: SizedBox(
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              'کد رهگیری: ${getOneDeposit?.trackingNumber ?? ""}',
                                                                                                              style:
                                                                                                              AppTextStyle.bodyText,
                                                                                                            ),
                                                                                                            Text(
                                                                                                              '${getOneDeposit?.date?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-')?? ""}',
                                                                                                              style:
                                                                                                              AppTextStyle.bodyText.copyWith(color: AppColor.secondary3Color,fontWeight: FontWeight.w600),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),

                                                                                                    // اضافه واریزی
                                                                                                    if( (getOneDeposit?.extraAmount ?? 0) > 0)
                                                                                                      Tooltip(
                                                                                                        message: "انتقال اضافه واریزی واریزی",
                                                                                                        child: GestureDetector(
                                                                                                          onTap: () {
                                                                                                            Get.defaultDialog(
                                                                                                                backgroundColor: AppColor
                                                                                                                    .backGroundColor,
                                                                                                                title: "انتقال اضافه واریزی",
                                                                                                                titleStyle: AppTextStyle
                                                                                                                    .smallTitleText,
                                                                                                                middleText: "آیا از انتقال اضافه واریزی مطمئن هستید؟",
                                                                                                                middleTextStyle: AppTextStyle
                                                                                                                    .bodyText,
                                                                                                                confirm: ElevatedButton(
                                                                                                                    style: ButtonStyle(
                                                                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                                                                            AppColor.primaryColor)),
                                                                                                                    onPressed: () {
                                                                                                                      Get.back();
                                                                                                                      withdrawGetOneController.changeExteraAmount(getOneDeposit?.id ?? 0);
                                                                                                                    },
                                                                                                                    child: Text(
                                                                                                                      'انتقال',
                                                                                                                      style: AppTextStyle
                                                                                                                          .bodyText,
                                                                                                                    )));
                                                                                                          },
                                                                                                          child: SvgPicture.asset(
                                                                                                            'assets/svg/extera-amount.svg',
                                                                                                            height: 24,
                                                                                                            //colorFilter: ColorFilter.mode(AppColor.dividerColor, BlendMode.srcIn),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    SizedBox(width: 10,),

                                                                                                    // برگشت واریزی
                                                                                                    if(getOneDeposit?.status!=4)
                                                                                                    Tooltip(
                                                                                                      message: "برگشت واریزی",
                                                                                                      child: GestureDetector(
                                                                                                        onTap: () {
                                                                                                            Get.defaultDialog(
                                                                                                                backgroundColor: AppColor
                                                                                                                    .backGroundColor,
                                                                                                                title: "برگشت واریزی",
                                                                                                                titleStyle: AppTextStyle
                                                                                                                    .smallTitleText,
                                                                                                                middleText: "آیا از برگشت واریزی مطمئن هستید؟",
                                                                                                                middleTextStyle: AppTextStyle
                                                                                                                    .bodyText,
                                                                                                                confirm: ElevatedButton(
                                                                                                                    style: ButtonStyle(
                                                                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                                                                            AppColor.primaryColor)),
                                                                                                                    onPressed: () {
                                                                                                                      Get.back();
                                                                                                                      withdrawGetOneController.insertFromDeposit(getOneDeposit?.id ?? 0);
                                                                                                                    },
                                                                                                                    child: Text(
                                                                                                                      'برگشت',
                                                                                                                      style: AppTextStyle
                                                                                                                          .bodyText,
                                                                                                                    )));
                                                                                                        },
                                                                                                        child: SvgPicture.asset(
                                                                                                                'assets/svg/back-deposit.svg',
                                                                                                                height: 20,
                                                                                                                colorFilter: ColorFilter.mode(AppColor.dividerColor, BlendMode.srcIn),
                                                                                                              ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(width: 8,),

                                                                                                    // وضعیت
                                                                                                    getOneDeposit
                                                                                                        ?.status ==
                                                                                                        1 ?
                                                                                                    SvgPicture.asset('assets/svg/check-mark-circle.svg',width: 18,height: 18,
                                                                                                        colorFilter: ColorFilter.mode(
                                                                                                          AppColor.primaryColor,
                                                                                                          BlendMode.srcIn,
                                                                                                        )):
                                                                                                    getOneDeposit
                                                                                                        ?.status ==
                                                                                                        2 ?
                                                                                                    SvgPicture.asset('assets/svg/close-circle1.svg',width: 18,height: 18,
                                                                                                        colorFilter: ColorFilter.mode(
                                                                                                          AppColor.accentColor,
                                                                                                          BlendMode.srcIn,
                                                                                                        )) :
                                                                                                    getOneDeposit
                                                                                                        ?.status ==
                                                                                                        4 ?
                                                                                                        Container(padding: EdgeInsets.only(bottom: 3),
                                                                                                            width: 45,
                                                                                                            height: 25,
                                                                                                            color: AppColor.accentColor,
                                                                                                            child: Center(child: Text("برگشتی",style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.bold),)))
                                                                                                        :
                                                                                                    SvgPicture.asset('assets/svg/unknown.svg',width: 16,height: 16,
                                                                                                        colorFilter: ColorFilter.mode(
                                                                                                          AppColor.dividerColor,
                                                                                                          BlendMode.srcIn,
                                                                                                        )),
                                                                                                    SizedBox(width: 8,),
                                                                                                    // ارسال تلگرام
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        getOneDeposit?.isSendTelegram == true ?
                                                                                                        Get.defaultDialog(
                                                                                                            backgroundColor: AppColor.backGroundColor,
                                                                                                            title: "ارسال مجدد",
                                                                                                            titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                                                                                            middleText: "آیا از ارسال مجدد واریزی مطمئن هستید؟",
                                                                                                            middleTextStyle: AppTextStyle.bodyText,
                                                                                                            confirm: ElevatedButton(
                                                                                                                style: ButtonStyle(
                                                                                                                    backgroundColor: WidgetStatePropertyAll(
                                                                                                                        AppColor.primaryColor)),
                                                                                                                onPressed: () {
                                                                                                                  Get.back();
                                                                                                                  withdrawGetOneController.sendTelegramDeposit(getOneDeposit?.id ?? 0);
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                  'ارسال مجدد',
                                                                                                                  style: AppTextStyle.bodyText,
                                                                                                                ))
                                                                                                        ) :
                                                                                                        Get.defaultDialog(
                                                                                                            backgroundColor: AppColor.backGroundColor,
                                                                                                            title: "ارسال به تلگرام",
                                                                                                            titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                                                                            middleText: "آیا از ارسال واریزی مطمئن هستید؟",
                                                                                                            middleTextStyle: AppTextStyle.bodyText,
                                                                                                            confirm: ElevatedButton(
                                                                                                                style: ButtonStyle(
                                                                                                                    backgroundColor: WidgetStatePropertyAll(
                                                                                                                        AppColor.primaryColor)),
                                                                                                                onPressed: () {
                                                                                                                  Get.back();
                                                                                                                  withdrawGetOneController.sendTelegramDeposit(getOneDeposit?.id ?? 0);
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                  'ارسال',
                                                                                                                  style: AppTextStyle.bodyText,
                                                                                                                ))
                                                                                                        );
                                                                                                      },
                                                                                                      child: Tooltip(
                                                                                                        message: getOneDeposit?.isSendTelegram == true ?  "ارسال مجدد واریزی به تلگرام" : "ارسال واریزی به تلگرام",
                                                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                          children: [
                                                                                                            Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: getOneDeposit?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                                                                                            SvgPicture.asset(
                                                                                                              'assets/svg/telegram.svg',height: 20,
                                                                                                              colorFilter: ColorFilter.mode(getOneDeposit?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(width: 8,),
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
                                                                                                          SvgPicture.asset('assets/svg/picture.svg',height: 18,
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
                                                                                      }))
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
                    /*width: Get.width*0.95,
                    height: Get.height,*/
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
                           Column(
                              children: [
                                // اطلاعات درخواست برداشت
                                withdrawGetOneController.currentTabIndex.value==0 ?
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
                                                getWithdraw.requestDate?.toPersianDate(
                                                    showTime: true,
                                                    twoDigits: true,
                                                    timeSeprator: "-") ?? "",
                                                style: AppTextStyle.bodyText,
                                              ),
                                              SizedBox(width: 40,),
                                              // وضعیت
                                              Row(
                                                children: [
                                                  Text(
                                                    'وضعیت: ',
                                                    style: AppTextStyle.bodyText,
                                                  ),
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          5),
                                                    ),
                                                    color: getWithdraw.status ==
                                                        2
                                                        ? AppColor
                                                        .accentColor
                                                        : getWithdraw
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
                                                          getWithdraw
                                                              .status ==
                                                              2
                                                              ? 'تایید نشده'
                                                              : getWithdraw
                                                              .status ==
                                                              1
                                                              ? 'تایید شده'
                                                              : 'در انتظار',
                                                          style: AppTextStyle
                                                              .labelText,
                                                          textAlign: TextAlign
                                                              .center),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 30,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  Text('تلگرام: ',
                                                    style: AppTextStyle
                                                        .labelText,),
                                                  getWithdraw.allDepositSent == true ?
                                                  Icon(Icons.check,
                                                    color: AppColor
                                                        .primaryColor,
                                                    size: 20,) :
                                                  Icon(Icons.close,
                                                    color: AppColor
                                                        .accentColor,
                                                    size: 20,)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // نام , شماره موبایل
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'نام: ${getWithdraw.wallet?.account?.name ?? ""}',
                                                style: AppTextStyle.bodyText,
                                              ),
                                              Text(
                                                'موبایل: ${getWithdraw.wallet?.account?.contactInfo ?? ""} ',
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
                                        // نام بانک , نام صاحب حساب
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                            children: [
                                              Text(
                                                'بانک: ${getWithdraw.bank?.name ?? ""}',
                                                style: AppTextStyle.bodyText,
                                              ),
                                              Text(
                                                'صاحب حساب: ${getWithdraw.ownerName ?? ""}',
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
                                                //'شماره کارت: ${getWithdraw.cardNumber ?? ""}',
                                                'شماره کارت: ${_formatCardNumber(getWithdraw.cardNumber)}',
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
                                ) :
                                SizedBox.shrink(),


                                Column(mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TabBar(
                                          controller: _tabController,
                                          labelStyle: AppTextStyle.bodyText,
                                          labelColor: AppColor.textColor,
                                          dividerColor: AppColor.backGroundColor,
                                          overlayColor: WidgetStatePropertyAll(AppColor.backGroundColor1),
                                          unselectedLabelColor: AppColor.textColor.withAlpha(120),
                                          indicatorColor: AppColor.primaryColor,
                                          onTap: (index) {
                                            withdrawGetOneController.currentTabIndex.value = index;
                                          },
                                          tabs: [
                                            Tab(text: "واریزهای تقسیم شده"),
                                            Tab(text: "مبالغ واریز شده"),
                                          ],
                                        ),

                                        SizedBox(
                                          height: withdrawGetOneController.currentTabIndex.value==0 ? Get.height*0.45 : Get.height*0.85,
                                          child: TabBarView(
                                            controller: _tabController,
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
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Get.toNamed('/depositRequestGetOne',parameters:{"id":getOneDepositRequest!.id.toString()});
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    SvgPicture.asset(
                                                                                        'assets/svg/eye1.svg',height: 30,width: 40,
                                                                                        colorFilter: ColorFilter
                                                                                            .mode(AppColor
                                                                                            .iconViewColor,
                                                                                          BlendMode.srcIn,)
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // مبلغ کل
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
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
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .end,
                                                                            children: [
                                                                              Text('تلگرام: ',
                                                                                style: AppTextStyle
                                                                                    .labelText,),
                                                                              getOneDepositRequest?.isSendTelegram == true ?
                                                                              Icon(Icons.check,
                                                                                color: AppColor
                                                                                    .primaryColor,
                                                                                size: 20,) :
                                                                              Icon(Icons.close,
                                                                                color: AppColor
                                                                                    .accentColor,
                                                                                size: 20,)
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      // مبلغ واریز شده
                                                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
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
                                                                            // ارسال تلگرام
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(width: 10,),
                                                                                // ارسال تلگرام
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    getOneDepositRequest?.isSendTelegram == true ?
                                                                                    Get.defaultDialog(
                                                                                        backgroundColor: AppColor.backGroundColor,
                                                                                        title: "ارسال مجدد",
                                                                                        titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                                                                        middleText: "آیا از ارسال مجدد درخواست واریزی مطمئن هستید؟",
                                                                                        middleTextStyle: AppTextStyle.bodyText,
                                                                                        confirm: ElevatedButton(
                                                                                            style: ButtonStyle(
                                                                                                backgroundColor: WidgetStatePropertyAll(
                                                                                                    AppColor.primaryColor)),
                                                                                            onPressed: () {
                                                                                              Get.back();
                                                                                              withdrawGetOneController.sendTelegramDepositRequest(getOneDepositRequest?.id ?? 0);
                                                                                            },
                                                                                            child: Text(
                                                                                              'ارسال مجدد',
                                                                                              style: AppTextStyle.bodyText,
                                                                                            ))
                                                                                    ) :
                                                                                    Get.defaultDialog(
                                                                                        backgroundColor: AppColor.backGroundColor,
                                                                                        title: "ارسال به تلگرام",
                                                                                        titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                                                        middleText: "آیا از ارسال درخواست واریزی مطمئن هستید؟",
                                                                                        middleTextStyle: AppTextStyle.bodyText,
                                                                                        confirm: ElevatedButton(
                                                                                            style: ButtonStyle(
                                                                                                backgroundColor: WidgetStatePropertyAll(
                                                                                                    AppColor.primaryColor)),
                                                                                            onPressed: () {
                                                                                              Get.back();
                                                                                              withdrawGetOneController.sendTelegramDepositRequest(getOneDepositRequest?.id ?? 0);
                                                                                            },
                                                                                            child: Text(
                                                                                              'ارسال',
                                                                                              style: AppTextStyle.bodyText,
                                                                                            ))
                                                                                    );
                                                                                  },
                                                                                  child: Tooltip(
                                                                                    message: getOneDepositRequest?.isSendTelegram == true ?  "ارسال مجدد درخواست واریزی به تلگرام" : "ارسال درخواست واریزی به تلگرام",
                                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: getOneDepositRequest?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                                                                        SvgPicture.asset(
                                                                                          'assets/svg/telegram.svg',height: 20,
                                                                                          colorFilter: ColorFilter.mode(getOneDepositRequest?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 45,)
                                                                              ],
                                                                            ),
                                                                            // وضعیت
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                  top: 4),
                                                                              child: Card(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      5),
                                                                                ),
                                                                                color: getOneDepositRequest?.status ==
                                                                                    2
                                                                                    ? AppColor
                                                                                    .accentColor
                                                                                    : getOneDepositRequest
                                                                                    ?.status ==
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
                                                                                      getOneDepositRequest
                                                                                          ?.status ==
                                                                                          2
                                                                                          ? 'تایید نشده'
                                                                                          : getOneDepositRequest
                                                                                          ?.status ==
                                                                                          1
                                                                                          ? 'تایید شده'
                                                                                          : 'در انتظار',
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      textAlign: TextAlign
                                                                                          .center),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                    child: SizedBox(width:Get.width ,
                                                      child: Card(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.zero,bottomLeft: Radius.zero,topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                                                          margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                                          color: AppColor.secondaryColor,
                                                          elevation: 0,
                                                          child:
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 10,top: 5,left: 10,bottom: 5),
                                                            child: Column(
                                                              children: [
                                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('مبالغ واریز شده',style: AppTextStyle.smallTitleText.copyWith(fontSize: 13),),
                                                                    Row(
                                                                      children: [
                                                                        // Filter button
                                                                        Obx(() {
                                                                          final hasFilters = withdrawGetOneController.hasActiveDepositFilters();
                                                                          return hasFilters
                                                                              ? IconButton(
                                                                            onPressed: () {
                                                                              withdrawGetOneController.clearDepositFilters();
                                                                            },
                                                                            icon: Icon(Icons.clear, color: AppColor.accentColor, size: 20),
                                                                            tooltip: 'پاک کردن فیلترها',
                                                                          )
                                                                              : SizedBox.shrink();
                                                                        }),
                                                                        IconButton(
                                                                          onPressed: () {
                                                                            showModalBottomSheet(
                                                                              enableDrag: true,
                                                                              context: context,
                                                                              backgroundColor: AppColor.backGroundColor,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                                              ),
                                                                              builder: (context) {
                                                                                return _buildDepositFilterBottomSheet();
                                                                              },
                                                                            );
                                                                          },
                                                                          icon: Icon(Icons.filter_list, color: AppColor.primaryColor, size: 20),
                                                                          tooltip: 'فیلتر',
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                // Filter summary
                                                                Obx(() {
                                                                  final hasFilters = withdrawGetOneController.hasActiveDepositFilters();
                                                                  return hasFilters
                                                                      ? Padding(
                                                                    padding: const EdgeInsets.only(top: 5),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons.filter_alt, color: AppColor.primaryColor, size: 16),
                                                                        SizedBox(width: 5),
                                                                        Text(
                                                                          'فیلتر فعال',
                                                                          style: AppTextStyle.labelText.copyWith(color: AppColor.primaryColor),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                      : SizedBox.shrink();
                                                                }),
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
                                                        Obx(() => ListView.builder(
                                                          shrinkWrap: true,
                                                          //physics: AlwaysScrollableScrollPhysics(),
                                                            itemCount: withdrawGetOneController.hasActiveDepositFilters()
                                                                ? withdrawGetOneController.filteredDeposits.length
                                                                : withdrawGetOneController.getOneWithdraw.value?.deposits?.length ?? 0,
                                                          itemBuilder: (context, index) {
                                                            var getOneDeposit = withdrawGetOneController.hasActiveDepositFilters()
                                                                ? withdrawGetOneController.filteredDeposits[index]
                                                                : withdrawGetOneController.getOneWithdraw.value?.deposits?[index];
                                                            return Container(
                                                              color: getOneDeposit?.registered==true ? AppColor.primaryColor.withAlpha(40) : getOneDeposit?.status==4 ? AppColor.accentColor.withAlpha(40): AppColor.secondaryColor,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      left: 10,
                                                                      right: 7,),
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              child: Text(
                                                                                '${getOneDeposit?.rowNum ?? ""}',
                                                                                style:
                                                                                AppTextStyle.labelText,
                                                                              ),
                                                                            ),
                                                                            Checkbox(
                                                                              value: getOneDeposit?.registered ?? false,
                                                                              onChanged: (value) async{
                                                                                if (value != null) {
                                                                                  //EasyLoading.show(status: 'لطفا منتظر بمانید');
                                                                                  await withdrawGetOneController.updateRegistered(getOneDeposit?.id ?? 0,
                                                                                      value
                                                                                  );
                                                                                }
                                                                                //depositController.fetchDepositList();
                                                                                //EasyLoading.dismiss();
                                                                              },
                                                                            ),
                                                                            // نام کاربر
                                                                            SizedBox(
                                                                              child: Text(
                                                                                getOneDeposit?.wallet?.account?.name ?? "",
                                                                                style:
                                                                                AppTextStyle.labelText,
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                                        // اضافه واریزی
                                                                         SizedBox(
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  'اضافه واریزی: ',
                                                                                  style:
                                                                                  AppTextStyle.bodyText,
                                                                                ),
                                                                                Text(
                                                                                  ' ${getOneDeposit?.extraAmount == null ? 0 : getOneDeposit?.extraAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                                  style:
                                                                                  AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                      padding: const EdgeInsets.only(
                                                                          left: 12,
                                                                          right: 7,
                                                                          bottom: 5),
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        // وضعیت و نمایش تصویر
                                                                        Row(
                                                                          children: [
                                                                            // ارسال تلگرام
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                getOneDeposit?.isSendTelegram == true ?
                                                                                Get.defaultDialog(
                                                                                    backgroundColor: AppColor.backGroundColor,
                                                                                    title: "ارسال مجدد",
                                                                                    titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                                                                    middleText: "آیا از ارسال مجدد واریزی مطمئن هستید؟",
                                                                                    middleTextStyle: AppTextStyle.bodyText,
                                                                                    confirm: ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                            backgroundColor: WidgetStatePropertyAll(
                                                                                                AppColor.primaryColor)),
                                                                                        onPressed: () {
                                                                                          Get.back();
                                                                                          withdrawGetOneController.sendTelegramDeposit(getOneDeposit?.id ?? 0);
                                                                                        },
                                                                                        child: Text(
                                                                                          'ارسال مجدد',
                                                                                          style: AppTextStyle.bodyText,
                                                                                        ))
                                                                                ) :
                                                                                Get.defaultDialog(
                                                                                    backgroundColor: AppColor.backGroundColor,
                                                                                    title: "ارسال به تلگرام",
                                                                                    titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                                                    middleText: "آیا از ارسال واریزی مطمئن هستید؟",
                                                                                    middleTextStyle: AppTextStyle.bodyText,
                                                                                    confirm: ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                            backgroundColor: WidgetStatePropertyAll(
                                                                                                AppColor.primaryColor)),
                                                                                        onPressed: () {
                                                                                          Get.back();
                                                                                          withdrawGetOneController.sendTelegramDeposit(getOneDeposit?.id ?? 0);
                                                                                        },
                                                                                        child: Text(
                                                                                          'ارسال',
                                                                                          style: AppTextStyle.bodyText,
                                                                                        ))
                                                                                );
                                                                              },
                                                                              child: Tooltip(
                                                                                message: getOneDeposit?.isSendTelegram == true ?  "ارسال مجدد واریزی به تلگرام" : "ارسال واریزی به تلگرام",
                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: getOneDeposit?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                                                                    SvgPicture.asset(
                                                                                      'assets/svg/telegram.svg',height: 20,
                                                                                      colorFilter: ColorFilter.mode(getOneDeposit?.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 5,),
                                                                            // وضعیت
                                                                            getOneDeposit
                                                                                ?.status ==
                                                                                1 ?
                                                                            SvgPicture.asset('assets/svg/check-mark-circle.svg',width: 20,height: 20,
                                                                                colorFilter: ColorFilter.mode(
                                                                                  AppColor.primaryColor,
                                                                                  BlendMode.srcIn,
                                                                                )):
                                                                            getOneDeposit
                                                                                ?.status ==
                                                                                2 ?
                                                                            SvgPicture.asset('assets/svg/close-circle1.svg',width: 20,height: 20,
                                                                                colorFilter: ColorFilter.mode(
                                                                                  AppColor.accentColor,
                                                                                  BlendMode.srcIn,
                                                                                )) :
                                                                            getOneDeposit
                                                                                ?.status ==
                                                                                4 ?
                                                                            Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: AppColor.accentColor,
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                                padding: EdgeInsets.only(bottom: 3),
                                                                                width: 45,
                                                                                height: 22,
                                                                                child: Center(child: Text("برگشتی",style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.bold),)))
                                                                                :
                                                                            SvgPicture.asset('assets/svg/unknown.svg',width: 20,height: 20,
                                                                                colorFilter: ColorFilter.mode(
                                                                                  AppColor.dividerColor,
                                                                                  BlendMode.srcIn,
                                                                                )),
                                                                            SizedBox(width: 5,),
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
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 35,
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
                                                                        // تاریخ
                                                                        Text(
                                                                          getOneDeposit?.date?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-')?? "",
                                                                          style:
                                                                          AppTextStyle.bodyText.copyWith(color: AppColor.secondary3Color,fontWeight: FontWeight.w600),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            // اضافه واریزی
                                                                            if( (getOneDeposit?.extraAmount ?? 0) > 0)
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Get.defaultDialog(
                                                                                      backgroundColor: AppColor
                                                                                          .backGroundColor,
                                                                                      title: "انتقال اضافه واریزی",
                                                                                      titleStyle: AppTextStyle
                                                                                          .smallTitleText,
                                                                                      middleText: "آیا از انتقال اضافه واریزی مطمئن هستید؟",
                                                                                      middleTextStyle: AppTextStyle
                                                                                          .bodyText,
                                                                                      confirm: ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                              backgroundColor: WidgetStatePropertyAll(
                                                                                                  AppColor.primaryColor)),
                                                                                          onPressed: () {
                                                                                            Get.back();
                                                                                            withdrawGetOneController.changeExteraAmount(getOneDeposit!.id!);
                                                                                          },
                                                                                          child: Text(
                                                                                            'انتقال',
                                                                                            style: AppTextStyle
                                                                                                .bodyText,
                                                                                          )));
                                                                                },
                                                                                child: SvgPicture.asset(
                                                                                  'assets/svg/extera-amount.svg',
                                                                                  height: 30,width: 40,
                                                                                  //colorFilter: ColorFilter.mode(AppColor.dividerColor, BlendMode.srcIn),
                                                                                ),
                                                                              ),
                                                                            SizedBox(width: 10,),
                                                                            // برگشت واریزی
                                                                            if(getOneDeposit?.status!=4)
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Get.defaultDialog(
                                                                                      backgroundColor: AppColor
                                                                                          .backGroundColor,
                                                                                      title: "برگشت واریزی",
                                                                                      titleStyle: AppTextStyle
                                                                                          .smallTitleText,
                                                                                      middleText: "آیا از برگشت واریزی مطمئن هستید؟",
                                                                                      middleTextStyle: AppTextStyle
                                                                                          .bodyText,
                                                                                      confirm: ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                              backgroundColor: WidgetStatePropertyAll(
                                                                                                  AppColor.primaryColor)),
                                                                                          onPressed: () {
                                                                                            Get.back();
                                                                                            withdrawGetOneController.insertFromDeposit(getOneDeposit!.id!);
                                                                                          },
                                                                                          child: Text(
                                                                                            'برگشت',
                                                                                            style: AppTextStyle
                                                                                                .bodyText,
                                                                                          )));
                                                                                },
                                                                                child: SvgPicture.asset(
                                                                                  'assets/svg/back-deposit.svg',
                                                                                  height: 30,width:40,
                                                                                  colorFilter: ColorFilter.mode(AppColor.dividerColor, BlendMode.srcIn),
                                                                                ),
                                                                              ),
                                                                          ],
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
                                                            );
                                                          }))
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
      floatingActionButton:isDesktop? FloatingActionButton(
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
    );
  }

  Widget _buildDepositFilterBottomSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'فیلتر مبالغ واریز شده',
                style: AppTextStyle.smallTitleText,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: AppColor.textColor),
              ),
            ],
          ),
          SizedBox(height: 20),

          // User name filter
          Text(
            'نام کاربر:',
            style: AppTextStyle.bodyText,
          ),
          SizedBox(height: 8),
          TextField(
            controller: withdrawGetOneController.userNameFilterController,
            style: AppTextStyle.labelText.copyWith(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'نام کاربر را وارد کنید',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (value) {
              withdrawGetOneController.userNameFilter.value = value;
              withdrawGetOneController.applyDepositFilters();
            },
          ),
          SizedBox(height: 16),

          // Amount filter
          Text(
            'مبلغ:',
            style: AppTextStyle.bodyText,
          ),
          SizedBox(height: 8),
          TextField(
            controller: withdrawGetOneController.amountFilterController,
            style: AppTextStyle.labelText.copyWith(fontSize: 15),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^[\d٠-٩۰-۹,]*\.?[\d٠-٩۰-۹]*$'),
              ),
              TextInputFormatter.withFunction((oldValue, newValue) {
                // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                String newText = newValue.text
                    .replaceAll('٠', '0')
                    .replaceAll('١', '1')
                    .replaceAll('٢', '2')
                    .replaceAll('٣', '3')
                    .replaceAll('٤', '4')
                    .replaceAll('٥', '5')
                    .replaceAll('٦', '6')
                    .replaceAll('٧', '7')
                    .replaceAll('٨', '8')
                    .replaceAll('٩', '9');

                // حذف کاماهای موجود برای پردازش
                String cleanText = newText.replaceAll(',', '');

                // اضافه کردن کاما به عنوان جداکننده هزارگان
                String formattedText = _formatNumberWithCommas(cleanText);

                return newValue.copyWith(
                  text: formattedText,
                  selection: TextSelection.collapsed(offset: formattedText.length),
                );
              }),
            ],
            decoration: InputDecoration(
              hintText: 'مبلغ را وارد کنید',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (value) {
              withdrawGetOneController.amountFilter.value = value;
              withdrawGetOneController.applyDepositFilters();
            },
          ),
          SizedBox(height: 16),

          // Tracking number filter
          Text(
            'کد رهگیری:',
            style: AppTextStyle.bodyText,
          ),
          SizedBox(height: 8),
          TextField(
            controller: withdrawGetOneController.trackingNumberFilterController,
            style: AppTextStyle.labelText.copyWith(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'کد رهگیری را وارد کنید',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (value) {
              withdrawGetOneController.trackingNumberFilter.value = value;
              withdrawGetOneController.applyDepositFilters();
            },
          ),
          SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    withdrawGetOneController.clearDepositFilters();
                    Get.back();
                  },
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(BorderSide(color: AppColor.accentColor)),
                  ),
                  child: Text(
                    'پاک کردن',
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                  ),
                  child: Text(
                    'اعمال فیلتر',
                    style: AppTextStyle.bodyText.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatNumberWithCommas(String text) {
    if (text.isEmpty) return text;

    // حذف تمام کاراکترهای غیر عددی به جز نقطه
    String cleanText = text.replaceAll(RegExp(r'[^\d.]'), '');

    // اگر متن خالی است، برگردان
    if (cleanText.isEmpty) return '';

    // تقسیم به قسمت اعشار و عدد صحیح
    List<String> parts = cleanText.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // اضافه کردن کاما به عدد صحیح
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    return formattedInteger + decimalPart;
  }
}

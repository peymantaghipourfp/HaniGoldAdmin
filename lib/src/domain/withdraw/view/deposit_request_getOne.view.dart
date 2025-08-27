
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/deposit_request_getOne.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import '../../home/widget/chat_dialog.widget.dart';

class DepositRequestGetOneView extends StatelessWidget {
  DepositRequestGetOneView({super.key});

  final DepositRequestGetOneController depositRequestGetOneController = Get.find<DepositRequestGetOneController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(title: 'اطلاعات واریزی',
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
                      child: SingleChildScrollView(
                    child: Obx(() {
                      var getDepositRequest =
                          depositRequestGetOneController.getOneDepositRequest.value;
                      if (depositRequestGetOneController.state.value == PageState.loading) {
                        EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
                        return Center(child: CircularProgressIndicator());
                      } else if (depositRequestGetOneController.state.value == PageState.empty) {
                        EasyLoading.dismiss();
                        return EmptyPage(
                          title: 'واریزی وجود ندارد',
                          callback: () {
                            depositRequestGetOneController.fetchGetOneDepositRequest(
                                depositRequestGetOneController.id.value);
                          },
                        );
                      } else if (depositRequestGetOneController.state.value == PageState.list) {
                        EasyLoading.dismiss();
                        if (getDepositRequest == null) {
                          return Center(child: Text('اطلاعات واریزی یافت نشد'));
                        }
                        return
                          SingleChildScrollView(
                            child: Column(
                            children: [
                              // اطلاعات واریزی
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
                                        // اطلاعات واریزی
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('اطلاعات واریزی',
                                              style: AppTextStyle.smallTitleText
                                                  .copyWith(fontSize: 13),
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
                                              getDepositRequest.date?.toPersianDate(
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
                                              color: getDepositRequest
                                                  .status ==
                                                  2
                                                  ? AppColor
                                                  .accentColor
                                                  : getDepositRequest
                                                  .status ==
                                                  1
                                                  ? AppColor
                                                  .primaryColor
                                                  : AppColor
                                                  .secondaryColor
                                              ,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 5),
                                              child: Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Text(
                                                    getDepositRequest
                                                        .status ==
                                                        2
                                                        ? 'تایید نشده'
                                                        : getDepositRequest
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
                                      ),
                                      // نام
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            Text(
                                              'نام: ${getDepositRequest.account?.name ?? ""}',
                                              style: AppTextStyle.bodyText,
                                            ),
                                            Text(
                                              'شماره موبایل: ${getDepositRequest.account?.contactInfo ?? ""} ',
                                              style: AppTextStyle.bodyText,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // مبلغ تعیین شده
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'مبلغ کل: ${getDepositRequest.amount== null ? 0 :
                                              getDepositRequest.amount?.toInt().toString().seRagham(separator: ',') } ریال ',
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
                                              '${getDepositRequest.paidAmount==null ? 0 :
                                              getDepositRequest.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                              style: AppTextStyle.bodyText.copyWith(
                                                  color: AppColor.primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // واریز های انجام شده
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
                                  depositRequestGetOneController.getOneDepositRequest.value?.deposits!=null ?
                                  SizedBox(
                                    width: Get.width,
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
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: depositRequestGetOneController.getOneDepositRequest.value?.deposits?.length,
                                          itemBuilder: (context, index) {
                                            var getOneDeposit =
                                            depositRequestGetOneController.getOneDepositRequest.value?.deposits?[index];
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

                                                        // مبلغ و عکس
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              top: 2, bottom: 2),
                                                          child:
                                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Checkbox(
                                                                value: getOneDeposit?.registered ?? false,
                                                                onChanged: (value) async{
                                                                  if (value != null) {
                                                                    //EasyLoading.show(status: 'لطفا منتظر بمانید');
                                                                    await depositRequestGetOneController.updateRegistered(
                                                                        getOneDeposit!.id!,
                                                                        value
                                                                    );
                                                                  }
                                                                  //EasyLoading.dismiss();
                                                                },
                                                              ),
                                                              Text(
                                                                'مبلغ: ${getOneDeposit?.amount == null ? 0 : getOneDeposit?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                                style:
                                                                AppTextStyle.bodyText,
                                                              ),
                                                              // نمایش عکس
                                                              GestureDetector(
                                                                onTap: () async{
                                                                  await depositRequestGetOneController.getImage(getOneDeposit?.recId ??"", "Deposit");
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
                                                                                        controller: depositRequestGetOneController
                                                                                            .pageController,
                                                                                        itemCount: depositRequestGetOneController.imageList.length,
                                                                                        onPageChanged: (index) =>
                                                                                        depositRequestGetOneController
                                                                                            .currentImagePage
                                                                                            .value =
                                                                                            index,
                                                                                        itemBuilder: (context,
                                                                                            index) {
                                                                                          final attachment = depositRequestGetOneController.imageList[index];
                                                                                          return Column(
                                                                                            children: [
                                                                                              if (kIsWeb)
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(right: 50),
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      IconButton(
                                                                                                        icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                                                                        onPressed: () => depositRequestGetOneController.downloadImage(
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
                                                                                              visible: depositRequestGetOneController
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
                                                                                                  depositRequestGetOneController.pageController
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
                                                                                              visible: depositRequestGetOneController
                                                                                                  .currentImagePage.value <
                                                                                                  (depositRequestGetOneController.imageList.length ?? 1) -
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
                                                                                                  depositRequestGetOneController.pageController
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
                                                                                              depositRequestGetOneController.imageList.length,
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
                                                                                                      color: depositRequestGetOneController
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
                                                            ],
                                                          ),
                                                        ),

                                                        // آیکون های عملیات حذف و آپدیت و کد رهگیری
                                                        Padding(
                                                            padding: const EdgeInsets.only(
                                                                top: 5, bottom: 2),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              // وضعیت
                                                              Card(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      5),
                                                                ),
                                                                color: getOneDeposit?.status ==
                                                                    2
                                                                    ? AppColor
                                                                    .accentColor
                                                                    : getOneDeposit
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
                                                                      getOneDeposit
                                                                          ?.status ==
                                                                          2
                                                                          ? 'تایید نشده'
                                                                          : getOneDeposit
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
                                                              // آیکون ویرایش و آیکون حذف کردن
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      /*if ( getOneDeposit?.status==1){
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
                                                                      }else {*/
                                                                        Get.toNamed('/depositUpdate', parameters:{"id":getOneDeposit!.id.toString()});
                                                                      //}
                                                                    },
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                            'assets/svg/edit.svg',
                                                                            colorFilter: ColorFilter
                                                                                .mode(AppColor
                                                                                .iconViewColor,
                                                                              BlendMode.srcIn,)
                                                                        ),
                                                                        Text(' ویرایش',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 10,),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      /*if (getOneDeposit?.status==1){
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
                                                                      }else {*/
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
                                                                                  depositRequestGetOneController.deleteDeposit(getOneDeposit!.id!, true);
                                                                                },
                                                                                child: Text(
                                                                                  'حذف',
                                                                                  style: AppTextStyle.bodyText,
                                                                                )));
                                                                      //}
                                                                    },
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                            'assets/svg/trash-bin.svg',
                                                                            colorFilter: ColorFilter
                                                                                .mode(AppColor
                                                                                .accentColor,
                                                                              BlendMode.srcIn,)
                                                                        ),
                                                                        Text(' حذف',style: AppTextStyle.labelText.copyWith(color: AppColor.accentColor),),
                                                                      ],
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
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  )
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
                                ],
                              ),
                            ],
                                                    ),
                          );
                      }
                      EasyLoading.dismiss();
                      return ErrPage(
                        callback: () {
                          depositRequestGetOneController.fetchGetOneDepositRequest(getDepositRequest?.id ?? 0);
                        },
                        title: "خطا در دریافت اطلاعات درخواست برداشت",
                        des: 'برای مشاهده درخواست برداشت مجددا تلاش کنید',
                      );
                    }),
                  ),
                   ),
                    )
                      :
                  SizedBox(
                    width: Get.width*0.9,
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Obx(() {
                          var getDepositRequest =
                              depositRequestGetOneController.getOneDepositRequest.value;
                          if (depositRequestGetOneController.state.value ==
                              PageState.loading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (depositRequestGetOneController.state.value ==
                              PageState.empty) {
                            return EmptyPage(
                              title: 'واریزی وجود ندارد',
                              callback: () {
                                depositRequestGetOneController.fetchGetOneDepositRequest(
                                    depositRequestGetOneController.id.value);
                              },
                            );
                          } else if (depositRequestGetOneController.state.value ==
                              PageState.list) {

                            if (getDepositRequest == null) {
                              return Center(child: Text('اطلاعات واریزی یافت نشد'));
                            }
                            return
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  // اطلاعات واریزی
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
                                            // اطلاعات واریزی
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('اطلاعات واریزی',
                                                  style: AppTextStyle.smallTitleText
                                                      .copyWith(fontSize: 13),
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
                                                  getDepositRequest.date?.toPersianDate(
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
                                                  color: getDepositRequest
                                                      .status ==
                                                      2
                                                      ? AppColor
                                                      .accentColor
                                                      : getDepositRequest
                                                      .status ==
                                                      1
                                                      ? AppColor
                                                      .primaryColor
                                                      : AppColor
                                                      .secondaryColor
                                                  ,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 0, horizontal: 5),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2),
                                                    child: Text(
                                                        getDepositRequest
                                                            .status ==
                                                            2
                                                            ? 'تایید نشده'
                                                            : getDepositRequest
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
                                          ),
                                          // نام
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Row(mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                              children: [
                                                Text(
                                                  'نام: ${getDepositRequest.account?.name ?? ""}',
                                                  style: AppTextStyle.bodyText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // شماره موبایل
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Row(mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                              children: [
                                                Text(
                                                  'شماره موبایل: ${getDepositRequest.account?.contactInfo ?? ""} ',
                                                  style: AppTextStyle.bodyText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // مبلغ تعیین شده
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'مبلغ کل: ${getDepositRequest.amount== null ? 0 :
                                                  getDepositRequest.amount?.toInt().toString().seRagham(separator: ',') } ریال ',
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
                                                  '${getDepositRequest.paidAmount==null ? 0 :
                                                  getDepositRequest.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                  style: AppTextStyle.bodyText.copyWith(
                                                      color: AppColor.primaryColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // واریز های انجام شده
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
                                      depositRequestGetOneController.getOneDepositRequest.value?.deposits!=null ?
                                      SizedBox(
                                        width: Get.width,

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
                                          child: ListView.builder(

                                              shrinkWrap: true,
                                              itemCount: depositRequestGetOneController.getOneDepositRequest.value?.deposits?.length,
                                              itemBuilder: (context, index) {
                                                var getOneDeposit =
                                                depositRequestGetOneController.getOneDepositRequest.value?.deposits?[index];
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

                                                            // مبلغ و عکس
                                                            Padding(
                                                              padding: const EdgeInsets.only(
                                                                  top: 2, bottom: 2),
                                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Checkbox(
                                                                    value: getOneDeposit?.registered ?? false,
                                                                    onChanged: (value) async{
                                                                      if (value != null) {
                                                                        //EasyLoading.show(status: 'لطفا منتظر بمانید');
                                                                        await depositRequestGetOneController.updateRegistered(
                                                                            getOneDeposit!.id!,
                                                                            value
                                                                        );
                                                                      }
                                                                      //EasyLoading.dismiss();
                                                                    },
                                                                  ),
                                                                  Text(
                                                                    'مبلغ: ${getOneDeposit?.amount == null ? 0 : getOneDeposit?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
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
                                                                                        return Column(
                                                                                          children: [
                                                                                            Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                                                                  onPressed: () => depositRequestGetOneController.downloadImage(
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

                                                            // آیکون های عملیات حذف و آپدیت و کد رهگیری
                                                            Padding(
                                                              padding: const EdgeInsets.only(
                                                                  top: 10, bottom: 2),
                                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  // وضعیت
                                                                  Card(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          5),
                                                                    ),
                                                                    color: getOneDeposit?.status ==
                                                                        2
                                                                        ? AppColor
                                                                        .accentColor
                                                                        : getOneDeposit
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
                                                                          getOneDeposit
                                                                              ?.status ==
                                                                              2
                                                                              ? 'تایید نشده'
                                                                              : getOneDeposit
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
                                                                  // آیکون ویرایش و آیکون حذف کردن
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          /*if ( getOneDeposit?.status==1){
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
                                                                          }else {*/
                                                                            Get.toNamed('/depositUpdate', parameters:{"id":getOneDeposit!.id.toString()});
                                                                         // }
                                                                        },
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                                'assets/svg/edit.svg',
                                                                                colorFilter: ColorFilter
                                                                                    .mode(AppColor
                                                                                    .iconViewColor,
                                                                                  BlendMode.srcIn,)
                                                                            ),
                                                                            Text(' ویرایش',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 10,),
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          /*if (getOneDeposit?.status==1){
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
                                                                          }else {*/
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
                                                                                      depositRequestGetOneController.deleteDeposit(getOneDeposit!.id!, true);
                                                                                    },
                                                                                    child: Text(
                                                                                      'حذف',
                                                                                      style: AppTextStyle.bodyText,
                                                                                    )));
                                                                          //}
                                                                        },
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                                'assets/svg/trash-bin.svg',
                                                                                colorFilter: ColorFilter
                                                                                    .mode(AppColor
                                                                                    .accentColor,
                                                                                  BlendMode.srcIn,)
                                                                            ),
                                                                            Text(' حذف',style: AppTextStyle.labelText.copyWith(color: AppColor.accentColor),),
                                                                          ],
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
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      )
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
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return ErrPage(
                            callback: () {
                              depositRequestGetOneController.fetchGetOneDepositRequest(getDepositRequest?.id ?? 0);
                            },
                            title: "خطا در دریافت اطلاعات درخواست برداشت",
                            des: 'برای مشاهده درخواست برداشت مجددا تلاش کنید',
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

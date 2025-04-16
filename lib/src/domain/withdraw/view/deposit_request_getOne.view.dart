
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/deposit_request_getOne.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';

class DepositRequestGetOneView extends StatelessWidget {
  DepositRequestGetOneView({super.key});

  final DepositRequestGetOneController depositRequestGetOneController = Get.find<DepositRequestGetOneController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppBar(title: 'اطلاعات واریزی',
          onBackTap: ()=> Get.back()
      ),
      body: SafeArea(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
            child: Obx(() {
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
                var getDepositRequest =
                    depositRequestGetOneController.getOneDepositRequest.value;
                if (getDepositRequest == null) {
                  return Center(child: Text('اطلاعات واریزی یافت نشد'));
                }
                return Column(
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
                                    color: (getDepositRequest.status == 0)
                                        ? AppColor.accentColor
                                        : AppColor.primaryColor,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                          (getDepositRequest.status == 0)
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

                                              // مبلغ و عکس
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 2),
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'مبلغ: ${getOneDeposit?.amount == null ? 0 : getOneDeposit?.amount?.toInt().toString().seRagham(separator: ',')} ریال ',
                                                      style:
                                                      AppTextStyle.bodyText,
                                                    ),
                                                    // نمایش عکس
                                                    GestureDetector(
                                                      onTap: () {
                                                        int attachIndex=getOneDeposit!.attachments!.isNotEmpty ? 0 : -1;
                                                        if (getOneDeposit.attachments != null && getOneDeposit.attachments!.isNotEmpty) {
                                                          String imageUrl =
                                                              "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=${getOneDeposit.attachments?[attachIndex].guidId}";
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return Dialog(
                                                                clipBehavior: Clip.antiAlias,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                insetPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                                                                child: Container(
                                                                  constraints: BoxConstraints( // Add constraints for web
                                                                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                                                                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                                                                  ),
                                                                  padding: EdgeInsets.all(8),
                                                                  child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        InteractiveViewer(
                                                                          panEnabled: true,
                                                                          boundaryMargin: EdgeInsets.zero,
                                                                          minScale: 0.5,
                                                                          maxScale: 4,
                                                                          child: ConstrainedBox(
                                                                            constraints: BoxConstraints(
                                                                              maxHeight: MediaQuery.of(context).size.height * 0.6,
                                                                            ),
                                                                            child: Image.network(
                                                                              imageUrl,
                                                                              fit: BoxFit.contain,
                                                                              loadingBuilder: (context, child, loadingProgress) {
                                                                                if (loadingProgress == null) return child;
                                                                                return Center(
                                                                                  child: CircularProgressIndicator(
                                                                                    value: loadingProgress.expectedTotalBytes != null
                                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                                        loadingProgress.expectedTotalBytes!
                                                                                        : null,
                                                                                  ),
                                                                                );
                                                                              },
                                                                              errorBuilder: (context, error, stackTrace) =>
                                                                                  Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Icon(Icons.error_outline, color: Colors.red, size: 40),
                                                                                      SizedBox(height: 10),
                                                                                      Text('خطا در بارگذاری تصویر',
                                                                                          style: AppTextStyle.bodyText),
                                                                                    ],
                                                                                  )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top: 10),
                                                                          child: TextButton(
                                                                            onPressed: () {
                                                                              Get.back();
                                                                            },
                                                                            child: Text("بستن"),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }else {
                                                          Get.snackbar('پیغام', 'تصویری ثبت نشده است');
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text('عکس  ',style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor),),
                                                          SizedBox(width: 25,height: 25,
                                                            child: SvgPicture.asset(
                                                                'assets/svg/picture.svg',
                                                                colorFilter: ColorFilter
                                                                    .mode(AppColor
                                                                    .iconViewColor,
                                                                  BlendMode.srcIn,)
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
                );
              }
              return ErrPage(
                callback: () {
                  depositRequestGetOneController.fetchGetOneDepositRequest(depositRequestGetOneController.id.value);
                },
                title: "خطا در دریافت اطلاعات درخواست برداشت",
                des: 'برای مشاهده درخواست برداشت مجددا تلاش کنید',
              );
            }),
          ),
        ),
          )
      ),
    );
  }
}

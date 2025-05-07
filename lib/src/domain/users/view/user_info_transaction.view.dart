import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/user_info_transaction.controller.dart';
import '../widgets/balance.widget.dart';
import '../widgets/tabel_info.widget.dart';

class UserInfoTransactionView extends GetView<UserInfoTransactionController> {
  const UserInfoTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
          appBar: CustomAppBar(
            title: 'جزییات تراکنش کاربر',
            onBackTap: () => Get.back(),
          ),
          body: SafeArea(
            child: controller.state.value == PageState.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.state.value == PageState.list
                    ? SizedBox(
                    height: Get.height,width: Get.width,
                        child: Column(
                          children: [
                            isDesktop?
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: AppColor.backGroundColor
                              ),
                              child: Column(
                                children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          ' حساب کاربری ${controller.headerInfoUserTransactionModel?.accountName??""}',
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 14 : 13),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,height: 35,
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: AppColor.primaryColor
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColor.textColor,
                                                    BlendMode.srcIn,
                                                  )),
                                              SizedBox(width: 2,),
                                              Text(
                                                'ویرایش',
                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 90,height: 35,
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: AppColor.secondary2Color
                                          ),
                                          child: Row(
                                            children: [
                                              // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                              //     colorFilter: ColorFilter.mode(
                                              //       AppColor.textColor,
                                              //       BlendMode.srcIn,
                                              //     )),
                                              // SizedBox(width: 5,),
                                              Text(
                                                'صدور فاکتور',
                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Container(
                                          width: 120,height: 35,
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: AppColor.accentColor
                                          ),
                                          child: Row(
                                            children: [
                                              // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                              //     colorFilter: ColorFilter.mode(
                                              //       AppColor.textColor,
                                              //       BlendMode.srcIn,
                                              //     )),
                                              // SizedBox(width: 5,),
                                              Text(
                                                'صدور فاکتور جدید',
                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 120,height: 35,
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: AppColor.secondary2Color
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset('assets/svg/fileExcel.svg',height: 20,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColor.textColor,
                                                    BlendMode.srcIn,
                                                  )),
                                              SizedBox(width: 0,),
                                              Text(
                                                'خروجی اکسل',
                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                              
                                  ],
                                ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    height: 0.8,
                                    width: Get.width,
                                    color: AppColor.textColor,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: AppColor.textFieldColor,
                                            backgroundImage: AssetImage("assets/images/boy.png"),
                                          ),
                                          Container(
                                           // width: 300,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(
                                                            'نام : ',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,fontWeight: FontWeight.normal),
                                                          ),
                                                        ),
                              
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(
                                                            'شماره : ',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(
                                                            'نقش : ',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(
                                                            'تاریخ عضویت : ',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(
                                                            'بیعانه : ',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(
                                                            'آدرس : ',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: AppColor.textColor
                                                          ),
                                                          child: Text(
                                                            controller.headerInfoUserTransactionModel?.accountName??"",
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: AppColor.textColor
                                                          ),
                                                          child: Text(
                                                            controller.headerInfoUserTransactionModel?.tell??"",
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: AppColor.textColor
                                                          ),
                                                          child: Text(
                                                            controller.headerInfoUserTransactionModel?.accountGroup??"",
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: AppColor.textColor
                                                          ),
                                                          child: Text(
                                                            controller.headerInfoUserTransactionModel!.startDate!.toPersianDate().toString(),
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                          ),
                                                        ),
                                                          
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: AppColor.textColor
                                                          ),
                                                          child: Text(
                                                            controller.headerInfoUserTransactionModel?.deposit??"",
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color: AppColor.accentColor),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: AppColor.textColor
                                                          ),
                                                          child: Text(
                                                            controller.headerInfoUserTransactionModel?.address??"",
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      BalanceWidget(listBalance: controller.balanceList, size: 300,)
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TabelInfoWidget(list: controller.headerInfoUserTransactionModel!.inventorys!, title: 'دریافت و پرداخت', title1: 'دریافت', title2: 'پرداخت',
                                      typeSel1: 'receive', typeSel2: 'payment',),
                                    SizedBox(width: 30,),
                                    TabelInfoWidget(list: controller.headerInfoUserTransactionModel!.orders!, title: 'خرید و فروش', title1: 'خرید', title2: 'فروش',
                                      typeSel1: 'buy', typeSel2: 'sell',),
                                    SizedBox(width: 30,),
                                    TabelInfoWidget(list: controller.headerInfoUserTransactionModel!.remmitances!, title: 'حواله', title1: 'حواله', title2: 'رسید',
                                      typeSel1: 'issue', typeSel2: 'reciept',),
                                  ],
                                ),
                                                          
                              
                                ],
                              ),
                            ):
                            Expanded(
                              flex:3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: AppColor.backGroundColor
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'حساب کاربری محمود نصرالهی',
                                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 14 : 13),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 80,height: 35,
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(7),
                                                          color: AppColor.primaryColor
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                                              colorFilter: ColorFilter.mode(
                                                                AppColor.textColor,
                                                                BlendMode.srcIn,
                                                              )),
                                                          SizedBox(width: 2,),
                                                          Text(
                                                            'ویرایش',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 80,height: 35,
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(7),
                                                          color: AppColor.secondary2Color
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                                          //     colorFilter: ColorFilter.mode(
                                                          //       AppColor.textColor,
                                                          //       BlendMode.srcIn,
                                                          //     )),
                                                          // SizedBox(width: 5,),
                                                          Text(
                                                            'صدور فاکتور',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 100,height: 35,
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(7),
                                                          color: AppColor.accentColor
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          // SvgPicture.asset('assets/svg/edit.svg',height: 17,
                                                          //     colorFilter: ColorFilter.mode(
                                                          //       AppColor.textColor,
                                                          //       BlendMode.srcIn,
                                                          //     )),
                                                          // SizedBox(width: 5,),
                                                          Text(
                                                            'صدور فاکتور جدید',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100,height: 35,
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(7),
                                                          color: AppColor.secondary2Color
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset('assets/svg/fileExcel.svg',height: 20,
                                                              colorFilter: ColorFilter.mode(
                                                                AppColor.textColor,
                                                                BlendMode.srcIn,
                                                              )),
                                                          SizedBox(width: 0,),
                                                          Text(
                                                            'خروجی اکسل',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                        height: 0.8,
                                        width: Get.width,
                                        color: AppColor.textColor,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor: AppColor.textFieldColor,
                                                backgroundImage: AssetImage("assets/images/boy.png"),
                                              ),
                                              Container(
                                                // width: 300,
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              child: Text(
                                                                'نام : ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,fontWeight: FontWeight.normal),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              child: Text(
                                                                'شماره : ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              child: Text(
                                                                'نقش : ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              child: Text(
                                                                'تاریخ عضویت : ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              child: Text(
                                                                'بیعانه : ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              child: Text(
                                                                'آدرس : ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: AppColor.textColor
                                                              ),
                                                              child: Text(
                                                                controller.headerInfoUserTransactionModel?.accountName??"",
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: AppColor.textColor
                                                              ),
                                                              child: Text(
                                                                controller.headerInfoUserTransactionModel?.tell??"",
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: AppColor.textColor
                                                              ),
                                                              child: Text(
                                                                controller.headerInfoUserTransactionModel?.accountGroup??"",
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: AppColor.textColor
                                                              ),
                                                              child: Text(
                                                                controller.headerInfoUserTransactionModel!.startDate!.toPersianDate().toString(),
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: AppColor.textColor
                                                              ),
                                                              child: Text(
                                                                controller.headerInfoUserTransactionModel?.deposit??"",
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color: AppColor.accentColor),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: AppColor.textColor
                                                              ),
                                                              child: Text(
                                                                controller.headerInfoUserTransactionModel?.address??"",
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10,color:AppColor.backGroundColor ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          BalanceWidget(listBalance: controller.balanceList, size: 300,)
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              TabelInfoWidget(list: controller.headerInfoUserTransactionModel!.inventorys!, title: 'دریافت و پرداخت', title1: 'دریافت', title2: 'پرداخت',
                                                typeSel1: 'receive', typeSel2: 'payment',
                                              ),
                                              // / SizedBox(width: 30,),
                                              TabelInfoWidget(list: controller.headerInfoUserTransactionModel!.orders!, title: 'خرید و فروش', title1: 'خرید', title2: 'فروش',
                                                typeSel1: 'buy', typeSel2: 'sell',
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: 20,width: 20,),
                                          TabelInfoWidget(list: controller.headerInfoUserTransactionModel!.remmitances!, title: 'حواله', title1: 'حواله', title2: 'رسید',
                                            typeSel1: 'issue', typeSel2: 'reciept',
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                            ),
                           Expanded(
                              flex:2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: controller.scrollController,
                                physics: ClampingScrollPhysics(),
                                child: Row(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          DataTable(
                                            columns: buildDataColumns(),
                                            dividerThickness: 1,
                                            rows: buildDataRows(context),
                                            dataRowMaxHeight: 90,
                                            //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                            //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                            headingRowHeight: 60,
                                            columnSpacing: 25,
                                            horizontalMargin: 6,
                                          ),
                                          buildPaginationControls(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'خطا در سمت سرور رخ داده',
                          style: AppTextStyle.labelText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
          ),
        ));
  }

  List<DataColumn> buildDataColumns() {
    return [
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('تاریخ',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('نام ثبت کننده',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Column(
      //           children: [
      //             Text('بدهکار ',
      //                 style: AppTextStyle.labelText
      //                     .copyWith(color: AppColor.accentColor, fontSize: 12)),
      //             SvgPicture.asset('assets/svg/refresh.svg',
      //                 height: 16,
      //                 colorFilter: ColorFilter.mode(
      //                   AppColor.textColor,
      //                   BlendMode.srcIn,
      //                 )),
      //             Text(' بستانکار',
      //                 style: AppTextStyle.labelText.copyWith(
      //                     color: AppColor.primaryColor, fontSize: 12)),
      //           ],
      //         )),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('محصول',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('مقدار',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('وضعیت',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('شرح',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('مانده ریالی',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('مانده طلایی',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      // DataColumn(
      //     label: ConstrainedBox(
      //         constraints: BoxConstraints(maxWidth: 80),
      //         child: Text('مانده سکه',
      //             style: AppTextStyle.labelText.copyWith(fontSize: 12))),
      //     headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('نوع',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('ردیف',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('تاریخ',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('شرح',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده ریالی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده طلایی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده سکه',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('عملیات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return [ DataRow(
      cells: [
        // تاریخ


        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset('assets/svg/edit.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.iconViewColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 30,
                ),
                SvgPicture.asset('assets/svg/trash-bin.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),
      ],
    )];


  }

  Widget buildPaginationControls() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: controller.currentPage.value > 1
                    ? controller.previousPage
                    : null,
              ),
              Text(
                'صفحه ${controller.currentPage.value}',
                style: AppTextStyle.bodyText,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed:
                    controller.hasMore.value ? controller.nextPage : null,
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../model/balance_trading_item.model.dart';

class BalanceItemWidget extends StatelessWidget {
  final String titleBase;
  final String title;
  final bool isDesktop;
  final List<BalanceTradingItemModel> balanceList;
  const BalanceItemWidget({
    super.key,
    required this.title,
    required this.balanceList,
    required this.titleBase,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: isDesktop ? Get.width * 0.22 : Get.width * 0.85,
          //  height: isDesktop ? Get.height * 0.22 : Get.height * 0.22,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              //  border: Border.all(color: AppColor.textColor),
                color: AppColor.secondaryColor),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: AppColor.textColor),
                      color: AppColor.textColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: 14,
                          color: AppColor.iconViewColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      titleBase==""?SizedBox() :    Column(
                        children: balanceList.map((e)=>
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    e.netQuantity!
                                        >
                                        0
                                        ? SvgPicture.asset(
                                      'assets/svg/arrow-up.svg',
                                      colorFilter: ColorFilter.mode(
                                        AppColor.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 13,
                                    )
                                        :   e.netQuantity!
                                        <
                                        0
                                        ? SvgPicture.asset(
                                      'assets/svg/arrow-down.svg',
                                      colorFilter: ColorFilter.mode(
                                        AppColor.accentColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 13,
                                    )
                                        : SizedBox(),
                                    Text(
                                      e.itemName??"",
                                      style: AppTextStyle.labelText.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color:
                                               AppColor.textColor),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${  e.netQuantity!
                                      }",
                                      style: AppTextStyle.labelText.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color:   e.netQuantity!
                                              >
                                              0
                                              ? AppColor.primaryColor
                                              :   e.netQuantity!
                                              <
                                              0
                                              ? AppColor.accentColor
                                              : AppColor.textColor),textDirection: TextDirection.ltr,
                                    ),
                                    e.netQuantity!
                                        ==
                                        0?SizedBox()  :  Text(
                                      " ${e.unitName} ",
                                      style: AppTextStyle.labelText.copyWith(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color:   e.netQuantity!
                                              >
                                              0
                                              ? AppColor.primaryColor
                                              :   e.netQuantity!
                                              <
                                              0
                                              ? AppColor.accentColor
                                              : AppColor.textColor),
                                    ),
                                    e.netQuantity!
                                        >
                                        0
                                        ? SvgPicture.asset(
                                      'assets/svg/arrow-up.svg',
                                      colorFilter: ColorFilter.mode(
                                        AppColor.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 13,
                                    )
                                        :  e.netQuantity!
                                        <
                                        0
                                        ? SvgPicture.asset(
                                      'assets/svg/arrow-down.svg',
                                      colorFilter: ColorFilter.mode(
                                        AppColor.accentColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 13,
                                    )
                                        : SizedBox(),

                                  ],
                                ),

                              ],
                            ),
                        ).toList(),
                      ),


                      Container(
                        height: 1,color: AppColor.textColor,
                        margin: EdgeInsets.symmetric(vertical: 5),
                      ),


                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "فعلی",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${ (balanceList.fold(
                                    0,
                                        (sum, item) =>
                                    sum + item.netTotalPrice!))
                                }".seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.netTotalPrice!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.netTotalPrice!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),textDirection: TextDirection.ltr,
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.netTotalPrice!))
                                  ==
                                  0?SizedBox()  :  Text(
                                " ریال ",
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.netTotalPrice!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.netTotalPrice!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.netTotalPrice!))
                                  >
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-up.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.primaryColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.netTotalPrice!))
                                  <
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-down.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : SizedBox(),

                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        
                        children: [
                          Text(
                            "پیش بینی",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${ (balanceList.fold(
                                    0,
                                        (sum, item) =>
                                    sum + item.predicatePrice!))
                                }".seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.predicatePrice!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.predicatePrice!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),textDirection: TextDirection.ltr,
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.predicatePrice!))
                                  ==
                                  0?SizedBox()  :  Text(
                                " ریال ",
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.predicatePrice!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.predicatePrice!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.predicatePrice!))
                                  >
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-up.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.primaryColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.predicatePrice!))
                                  <
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-down.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : SizedBox(),

                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "میانگین",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${ (balanceList.fold(
                                    0,
                                        (sum, item) =>
                                    sum + item.avgPricePerUnit!))
                                }".seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.avgPricePerUnit!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.avgPricePerUnit!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),textDirection: TextDirection.ltr,
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.avgPricePerUnit!))
                                  ==
                                  0?SizedBox()  :  Text(
                                " ریال ",
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.avgPricePerUnit!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.avgPricePerUnit!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.avgPricePerUnit!))
                                  >
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-up.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.primaryColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.avgPricePerUnit!))
                                  <
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-down.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : SizedBox(),

                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "سود / زیان",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${ (balanceList.fold(
                                    0,
                                        (sum, item) =>
                                    sum + item.profitAndLoss!))
                                }".seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.profitAndLoss!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.profitAndLoss!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),textDirection: TextDirection.ltr,
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.profitAndLoss!))
                                  ==
                                  0?SizedBox()  :  Text(
                                " ریال ",
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.profitAndLoss!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.profitAndLoss!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.profitAndLoss!))
                                  >
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-up.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.primaryColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.profitAndLoss!))
                                  <
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-down.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : SizedBox(),

                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "سود / زیان واقعی",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${ (balanceList.fold(
                                    0,
                                        (sum, item) =>
                                    sum + item.realProfitAndLoss!))
                                }".seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.realProfitAndLoss!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.realProfitAndLoss!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),textDirection: TextDirection.ltr,
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.realProfitAndLoss!))
                                  ==
                                  0?SizedBox()  :  Text(
                                " ریال ",
                                style: AppTextStyle.labelText.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color:  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.realProfitAndLoss!))
                                        >
                                        0
                                        ? AppColor.primaryColor
                                        :  (balanceList.fold(
                                        0,
                                            (sum, item) =>
                                        sum + item.realProfitAndLoss!))
                                        <
                                        0
                                        ? AppColor.accentColor
                                        : AppColor.textColor),
                              ),
                              (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.realProfitAndLoss!))
                                  >
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-up.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.primaryColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : (balanceList.fold(
                                  0,
                                      (sum, item) =>
                                  sum + item.realProfitAndLoss!))
                                  <
                                  0
                                  ? SvgPicture.asset(
                                'assets/svg/arrow-down.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode.srcIn,
                                ),
                                height: 13,
                              )
                                  : SizedBox(),

                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

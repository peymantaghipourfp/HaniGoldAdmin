

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/model/total_balance.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/order.controller.dart';

class TotalBalanceWidget extends StatelessWidget {
  const TotalBalanceWidget({
    super.key,
    required this.isDesktop,
    required this.totalBalance,
  });

  final bool isDesktop;
  final TotalBalanceModel totalBalance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isDesktop ? Get.width * 0.25 : Get
          .width * 0.85,
      height: isDesktop ? Get.height * 0.3 : Get
          .height * 0.3,
      child: Card(
        color: AppColor.secondaryColor,
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        totalBalance
                            .itemName ??
                            '',
                        style:
                        AppTextStyle.bodyText.copyWith(fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_shopping_cart,color: AppColor.primaryColor,size: 15,),
                          SizedBox(width: 4,),
                          Text('خرید - % ${totalBalance.buyPercent ?? ''}',style: AppTextStyle.bodyText,),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          totalBalance.itemGroupName=="طلا" ?
                          Text(' ${totalBalance.buyQuantity ?? 0} ${totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,):
                          totalBalance.itemGroupName=="سکه" ?
                          Text(' ${totalBalance.buyQuantity?.toStringAsFixed(0) ?? 0} ${totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,):
                          Text(' ${totalBalance.buyQuantity?.toStringAsFixed(0) ?? 0} ${totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,),
                          SizedBox(height: 1,),
                          Icon(Icons.arrow_drop_up_sharp,color: AppColor.primaryColor,size: 20,)
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 6,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_shopping_cart,color: AppColor.accentColor,size: 15,),
                          SizedBox(width: 4,),
                          Text('فروش - % ${totalBalance.sellPercent ?? ''}',style: AppTextStyle.bodyText,),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          totalBalance.itemGroupName=="طلا" ?
                          Text(' ${totalBalance.sellQuantity ?? 0} ${totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,):
                          totalBalance.itemGroupName=="سکه" ?
                          Text(' ${totalBalance.sellQuantity?.toStringAsFixed(0) ?? 0} ${totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,) :
                          Text(' ${totalBalance.sellQuantity?.toStringAsFixed(0) ?? 0} ${totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,),
                          SizedBox(height: 1,),
                          Icon(Icons.arrow_drop_down,color: AppColor.accentColor,size: 20,)
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 6,),
                  Divider(
                    height: 1,
                    color: AppColor.backGroundColor1,
                  ),
                  SizedBox(height: 6,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_shopping_cart,color: AppColor.primaryColor,size: 15,),
                          SizedBox(width: 4,),
                          Text('جمع کل خرید ',style: AppTextStyle.labelText,),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(' ${totalBalance.buyTotalPrice?.toStringAsFixed(0).seRagham(separator: ',') ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,),
                              Text('ریال',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_shopping_cart,color: AppColor.accentColor,size: 15,),
                          SizedBox(width: 4,),
                          Text('جمع کل فروش ',style: AppTextStyle.labelText,),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(' ${totalBalance.sellTotalPrice?.toStringAsFixed(0).seRagham(separator: ',') ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,),
                              Text('ریال',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Divider(
                    height: 1,
                    color: AppColor.backGroundColor1,
                  ),
                  SizedBox(height: 6,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.balance,color: AppColor.textColor,size: 15,),
                          SizedBox(width: 4,),
                          Text('تراز کل ',style: AppTextStyle.labelText,),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          totalBalance.itemGroupName=="طلا" ?
                          Row(
                            children: [
                              Text(' ${totalBalance.totalBalanceQuantity ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                              Text(totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                            ],
                          ) :
                          totalBalance.itemGroupName=="سکه" ?
                          Row(
                            children: [
                              Text(' ${totalBalance.totalBalanceQuantity?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                              Text(totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                            ],
                          ) :
                          Row(
                            children: [
                              Text(' ${totalBalance.totalBalanceQuantity?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                              Text('${totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,),
                            ],
                          ),
                          SizedBox(height: 1,),
                          totalBalance.totalBalanceQuantity!>0 ?
                          Icon(Icons.arrow_drop_up_sharp,color: AppColor.primaryColor,size: 20,) :
                          totalBalance.totalBalanceQuantity!<0 ?
                          Icon(Icons.arrow_drop_down,color: AppColor.accentColor,size: 20,) :
                          SizedBox()
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 6,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.balance,color: AppColor.textColor,size: 15,),
                          SizedBox(width: 4,),
                          Text('تراز ',style: AppTextStyle.labelText,),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          totalBalance.itemGroupName=="طلا" ?
                          Row(
                            children: [
                              Text(' ${totalBalance.balanceQuantity ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                              Text(totalBalance.unitName ?? '',style: AppTextStyle.bodyText,)
                            ],
                          ) :
                          totalBalance.itemGroupName=="سکه" ?
                          Row(
                            children: [
                              Text(' ${totalBalance.balanceQuantity?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                              Text(totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                            ],
                          ) :
                          Row(
                            children: [
                              Text(' ${totalBalance.balanceQuantity?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                              Text(totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                            ],
                          ),
                          SizedBox(height: 1,),
                          totalBalance.balanceQuantity!>0 ?
                          Icon(Icons.arrow_drop_up_sharp,color: AppColor.primaryColor,size: 20,) :
                          totalBalance.balanceQuantity!<0 ?
                          Icon(Icons.arrow_drop_down,color: AppColor.accentColor,size: 20,) :
                          SizedBox()
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 6,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.price_change,color: AppColor.textColor,size: 15,),
                          SizedBox(width: 4,),
                          Text('میانگین ',style: AppTextStyle.labelText,),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          totalBalance.avaragePridicate!>0 ?
                          Text(' ${totalBalance.avaragePridicate?.toStringAsFixed(4).seRagham(separator: ',') ?? 0} ریال ',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),) :
                          totalBalance.avaragePridicate!<0 ?
                          Row(
                            children: [
                              Text(' ${totalBalance.avaragePridicate?.toStringAsFixed(4).seRagham(separator: ',') ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,),
                              Text('ریال',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),),
                            ],
                          ) :
                          Text(' ${totalBalance.avaragePridicate?.toStringAsFixed(0) ?? 0} ریال ',style: AppTextStyle.bodyText,),
                          SizedBox(height: 1,),
                          totalBalance.avaragePridicate!>0 ?
                          Icon(Icons.arrow_drop_up_sharp,color: AppColor.primaryColor,size: 20,) :
                          totalBalance.avaragePridicate!<0 ?
                          Icon(Icons.arrow_drop_down,color: AppColor.accentColor,size: 20,) :
                          SizedBox()
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
    );
  }
}

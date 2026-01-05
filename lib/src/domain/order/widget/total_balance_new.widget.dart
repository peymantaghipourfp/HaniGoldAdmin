

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/model/total_balance_new.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/order.controller.dart';

class TotalBalanceNewWidget extends StatefulWidget {
  const TotalBalanceNewWidget({
    super.key,
    required this.isDesktop,
    required this.totalBalance,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  final bool isDesktop;
  final TotalBalanceNewModel totalBalance;
  final bool isExpanded;
  final Function(bool isExpanded) onExpansionChanged;

  @override
  State<TotalBalanceNewWidget> createState() => _TotalBalanceNewWidgetState();
}

class _TotalBalanceNewWidgetState extends State<TotalBalanceNewWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.isDesktop ? Get.width * 0.23 : Get.width * 0.85,
        height: widget.isDesktop ? Get.height * 0.35 : Get.height * 0.49,
        margin: EdgeInsets.only(left: 10,bottom: widget.isDesktop ? 0 : 3,top: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.secondary10Color, AppColor.backGroundColor1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 5,
              offset: const Offset(0,3),
            ),
          ],
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Column(
            children: [
              ListTile(
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.totalBalance.itemName ?? '',
                          style:
                          AppTextStyle.bodyText.copyWith(fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    // خرید
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withAlpha(15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_shopping_cart,color: AppColor.primaryColor,size: 15,),
                              SizedBox(width: 4,),
                              Text('خرید - % ${(((widget.totalBalance.buyQty ?? 0)/((widget.totalBalance.buyQty ?? 0)+(widget.totalBalance.salesQty ?? 0)))*100).toStringAsFixed(2) ?? ''}',style: AppTextStyle.bodyText,),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.totalBalance.itemGroupName=="طلا" ?
                              Text(' ${widget.totalBalance.buyQty ?? 0} ${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,):
                              widget.totalBalance.itemGroupName=="سکه" ?
                              Text(' ${widget.totalBalance.buyQty?.toStringAsFixed(0) ?? 0} ${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,):
                              Text(' ${widget.totalBalance.buyQty?.toStringAsFixed(0) ?? 0} ${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,),
                              SizedBox(height: 1,),
                              Icon(Icons.arrow_drop_up_sharp,color: AppColor.primaryColor,size: 20,)
                            ],
                          )
                        ],
                      ),
                    ),
                    // فروش
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColor.accentColor.withAlpha(15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_shopping_cart,color: AppColor.accentColor,size: 15,),
                              SizedBox(width: 4,),
                              Text('فروش - % ${(((widget.totalBalance.salesQty ?? 0)/((widget.totalBalance.buyQty ?? 0)+(widget.totalBalance.salesQty ?? 0)))*100).toStringAsFixed(2) ?? ''}',style: AppTextStyle.bodyText,),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.totalBalance.itemGroupName=="طلا" ?
                              Text(' ${widget.totalBalance.salesQty ?? 0} ${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,):
                              widget.totalBalance.itemGroupName=="سکه" ?
                              Text(' ${widget.totalBalance.salesQty?.toStringAsFixed(0) ?? 0} ${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,) :
                              Text(' ${widget.totalBalance.salesQty?.toStringAsFixed(0) ?? 0} ${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,),
                              SizedBox(height: 1,),
                              Icon(Icons.arrow_drop_down,color: AppColor.accentColor,size: 20,)
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 4,),
                    Divider(
                      height: 1,
                      color: AppColor.dividerColor.withAlpha(150),
                    ),
                    SizedBox(height: 4,),
                    // جمع کل خرید
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.add_shopping_cart,color: AppColor.primaryColor,size: 15,),
                            SizedBox(width: 4,),
                            Text('جمع کل خرید ',style: AppTextStyle.bodyText.copyWith(color: AppColor.textPrimaryColor),),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(' ${widget.totalBalance.buyAmount?.toStringAsFixed(0).seRagham(separator: ',') ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,),
                                Text('ریال',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // جمع کل فروش
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.add_shopping_cart,color: AppColor.accentColor,size: 15,),
                            SizedBox(width: 4,),
                            Text('جمع کل فروش ',style: AppTextStyle.bodyText.copyWith(color: AppColor.textAccentColor),),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(' ${widget.totalBalance.sellAmount?.toStringAsFixed(0).seRagham(separator: ',') ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,),
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
                      color: AppColor.dividerColor.withAlpha(150),
                    ),
                    SizedBox(height: 6,),
                    // تراز کل
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 2),
                      decoration: BoxDecoration(
                        color:(widget.totalBalance.totalBalanceQty ?? 0) < 0 ? AppColor.accentColor.withAlpha(30) :  AppColor.primaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.balance,color: AppColor.textColor,size: 15,),
                              SizedBox(width: 4,),
                              Text('تراز کل ',style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor),),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.totalBalance.itemGroupName=="طلا" ?
                              Row(
                                children: [
                                  (widget.totalBalance.totalBalanceQty ?? 0) > 0 ?
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(4)}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  (widget.totalBalance.totalBalanceQty ?? 0 )<0 ?
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(4)}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(4)}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                  (widget.totalBalance.totalBalanceQty ?? 0)>0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,),):
                                  (widget.totalBalance.totalBalanceQty ?? 0)<0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,),):
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                                ],
                              ) :
                              widget.totalBalance.itemGroupName=="سکه" ?
                              Row(
                                children: [
                                  (widget.totalBalance.totalBalanceQty ?? 0)>0 ?
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  (widget.totalBalance.totalBalanceQty ?? 0)<0 ?
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                  (widget.totalBalance.totalBalanceQty ?? 0)>0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                  (widget.totalBalance.totalBalanceQty ?? 0)<0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                                ],
                              ) :
                              Row(
                                children: [
                                  (widget.totalBalance.totalBalanceQty ?? 0)>0 ?
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  (widget.totalBalance.totalBalanceQty ?? 0)<0 ?
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  Text(' ${widget.totalBalance.totalBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                  (widget.totalBalance.totalBalanceQty ?? 0)>0 ?
                                  Text('${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                  (widget.totalBalance.totalBalanceQty ?? 0)<0 ?
                                  Text('${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                  Text('${widget.totalBalance.unitName ?? ''} ',style: AppTextStyle.bodyText,),
                                ],
                              ),
                              SizedBox(height: 1,),
                              (widget.totalBalance.totalBalanceQty ?? 0)>0 ?
                              Icon(Icons.arrow_drop_up_sharp,color: AppColor.primaryColor,size: 20,) :
                              (widget.totalBalance.totalBalanceQty ?? 0)<0 ?
                              Icon(Icons.arrow_drop_down,color: AppColor.accentColor,size: 20,) :
                              SizedBox.shrink(),
                            ],
                          )
                        ],
                      ),
                    ),
                    // تراز
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColor.secondary2Color.withAlpha(15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.balance,color: AppColor.textColor,size: 15,),
                              SizedBox(width: 4,),
                              Text('تراز ',style: AppTextStyle.bodyText,),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.totalBalance.itemGroupName=="طلا" ?
                              Row(
                                children: [
                                  (widget.totalBalance.dailyBalanceQty ?? 0)>0 ?
                                  Text(' ${widget.totalBalance.dailyBalanceQty ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  (widget.totalBalance.dailyBalanceQty ?? 0)<0 ?
                                  Text(' ${widget.totalBalance.dailyBalanceQty ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  Text(' ${widget.totalBalance.dailyBalanceQty ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                  (widget.totalBalance.dailyBalanceQty ?? 0)>0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                  (widget.totalBalance.dailyBalanceQty ?? 0)<0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                                ],
                              ) :
                              widget.totalBalance.itemGroupName=="سکه" ?
                              Row(
                                children: [
                                  (widget.totalBalance.dailyBalanceQty ?? 0)>0 ?
                                  Text(' ${widget.totalBalance.dailyBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  (widget.totalBalance.dailyBalanceQty ?? 0)<0 ?
                                  Text(' ${widget.totalBalance.dailyBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  Text(' ${widget.totalBalance.dailyBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                  (widget.totalBalance.dailyBalanceQty ?? 0)>0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                  (widget.totalBalance.dailyBalanceQty ?? 0)<0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                                ],
                              ) :
                              Row(
                                children: [
                                  (widget.totalBalance.dailyBalanceQty ?? 0)>0 ?
                                  Text(' ${widget.totalBalance.dailyBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  (widget.totalBalance.dailyBalanceQty ?? 0)<0 ?
                                  Text(' ${widget.totalBalance.dailyBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,):
                                  Text(' ${widget.totalBalance.dailyBalanceQty?.toStringAsFixed(0) ?? 0}',style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                  (widget.totalBalance.dailyBalanceQty ?? 0)>0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                  (widget.totalBalance.dailyBalanceQty ?? 0)<0 ?
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                  Text(widget.totalBalance.unitName ?? '',style: AppTextStyle.bodyText,),
                                ],
                              ),
                              SizedBox(height: 1,),
                              (widget.totalBalance.dailyBalanceQty ?? 0)>0 ?
                              Icon(Icons.arrow_drop_up_sharp,color: AppColor.primaryColor,size: 20,) :
                              (widget.totalBalance.dailyBalanceQty ?? 0)<0 ?
                              Icon(Icons.arrow_drop_down,color: AppColor.accentColor,size: 20,) :
                              SizedBox.shrink(),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 6,),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColor.buttonColor.withAlpha(15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          // میانگین خرید
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.price_change,color: AppColor.textColor,size: 15,),
                                  SizedBox(width: 4,),
                                  Text('میانگین خرید ',style: AppTextStyle.bodyText.copyWith(color: AppColor.textPrimaryColor),),
                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(' ${widget.totalBalance.buyAvgPrice?.toStringAsFixed(0).seRagham(separator: ',') ?? 0} ریال ',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ],
                          ),
                          // میانگین فروش
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.price_change,color: AppColor.textColor,size: 15,),
                                  SizedBox(width: 4,),
                                  Text('میانگین فروش ',style: AppTextStyle.bodyText.copyWith(color: AppColor.textAccentColor),),
                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(' ${widget.totalBalance.salesAvgPrice?.toStringAsFixed(0).seRagham(separator: ',') ?? 0} ریال ',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Expanded section with 5 new items
                    if (widget.isExpanded) ...[
                      SizedBox(height: 6,),
                      Divider(
                        height: 1,
                        color: AppColor.dividerColor.withAlpha(150),
                      ),
                      SizedBox(height: 6,),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 2),
                        decoration: BoxDecoration(
                          color: AppColor.iconViewColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            // مانده تا روز قبل
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.history, color: AppColor.textColor, size: 15,),
                                    SizedBox(width: 4,),
                                    Text('مانده منتقل شده', style: AppTextStyle.labelText,),
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    widget.totalBalance.itemGroupName=="طلا" ?
                                    Row(
                                      children: [
                                        (widget.totalBalance.carryInQty ?? 0)>0 ?
                                        Text(' ${widget.totalBalance.carryInQty ?? 0}', style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,):
                                        (widget.totalBalance.carryInQty ?? 0)<0 ?
                                        Text(' ${widget.totalBalance.carryInQty ?? 0}', style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,):
                                        Text(' ${widget.totalBalance.carryInQty ?? 0}', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,),
                                        (widget.totalBalance.carryInQty ?? 0)>0 ?
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                        (widget.totalBalance.carryInQty ?? 0)<0 ?
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText,)
                                      ],
                                    ) :
                                    widget.totalBalance.itemGroupName=="سکه" ?
                                    Row(
                                      children: [
                                        (widget.totalBalance.carryInQty ?? 0)>0 ?
                                        Text(' ${(widget.totalBalance.carryInQty ?? 0).toStringAsFixed(0)}', style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,):
                                        (widget.totalBalance.carryInQty ?? 0)<0 ?
                                        Text(' ${(widget.totalBalance.carryInQty ?? 0).toStringAsFixed(0)}', style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,):
                                        Text(' ${(widget.totalBalance.carryInQty ?? 0).toStringAsFixed(0)}', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,),
                                        (widget.totalBalance.carryInQty ?? 0)>0 ?
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                        (widget.totalBalance.carryInQty ?? 0)<0 ?
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText,)
                                      ],
                                    ) :
                                    Row(
                                      children: [
                                        (widget.totalBalance.carryInQty ?? 0)>0 ?
                                        Text(' ${(widget.totalBalance.carryInQty ?? 0).toStringAsFixed(0)}', style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,):
                                        (widget.totalBalance.carryInQty ?? 0)<0 ?
                                        Text(' ${(widget.totalBalance.carryInQty ?? 0).toStringAsFixed(0)}', style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,):
                                        Text(' ${(widget.totalBalance.carryInQty ?? 0).toStringAsFixed(0)}', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold), textDirection: TextDirection.ltr,),
                                        (widget.totalBalance.carryInQty ?? 0)>0 ?
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),):
                                        (widget.totalBalance.carryInQty ?? 0)<0 ?
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),):
                                        Text(widget.totalBalance.unitName ?? '', style: AppTextStyle.bodyText,)
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 6,),
                            // میانگین قیمت روز قبل
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.trending_up, color: AppColor.textColor, size: 15,),
                                    SizedBox(width: 4,),
                                    Text('میانگین قیمت منتقل شده', style: AppTextStyle.labelText,),
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(' ${(widget.totalBalance.carryInPrice ?? 0).toStringAsFixed(0).seRagham(separator: ',')} ریال', style: AppTextStyle.bodyText, textDirection: TextDirection.rtl,),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 6,),
                            // مبلغ قیمت مانده روز قبل
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.account_balance_wallet, color: AppColor.textColor, size: 15,),
                                    SizedBox(width: 4,),
                                    Text('مبلغ قیمت منتقل شده', style: AppTextStyle.labelText,),
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(' ${(widget.totalBalance.previousCarryPrice ?? 0).toStringAsFixed(0).seRagham(separator: ',')} ریال', style: AppTextStyle.bodyText, textDirection: TextDirection.rtl,),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6,),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 2),
                        decoration: BoxDecoration(
                          color: AppColor.dividerColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            // میانگین قیمت خرید کل
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.shopping_cart, color: AppColor.primaryColor, size: 15,),
                                    SizedBox(width: 4,),
                                    Text('میانگین قیمت خرید کل', style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor),),
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(' ${(widget.totalBalance.adjustedBuyAvgPrice ?? 0).toStringAsFixed(0).seRagham(separator: ',')} ریال', style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 6,),
                            // میانگین قیمت فروش کل
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.shopping_cart, color: AppColor.accentColor, size: 15,),
                                    SizedBox(width: 4,),
                                    Text('میانگین قیمت فروش کل', style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor),),
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(' ${(widget.totalBalance.adjustedSalesAvgPrice ?? 0).toStringAsFixed(0).seRagham(separator: ',')} ریال', style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )

                    ],
                  ],
                ),
              ),
              // Expand/Collapse arrow at the bottom
              GestureDetector(
                onTap: () {
                  /*setState(() {
                    isExpanded = !isExpanded;
                  });*/
                  widget.onExpansionChanged(!widget.isExpanded);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColor.dividerColor.withAlpha(150),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Icon(
                    widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color:widget.isExpanded ? AppColor.accentColor : AppColor.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

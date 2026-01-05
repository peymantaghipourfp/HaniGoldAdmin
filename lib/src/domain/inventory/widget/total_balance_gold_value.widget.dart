import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/model/tooltip_total_balance.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class TotalBalanceGoldValue extends StatefulWidget {
  final TooltipTotalBalanceModel totalBalanceGoldValue;
  final double size;
  final String? title;
  const TotalBalanceGoldValue({super.key, required this.totalBalanceGoldValue, required this.size, this.title});

  @override
  State<TotalBalanceGoldValue> createState() => _TotalBalanceGoldValueState();
}

class _TotalBalanceGoldValueState extends State<TotalBalanceGoldValue> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      width: widget.size,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.secondaryColor
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ' تراز کاربر ',
                style: AppTextStyle.labelText.copyWith(fontSize: 14,
                  fontWeight: FontWeight.bold, ),
              ),
              Text(
                widget.title??"",
                style: AppTextStyle.labelText.copyWith(fontSize: 13,color: AppColor.secondary3Color,
                  fontWeight: FontWeight.normal, ),
              ),
            ],
          ),
          const Divider(height: 10.0,color: Colors.white,thickness: 0.5,),
          SizedBox(height: 5,),
          Column(
            children:
            widget.totalBalanceGoldValue.balances?.map((balance)=>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: AppColor.textColor,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          balance.itemName??"",
                          style: AppTextStyle.labelText.copyWith(fontSize: 13,
                              fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        balance.unitName=="ریال" ?
                        Text(
                          (balance.balance ?? 0.0) < 0 ?
                          "-${balance.balance?.abs().toStringAsFixed(0).seRagham()??0.0}":
                          "${balance.balance?.toStringAsFixed(0).seRagham()??0.0}",
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.bold,color:(balance.balance ?? 0.0) > 0?AppColor.primaryColor: (balance.balance ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),textDirection: TextDirection.ltr,
                        ): balance.unitName=="گرم" ?
                        Text(
                          (balance.balance ?? 0.0) < 0 ?
                          "-${balance.balance?.abs().toStringAsFixed(3).seRagham()??0.0}":
                          "${balance.balance?.abs().toStringAsFixed(3).seRagham()??0.0}",
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.bold,color:(balance.balance ?? 0.0) > 0?AppColor.primaryColor: (balance.balance ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),textDirection: TextDirection.ltr,
                        ):
                        Text(
                          (balance.balance ?? 0.0) < 0 ?
                          "-${balance.balance?.abs().toString().seRagham()??0.0}":
                          "${balance.balance?.abs().toString().seRagham()??0.0}",
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.bold,color:(balance.balance ?? 0.0) > 0?AppColor.primaryColor: (balance.balance ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),textDirection: TextDirection.ltr,
                        ),
                        SizedBox(width: 8,),
                        Text(
                          balance.unitName??"",
                          style: AppTextStyle.labelText.copyWith(fontSize: 10,
                              fontWeight: FontWeight.normal,color: AppColor.textColor ),textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                  ],
                )).toList() ?? [],
          ),
          widget.totalBalanceGoldValue.balances?.isNotEmpty == true ?
          const Divider(height: 10.0,color: Colors.white,thickness: 0.5,) :SizedBox.shrink(),
          widget.totalBalanceGoldValue.balances?.isNotEmpty == true ?
          Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // مانده طلایی
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 5,
                                  backgroundColor: AppColor.dividerColor,
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "مانده طلایی",
                                  style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                      fontWeight: FontWeight.normal,color: AppColor.dividerColor ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Row(
                              children: [
                                widget.totalBalanceGoldValue.balances!.where((balance) => balance.unitName == 'گرم')
                                    .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0))<0 ?
                                Text("-${widget.totalBalanceGoldValue.balances?.where((balance) => balance.unitName == 'گرم').fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).abs().toStringAsFixed(3).seRagham()}",
                                  style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.accentColor ),
                                  textDirection: TextDirection.ltr,):
                                widget.totalBalanceGoldValue.balances!.where((balance) => balance.unitName == 'گرم')
                                    .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0))>0 ?
                                Text(widget.totalBalanceGoldValue.balances!.where((balance) => balance.unitName == 'گرم')
                                    .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).toStringAsFixed(3).seRagham(),
                                  style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:AppColor.primaryColor ),
                                  textDirection: TextDirection.ltr,):
                                Text(widget.totalBalanceGoldValue.balances!.where((balance) => balance.unitName == 'گرم')
                                    .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).toStringAsFixed(3),
                                  style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:AppColor.textColor ),
                                  textDirection: TextDirection.ltr,),
                                SizedBox(width: 8,),
                                Text(
                                  "گرم",
                                  style: AppTextStyle.labelText.copyWith(fontSize: 10,
                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Gold Value (معادل آبشده)
                        Row(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 5,
                                  backgroundColor: AppColor.buttonColor,
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  ": معادل آبشده",
                                  style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                      fontWeight: FontWeight.normal,color: AppColor.textPrimaryColor ),
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Text(
                              widget.totalBalanceGoldValue.goldValue != null ?
                              (widget.totalBalanceGoldValue.goldValue! < 0 ?
                              "-${widget.totalBalanceGoldValue.goldValue!.abs().toStringAsFixed(3).seRagham()}" :
                              widget.totalBalanceGoldValue.goldValue!.toStringAsFixed(3).seRagham()) :
                              "0",
                              style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: (widget.totalBalanceGoldValue.goldValue ?? 0.0) > 0 ? AppColor.primaryColor :
                                  (widget.totalBalanceGoldValue.goldValue ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(width: 8,),
                            Text(
                              "گرم",
                              style: AppTextStyle.labelText.copyWith(fontSize: 10,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ]
          ) :SizedBox.shrink(),
        ],
      ),
    );
  }
}

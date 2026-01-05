import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/model/tooltip_total_balance.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class TooltipTotalBalanceWidget extends StatefulWidget {
  final TooltipTotalBalanceModel tooltipTotalBalance;
  final double size;
  final String? title;
  const TooltipTotalBalanceWidget({super.key, required this.tooltipTotalBalance, required this.size, this.title});

  @override
  State<TooltipTotalBalanceWidget> createState() => _TooltipTotalBalanceWidgetState();
}

class _TooltipTotalBalanceWidgetState extends State<TooltipTotalBalanceWidget> {
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
            widget.tooltipTotalBalance.balances?.map((balance)=>
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
          widget.tooltipTotalBalance.balances?.isNotEmpty == true ?
          const Divider(height: 10.0,color: Colors.white,thickness: 0.5,) :SizedBox.shrink(),
          widget.tooltipTotalBalance.balances?.isNotEmpty == true ?
          Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: AppColor.dividerColor,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "تراز کل",
                          style: AppTextStyle.labelText.copyWith(fontSize: 13,
                              fontWeight: FontWeight.normal,color: AppColor.dividerColor ),
                        ),
                      ],
                    ),
                    //SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Currency Value (ریال)
                        Row(
                          children: [
                            Text(
                              widget.tooltipTotalBalance.currencyValue != null ?
                              (widget.tooltipTotalBalance.currencyValue! < 0 ?
                              "-${widget.tooltipTotalBalance.currencyValue!.abs().toStringAsFixed(0).seRagham()}" :
                              widget.tooltipTotalBalance.currencyValue!.toStringAsFixed(0).seRagham()) :
                              "0",
                              style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: (widget.tooltipTotalBalance.currencyValue ?? 0.0) > 0 ? AppColor.primaryColor :
                                  (widget.tooltipTotalBalance.currencyValue ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(width: 8,),
                            Text(
                              "ریال",
                              style: AppTextStyle.labelText.copyWith(fontSize: 10,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                        SizedBox(height: 3,),
                        // Gold Value (معادل آبشده)
                        Row(
                          children: [
                            Text(
                              ": معادل آبشده",
                              style: AppTextStyle.labelText.copyWith(fontSize: 10,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              widget.tooltipTotalBalance.goldValue != null ?
                              (widget.tooltipTotalBalance.goldValue! < 0 ?
                              "-${widget.tooltipTotalBalance.goldValue!.abs().toStringAsFixed(3).seRagham()}" :
                              widget.tooltipTotalBalance.goldValue!.toStringAsFixed(3).seRagham()) :
                              "0",
                              style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: (widget.tooltipTotalBalance.goldValue ?? 0.0) > 0 ? AppColor.primaryColor :
                                  (widget.tooltipTotalBalance.goldValue ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),
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
                        SizedBox(height: 3,),
                        // Coin Value (معادل سکه)
                        Row(
                          children: [
                            Text(
                              ": معادل سکه",
                              style: AppTextStyle.labelText.copyWith(fontSize: 10,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              widget.tooltipTotalBalance.coinValue != null ?
                              (widget.tooltipTotalBalance.coinValue! < 0 ?
                              "-${widget.tooltipTotalBalance.coinValue!.abs().toStringAsFixed(3).seRagham()}" :
                              widget.tooltipTotalBalance.coinValue!.toStringAsFixed(3).seRagham()) :
                              "0",
                              style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: (widget.tooltipTotalBalance.coinValue ?? 0.0) > 0 ? AppColor.primaryColor :
                                  (widget.tooltipTotalBalance.coinValue ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(width: 8,),
                            Text(
                              "عدد",
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

import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/users/model/balance_item.model.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class BalanceWidget extends StatefulWidget {
  final List<BalanceItemModel> listBalance;
  final double size;
  final String? title;
  const BalanceWidget({super.key, required this.listBalance, required this.size, this.title});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  @override
  Widget build(BuildContext context) {
    //final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      width: widget.size,
      //height: controller.isOpenMore.value?300:200,
      constraints: BoxConstraints(
        // maxHeight: controller.isOpenMore.value?300:120,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.secondary50Color
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
            widget.listBalance.map((e)=>
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
                     e.item?.name??"",
                      style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    e.item?.itemUnit?.name=="ریال" ?
                    Text(
                      (e.balance ?? 0.0) < 0 ?
                "-${e.balance?.abs().toStringAsFixed(0).seRagham()??0.0}":
                "${e.balance?.toStringAsFixed(0).seRagham()??0.0}",
                      style: AppTextStyle.labelText.copyWith(fontSize: 14,
                          //fontWeight: FontWeight.normal,color:e.balance!>0?AppColor.primaryColor: AppColor.accentColor ),textDirection: TextDirection.ltr,
                          fontWeight: FontWeight.normal,color:(e.balance ?? 0.0) > 0?AppColor.primaryColor: (e.balance ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),textDirection: TextDirection.ltr,
                    ):
                    Text(
                      (e.balance ?? 0.0) < 0 ?
                      "-${e.balance?.abs().toDisplayString().seRagham()??0.0}":
                      "${e.balance?.abs().toDisplayString().seRagham()??0.0}",
                      style: AppTextStyle.labelText.copyWith(fontSize: 14,
                          //fontWeight: FontWeight.normal,color:e.balance!>0?AppColor.primaryColor: AppColor.accentColor ),textDirection: TextDirection.ltr,
                          fontWeight: FontWeight.normal,color:(e.balance ?? 0.0) > 0?AppColor.primaryColor: (e.balance ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),textDirection: TextDirection.ltr,
                    ),

                    SizedBox(width: 8,),
                    Text(
                      e.item?.itemUnit?.name??"",
                      style: AppTextStyle.labelText.copyWith(fontSize: 10,
                          fontWeight: FontWeight.normal,color: AppColor.textColor ),textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ],
            )).toList(),
          ),
          widget.listBalance.isNotEmpty ?
          const Divider(height: 10.0,color: Colors.white,thickness: 0.5,) :SizedBox.shrink(),
          widget.listBalance.isNotEmpty ?
          Column(
              children: [
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
                        widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0))<0 ?
                        Text("-${widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم').fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).abs().toStringAsFixed(3).seRagham()}",
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColor.accentColor ),
                          textDirection: TextDirection.ltr,):
                        widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0))>0 ?
                        Text(widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).toStringAsFixed(3).seRagham(),
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color:AppColor.primaryColor ),
                          textDirection: TextDirection.ltr,):
                        Text(widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).toStringAsFixed(3),
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.normal,
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
                )
              ]
          ) :SizedBox.shrink(),
        ],
      ),
    );
  }
}

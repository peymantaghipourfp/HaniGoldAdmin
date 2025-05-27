import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/model/balance_item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/user_info_transaction.controller.dart';

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
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      width: widget.size,
      //height: controller.isOpenMore.value?300:200,
      constraints: BoxConstraints(
        // maxHeight: controller.isOpenMore.value?300:120,
      ),
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
                '  تراز کاربر ${widget.title??""}',
                style: AppTextStyle.labelText.copyWith(fontSize: 14,
                  fontWeight: FontWeight.bold, ),
              ),
            ],
          ),
          const Divider(height: 10.0,color: Colors.white,thickness: 0.5,),
          Column(
            children: widget.listBalance.map((e)=>
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
                    Text(
                      "${e.balance??0.0}".seRagham(),
                      style: AppTextStyle.labelText.copyWith(fontSize: 14,
                          fontWeight: FontWeight.normal,color:e.balance!>0?AppColor.primaryColor: AppColor.accentColor ),textDirection: TextDirection.ltr,
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
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class BalanceItemWidget extends StatelessWidget {
  final String title;
  final String current;
  final String forecast;
  final String average;
  final String profitLoss;
  final List<String> balanceList;
  const BalanceItemWidget({super.key, required this.title, required this.balanceList, required this.current, required this.forecast, required this.average, required this.profitLoss});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.secondaryColor
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft:  Radius.circular(8),topRight: Radius.circular(8)),
                color: AppColor.textFieldColor
            ),
            child: Row(
              children: [
                Text(
                  'طلا',
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

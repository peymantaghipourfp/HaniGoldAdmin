import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../model/account_level_get_one_item.model.dart';
import '../model/account_level_item.model.dart';

class AccountLevelGetOneItemWidget extends StatelessWidget {
  final AccountLevelGetOneItemModel? data;
  final double width;
  final String? title;
  final bool isLoading;

  const AccountLevelGetOneItemWidget({
    super.key,
    required this.data,
    required this.width,
    this.title,
    this.isLoading = false,
  });

  String _formatNumber(num? value, {int fractionDigits = 3}) {
    if (value == null) return "-";
    if (value is int) {
      return value
          .toString()
          .toPersianDigit()
          .seRagham();
    }
    return value
        .toStringAsFixed(fractionDigits)
        .toPersianDigit()
        .seRagham();
  }

  String _safeText(String? value) {
    if (value == null || value.trim().isEmpty) return "-";
    return value;
  }

  AccountLevelItemModel? _currentItem() {
    if (data?.accountLevelItems == null || data!.accountLevelItems!.isEmpty) {
      return null;
    }
    // API is already filtered by itemId, so we can safely use the first one.
    return data!.accountLevelItems!.first;
  }

  @override
  Widget build(BuildContext context) {
    final item = _currentItem();

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.secondary100Color.withAlpha(200),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'سطح کاربری',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      title ?? "",
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 13,
                        color: AppColor.secondary3Color,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
               Text(
                  item?.itemName ?? "",
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: 13,
                    color: AppColor.secondary3Color,
                    fontWeight: FontWeight.bold,
                  ),
                ),

            ],
          ),
          const Divider(height: 10.0, color: Colors.white, thickness: 0.5),
        if (data != null) ...[
          const SizedBox(height: 5),
          /*_buildRow(
            label: "نام سطح",
            value: _safeText(data?.name),
          ),*/
          _buildRow(
            label: "تراز سطح",
            value: data?.balance != null
                ? (data?.balance ?? 0 ) < 0 ? "-${data?.balance?.abs().toStringAsFixed(0).seRagham() ?? ""}" : data?.balance?.toStringAsFixed(0).seRagham() ?? ""
                : "-",
              valueColor: (data?.balance ?? 0 ) < 0 ? AppColor.accentColor : AppColor.primaryColor,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildRowTwo(
                  label: "حد مثبت طلایی",
                  value: data?.positiveGold != null
                      ? _formatNumber(data!.positiveGold)
                      : "-",
                  valueColor: AppColor.textPrimaryColor
                ),
              ),
               _buildRowTwo(
                  label: "حد منفی طلایی",
                  value: data?.negativeGold != null
                      ? (data?.negativeGold ?? 0 ) < 0 ? "-${data?.negativeGold?.abs().toString() ?? ""}" : data?.negativeGold?.toString() ?? ""
                      : "-",
                  valueColor: AppColor.textAccentColor
                ),

            ],
          ),
          Divider( color: AppColor.dividerColor, thickness: 0.5),
          /*_buildRow(
            label: "نام آیتم",
            value: _safeText(item?.itemName),
            valueColor: AppColor.secondary3Color
          ),*/
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildRowTwo(
                  label: "حداکثر خرید",
                  value: item?.maxBuy != null
                      ? item?.maxBuy.toString() ?? ""
                      : "-",
                  valueColor: AppColor.primaryColor
                ),
              ),
               _buildRowTwo(
                  label: "حداکثر فروش",
                  value: item?.maxSell != null
                      ? item?.maxSell.toString() ?? ""
                      : "-",
                  valueColor: AppColor.accent2Color
                ),
            ],
          ),
        ],
        ],
      ),
    );
  }

  Widget _buildRow({required String label, required String value , Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 4,
                backgroundColor: AppColor.dividerColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppColor.iconViewColor,
                ),
              ),
            ],
          ),
           Text(
              value,
              style: AppTextStyle.labelText.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color:valueColor ?? AppColor.textColor,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
            ),

        ],
      ),
    );
  }

  Widget _buildRowTwo({required String label, required String value , Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 4,
                backgroundColor: AppColor.dividerColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppColor.iconViewColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color:valueColor ?? AppColor.textColor,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
              ),
            ],
          ),

        ],
      ),
    );
  }

}
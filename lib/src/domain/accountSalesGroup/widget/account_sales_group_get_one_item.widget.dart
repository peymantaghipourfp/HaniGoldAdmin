import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanigold_admin/src/domain/accountSalesGroup/model/account_sales_group_item.model.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../model/account_sales_group_get_one_item.model.dart';

class AccountSalesGroupGetOneItemWidget extends StatelessWidget {
  final AccountSalesGroupGetOneItemModel? data;
  final double width;
  final String? title;
  final bool isLoading;
  final int? selectedItemId;
  final int? selectedBuySellId; // 0 = Sell, 1 = Buy
  final Function(double)? onPriceSelected;

  const AccountSalesGroupGetOneItemWidget({
    super.key,
    required this.data,
    required this.width,
    this.title,
    this.isLoading = false,
    this.selectedItemId,
    this.selectedBuySellId,
    this.onPriceSelected,
  });

  String _formatNumber(num? value, /*{int fractionDigits = 3}*/) {
    if (value == null) return "-";
    if (value is int) {
      return value
          .toDisplayString()
          .toPersianDigit()
          .seRagham();
    }
    return value
        .toDisplayString()
        .toPersianDigit()
        .seRagham();
  }

  /*String _safeText(String? value) {
    if (value == null || value.trim().isEmpty) return "-";
    return value;
  }*/

  AccountSalesGroupItemModel? _currentItem() {
    if (data?.accountSalesGroupItems == null || data!.accountSalesGroupItems!.isEmpty) {
      return null;
    }
    if (selectedItemId == null) {
      return null;
    }
    // Find the item that matches the selected itemId
    try {
      return data!.accountSalesGroupItems!.firstWhere(
            (item) => item.itemId == selectedItemId,
      );
    } catch (e) {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final item = _currentItem();

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.circleColor.withAlpha(200),
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
                      'گروه قیمت گذاری',
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
        if (item != null) ...[
          const SizedBox(height: 5),
          /*_buildRow(
            label: "نام آیتم",
            value: _safeText(item?.itemName),
          ),*/
          _buildRow(
            label: "قیمت فروش",
            value: item.mesghalPrice != null
                ? _formatNumber(item.mesghalPrice ?? 0)
                : "-",
            valueColor: AppColor.accentColor,
            showButton: selectedBuySellId == 0 && item.mesghalPrice != null,
            onButtonPressed: item.mesghalPrice != null
                ? () {
              if (onPriceSelected != null) {
                onPriceSelected!(item.mesghalPrice ?? 0);
              }
            }
                : null,
          ),
          _buildRow(
            label: "قیمت خرید",
            value: item.mesghalBuyPrice != null
                ? _formatNumber(item.mesghalBuyPrice ?? 0)
                : "-",
            valueColor: AppColor.primaryColor,
            showButton: selectedBuySellId == 1 && item.mesghalBuyPrice != null,
            onButtonPressed: item.mesghalBuyPrice != null
                ? () {
              if (onPriceSelected != null) {
                onPriceSelected!(item.mesghalBuyPrice ?? 0);
              }
            }
                : null,
          ),
          _buildRow(
            label: "محدوده خرید",
            value: item.buyRange != null
                ? (item.buyRange ?? 0 ) < 0 ? "- ${item.buyRange?.abs().toStringAsFixed(0).seRagham() ?? ""}" : item.buyRange?.toStringAsFixed(0).seRagham() ?? ""
                : "-",
            valueColor: AppColor.textPrimaryColor,
          ),
          _buildRow(
            label: "محدوده فروش",
            value: item.salesRange != null
                ? (item.salesRange ?? 0 ) < 0 ? "-${item.salesRange?.abs().toStringAsFixed(0).seRagham() ?? ""}" : item.salesRange?.toStringAsFixed(0).seRagham() ?? ""
                : "-",
            valueColor: AppColor.textAccentColor
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildRow2(
                  label: "وضعیت خرید",
                  value: item.buyStatus ==true ? "فعال" : "غیر فعال",
                  valueColor: item.buyStatus ==true ? AppColor.primaryColor : AppColor.accentColor,
                ),
              ),
              Expanded(
                child: _buildRow2(
                    label: "وضعیت فروش",
                    value: item.sellStatus == true ? "فعال" : "غیر فعال",
                    valueColor: item.buyStatus ==true ? AppColor.primaryColor : AppColor.accentColor,
                ),
              ),
            ],
          )
        ],
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    Color? valueColor,
    bool showButton = false,
    VoidCallback? onButtonPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 4,
                backgroundColor: AppColor.textColor,
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
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showButton && onButtonPressed != null) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 28,
                    child:
                    Tooltip(
                      message: "افزودن قیمت",
                      child: GestureDetector(
                        onTap: onButtonPressed,
                        child: Transform.rotate(
                          angle: math.pi / 2,
                          child: SvgPicture.asset(
                            'assets/svg/add-price.svg',
                            height: 28,
                            colorFilter: ColorFilter.mode(
                              AppColor.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 5,),
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? AppColor.textColor,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow2({
    required String label,
    required String value,
    Color? valueColor,
    bool showButton = false,
    VoidCallback? onButtonPressed,
  }) {
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
            ],
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showButton && onButtonPressed != null) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 28,
                    child:
                    Tooltip(
                      message: "افزودن قیمت",
                      child: GestureDetector(
                        onTap: onButtonPressed,
                        child: Transform.rotate(
                          angle: math.pi / 2,
                          child: SvgPicture.asset(
                            'assets/svg/add-price.svg',
                            height: 28,
                            colorFilter: ColorFilter.mode(
                              AppColor.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 5,),
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? AppColor.textColor,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
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


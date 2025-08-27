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
    if (balanceList.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF334155),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF475569), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          if (titleBase.isNotEmpty) _buildContent(),
          _buildSummaryMetrics(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(height: 12),
          Text(
            'هیچ داده‌ای موجود نیست',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF475569), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calendar_today,
              size: 16,
              color: const Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.labelText.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF1F5F9),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${balanceList.length} آیتم',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF34D399),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'موجودی اقلام',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 12),
          ...balanceList.map((item) => _buildBalanceItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(BalanceTradingItemModel item) {
    final isPositive = (item.netQuantity ?? 0) > 0;
    final isNegative = (item.netQuantity ?? 0) < 0;
    final isZero = (item.netQuantity ?? 0) == 0;

    Color quantityColor;
    IconData? trendIcon;

    if (isPositive) {
      quantityColor = const Color(0xFF10B981);
      trendIcon = Icons.trending_up;
    } else if (isNegative) {
      quantityColor = const Color(0xFFEF4444);
      trendIcon = Icons.trending_down;
    } else {
      quantityColor = const Color(0xFF64748B);
      trendIcon = null;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: quantityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: quantityColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          if (trendIcon != null)
            Icon(
              trendIcon,
              size: 16,
              color: quantityColor,
            ),
          if (trendIcon != null) const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.itemName ?? '',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF1F5F9),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.netQuantity ?? 0}',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: quantityColor,
            ),
            textDirection: TextDirection.ltr,
          ),
          if (!isZero && item.unitName != null) ...[
            const SizedBox(width: 4),
            Text(
              item.unitName!,
              style: AppTextStyle.labelText.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: quantityColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryMetrics() {
    final metrics = _calculateMetrics();
    final isAggregateBalance = titleBase.isEmpty || titleBase == 'تراز تجمیعی';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAggregateBalance ) ...[
            _buildMetricRow('وزن 750', metrics.totalW750, Icons.fitness_center, isWeight: true),
          ],
          const SizedBox(height: 12),
          _buildMetricRow('ارزش فعلی', metrics.totalCurrent, Icons.account_balance_wallet),
          const SizedBox(height: 12),
          _buildMetricRow('پیش‌بینی', metrics.totalPredicted, Icons.trending_up),
          const SizedBox(height: 12),
          _buildMetricRow('میانگین قیمت', metrics.totalAverage, Icons.show_chart),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFF475569),
          ),
          const SizedBox(height: 16),
          _buildMetricRow('سود/زیان', metrics.totalProfit, Icons.assessment, isProfit: true),
          const SizedBox(height: 12),
          _buildMetricRow('سود/زیان واقعی', metrics.totalRealProfit, Icons.account_balance, isProfit: true),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, double value, IconData icon, {bool isProfit = false, bool isWeight = false}) {
    Color valueColor;
    if (isProfit) {
      if (value > 0) {
        valueColor = const Color(0xFF10B981);
      } else if (value < 0) {
        valueColor = const Color(0xFFEF4444);
      } else {
        valueColor = const Color(0xFF94A3B8);
      }
    } else if (isWeight) {
      if (value > 0) {
        valueColor = const Color(0xFF10B981);
      } else if (value < 0) {
        valueColor = const Color(0xFFEF4444);
      } else {
        valueColor = const Color(0xFFF1F5F9);
      }
    } else {
      valueColor = const Color(0xFFF1F5F9);
    }

    final formattedValue = isWeight
        ? value.toStringAsFixed(3).seRagham()
        : value.toStringAsFixed(0).seRagham();
    final displayValue = isProfit && value > 0 ? '+$formattedValue' : formattedValue;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF475569).withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Text(
            isWeight ? displayValue : '$displayValue ریال',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  BalanceMetrics _calculateMetrics() {
    double totalCurrent = 0;
    double totalPredicted = 0;
    double totalAverage = 0;
    double totalProfit = 0;
    double totalRealProfit = 0;
    double totalW750 = 0;

    for (var item in balanceList) {
      totalCurrent += item.netTotalPrice ?? 0;
      totalPredicted += item.predicatePrice ?? 0;
      totalAverage += item.avgPricePerUnit ?? 0;
      totalProfit += item.profitAndLoss ?? 0;
      totalRealProfit += item.realProfitAndLoss ?? 0;
      totalW750 += item.w750 ?? 0;
    }

    return BalanceMetrics(
      totalCurrent: totalCurrent,
      totalPredicted: totalPredicted,
      totalAverage: totalAverage,
      totalProfit: totalProfit,
      totalRealProfit: totalRealProfit,
      totalW750: totalW750,
    );
  }
}

class BalanceMetrics {
  final double totalCurrent;
  final double totalPredicted;
  final double totalAverage;
  final double totalProfit;
  final double totalRealProfit;
  final double totalW750;

  BalanceMetrics({
    required this.totalCurrent,
    required this.totalPredicted,
    required this.totalAverage,
    required this.totalProfit,
    required this.totalRealProfit,
    required this.totalW750,
  });
}

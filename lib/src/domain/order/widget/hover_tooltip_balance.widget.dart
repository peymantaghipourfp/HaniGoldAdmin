import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/order/controller/order.controller.dart';
import 'package:hanigold_admin/src/domain/order/model/tooltip_total_balance.model.dart';
import 'package:hanigold_admin/src/domain/order/widget/tooltip_total_balance.widget.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class HoverTooltipBalanceWidget extends StatefulWidget {
  final bool isNegative;
  final int accountId;
  final String accountName;
  final OrderController orderController;

  const HoverTooltipBalanceWidget({
    super.key,
    required this.isNegative,
    required this.accountId,
    required this.accountName,
    required this.orderController,
  });

  @override
  State<HoverTooltipBalanceWidget> createState() => _HoverTooltipBalanceWidgetState();
}

class _HoverTooltipBalanceWidgetState extends State<HoverTooltipBalanceWidget> {
  bool _isHovering = false;
  Future<TooltipTotalBalanceModel?>? _balanceFuture;
  int _lastRefreshCounter = 0;

  @override
  void initState() {
    super.initState();
    // Store initial refresh counter value
    _lastRefreshCounter = widget.orderController.refreshCounter.value;
  }

  // Invalidate cache when refresh counter changes
  void _checkAndInvalidateCache() {
    final currentCounter = widget.orderController.refreshCounter.value;
    if (currentCounter != _lastRefreshCounter) {
      _balanceFuture = null;
      _lastRefreshCounter = currentCounter;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if cache should be invalidated due to data refresh
    _checkAndInvalidateCache();
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
          // Invalidate cache if data was refreshed, then fetch
          _checkAndInvalidateCache();
          if (_balanceFuture == null) {
            _balanceFuture = widget.orderController.getTooltipTotalBalance(widget.accountId);
          }
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Tooltip(
        preferBelow: false,
        showDuration: Duration(seconds: 5),
        richMessage: WidgetSpan(
          child: _isHovering && _balanceFuture != null
              ? FutureBuilder<TooltipTotalBalanceModel?>(
            future: _balanceFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'خطا در بارگذاری تراز',
                    style: AppTextStyle.labelText.copyWith(fontSize: 12),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return TooltipTotalBalanceWidget(
                  tooltipTotalBalance: snapshot.data!,
                  size: 400,
                  title: widget.accountName.length > 32
                      ? '${widget.accountName.substring(0, 32)}...'
                      : widget.accountName,
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'تراز موجود نیست',
                    style: AppTextStyle.labelText.copyWith(fontSize: 12),
                  ),
                );
              }
            },
          )
              : Container(
            padding: EdgeInsets.all(8),
            child: Text(
              'در حال بارگذاری...',
              style: AppTextStyle.labelText.copyWith(fontSize: 12),
            ),
          ),
        ),
        child: Text(
          widget.accountName,
          style: AppTextStyle.bodyText.copyWith(fontSize: 12 ,fontWeight: FontWeight.bold, color: widget.isNegative==true ? AppColor.errorColor : AppColor.textColor ),
        ),
      ),
    );
  }
}

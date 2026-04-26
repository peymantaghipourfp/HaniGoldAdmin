import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/order/model/tooltip_total_balance.model.dart';
import 'package:hanigold_admin/src/domain/order/widget/tooltip_total_balance.widget.dart';
import 'package:hanigold_admin/src/domain/remittance/controller/remittance_request.controller.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class HoverTooltipBalanceRemReqWidget extends StatefulWidget {
  final int accountId;
  final String accountName;
  final RemittanceRequestController remittanceRequestController;

  const HoverTooltipBalanceRemReqWidget({
    super.key,
    required this.accountId,
    required this.accountName,
    required this.remittanceRequestController,
  });

  @override
  State<HoverTooltipBalanceRemReqWidget> createState() => _HoverTooltipBalanceRemReqWidgetState();
}

class _HoverTooltipBalanceRemReqWidgetState extends State<HoverTooltipBalanceRemReqWidget> {
  bool _isHovering = false;
  Future<TooltipTotalBalanceModel?>? _balanceFuture;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
          // Only fetch when hover starts
          if (_balanceFuture == null) {
            _balanceFuture = widget.remittanceRequestController.getTooltipTotalBalance(widget.accountId);
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
          style: AppTextStyle.bodyText.copyWith(fontSize: 12 ,fontWeight: FontWeight.bold, color: AppColor.textColor ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_layout.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_payment.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'inventory_create_payment_tab.widget.dart';
import 'inventory_create_receive_tab.widget.dart';

class InventoryCreateDialogWidget extends StatefulWidget {
  const InventoryCreateDialogWidget({super.key});

  @override
  State<InventoryCreateDialogWidget> createState() =>
      _InventoryCreateDialogWidgetState();
}

class _InventoryCreateDialogWidgetState extends State<InventoryCreateDialogWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late InventoryCreateLayoutController _layoutController;
  late InventoryCreatePaymentController _paymentController;
  late InventoryCreateReceiveController _receiveController;

  Offset _dialogOffset = Offset.zero;

  void _ensureControllers() {
    if (!Get.isRegistered<InventoryCreateLayoutController>()) {
      Get.put(InventoryCreateLayoutController());
    }
    if (!Get.isRegistered<InventoryCreatePaymentController>()) {
      Get.put(InventoryCreatePaymentController());
    }
    if (!Get.isRegistered<InventoryCreateReceiveController>()) {
      Get.put(InventoryCreateReceiveController());
    }
    _layoutController = Get.find<InventoryCreateLayoutController>();
    _paymentController = Get.find<InventoryCreatePaymentController>();
    _receiveController = Get.find<InventoryCreateReceiveController>();
  }

  void _resetFormState() {
    _layoutController.getTooltipTotalBalance(0);
    _paymentController.clearList();
    _receiveController.clearList();
  }

  @override
  void initState() {
    super.initState();
    _ensureControllers();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetFormState();
    });
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging && mounted) {
      _layoutController.getTooltipTotalBalance(0);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Transform.translate(
      offset: _dialogOffset,
      child: Dialog(
        backgroundColor: AppColor.backGroundColor2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColor.secondaryColor),
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40 : 16,
          vertical: 24,
        ),
        child: Container(
          width: isDesktop ? Get.width * 0.65 : Get.width * 0.95,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.9,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Draggable header
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dialogOffset += details.delta;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColor.backGroundColor2,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.drag_indicator,
                            color: AppColor.textColor.withAlpha(150),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ایجاد دریافت/پرداخت جدید',
                            style: AppTextStyle.smallTitleText,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          _resetFormState();
                          Get.back();
                        },
                        icon: Icon(Icons.close, color: AppColor.textColor),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab bar
              Container(
                width: isDesktop ? Get.width * 0.3 : Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.backGroundColor2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final currentIndex = _tabController.index;
                    return TabBar(
                      controller: _tabController,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: currentIndex == 0
                              ? AppColor.accentColor
                              : AppColor.primaryColor,
                          width: 3,
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColor.textColor,
                      dividerColor: AppColor.backGroundColor1,
                      unselectedLabelColor: AppColor.textColor.withAlpha(150),
                      labelStyle: AppTextStyle.labelText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      tabs: const [
                        Tab(text: 'دریافت'),
                        Tab(text: 'پرداخت'),
                      ],
                    );
                  },
                ),
              ),
              // Content
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      InventoryCreateReceiveTabWidget(
                        callBack: (int id) {
                          _layoutController.getTooltipTotalBalance(id);
                          if (mounted) setState(() {});
                        },
                      ),
                      InventoryCreatePaymentTabWidget(
                        callBack: (int id) {
                          _layoutController.getTooltipTotalBalance(id);
                          if (mounted) setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/trading_balance.controller.dart';
import '../widgets/balance_item.widget.dart';


class TradingBalanceView extends StatefulWidget {
  const TradingBalanceView({super.key});

  @override
  State<TradingBalanceView> createState() => _UserInfoTransactionViewState();
}

class _UserInfoTransactionViewState extends State<TradingBalanceView> {
  var controller=Get.find<TradingBalanceController>();
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppBar(
        title: 'تراز معاملاتی',
        onBackTap: () => Get.back(),
      ),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageStateBalance.loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : controller.state.value == PageStateBalance.list
                ? SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BalanceItemWidget(
                      title: '',
                      balanceList: [],
                      current: '',
                      forecast: '',
                      average: '',
                      profitLoss: '',)


                  ],
                ),
              ),
            )
                : Center(
              child: Text(
                'خطا در سمت سرور رخ داده',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

}


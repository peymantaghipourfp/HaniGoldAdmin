import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../controller/trading_balance.controller.dart';
import '../widgets/balance_item.widget.dart';

class TradingBalanceView extends StatefulWidget {
  const TradingBalanceView({super.key});

  @override
  State<TradingBalanceView> createState() => _TradingBalanceViewState();
}

class _TradingBalanceViewState extends State<TradingBalanceView> {
  var controller = Get.find<TradingBalanceController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Obx(() => Scaffold(
      //backgroundColor: const Color(0xFF0F172A),
      appBar: CustomAppbar1(
        title: 'تراز معاملاتی',
        onBackTap: () => Get.toNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body:
      controller.state.value == PageStateBalance.loading
          ? _buildLoadingState()
          : controller.state.value == PageStateBalance.list
          ? Stack(
        children: [
          BackgroundImageTotal(),
        _buildMainContent(isDesktop, isTablet)
      ],)
          : _buildErrorState(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
          SizedBox(height: 16),
          Text(
            'در حال بارگذاری اطلاعات...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'خطا در دریافت اطلاعات',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF1F5F9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لطفاً مجدداً تلاش کنید',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.getListTransactionInfo(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('تلاش مجدد'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isDesktop, bool isTablet) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySection('طلا', Icons.ac_unit, const Color(0xFFFBBF24), isDesktop, isTablet),
            const SizedBox(height: 20),
            _buildCategorySection('سکه', Icons.monetization_on, const Color(0xFFF59E0B), isDesktop, isTablet),
            const SizedBox(height: 20),
            _buildCategorySection('ارز', Icons.attach_money, const Color(0xFF10B981), isDesktop, isTablet),
            const SizedBox(height: 20),
            _buildCategorySection('تراز تجمیعی', Icons.dashboard, const Color(0xFF8B5CF6), isDesktop, isTablet),
          ],
        ),
      ),
    );
  }



  Widget _buildCategorySection(String categoryName, IconData icon, Color accentColor, bool isDesktop, bool isTablet) {
    final categoryItems = _getCategoryItems(categoryName);

    if (categoryItems.isEmpty) {
      return Container();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    categoryName,
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF1F5F9),
                    ),
                  ),
                ),
                /*Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${categoryItems.length} آیتم',
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: isDesktop
                ? _buildDesktopGrid(categoryItems, accentColor)
                : isTablet
                ? _buildTabletGrid(categoryItems, accentColor)
                : _buildMobileList(categoryItems, accentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopGrid(List<dynamic> items, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) => SizedBox(
            width: (constraints.maxWidth - 48) / 4,
            child: _buildModernBalanceCard(item, accentColor),
          )).toList(),
        );
      },
    );
  }

  Widget _buildTabletGrid(List<dynamic> items, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) => SizedBox(
            width: (constraints.maxWidth - 16) / 2,
            child: _buildModernBalanceCard(item, accentColor),
          )).toList(),
        );
      },
    );
  }

  Widget _buildMobileList(List<dynamic> items, Color accentColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernBalanceCard(item, accentColor),
            if (index < items.length - 1) const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildModernBalanceCard(dynamic item, Color accentColor) {
    return BalanceItemWidget(
      title: item.dateName ?? "",
      balanceList: item.balances ?? [],
      titleBase: item.itemGroup ?? "",
      isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),
    );
  }

  List<dynamic> _getCategoryItems(String category) {
    if (category == 'تراز تجمیعی') {
      return controller.tradingBalanceList.where((item) => item.itemGroup == null).toList();
    }
    return controller.tradingBalanceList.where((item) => item.itemGroup == category).toList();
  }
}


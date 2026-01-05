import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../product/model/item.model.dart';
import '../controller/trading_balance.controller.dart';
import '../model/balance_trading.model.dart';
import '../model/order_result_day.model.dart';

class TradingBalanceView extends StatefulWidget {
  const TradingBalanceView({super.key});

  @override
  State<TradingBalanceView> createState() => _TradingBalanceViewState();
}

class _TradingBalanceViewState extends State<TradingBalanceView> {
  var controller = Get.find<TradingBalanceController>();
  final ScrollController _headerHorizontalController = ScrollController();
  final ScrollController _bodyHorizontalController = ScrollController();
  final ScrollController _tableBodyVerticalController = ScrollController();
  bool _isSyncingHorizontal = false;

  @override
  void initState() {
    super.initState();
    // Link horizontal scroll positions between header and body
    _bodyHorizontalController.addListener(() {
      if (_isSyncingHorizontal) return;
      _isSyncingHorizontal = true;
      _headerHorizontalController.jumpTo(_bodyHorizontalController.position.pixels);
      _isSyncingHorizontal = false;
    });
    _headerHorizontalController.addListener(() {
      if (_isSyncingHorizontal) return;
      _isSyncingHorizontal = true;
      _bodyHorizontalController.jumpTo(_headerHorizontalController.position.pixels);
      _isSyncingHorizontal = false;
    });
  }

  @override
  void dispose() {
    _headerHorizontalController.dispose();
    _bodyHorizontalController.dispose();
    _tableBodyVerticalController.dispose();
    super.dispose();
  }
  // Fixed widths to keep header and body columns aligned
  final List<double> _columnWidths = const [
    85, // تاریخ
    100, // مقدار خرید
    130, // مبلغ کل خرید
    135, // مبلغ میانگین واقعی خرید
    100, // مقدار فروش
    130, // مبلغ کل فروش
    135, // مبلغ میانگین واقعی فروش
    95, // مقدار منتقل شده
    120, // مبلغ منتقل شده
    100, // مقدار بالانس روزانه
    95, // مقدار بالانس کل
    100, // مقدار محاسبه سود
    130, // مبلغ سود/زیان روزانه
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'تراز معاملاتی',
        onBackTap: () => Get.toNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: controller.state.value == PageStateBalance.loading
          ? _buildLoadingState()
          : controller.state.value == PageStateBalance.err
          ? _buildErrorState()
          : controller.state.value == PageStateBalance.empty
          ? Stack(
        children: [
          BackgroundImageTotal(),
          _buildMainContentWithNoData(isDesktop, isTablet)
        ],)
          : Stack(
        children: [
          BackgroundImageTotal(),
          _buildMainContent(isDesktop, isTablet)
        ],),
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
              border: Border.all(color: const Color(0xFFEF4444).withAlpha(75)),
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
            onPressed: () {
              // Retry loading data with proper date conversion
              if (controller.selectedItem.value?.id != null) {
                String gregorianStartDate = controller.convertJalaliToGregorianForApi(controller.dateStartController.text);
                String gregorianEndDate = controller.convertJalaliToGregorianForApi(controller.dateEndController.text);
                controller.getTradingBalanceList(
                  controller.selectedItem.value!.id!,
                  gregorianStartDate,
                  gregorianEndDate,
                );
              } else {
                // If no item selected, reload the item list first
                controller.fetchItemList();
              }
            },
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
            // Control Panel
            _buildControlPanel(isDesktop),
            const SizedBox(height: 24),

            // Summary Cards
            if (controller.tradingBalanceList.isNotEmpty)
              _buildSummaryCards(isDesktop),
            const SizedBox(height: 24),

            // Trading Data Table
            if (controller.tradingBalanceList.isNotEmpty)
              _buildTradingDataSection(isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContentWithNoData(bool isDesktop, bool isTablet) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control Panel
            _buildControlPanel(isDesktop),
            const SizedBox(height: 24),

            // No Data Message
            _buildNoDataMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondary100Color, AppColor.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF334155), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تنظیمات جستجو',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF1F5F9),
                ),
              ),
              isDesktop ?
              // خروجی اکسل
              ElevatedButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets
                          .symmetric(
                          horizontal: 15,
                          vertical: 7
                      ),
                    ),
                    fixedSize: WidgetStatePropertyAll(
                        Size(110, 30)),
                    elevation: WidgetStatePropertyAll(
                        5),
                    backgroundColor:
                    WidgetStatePropertyAll(
                        AppColor
                            .secondary3Color),
                    shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .circular(
                                5)))),
                onPressed: () {
                  String gregorianStartDate = controller.convertJalaliToGregorianForApi(controller.dateStartController.text);
                  String gregorianEndDate = controller.convertJalaliToGregorianForApi(controller.dateEndController.text);
                  controller.getTradingBalanceExcel(
                    controller.selectedItem.value!.id!,
                    gregorianStartDate,
                    gregorianEndDate,
                  );
                },
                child: Text(
                  'خروجی اکسل',
                  style: AppTextStyle
                      .bodyText,
                ),
                //onPressed: () => controller.getOrderExcel(),
              ):
              GestureDetector(
                onTap: () {
                  String gregorianStartDate = controller.convertJalaliToGregorianForApi(controller.dateStartController.text);
                  String gregorianEndDate = controller.convertJalaliToGregorianForApi(controller.dateEndController.text);
                  controller.getTradingBalanceExcel(
                    controller.selectedItem.value!.id!,
                    gregorianStartDate,
                    gregorianEndDate,
                  );
                },
                child: SvgPicture.asset(
                  'assets/svg/excel.svg',
                  height: 33,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isDesktop)
            Row(
              children: [
                Expanded(flex: 2, child: _buildItemDropdown()),
                const SizedBox(width: 16),
                Expanded(child: _buildDateField('تاریخ شروع', controller.dateStartController, true)),
                const SizedBox(width: 16),
                Expanded(child: _buildDateField('تاریخ پایان', controller.dateEndController, false)),
                const SizedBox(width: 16),
                _buildSearchButton(),
              ],
            )
          else
            Column(
              children: [
                _buildItemDropdown(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDateField('تاریخ شروع', controller.dateStartController, true)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDateField('تاریخ پایان', controller.dateEndController, false)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSearchButton(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildItemDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'انتخاب کالا',
          style: AppTextStyle.labelText.copyWith(
            fontSize: 12,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF334155),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF475569)),
          ),
          child: DropdownButtonFormField<ItemModel>(
            initialValue: controller.itemList.contains(controller.selectedItem.value) ? controller.selectedItem.value : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: InputBorder.none,
              hintText: 'انتخاب کنید...',
              hintStyle: AppTextStyle.labelText.copyWith(
                color: const Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            style: AppTextStyle.labelText.copyWith(
              color: const Color(0xFFF1F5F9),
              fontSize: 14,
            ),
            dropdownColor: const Color(0xFF334155),
            items: controller.itemList.map((ItemModel item) {
              return DropdownMenuItem<ItemModel>(
                value: item,
                child: Text(
                  item.name ?? 'نامشخص',
                  style: AppTextStyle.labelText.copyWith(
                    color: const Color(0xFFF1F5F9),
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: (ItemModel? newValue) {
              controller.changeSelectedItem(newValue);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController textController, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            fontSize: 12,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print('Date field tapped: ${isStart ? 'Start' : 'End'} date');
            _selectDate(textController, isStart);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    textController.text.isNotEmpty ? textController.text : 'انتخاب تاریخ',
                    style: AppTextStyle.labelText.copyWith(
                      color: textController.text.isNotEmpty ? const Color(0xFFF1F5F9) : const Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 23),
      child: ElevatedButton(
        onPressed: () {
          controller.onDateRangeChanged();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 16),
            const SizedBox(width: 8),
            Text('جستجو'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondary100Color, AppColor.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF334155), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.bar_chart_outlined,
              size: 48,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'هیچ داده معاملاتی یافت نشد',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF1F5F9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'برای کالای انتخابی در بازه زمانی مشخص شده، هیچ معاملات ثبت شده‌ای وجود ندارد',
            textAlign: TextAlign.center,
            style: AppTextStyle.labelText.copyWith(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: const Color(0xFF60A5FA),
              ),
              const SizedBox(width: 8),
              Text(
                'کالای دیگری انتخاب کنید یا بازه زمانی را تغییر دهید',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF60A5FA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(bool isDesktop) {
    if (controller.tradingBalanceList.isEmpty) return Container();

    final selectedData = controller.tradingBalanceList.first;

    final cards = [
      selectedData.itemId==0 ? SizedBox.shrink() :
      _buildSummaryCard(
        selectedData.unitName=="گرم" ? 'خرید گرمی' : 'خرید تعدادی',
        selectedData.unitName=="گرم" ? selectedData.sumBuyQty?.toStringAsFixed(3).seRagham() ?? "" : selectedData.sumBuyQty?.toStringAsFixed(0).seRagham() ?? "",
        selectedData.unitName ?? '',
        Icons.trending_up,
        const Color(0xFF10B981),
      ),
      selectedData.itemId==0 ? SizedBox.shrink() :
      _buildSummaryCard(
        'خرید ریالی',
        selectedData.sumBuyAmount?.toStringAsFixed(0).seRagham() ?? "",
        'ریال',
        Icons.account_balance_wallet,
        const Color(0xFF3B82F6),
      ),
      selectedData.itemId==0 ? SizedBox.shrink() :
      _buildSummaryCard(
        selectedData.unitName=="گرم" ? 'فروش گرمی' : 'فروش تعدادی',
        selectedData.unitName=="گرم" ? selectedData.sumSalesQty?.toStringAsFixed(3).seRagham() ?? "" : selectedData.sumSalesQty?.toStringAsFixed(0).seRagham() ?? "",
        selectedData.unitName ?? '',
        Icons.trending_down,
        const Color(0xFFF59E0B),
      ),
      selectedData.itemId==0 ? SizedBox.shrink() :
      _buildSummaryCard(
        'فروش ریالی',
        selectedData.sumSellAmount?.toStringAsFixed(0).seRagham() ?? "",
        'ریال',
        Icons.monetization_on,
        const Color(0xFF8B5CF6),
      ),
      selectedData.itemId==0 ? SizedBox.shrink() :
      _buildSummaryCard(
        'تراز کل',
        (selectedData.totalBalanceQty ?? 0 ) < 0 ? "-${selectedData.unitName=="گرم" ? selectedData.totalBalanceQty?.abs().toStringAsFixed(3).seRagham() : selectedData.totalBalanceQty?.abs().toStringAsFixed(0).seRagham()}" :
        selectedData.unitName=="گرم" ? selectedData.totalBalanceQty?.toStringAsFixed(3).seRagham() ?? "" : selectedData.totalBalanceQty?.toStringAsFixed(0).seRagham() ?? "",
        selectedData.unitName ?? '',
        Icons.balance,
        (selectedData.totalBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (selectedData.totalBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
      ),
      _buildSummaryCard(
        'سود / زیان',
        (selectedData.sumProfit ?? 0) < 0 ? "-${selectedData.sumProfit?.abs().toStringAsFixed(0).seRagham()}" : selectedData.sumProfit?.toStringAsFixed(0).seRagham() ?? "",
        'ریال',
        Icons.assessment,
        (selectedData.sumProfit ?? 0) > 0 ? const Color(0xFF10B981) : (selectedData.sumProfit ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
      ),
    ];

    if (isDesktop) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: cards.map((card) => SizedBox(
          width: (MediaQuery.of(context).size.width - 112) / 6, // 6 cards now
          child: card,
        )).toList(),
      );
    } else {
      return Column(
        children: cards.map((card) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: card,
        )).toList(),
      );
    }
  }

  Widget _buildSummaryCard(String title, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondary100Color, AppColor.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withAlpha(75)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyle.labelText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: AppTextStyle.labelText.copyWith(
              fontSize: 10,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingDataSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      /*decoration: BoxDecoration(
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
      ),*/
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            /*decoration: BoxDecoration(
              color: const Color(0xFF334155).withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),*/
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_chart,
                  color: const Color(0xFF60A5FA),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'جزئیات تراز معاملات',
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop)
            _buildDesktopTable()
          else
            _buildMobileCards(),
        ],
      ),
    );
  }

  Widget _buildDesktopTable() {
    if (controller.tradingBalanceList.isEmpty) return Container();

    final orderResults = controller.tradingBalanceList.first.orderBalanceResultDays ?? [];

    // Build sticky header (horizontal scrollable) and a vertically scrollable body
    return Column(
      children: [
        // Sticky header
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _headerHorizontalController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DataTable(
              dividerThickness: 0.3,
              border: TableBorder.symmetric(
                inside: BorderSide(color: AppColor.textColor, width: 0.3),
                outside: BorderSide(color: AppColor.textColor, width: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              headingRowHeight: 60,
              dataRowHeight: 0, // hide any data rows in header table
              columnSpacing: 0,
              horizontalMargin: 0,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF475569)),
              dataRowColor: WidgetStateProperty.all(Colors.transparent),
              columns: [
                // تاریخ
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[0],
                    child: Center(
                      child: Text(
                        'تاریخ',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مقدار خرید
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[1],
                    child: Center(
                      child: Text(
                        controller.tradingBalanceList.first.unitName=="گرم" ? 'مقدار خرید(گرم)' : 'مقدار خرید(تعداد)',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مبلغ کل خرید
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[2],
                    child: Center(
                      child: Text(
                        'مبلغ کل خرید',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مبلغ میانگین خرید
                /*DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Text(
                'مبلغ میانگین خرید',
                style: AppTextStyle.labelText.copyWith(
                  color: const Color(0xFFF1F5F9),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),*/
                // مبلغ میانگین واقعی خرید
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[3],
                    child: Center(
                      child: Text(
                        'مبلغ میانگین واقعی خرید',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مقدار فروش
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[4],
                    child: Center(
                      child: Text(
                        controller.tradingBalanceList.first.unitName=="گرم" ? 'مقدار فروش(گرم)' : 'مقدار فروش(تعداد)',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مبلغ کل فروش
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[5],
                    child: Center(
                      child: Text(
                        'مبلغ کل فروش',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مبلغ میانگین فروش
                /*DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Text(
                'مبلغ میانگین فروش',
                style: AppTextStyle.labelText.copyWith(
                  color: const Color(0xFFF1F5F9),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),*/
                // مقدار فروش منتقل شده
                /*DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Text(
                'مقدار فروش منتقل شده',
                style: AppTextStyle.labelText.copyWith(
                  color: const Color(0xFFF1F5F9),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),*/
                // مبلغ فروش منتقل شده
                /*DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Text(
                'مبلغ فروش منتقل شده',
                style: AppTextStyle.labelText.copyWith(
                  color: const Color(0xFFF1F5F9),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),*/
                // مبلغ میانگین واقعی فروش
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[6],
                    child: Center(
                      child: Text(
                        'مبلغ میانگین واقعی فروش',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                //  مقدار خرید و فروش منتقل شده
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[7],
                    child: Center(
                      child: Text(
                        'مقدار منتقل شده',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                ),
                // مبلغ خرید و فروش منتقل شده
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[8],
                    child: Center(
                      child: Text(
                        'مبلغ منتقل شده',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مقدار بالانس روزانه
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[9],
                    child: Center(
                      child: Text(
                        'مقدار بالانس روزانه',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مقدار بالانس کل
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[10],
                    child: Center(
                      child: Text(
                        'مقدار بالانس کل',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مقدار محاسبه سود
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[11],
                    child: Center(
                      child: Text(
                        'مقدار محاسبه سود',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // مبلغ سود/زیان روزانه
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: _columnWidths[12],
                    child: Center(
                      child: Text(
                        'مبلغ سود/زیان روزانه',
                        style: AppTextStyle.labelText.copyWith(
                          color: const Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              rows: const [],
            ),
          ),
        ),
        // Scrollable body
        SizedBox(
          height: 700,
          child: Scrollbar(
            controller: _tableBodyVerticalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _tableBodyVerticalController,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _bodyHorizontalController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DataTable(
                    dividerThickness: 0.3,
                    border: TableBorder.symmetric(
                      inside: BorderSide(color: AppColor.textColor, width: 0.3),
                      outside: BorderSide(color: AppColor.textColor, width: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    headingRowHeight: 0, // hide header in body table
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    dataRowColor: WidgetStateProperty.resolveWith((states) {
                      return AppColor.backGroundColor.withAlpha(80);
                    }),
                    columns: [
                      DataColumn(label: SizedBox(width: _columnWidths[0])),
                      DataColumn(label: SizedBox(width: _columnWidths[1])),
                      DataColumn(label: SizedBox(width: _columnWidths[2])),
                      DataColumn(label: SizedBox(width: _columnWidths[3])),
                      DataColumn(label: SizedBox(width: _columnWidths[4])),
                      DataColumn(label: SizedBox(width: _columnWidths[5])),
                      DataColumn(label: SizedBox(width: _columnWidths[6])),
                      DataColumn(label: SizedBox(width: _columnWidths[7])),
                      DataColumn(label: SizedBox(width: _columnWidths[8])),
                      DataColumn(label: SizedBox(width: _columnWidths[9])),
                      DataColumn(label: SizedBox(width: _columnWidths[10])),
                      DataColumn(label: SizedBox(width: _columnWidths[11])),
                      DataColumn(label: SizedBox(width: _columnWidths[12])),
                    ],
                    rows: orderResults.map((OrderResultDayModel order) {
                      final profit = order.profit ?? 0;
                      final profitColor = profit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                      return DataRow(
                        cells: [
                          // تاریخ
                          DataCell(SizedBox(
                            width: _columnWidths[0],
                            child: Center(
                              child: Text(
                                _formatDateToPersian(order.tradeDate ?? ''),
                                style: AppTextStyle.labelText.copyWith(
                                  color: const Color(0xFFF1F5F9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )),
                          // مقدار خرید
                          DataCell(SizedBox(
                            width: _columnWidths[1],
                            child: Center(
                              child: Text(
                                controller.tradingBalanceList.first.unitName=="گرم" ? (order.buyQty ?? 0).toStringAsFixed(3).seRagham() : (order.buyQty ?? 0).toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                  color: const Color(0xFF10B981),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مبلغ کل خرید
                          DataCell(SizedBox(
                            width: _columnWidths[2],
                            child: Center(
                              child: Text(
                                (order.buyAmount ?? 0).toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                  color: const Color(0xFF10B981),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مبلغ میانگین خرید
                          /*DataCell(
                  Center(
                    child: Text(
                      (order.buyAvgPrice ?? 0).toStringAsFixed(0).seRagham(),
                      style: AppTextStyle.labelText.copyWith(
                        color: const Color(0xFFF1F5F9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                                ),*/
                          // مبلغ میانگین واقعی خرید
                          DataCell(SizedBox(
                            width: _columnWidths[3],
                            child: Center(
                              child: Text(
                                (order.adjustedBuyAvgPrice ?? 0).toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                  color: const Color(0xFF10B981),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مقدار فروش
                          DataCell(SizedBox(
                            width: _columnWidths[4],
                            child: Center(
                              child: Text(
                                controller.tradingBalanceList.first.unitName=="گرم" ? (order.salesQty ?? 0).toStringAsFixed(3).seRagham() : (order.salesQty ?? 0).toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                  color: const Color(0xFFF59E0B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مبلغ کل فروش
                          DataCell(SizedBox(
                            width: _columnWidths[5],
                            child: Center(
                              child: Text(
                                (order.sellAmount ?? 0).toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                  color: const Color(0xFFF59E0B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مبلغ میانگین فروش
                          /*DataCell(
                  Center(
                    child: Text(
                      (order.salesAvgPrice ?? 0).toStringAsFixed(0).seRagham(),
                      style: AppTextStyle.labelText.copyWith(
                        color: const Color(0xFFF1F5F9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                                ),*/
                          // مقدار فروش منتقل شده
                          /*DataCell(
                  Center(
                    child: Text(
                      controller.tradingBalanceList.first.unitName=="گرم" ? (order.carryInSellQty ?? 0).toStringAsFixed(3).seRagham() : (order.carryInSellQty ?? 0).toStringAsFixed(0).seRagham(),
                      style: AppTextStyle.labelText.copyWith(
                        color: const Color(0xFFF59E0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                                ),*/
                          // مبلغ فروش منتقل شده
                          /*DataCell(
                  Center(
                    child: Text(
                      (order.carryInSellPrice ?? 0).toStringAsFixed(0).seRagham(),
                      style: AppTextStyle.labelText.copyWith(
                        color: const Color(0xFFF59E0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                                ),*/
                          // مبلغ میانگین واقعی فروش
                          DataCell(SizedBox(
                            width: _columnWidths[6],
                            child: Center(
                              child: Text(
                                (order.adjustedSalesAvgPrice ?? 0).toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                  color: const Color(0xFFF59E0B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          //  مقدار خرید و فروش منتقل شده
                          DataCell(SizedBox(
                            width: _columnWidths[7],
                            child: Center(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  order.carryInBuyQty==0 ? SizedBox.shrink() :
                                  Text(
                                    controller.tradingBalanceList.first.unitName=="گرم" ?
                                    (order.carryInBuyQty ?? 0).toStringAsFixed(3).seRagham() :
                                    (order.carryInBuyQty ?? 0).toStringAsFixed(0).seRagham(),
                                    style: AppTextStyle.labelText.copyWith(
                                      color: const Color(0xFF10B981),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textDirection: TextDirection.ltr,
                                  ),
                                  order.carryInSellQty==0 ? SizedBox.shrink() :
                                  Text(
                                    controller.tradingBalanceList.first.unitName=="گرم" ?
                                    "-${(order.carryInSellQty ?? 0).abs().toStringAsFixed(3).seRagham()}" :
                                    "-${(order.carryInSellQty ?? 0).abs().toStringAsFixed(0).seRagham()}",
                                    style: AppTextStyle.labelText.copyWith(
                                      color: const Color(0xFFEF4444),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textDirection: TextDirection.ltr,
                                  ),
                                ],
                              ),
                            ),
                          )),
                          // مبلغ خرید و فروش منتقل شده
                          DataCell(SizedBox(
                            width: _columnWidths[8],
                            child: Center(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  order.carryInBuyPrice==0 ? SizedBox.shrink() :
                                  Text(
                                    (order.carryInBuyPrice ?? 0).toStringAsFixed(0).seRagham(),
                                    style: AppTextStyle.labelText.copyWith(
                                      color: const Color(0xFF10B981),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textDirection: TextDirection.ltr,
                                  ),
                                  order.carryInSellPrice==0 ? SizedBox.shrink() :
                                  Text(
                                    (order.carryInSellPrice ?? 0).toStringAsFixed(0).seRagham(),
                                    style: AppTextStyle.labelText.copyWith(
                                      color: const Color(0xFFEF4444),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textDirection: TextDirection.ltr,
                                  ),
                                ],
                              ),
                            ),
                          )),
                          // مقدار بالانس روزانه
                          DataCell(SizedBox(
                            width: _columnWidths[9],
                            child: Center(
                              child:
                              controller.tradingBalanceList.first.unitName=="گرم" ?
                              Text(
                                (order.dailyBalanceQty ?? 0) < 0 ? "-${(order.dailyBalanceQty?.abs() ?? 0).toStringAsFixed(3).seRagham()}" : (order.dailyBalanceQty ?? 0).toStringAsFixed(3).seRagham(),
                                style: AppTextStyle.bodyText.copyWith(
                                  color: (order.dailyBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.dailyBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.ltr,
                              ):
                              Text(
                                (order.dailyBalanceQty ?? 0) < 0 ? "-${(order.dailyBalanceQty?.abs() ?? 0).toStringAsFixed(0).seRagham()}" : (order.dailyBalanceQty ?? 0).toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.bodyText.copyWith(
                                  color: (order.dailyBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.dailyBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مقدار بالانس کل
                          DataCell(SizedBox(
                            width: _columnWidths[10],
                            child: Center(
                              child:
                              controller.tradingBalanceList.first.unitName=="گرم" ?
                              Text(
                                (order.totalBalanceQty ?? 0) < 0 ? "-${(order.totalBalanceQty?.abs() ?? 0).toStringAsFixed(3).seRagham()}" : (order.totalBalanceQty ?? 0).toStringAsFixed(3).seRagham() ,
                                style: AppTextStyle.labelText.copyWith(
                                  color: (order.totalBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.totalBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.ltr,
                              ):
                              Text(
                                (order.totalBalanceQty ?? 0) < 0 ? "-${(order.totalBalanceQty?.abs() ?? 0).toStringAsFixed(0).seRagham()}" : (order.totalBalanceQty ?? 0).toStringAsFixed(0).seRagham() ,
                                style: AppTextStyle.labelText.copyWith(
                                  color: (order.totalBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.totalBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مقدار محاسبه سود
                          DataCell(SizedBox(
                            width: _columnWidths[11],
                            child: Center(
                              child:
                              controller.tradingBalanceList.first.unitName=="گرم" ?
                              Text(
                                (order.qtyForProfit ?? 0) < 0 ? "-${(order.qtyForProfit?.abs() ?? 0).toStringAsFixed(3).seRagham()}" : (order.qtyForProfit ?? 0).toStringAsFixed(3).seRagham() ,
                                style: AppTextStyle.labelText.copyWith(
                                  color: (order.qtyForProfit ?? 0) > 0 ? const Color(0xFF10B981) : (order.qtyForProfit ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.ltr,
                              ):
                              Text(
                                (order.qtyForProfit ?? 0) < 0 ? "-${(order.qtyForProfit?.abs() ?? 0).toStringAsFixed(0).seRagham()}" : (order.qtyForProfit ?? 0).toStringAsFixed(0).seRagham() ,
                                style: AppTextStyle.labelText.copyWith(
                                  color: (order.qtyForProfit ?? 0) > 0 ? const Color(0xFF10B981) : (order.qtyForProfit ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                          // مبلغ سود/زیان روزانه
                          DataCell(SizedBox(
                            width: _columnWidths[12],
                            child: Center(
                              child: Text(
                                profit < 0 ? "-${profit.abs().toStringAsFixed(0).seRagham()}" : profit.toStringAsFixed(0).seRagham(),
                                style: AppTextStyle.labelText.copyWith(
                                  color: profitColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileCards() {
    if (controller.tradingBalanceList.isEmpty) return Container();

    final orderResults = controller.tradingBalanceList.first.orderBalanceResultDays ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: orderResults.map((OrderResultDayModel order) {
          final profit = order.profit ?? 0;
          final profitColor = profit > 0 ? const Color(0xFF10B981) : profit < 0 ? const Color(0xFFEF4444) : AppColor.textColor;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.appBarColor.withAlpha(200),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF64748B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDateToPersian(order.tradeDate ?? ''),
                      style: AppTextStyle.labelText.copyWith(
                        color: const Color(0xFFF1F5F9),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: profitColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        profit < 0 ?
                        "-${profit.abs().toStringAsFixed(0).seRagham()}" :
                        profit.toStringAsFixed(0).seRagham(),
                        style: AppTextStyle.labelText.copyWith(
                          color: profitColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileCardItem(
                        controller.tradingBalanceList.first.unitName=="گرم" ? 'مقدار خرید(گرم)'
                            : controller.tradingBalanceList.first.unitName=="عدد" ? 'مقدار خرید(تعداد)' : 'مقدار خرید' ,
                        controller.tradingBalanceList.first.unitName=="گرم" ?
                        (order.buyQty ?? 0).toStringAsFixed(3).seRagham() :
                        controller.tradingBalanceList.first.unitName=="عدد" ? (order.buyQty ?? 0).toStringAsFixed(0).seRagham()  : (order.buyQty ?? 0).toString().seRagham(),
                        const Color(0xFF10B981),
                      ),
                    ),
                    Expanded(
                      child: _buildMobileCardItem(
                    controller.tradingBalanceList.first.unitName=="گرم" ? 'مقدار فروش(گرم)' : controller.tradingBalanceList.first.unitName=="عدد" ? 'مقدار فروش(تعداد)'  : 'مقدار فروش',
                        controller.tradingBalanceList.first.unitName=="گرم" ?
                        (order.salesQty ?? 0).toStringAsFixed(3).seRagham() :
                        controller.tradingBalanceList.first.unitName=="عدد" ?
                        (order.salesQty ?? 0).toStringAsFixed(0).seRagham() : (order.salesQty ?? 0).toString().seRagham(),
                        const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileCardItem(
                        'مبلغ کل خرید',
                        (order.buyAmount ?? 0).toStringAsFixed(0).seRagham(),
                        const Color(0xFF10B981),
                      ),
                    ),
                    Expanded(
                      child: _buildMobileCardItem(
                        'مبلغ کل فروش',
                        (order.sellAmount ?? 0).toStringAsFixed(0).seRagham(),
                        const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileCardItem(
                        'مبلغ میانگین واقعی خرید',
                          (order.adjustedBuyAvgPrice ?? 0).toStringAsFixed(0).seRagham(),
                        const Color(0xFF10B981),
                      ),
                    ),
                    Expanded(
                      child: _buildMobileCardItem(
                        'مبلغ میانگین واقعی فروش',
                          (order.adjustedSalesAvgPrice ?? 0).toStringAsFixed(0).seRagham(),
                        const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    order.carryInBuyQty==0 ? SizedBox.shrink() :
                    Expanded(
                      child: _buildMobileCardItem(
                        'مقدار منتقل شده',
                        controller.tradingBalanceList.first.unitName=="گرم" ?
                        (order.carryInBuyQty ?? 0).toStringAsFixed(3).seRagham() :
                        (order.carryInBuyQty ?? 0).toStringAsFixed(0).seRagham(),
                        const Color(0xFF10B981),
                      ),
                    ),
                    order.carryInSellQty==0 ? SizedBox.shrink() :
                    Expanded(
                      child: _buildMobileCardItem(
                        'مقدار منتقل شده',
                        controller.tradingBalanceList.first.unitName=="گرم" ?
                        "-${(order.carryInSellQty ?? 0).abs().toStringAsFixed(3).seRagham()}" :
                        "-${(order.carryInSellQty ?? 0).abs().toStringAsFixed(0).seRagham()}",
                        const Color(0xFFEF4444),
                      ),
                    ),
                    order.carryInBuyPrice==0 ? SizedBox.shrink() :
                    Expanded(
                      child: _buildMobileCardItem(
                        'مبلغ منتقل شده',
                        (order.carryInBuyPrice ?? 0).toStringAsFixed(0).seRagham(),
                        const Color(0xFF10B981),
                      ),
                    ),
                    order.carryInSellPrice==0 ? SizedBox.shrink() :
                    Expanded(
                      child: _buildMobileCardItem(
                        'مبلغ منتقل شده',
                        (order.carryInSellPrice ?? 0).toStringAsFixed(0).seRagham(),
                        const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child:
                      controller.tradingBalanceList.first.unitName=="گرم" ?
                      _buildMobileCardItem(
                        'مقدار بالانس روزانه',
                        (order.dailyBalanceQty ?? 0) < 0 ? "-${(order.dailyBalanceQty?.abs() ?? 0).toStringAsFixed(3).seRagham()}" : (order.dailyBalanceQty ?? 0).toStringAsFixed(3).seRagham(),
                        (order.dailyBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.dailyBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                      ):
                      _buildMobileCardItem(
                        'مقدار بالانس روزانه',
                        (order.dailyBalanceQty ?? 0) < 0 ? "-${(order.dailyBalanceQty?.abs() ?? 0).toStringAsFixed(0).seRagham()}" : (order.dailyBalanceQty ?? 0).toStringAsFixed(0).seRagham(),
                        (order.dailyBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.dailyBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                      )
                    ),
                    Expanded(
                      child:
                      controller.tradingBalanceList.first.unitName=="گرم" ?
                      _buildMobileCardItem(
                        'مقدار بالانس کل',
                        (order.totalBalanceQty ?? 0) < 0 ? "-${(order.totalBalanceQty?.abs() ?? 0).toStringAsFixed(3).seRagham()}" : (order.totalBalanceQty ?? 0).toStringAsFixed(3).seRagham() ,
                        (order.totalBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.totalBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                      ):
                      _buildMobileCardItem(
                        'مقدار بالانس کل',
                        (order.totalBalanceQty ?? 0) < 0 ? "-${(order.totalBalanceQty?.abs() ?? 0).toStringAsFixed(0).seRagham()}" : (order.totalBalanceQty ?? 0).toStringAsFixed(0).seRagham(),
                        (order.totalBalanceQty ?? 0) > 0 ? const Color(0xFF10B981) : (order.totalBalanceQty ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child:
                        controller.tradingBalanceList.first.unitName=="گرم" ?
                        _buildMobileCardItem(
                          'مقدار محاسبه سود',
                          (order.qtyForProfit ?? 0) < 0 ? "-${(order.qtyForProfit?.abs() ?? 0).toStringAsFixed(3).seRagham()}" : (order.qtyForProfit ?? 0).toStringAsFixed(3).seRagham(),
                          (order.qtyForProfit ?? 0) > 0 ? const Color(0xFF10B981) : (order.qtyForProfit ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                        ):
                        _buildMobileCardItem(
                          'مقدار محاسبه سود',
                          (order.qtyForProfit ?? 0) < 0 ? "-${(order.qtyForProfit?.abs() ?? 0).toStringAsFixed(0).seRagham()}" : (order.qtyForProfit ?? 0).toStringAsFixed(0).seRagham(),
                          (order.qtyForProfit ?? 0) > 0 ? const Color(0xFF10B981) : (order.qtyForProfit ?? 0) < 0 ? const Color(0xFFEF4444) : AppColor.textColor,
                        )
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileCardItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            color: const Color(0xFF94A3B8),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.labelText.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  String _formatDateToPersian(String gregorianDateString) {
    try {
      if (gregorianDateString.isEmpty) return '';

      // Parse the Gregorian date string (format: 2025-09-14T00:00:00)
      DateTime gregorianDate = DateTime.parse(gregorianDateString);

      // Convert to Jalali
      Jalali jalaliDate = Jalali.fromDateTime(gregorianDate);

      // Format as Persian date string
      String persianDate = "${jalaliDate.year}/${jalaliDate.month.toString().padLeft(2, '0')}/${jalaliDate.day.toString().padLeft(2, '0')}";

      // Convert numbers to Persian
      return persianDate.toPersianDigit();

    } catch (e) {
      print('Error formatting date to Persian: $e');
      return gregorianDateString.substring(0, 10); // Fallback to original format
    }
  }

  /*double _calculateTotalBalance(OrderResultDayModel order) {
    // Calculate total balance: diffQty_Gram + cumDiffQty_Gram_UptoPrev
    double diffQty = order.diffQtyGram ?? 0;
    double cumDiffQty = order.cumDiffQtyGramUptoPrev ?? 0;
    return diffQty + cumDiffQty;
  }*/

  Future<void> _selectDate(TextEditingController controller, bool isStart) async {
    try {
      print('_selectDate called for ${isStart ? 'start' : 'end'} date');

      final Jalali? picked = await showPersianDatePicker(
        context: context,
        initialDate: Jalali.now(),
        firstDate: Jalali(1400),
        lastDate: Jalali.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF3B82F6),
                onPrimary: Colors.white,
                surface: Color(0xFF1E293B),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      print('Date picker result: $picked');

      if (picked != null) {
        // Format the date in Jalali format for display
        final String formattedDate = "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')} ${isStart ? '00:00:00' : '23:59:59'}";
        controller.text = formattedDate;

        // Automatically refresh data when date is changed
        this.controller.onDateRangeChanged();
      }
    } catch (e) {
      print('Error selecting date: $e');
    }
  }
}

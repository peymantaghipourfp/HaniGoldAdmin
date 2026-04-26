import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/analyticalReports/controller/candle_price_chart.controller.dart';
import 'package:hanigold_admin/src/domain/analyticalReports/model/candle_price_chart.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/widget/background_image_total.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:hanigold_admin/src/widget/app_drawer.widget.dart';
import 'package:hanigold_admin/src/widget/empty.dart';
import 'package:hanigold_admin/src/widget/err_page.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandlePriceChartView extends StatefulWidget {
  const CandlePriceChartView({super.key});

  @override
  State<CandlePriceChartView> createState() => _CandlePriceChartViewState();
}

class _CandlePriceChartViewState extends State<CandlePriceChartView> {
  final CandlePriceChartController controller = Get.find<CandlePriceChartController>();
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _initChartBehaviors();
  }

  void _initChartBehaviors() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: AppColor.backGroundColor2.withAlpha(200),
        textStyle: AppTextStyle.labelText.copyWith(fontSize: 10,color: AppColor.dividerColor),
       // format: 'point.high : بالا\npoint.low : پایین\npoint.open : باز\npoint.close : بسته\npoint.y : حجم',
      ),
      lineType: TrackballLineType.vertical,
      lineColor: AppColor.dividerColor.withAlpha(100),
      lineWidth: 1,
    );

    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
      zoomMode: ZoomMode.x,
    );
  }

  @override
  void dispose() {
    Get.delete<CandlePriceChartController>();
    super.dispose();
  }

  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 600;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).size.width <= 1200;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width > 1200;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);
    final isDesktop = _isDesktop(context);

    return Scaffold(
      appBar: CustomAppbar1(
        title: 'نمودار تغییر قیمت و حجم',
        onBackTap: () => Get.offNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const BackgroundImageTotal(),
          _buildMainContent(isMobile, isTablet, isDesktop),
          _buildToolBar(),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
      return Column(
        children: [
          _buildControlPanel(isMobile),
          Expanded(child: _buildChartSection(isMobile)),
          _buildItemsListMobile(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Items list (right side)
        Container(
          width: isDesktop ? 320 : 280,
          decoration: BoxDecoration(
            color: AppColor.secondary10Color,
            border: Border(
              right: BorderSide(color: AppColor.dividerColor.withAlpha(50), width: 1),
            ),
          ),
          child: _buildItemsListDesktop(),
        ),
        // Chart area (left side)
        Expanded(
          flex: isDesktop ? 4 : 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildControlPanel(isMobile),
                const SizedBox(height: 16),
                Expanded(child: _buildChartSection(isMobile)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============== CONTROL PANEL ==============

  Widget _buildControlPanel(bool isMobile) {
    return Container(
      margin: isMobile ? const EdgeInsets.all(12) : EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondary100Color, AppColor.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تنظیمات نمودار',
                style: AppTextStyle.mediumTitleText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF1F5F9),
                ),
              ),
              _buildRefreshControls(),
            ],
          ),
          const SizedBox(height: 16),
          isMobile ? _buildControlsMobile() : _buildControlsDesktop(),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    const toolbarSize = Size(64, 320);
    return Obx(() {
      if (!controller.showToolbar.value) {
        return const SizedBox.shrink();
      }
      return Positioned(
        left: controller.toolbarLeft.value,
        top: controller.toolbarTop.value,
        child: GestureDetector(
          onPanUpdate: (details) {
            final screenSize = MediaQuery.of(context).size;
            controller.updateToolbarPosition(details.delta, screenSize, toolbarSize);
          },
          child: Container(
            width: toolbarSize.width,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: AppColor.secondaryColor.withAlpha(220),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.dividerColor.withAlpha(80)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withAlpha(120),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _toolButton(
                  icon: Icons.timeline,
                  tooltip: 'رسم خط روند',
                  isActive: controller.isTrendMode.value,
                  onTap: controller.toggleTrendMode,
                ),
                _toolButton(
                  icon: Icons.clear,
                  tooltip: 'حذف خط روند',
                  onTap: controller.clearTrendLine,
                ),
                const Divider(height: 18, color: Color(0xFF475569)),
                _toolButton(
                  icon: Icons.grid_on,
                  tooltip: 'نمایش/مخفی گرید',
                  isActive: controller.showGrid.value,
                  onTap: controller.toggleGridVisibility,
                ),
                _toolButton(
                  icon: Icons.bar_chart,
                  tooltip: 'نمایش/مخفی حجم',
                  isActive: controller.showVolume.value,
                  onTap: controller.toggleVolumeVisibility,
                ),
                _toolButton(
                  icon: Icons.refresh,
                  tooltip: 'بروزرسانی داده',
                  onTap: controller.refresh,
                ),
                const Divider(height: 18, color: Color(0xFF475569)),
                _toolButton(
                  icon: Icons.cancel_sharp,
                  tooltip: 'بستن تنظیمات',
                  onTap: controller.toggleToolbarVisibility,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _toolButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: tooltip ?? '',
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF3B82F6).withAlpha(60) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? const Color(0xFF3B82F6) : AppColor.dividerColor.withAlpha(120),
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isActive ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshControls() {
    /*return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Auto refresh toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: controller.isAutoRefreshEnabled.value
                ? AppColor.primaryColor.withAlpha(40)
                : AppColor.appBarColor.withAlpha(80),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: controller.isAutoRefreshEnabled.value
                  ? AppColor.primaryColor
                  : Colors.transparent,
            ),
          ),
          child: InkWell(
            onTap: controller.toggleAutoRefresh,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.isAutoRefreshEnabled.value
                      ? Icons.sync
                      : Icons.sync_disabled,
                  size: 14,
                  color: controller.isAutoRefreshEnabled.value
                      ? AppColor.primaryColor
                      : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 4),
                Text(
                  controller.isAutoRefreshEnabled.value ? 'بروزرسانی خودکار' : 'غیرفعال',
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: 10,
                    color: controller.isAutoRefreshEnabled.value
                        ? AppColor.primaryColor
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Manual refresh button
        IconButton(
          onPressed: controller.refresh,
          icon: const Icon(Icons.refresh, size: 20),
          color: const Color(0xFF3B82F6),
          tooltip: 'بروزرسانی',
        ),
      ],
    ));*/
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
            return IconButton(
              onPressed: controller.toggleToolbarVisibility,
              icon: SvgPicture.asset(controller.showToolbar.value ? 'assets/svg/setting.svg' : 'assets/svg/setting-o.svg',height: 18,
                  colorFilter: ColorFilter.mode(controller.showToolbar.value ? const Color(
                      0xFF8DB2E7) : const Color(
                      0xFF587093), BlendMode.srcIn,)
              ),
              tooltip: controller.showToolbar.value ? 'مخفی کردن تنظیمات' : 'نمایش تنظیمات',
            );
          }
        ),
        IconButton(
          onPressed: controller.refresh,
          icon: const Icon(Icons.refresh, size: 20),
          color: const Color(0xFF3B82F6),
          tooltip: 'بروزرسانی',
        ),
      ],
    );
  }

  Widget _buildControlsDesktop() {
    return Row(
      children: [
        Expanded(child: _buildDateField()),
        const SizedBox(width: 12),
        Expanded(child: _buildTimeField('از ساعت', controller.startTimeController, true)),
        const SizedBox(width: 12),
        Expanded(child: _buildTimeField('تا ساعت', controller.endTimeController, false)),
        const SizedBox(width: 16),
        _buildTimeFrameSelector(),
      ],
    );
  }

  Widget _buildControlsMobile() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildDateField()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTimeField('از ساعت', controller.startTimeController, true)),
            const SizedBox(width: 12),
            Expanded(child: _buildTimeField('تا ساعت', controller.endTimeController, false)),
          ],
        ),
        const SizedBox(height: 12),
        _buildTimeFrameSelector(),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تاریخ',
          style: AppTextStyle.labelText.copyWith(
            fontSize: 11,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _selectDate(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => Text(
                    controller.selectedDate.value.isNotEmpty
                        ? controller.selectedDate.value
                        : controller.dateController.text,
                    style: AppTextStyle.labelText.copyWith(
                      color: const Color(0xFFF1F5F9),
                      fontSize: 12,
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TextEditingController textController, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            fontSize: 11,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _selectTime(textController, isStart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => Text(
                    isStart
                        ? (controller.selectedStartTime.value.isNotEmpty
                        ? controller.selectedStartTime.value
                        : textController.text)
                        : (controller.selectedEndTime.value.isNotEmpty
                        ? controller.selectedEndTime.value
                        : textController.text),
                    style: AppTextStyle.labelText.copyWith(
                      color: const Color(0xFFF1F5F9),
                      fontSize: 12,
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFrameSelector() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بازه زمانی',
          style: AppTextStyle.labelText.copyWith(
            fontSize: 11,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF334155),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF475569)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ChartTimeFrame.values.map((tf) {
              final isSelected = controller.selectedTimeFrame.value == tf;
              return InkWell(
                onTap: () => controller.changeTimeFrame(tf),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tf.label,
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 11,
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ));
  }
  Future<void> _selectDate() async {
    try {
      final Jalali? picked = await showPersianDatePicker(
        context: context,
        initialDate: Jalali.now(),
        firstDate: Jalali(1400, 1, 1),
        lastDate: Jalali(1450, 12, 29),
        initialEntryMode: PersianDatePickerEntryMode.calendar,
        locale: const Locale("fa", "IR"),
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

      if (picked != null) {
        final formattedDate = "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
        controller.updateDate(formattedDate);
      }
    } catch (e) {
      print('Error selecting date: $e');
    }
  }

  Future<void> _selectTime(TextEditingController textController, bool isStart) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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

      if (picked != null) {
        final formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
        if (isStart) {
          controller.updateStartTime(formattedTime);
        } else {
          controller.updateEndTime(formattedTime);
        }
      }
    } catch (e) {
      print('Error selecting time: $e');
    }
  }

  // ============== CHART SECTION ==============

  Widget _buildChartSection(bool isMobile) {
    return Obx(() {
      if (controller.chartState.value == ChartPageState.loading) {
        return _buildLoadingState();
      }

      if (controller.chartState.value == ChartPageState.error) {
        return ErrPage(
          title: 'خطا در دریافت اطلاعات',
          des: controller.errorMessage.value,
          callback: controller.refresh,
        );
      }

      if (controller.chartState.value == ChartPageState.empty) {
        return EmptyPage(
          title: 'داده‌ای یافت نشد',
          des: controller.errorMessage.value.isNotEmpty
              ? controller.errorMessage.value
              : 'برای محصول و بازه زمانی انتخاب شده اطلاعاتی موجود نیست',
          callback: controller.refresh,
        );
      }

      return _buildChartContainer(isMobile);
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
          const SizedBox(height: 16),
          Text(
            'در حال بارگذاری نمودار...',
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 14,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChartHeader(),
          Expanded(child: _buildCandleChart()),
          _buildChartStats(isMobile),
        ],
      ),
    );
  }

  Widget _buildChartHeader() {
    return Obx(() {
      final item = controller.selectedItem.value;
      final priceChange = controller.getPriceChangePercent();
      final isPositive = priceChange >= 0;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.secondary100Color.withAlpha(80),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            if (item?.icon != null)
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: AppColor.appBarColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item!.icon}',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.show_chart,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.name ?? 'محصول انتخاب نشده',
                    style: AppTextStyle.mediumTitleText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondary3Color,
                    ),
                  ),
                  if (controller.candleData.isNotEmpty)
                    Text(
                      'تعداد کندل: ${controller.candleData.length}',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                ],
              ),
            ),
            if (controller.candleData.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColor.primaryColor.withAlpha(30)
                      : AppColor.accentColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPositive ? AppColor.primaryColor : AppColor.accentColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: isPositive ? AppColor.primaryColor : AppColor.accentColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${priceChange.toStringAsFixed(2)}%',
                      style: AppTextStyle.bodyTextBold.copyWith(
                        fontSize: 13,
                        color: isPositive ? AppColor.primaryColor : AppColor.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCandleChart() {
    return Obx(() {
      final data = controller.candleData;
      if (data.isEmpty) {
        return const Center(child: Text('داده‌ای برای نمایش وجود ندارد'));
      }

      return Padding(
        padding: const EdgeInsets.all(8),
        child: SfCartesianChart(
          backgroundColor: Colors.transparent,
          plotAreaBorderWidth: 0,
          margin: const EdgeInsets.all(8),
          // Disable side-by-side placement - render all series at exact same x-position
          enableSideBySideSeriesPlacement: false,
          primaryXAxis: DateTimeAxis(
            majorGridLines: MajorGridLines(
              width: controller.showGrid.value ? 0.5 : 0,
              color: const Color(0xFF334155).withAlpha(150),
            ),
            axisLine: AxisLine(width: controller.showGrid.value ? 1 : 0),
            labelStyle: AppTextStyle.labelText.copyWith(
              fontSize: 9,
              color: const Color(0xFF94A3B8),
            ),
            dateFormat: _PersianDateFormat(),
            intervalType: DateTimeIntervalType.auto,
          ),
          primaryYAxis: NumericAxis(
            name: 'priceAxis',
            majorGridLines: MajorGridLines(
              width: controller.showGrid.value ? 0.5 : 0,
              color: const Color(0xFF334155).withAlpha(150),
              dashArray: controller.showGrid.value ? const <double>[5, 5] : const <double>[],
            ),
            axisLine: AxisLine(width: controller.showGrid.value ? 1 : 0),
            labelStyle: AppTextStyle.labelText.copyWith(
              fontSize: 9,
              color: const Color(0xFF94A3B8),
            ),
            //numberFormat: null,
            numberFormat: NumberFormat('#,###', 'en_US'),
            opposedPosition: true,
            // Reserve bottom 20% for volume chart
            plotOffset: 0,
            anchorRangeToVisiblePoints: true,
          ),
          axes: <ChartAxis>[
            NumericAxis(
              name: 'volumeAxis',
              opposedPosition: true,
              majorGridLines: const MajorGridLines(width: 0),
              minorGridLines: const MinorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              labelStyle: AppTextStyle.labelText.copyWith(
                fontSize: 8,
                color: const Color(0xFF64748B),
              ),
              isVisible: false,
              // Scale volume to occupy bottom ~20% of chart
              // By setting maximum to 5x the actual max, bars stay at bottom
              maximum: _getMaxVolume(data) * 5,
              minimum: 0,
            ),
          ],
          trackballBehavior: _trackballBehavior,
          zoomPanBehavior: _zoomPanBehavior,
          series: <CartesianSeries>[
            // Volume bar series FIRST (renders behind candles)
            if (controller.showVolume.value)
            ColumnSeries<CandlePriceChartModel, DateTime>(
              dataSource: data,
              xValueMapper: (CandlePriceChartModel candle, _) => _parseDateTime(candle.candleTime),
              yValueMapper: (CandlePriceChartModel candle, _) => candle.volume ?? 0,
              yAxisName: 'volumeAxis',
              pointColorMapper: (CandlePriceChartModel candle, _) {
                final open = candle.openPrice ?? 0;
                final close = candle.closePrice ?? 0;
                return close >= open
                    ? AppColor.primaryColor.withAlpha(70)
                    : AppColor.accentColor.withAlpha(70);
              },
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(1),
                topRight: Radius.circular(1),
              ),
              width: 0.8,
              animationDuration: 500,
              spacing: 0.0,
            ),
            // Candlestick series (main chart - renders on top)
            CandleSeries<CandlePriceChartModel, DateTime>(
              dataSource: data,
              xValueMapper: (CandlePriceChartModel candle, _) => _parseDateTime(candle.candleTime),
              lowValueMapper: (CandlePriceChartModel candle, _) => candle.lowPrice?.toDouble() ?? 0,
              highValueMapper: (CandlePriceChartModel candle, _) => candle.highPrice?.toDouble() ?? 0,
              openValueMapper: (CandlePriceChartModel candle, _) => candle.openPrice?.toDouble() ?? 0,
              closeValueMapper: (CandlePriceChartModel candle, _) => candle.closePrice?.toDouble() ?? 0,
              bearColor: AppColor.accentColor,
              bullColor: AppColor.primaryColor,
              spacing: 0.0,
              width: 0.8,
              pointColorMapper: (CandlePriceChartModel candle, _) {
                final low = candle.lowPrice ?? 0;
                final high = candle.highPrice ?? 0;
                final open = candle.openPrice ?? 0;
                final close = candle.closePrice ?? 0;

                if (low == high && high == open && open == close) {
                  return AppColor.iconViewColor;
                }
                return null;
              },
              borderWidth: 1,
              enableSolidCandles: true,
              animationDuration: 500,
              yAxisName: 'priceAxis',
              onPointTap: (ChartPointDetails details) {
                final index = details.pointIndex ?? -1;
                if (index >= 0 && index < data.length) {
                  controller.addTrendPoint(data[index]);
                }
              },
            ),
            if (controller.hasTrendLine)
              LineSeries<CandlePriceChartModel, DateTime>(
                dataSource: controller.trendPoints,
                xValueMapper: (candle, _) => _parseDateTime(candle.candleTime),
                yValueMapper: (candle, _) => candle.lowPrice?.toDouble() ?? 0,
                width: 2,
                color: const Color(0xFFF3C50C),
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  height: 6,
                  width: 6,
                  shape: DataMarkerType.circle,
                  color: Color(0xFFFFC107),
                ),
              ),
          ],
        ),
      );
    });
  }

  DateTime _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateTimeStr);
    } catch (e) {
      print('Error parsing date: $dateTimeStr - $e');
      return DateTime.now();
    }
  }

  /// Get maximum volume from candle data for axis scaling
  double _getMaxVolume(List<CandlePriceChartModel> data) {
    if (data.isEmpty) return 1;
    final maxVolume = data
        .map((c) => c.volume ?? 0)
        .reduce((a, b) => a > b ? a : b);
    return maxVolume > 0 ? maxVolume : 1;
  }

  Widget _buildChartStats(bool isMobile) {
    return Obx(() {
      if (controller.candleData.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.secondary100Color.withAlpha(60),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'بالاترین قیمت',
              controller.getHighestPrice().toString().seRagham(),
              AppColor.primaryColor,
            ),
            Container(
              width: 1,
              height: 30,
              color: const Color(0xFF475569),
            ),
            _buildStatItem(
              'پایین‌ترین قیمت',
              controller.getLowestPrice().toString().seRagham(),
              AppColor.accentColor,
            ),
            Container(
              width: 1,
              height: 30,
              color: const Color(0xFF475569),
            ),
            _buildStatItem(
              'حجم معاملات',
              controller.getTotalVolume().toStringAsFixed(2).seRagham(),
              const Color(0xFF3B82F6),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            fontSize: 10,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.bodyTextBold.copyWith(
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }

  // ============== ITEMS LIST ==============

  Widget _buildItemsListDesktop() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.secondaryColor,
            border: Border(
              bottom: BorderSide(color: const Color(0xFF334155), width: 1),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.list_alt, color: Color(0xFF3B82F6), size: 20),
              const SizedBox(width: 8),
              Text(
                'لیست محصولات',
                style: AppTextStyle.mediumTitleText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildItemsList()),
      ],
    );
  }

  Widget _buildItemsListMobile() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColor.secondary10Color,
        border: Border(
          top: BorderSide(color: const Color(0xFF334155), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'محصولات',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 11,
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: _buildItemsListHorizontal(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Obx(() {
      if (controller.itemsState.value == ChartPageState.loading) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        );
      }

      if (controller.itemsState.value == ChartPageState.error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColor.errorColor, size: 40),
              const SizedBox(height: 8),
              Text(
                'خطا در دریافت لیست',
                style: AppTextStyle.bodyText.copyWith(color: const Color(0xFF94A3B8)),
              ),
            ],
          ),
        );
      }

      if (controller.itemsList.isEmpty) {
        return Center(
          child: Text(
            'محصولی یافت نشد',
            style: AppTextStyle.bodyText.copyWith(color: const Color(0xFF94A3B8)),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.itemsList.length,
        itemBuilder: (context, index) {
          final item = controller.itemsList[index];
          return _buildItemTile(item);
        },
      );
    });
  }

  Widget _buildItemsListHorizontal() {
    return Obx(() {
      if (controller.itemsState.value == ChartPageState.loading) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        );
      }

      if (controller.itemsList.isEmpty) {
        return Center(
          child: Text(
            'محصولی یافت نشد',
            style: AppTextStyle.bodyText.copyWith(color: const Color(0xFF94A3B8)),
          ),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: controller.itemsList.length,
        itemBuilder: (context, index) {
          final item = controller.itemsList[index];
          return _buildItemChip(item);
        },
      );
    });
  }

  Widget _buildItemTile(ItemModel item) {
    return Obx(() {
      final isSelected = controller.selectedItem.value?.id == item.id;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6).withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.appBarColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.icon != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item.icon}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.inventory_2,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ),
            )
                : const Icon(Icons.inventory_2, color: Color(0xFF94A3B8), size: 20),
          ),
          title: Text(
            item.name ?? 'نامشخص',
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF1F5F9),
            ),
          ),
          subtitle: item.mesghalPrice != null
              ? Text(
            '${item.mesghalPrice!.toStringAsFixed(0).seRagham()} ریال',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 10,
              color: const Color(0xFF94A3B8),
            ),
          )
              : null,
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 20)
              : null,
          onTap: () => controller.selectItem(item),
        ),
      );
    });
  }

  Widget _buildItemChip(ItemModel item) {
    return Obx(() {
      final isSelected = controller.selectedItem.value?.id == item.id;

      return GestureDetector(
        onTap: () => controller.selectItem(item),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3B82F6) : AppColor.secondaryColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF475569),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null)
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item.icon}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.inventory_2,
                        color: Colors.white70,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              Text(
                item.name ?? 'نامشخص',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : const Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Custom DateFormat class for Persian (Jalali) date formatting in Syncfusion charts
class _PersianDateFormat extends DateFormat {
  _PersianDateFormat() : super('', 'en_US');

  @override
  String format(DateTime date) {
    try {
      //final jalali = Jalali.fromDateTime(date);
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      // Format: YYYY/MM/DD HH:MM
      return '$hour:$minute';
      //return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')} $hour:$minute';
    } catch (e) {
      print('Error in _PersianDateFormat: $e');
      // Fallback to default format
      return DateFormat('yyyy/MM/dd HH:mm').format(date);
    }
  }
}
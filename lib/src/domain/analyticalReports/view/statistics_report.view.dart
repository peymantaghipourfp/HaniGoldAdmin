import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/order/model/user_admin_group.model.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:hanigold_admin/src/widget/background_image_total.widget.dart';
import 'package:hanigold_admin/src/widget/empty.dart';
import 'package:hanigold_admin/src/widget/err_page.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../controller/statistics_report.controller.dart';
import '../model/statistics_report.model.dart';

class StatisticsReportView extends StatefulWidget {
  const StatisticsReportView({super.key});

  @override
  State<StatisticsReportView> createState() => _StatisticsReportViewState();
}

class _StatisticsReportViewState extends State<StatisticsReportView> {
  final StatisticsReportController controller = Get.find<StatisticsReportController>();

  @override
  void initState() {
    _handleSearch();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<StatisticsReportController>();
    super.dispose();
  }

  bool _determineIsMobile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 0 && screenWidth <= 500;
  }

  bool _determineIsTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 501 && screenWidth <= 1200;
  }

  bool _determineIsDesktop(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1201 && screenWidth <= 1920;
  }

  Future<void> _selectDate(TextEditingController textController, bool isStart) async {
    try {
      final Jalali? picked = await showPersianDatePicker(
        context: context,
        initialDate: Jalali.now(),
        firstDate: Jalali(1400, 1, 1),
        lastDate: Jalali(1450, 12, 29),
        initialEntryMode: PersianDatePickerEntryMode.calendar,
        initialDatePickerMode: PersianDatePickerMode.day,
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
        final String formattedDate = "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
        textController.text = formattedDate;
        setState(() {});
      }
    } catch (e) {
      print('Error selecting date: $e');
    }
  }

  void _handleSearch() {
    if (controller.dateStartController.text.isEmpty || controller.dateEndController.text.isEmpty) {
      Get.snackbar(
        'خطا',
        'لطفاً تاریخ شروع و پایان را انتخاب کنید',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    String gregorianStartDate = controller.convertJalaliToGregorianForApi(controller.dateStartController.text);
    String gregorianEndDate = controller.convertJalaliToGregorianForApi(controller.dateEndController.text);

    controller.getStatisticsReportList(gregorianStartDate, gregorianEndDate);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _determineIsMobile(context);
    final isTablet = _determineIsTablet(context);
    final isDesktop = _determineIsDesktop(context);

    return Scaffold(
      appBar: CustomAppbar1(
        title: 'گزارش حجمی سفارشات',
        onBackTap: () => Get.offNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const BackgroundImageTotal(),
          _buildContent(isDesktop, isTablet, isMobile),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDesktop, bool isTablet, bool isMobile) {
    return Obx(() {
      if (controller.state.value == PageState.loading) {
        return _buildLoadingState();
      } else if (controller.state.value == PageState.err) {
        return ErrPage(
          title: 'خطا در دریافت اطلاعات',
          des: 'لطفاً مجدداً تلاش کنید',
          callback: () => _handleSearch(),
        );
      } else if (controller.state.value == PageState.empty) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Column(
              children: [
                _buildControlPanel(isDesktop, isMobile),
                const SizedBox(height: 24),
                _buildHeaderStats(isDesktop, isMobile),
                const SizedBox(height: 24),
                const EmptyPage(
                  title: 'داده‌ای یافت نشد',
                  des: 'برای بازه زمانی انتخاب شده اطلاعاتی موجود نیست',
                ),
              ],
            ),
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildControlPanel(isDesktop, isMobile),
                const SizedBox(height: 24),
                _buildHeaderStats(isDesktop, isMobile),
                const SizedBox(height: 24),
                _buildStatisticsCards(isDesktop, isTablet, isMobile),
              ],
            ),
          ),
        );
      }
    });
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

  Widget _buildControlPanel(bool isDesktop, bool isMobile) {
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
          Text(
            'تنظیمات جستجو',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF1F5F9),
            ),
          ),
          const SizedBox(height: 10),
          isDesktop
              ? Row(
            children: [
              Expanded(child: _buildDateField('تاریخ شروع', controller.dateStartController, true)),
              const SizedBox(width: 16),
              Expanded(child: _buildDateField('تاریخ پایان', controller.dateEndController, false)),
              const SizedBox(width: 16),
              _buildSearchButton(),
            ],
          )
              : Column(
            children: [
              _buildDateField('تاریخ شروع', controller.dateStartController, true),
              const SizedBox(height: 16),
              _buildDateField('تاریخ پایان', controller.dateEndController, false),
              const SizedBox(height: 5),
              _buildSearchButton(),
            ],
          ),
        ],
      ),
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
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF94A3B8),
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
                const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Color(0xFF94A3B8),
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
        onPressed: _handleSearch,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 18),
            SizedBox(width: 8),
            Text('جستجو'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(bool isDesktop, bool isTablet, bool isMobile) {
    // Sort by itemId descending (since there's no date field in StatisticsReportModel)
    final sortedList = List<StatisticsReportModel>.from(controller.statisticsReportList)
      ..sort((a, b) => (a.itemId ?? 0).compareTo(b.itemId ?? 0));

    if (isMobile) {
      return Column(
        children: sortedList.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildStatisticsCard(item, isDesktop, isTablet, isMobile),
          );
        }).toList(),
      );
    } else {

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 3 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: isDesktop ? 615 : 650, // Fixed height for precise control
        ),
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          return _buildStatisticsCard(sortedList[index], isDesktop, isTablet, isMobile);
        },
      );
    }
  }

  Widget _buildStatisticsCard(StatisticsReportModel item, bool isDesktop, bool isTablet, bool isMobile) {
    // Find User and Admin groups
    UserAdminGroupModel? userGroup;
    if (item.userGroup != null && item.userGroup!.isNotEmpty) {
      final userGroups = item.userGroup!.where((g) => g.byAdmin == 0);
      if (userGroups.isNotEmpty) {
        userGroup = userGroups.first;
      }
    }

    UserAdminGroupModel? adminGroup;
    if (item.adminGroup != null && item.adminGroup!.isNotEmpty) {
      final adminGroups = item.adminGroup!.where((g) => g.byAdmin == 1);
      if (adminGroups.isNotEmpty) {
        adminGroup = adminGroups.first;
      }
    }

    return Card(
      margin: EdgeInsets.all(isMobile ? 8 : 0),
      color: AppColor.secondaryColor,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main card content - natural size, no extra height
            isMobile ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with item info
                _buildCardHeader(item, isMobile),
                const SizedBox(height: 5),
                const Divider(color: Color(0xFF475569), thickness: 1),
                const SizedBox(height: 5),
                // Summary stats
                _buildSummaryStats(item, isDesktop, isMobile),
              ],
            ):
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with item info
                  _buildCardHeader(item, isMobile),
                  const SizedBox(height: 5),
                  const Divider(color: Color(0xFF475569), thickness: 1),
                  const SizedBox(height: 5),
                  // Summary stats
                  _buildSummaryStats(item, isDesktop, isMobile),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Sub-cards - natural height, no constraints
            (isDesktop || isTablet)
                ? IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: _buildUserAdminSubCard(userGroup, 'کاربر', isMobile)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildUserAdminSubCard(adminGroup, 'ادمین', isMobile)),
                ],
              ),
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUserAdminSubCard(userGroup, 'کاربر', isMobile),
                const SizedBox(height: 8),
                _buildUserAdminSubCard(adminGroup, 'ادمین', isMobile),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(StatisticsReportModel item, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item.itemIcon}',
              width: 30,
              height: 30,),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.itemName ?? 'نامشخص',
                style: AppTextStyle.mediumTitleText.copyWith(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.secondary3Color,
                ),
              ),
            ),
          ],
        ),
        /*if (item.itemUnitName != null) ...[
          const SizedBox(height: 3),
          Text(
            'واحد: ${item.itemUnitName}',
            style: AppTextStyle.bodyText.copyWith(
              fontSize: isMobile ? 9 : 10,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],*/
      ],
    );
  }

  Widget _buildSummaryStats(StatisticsReportModel item, bool isDesktop, bool isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem('تعداد فعالیت مشتریان', '${item.itemAccountCount ?? 0}', isMobile,
                  backGroundColor: AppColor.appBarColor.withAlpha(150)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildStatItem('تعداد سفارشات تایید شده', '${item.totalOrderCount ?? 0}', isMobile,
                  backGroundColor: AppColor.secondary2Color.withAlpha(100)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildStatItem('تعداد سفارشات رد شده', '${item.totalRejectedOrderCount ?? 0}', isMobile,
                  backGroundColor: AppColor.errorColor.withAlpha(150)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildStatItem('تعداد سفارشات خرید', '${item.totalBuyCount ?? 0}', isMobile,
                  backGroundColor: AppColor.primaryColor.withAlpha(150)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildStatItem('تعداد سفارشات فروش', '${item.totalSellCount ?? 0}', isMobile,
                  backGroundColor: AppColor.accentColor.withAlpha(150)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildStatItem('حجم کل خرید', _formatQuantity(item.totalBuyQuantity), isMobile,
                  backGroundColor: AppColor.primaryColor.withAlpha(50)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildStatItem('حجم کل فروش', _formatQuantity(item.totalSellQuantity), isMobile,
                  backGroundColor: AppColor.accentColor.withAlpha(50)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildStatItem('میانگین خرید به ازای سفارش', _formatQuantity(item.avgBuyPerOrder), isMobile,
                  backGroundColor: AppColor.secondary200Color.withAlpha(150),
                  labelColor: AppColor.textPrimaryColor),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildStatItem('میانگین فروش به ازای سفارش', _formatQuantity(item.avgSellPerOrder), isMobile,
                  backGroundColor: AppColor.secondary200Color.withAlpha(150),
                  labelColor: AppColor.textAccentColor.withGreen(150)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildStatItem('میانگین خرید به ازای مشتری', _formatQuantity(item.avgBuyPerAccount), isMobile,
                  backGroundColor: AppColor.secondary200Color.withAlpha(150),
                  labelColor: AppColor.textPrimaryColor),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildStatItem('میانگین فروش به ازای مشتری', _formatQuantity(item.avgSellPerAccount), isMobile,
                  backGroundColor: AppColor.secondary200Color.withAlpha(150),
                  labelColor: AppColor.textAccentColor.withGreen(150)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, bool isMobile,{Color? backGroundColor, Color? labelColor, Color? valueColor}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 6 : 7),
      decoration: BoxDecoration(
        color: backGroundColor ?? AppColor.backGroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF475569), width: 0.5),
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.labelText.copyWith(
              fontSize: isMobile ? 9 : 9,
              color: labelColor ?? AppColor.textColorSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3,),
          Text(
            value.seRagham(),
            style: AppTextStyle.bodyText.copyWith(
              fontSize: isMobile ? 11 : 10,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserAdminSubCard(UserAdminGroupModel? group, String title, bool isMobile) {
    if (group == null) {
      return Container(
        padding: EdgeInsets.all(isMobile ? 8 : 10),
        decoration: BoxDecoration(
          color: AppColor.backGroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF475569), width: 1),
        ),
        child: Center(
          child: Text(
            'اطلاعاتی برای $title موجود نیست',
            style: AppTextStyle.bodyText.copyWith(
              fontSize: isMobile ? 9 : 10,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 10),
      decoration: BoxDecoration(
        color: AppColor.backGroundColor1.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: title == 'کاربر' ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  title,
                  style: AppTextStyle.bodyTextBold.copyWith(
                    fontSize: isMobile ? 10 : 11,
                    color: title == 'کاربر' ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              /*if (group.byAdminName != null)
                Flexible(
                  flex: 1,
                  child: Text(
                    group.byAdminName!,
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: isMobile ? 8 : 9,
                      color: const Color(0xFF94A3B8),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                  ),
                ),*/
            ],
          ),
          const SizedBox(height: 6),
          _buildSubCardRow('تعداد فعالیت مشتریان', '${group.accountCountDistinct ?? 0}', isMobile),
          _buildSubCardRow('تعداد سفارشات تایید شده', '${group.orderCount ?? 0}', isMobile,),
          _buildSubCardRow('تعداد سفارشات رد شده', '${group.rejectedOrderCount ?? 0}', isMobile,valueColor: AppColor.errorColor.withGreen(100),labelColor: AppColor.textErrorColor),
          _buildSubCardRow('تعداد خرید', '${group.buyCount ?? 0}', isMobile,valueColor: AppColor.primaryColor,labelColor: AppColor.textPrimaryColor),
          _buildSubCardRow('تعداد فروش', '${group.sellCount ?? 0}', isMobile,valueColor: AppColor.accentColor,labelColor: AppColor.textAccentColor.withGreen(150)),
          const SizedBox(height: 3),
          const Divider(color: Color(0xFF475569), thickness: 0.5),
          const SizedBox(height: 3),
          _buildSubCardRow('حجم کل خرید', _formatQuantity(group.totalBuyQuantity), isMobile,labelColor: AppColor.textPrimaryColor,valueColor: AppColor.textPrimaryColor),
          _buildSubCardRow('حجم کل فروش', _formatQuantity(group.totalSellQuantity), isMobile,labelColor: AppColor.textAccentColor.withGreen(150),valueColor: AppColor.textAccentColor.withGreen(150)),
          _buildSubCardRow('کمترین حجم خرید', _formatQuantity(group.minBuyQuantity), isMobile,labelColor: AppColor.textPrimaryColor,valueColor: AppColor.textPrimaryColor),
          _buildSubCardRow('بیشترین حجم خرید', _formatQuantity(group.maxBuyQuantity), isMobile,labelColor: AppColor.textPrimaryColor,valueColor: AppColor.textPrimaryColor),
          _buildSubCardRow('کمترین حجم فروش', _formatQuantity(group.minSellQuantity), isMobile,labelColor: AppColor.textAccentColor.withGreen(150),valueColor: AppColor.textAccentColor.withGreen(150)),
          _buildSubCardRow('بیشترین حجم فروش', _formatQuantity(group.maxSellQuantity), isMobile,labelColor: AppColor.textAccentColor.withGreen(150),valueColor: AppColor.textAccentColor.withGreen(150)),
        ],
      ),
    );
  }

  Widget _buildSubCardRow(String label, String value, bool isMobile,{Color? labelColor, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              label,
              style: AppTextStyle.labelText.copyWith(
                fontSize: 11,
                color: labelColor ?? AppColor.textColorSecondary.withAlpha(200),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            flex: 0,
            child: Text(
              value.seRagham(),
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatQuantity(double? value) {
    if (value == null) return '0';
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(3);
  }

  Widget _buildHeaderStats(bool isDesktop, bool isMobile) {
    return Obx(() {
      final header = controller.headerData.value;
      if (header == null) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
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
            /*Text(
              'خلاصه آمار کلی',
              style: AppTextStyle.labelText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF1F5F9),
              ),
            ),
            const SizedBox(height: 20),*/
            isMobile
                ? Column(
              children: [
                _buildHeaderSection('مشتریان', [
                  _buildHeaderStatItem('تعداد فعالیت کننده', '${header.totalActiveAccounts ?? 0}', color:  AppColor.primaryColor),
                  _buildHeaderStatItem('تعداد خریدکننده', '${header.buyAccountCount ?? 0}', color:  Color(0xFF10B981),labelColor: AppColor.textPrimaryColor),
                  _buildHeaderStatItem('تعداد فروشنده', '${header.sellAccountCount ?? 0}', color:  AppColor.accentColor,labelColor: AppColor.textAccentColor.withGreen(150)),
                ], isMobile),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 16),
                _buildHeaderSection('سفارشات', [
                  _buildHeaderStatItem('تایید شده', '${header.approvedOrders ?? 0}', color:  Color(0xFF10B981)),
                  _buildHeaderStatItem('رد شده', '${header.rejectedOrders ?? 0}', color:  AppColor.errorColor,labelColor: AppColor.textErrorColor),
                ], isMobile),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 16),
                _buildHeaderSection('سفارشات ثبت شده', [
                  _buildHeaderStatItem('توسط ادمین', '${header.adminOrders ?? 0}', color:  Color(0xFF3B82F6)),
                  _buildHeaderStatItem('توسط کاربر', '${header.userOrders ?? 0}', color:  Color(0xFF8B5CF6)),
                ], isMobile),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildHeaderSection('مشتریان', [
                    _buildHeaderStatItem('تعداد فعالیت کننده', '${header.totalActiveAccounts ?? 0}', color:  AppColor.primaryColor),
                    _buildHeaderStatItem('تعداد خریدکننده', '${header.buyAccountCount ?? 0}', color:  Color(0xFF10B981),labelColor: AppColor.textPrimaryColor),
                    _buildHeaderStatItem('تعداد فروشنده', '${header.sellAccountCount ?? 0}', color:  AppColor.accentColor,labelColor: AppColor.textAccentColor.withGreen(150)),
                  ], isMobile),
                ),
                _buildVerticalDivider(),
                Expanded(
                  flex: 2,
                  child: _buildHeaderSection('سفارشات', [
                    _buildHeaderStatItem('تایید شده', '${header.approvedOrders ?? 0}', color:  Color(0xFF10B981)),
                    _buildHeaderStatItem('رد شده', '${header.rejectedOrders ?? 0}', color:  AppColor.errorColor,labelColor: AppColor.textErrorColor),
                  ], isMobile),
                ),
                _buildVerticalDivider(),
                Expanded(
                  flex: 2,
                  child: _buildHeaderSection('سفارشات ثبت شده', [
                    _buildHeaderStatItem('توسط ادمین', '${header.adminOrders ?? 0}', color:  Color(0xFF3B82F6)),
                    _buildHeaderStatItem('توسط کاربر', '${header.userOrders ?? 0}', color:  Color(0xFF8B5CF6)),
                  ], isMobile),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 70,
      color: AppColor.dividerColor.withAlpha(120),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildHeaderSection(String title, List<Widget> children, bool isMobile) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyle.labelText.copyWith(
            color: const Color(0xFF94A3B8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children.map((widget) => isMobile ? Expanded(child: widget) : widget).toList(),
        ),
      ],
    );
  }

  Widget _buildHeaderStatItem(String label, String value,{Color? labelColor, Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.seRagham(),
          style: AppTextStyle.mediumTitleText.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: 11,
            color: labelColor ?? Color(0xFFCBD5E1),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

}
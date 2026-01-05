import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../controller/invoice_preview.controller.dart';
import '../model/transaction_info_item.model.dart';

class InvoicePreviewView extends StatefulWidget {
  const InvoicePreviewView({super.key});

  @override
  State<InvoicePreviewView> createState() => _InvoicePreviewViewState();
}

class _InvoicePreviewViewState extends State<InvoicePreviewView> {
  final InvoicePreviewController controller = Get.find<InvoicePreviewController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'پیش‌نمایش فاکتور جدید',
        onBackTap: () => Get.back(),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.backGroundColor.withOpacity(0.1),
                  AppColor.backGroundColor.withOpacity(0.05),
                ],
              ),
            ),
          ),
          SafeArea(
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                // Header section with buttons
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColor.backGroundColor.withOpacity(0.3),
                  ),
                  child: Column(
                    children: [
                      // Action buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Settings button
                          ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                              ),
                              elevation: WidgetStatePropertyAll(5),
                              backgroundColor: WidgetStatePropertyAll(AppColor.secondary3Color),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: () => _showSettingsDialog(context, isDesktop),
                            child: Text(
                              'تنظیمات',
                              style: AppTextStyle.labelText,
                            ),
                          ),

                          // Print and Save button
                          ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                              ),
                              elevation: WidgetStatePropertyAll(5),
                              backgroundColor: WidgetStatePropertyAll(AppColor.secondary3Color),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.snackbar(
                                'اطلاعات',
                                'قابلیت چاپ و ذخیره در حال توسعه است',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: Text(
                              'چاپ کردن و ذخیره',
                              style: AppTextStyle.labelText,
                            ),
                          ),

                          // Show User Balance button
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                              ),
                              elevation: WidgetStatePropertyAll(5),
                              backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.snackbar(
                                'اطلاعات',
                                'نمایش مانده کاربر در حال توسعه است',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            icon: const Icon(Icons.check, color: Colors.white, size: 16),
                            label: Text(
                              'نمایش مانده کاربر',
                              style: AppTextStyle.labelText.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Date and document info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تاریخ ${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: isDesktop ? 14 : 12,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'سند: ',
                                style: AppTextStyle.labelText.copyWith(
                                  fontSize: isDesktop ? 14 : 12,
                                ),
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // User info
                      Row(
                        children: [
                          Text(
                            'کاربر کد ${controller.id.value}',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: isDesktop ? 14 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Transaction table
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColor.appBarColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Table
                            DataTable(
                              columns: _buildDataColumns(),
                              rows: _buildDataRows(),
                              border: TableBorder.symmetric(
                                inside: BorderSide(color: AppColor.textColor, width: 0.3),
                                outside: BorderSide(color: AppColor.textColor, width: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              dividerThickness: 0.3,
                              dataRowMaxHeight: 120,
                              headingRowHeight: 70,
                              columnSpacing: 30,
                              horizontalMargin: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Final balance section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColor.backGroundColor.withOpacity(0.3),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'مانده نهایی',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: isDesktop ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'بد ۱۴,۲۵۷ وجه نقد',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: isDesktop ? 14 : 12,
                              color: AppColor.accentColor,
                            ),
                          ),
                          Text(
                            'بده طلای آبشده',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: isDesktop ? 14 : 12,
                              color: AppColor.accentColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'محل امضا',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'توسط:',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Pagination
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: controller.paginated.value != null
                ? Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColor.appBarColor.withOpacity(0.5),
              alignment: Alignment.bottomCenter,
              child: PagerWidget(
                countPage: controller.paginated.value?.totalCount ?? 0,
                callBack: (int index) {
                  controller.isChangePage(index);
                },
              ),
            )
                : const SizedBox(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    ));
  }

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 50),
          child: Text(
            '',
            style: AppTextStyle.labelText.copyWith(fontSize: 11),
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            'شرح',
            style: AppTextStyle.labelText.copyWith(fontSize: 11),
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            'مقدار',
            style: AppTextStyle.labelText.copyWith(fontSize: 11),
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(
            'عیار',
            style: AppTextStyle.labelText.copyWith(fontSize: 11),
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            'وزن ۷۵۰',
            style: AppTextStyle.labelText.copyWith(fontSize: 11),
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            'فی',
            style: AppTextStyle.labelText.copyWith(fontSize: 11),
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            'مبلغ',
            style: AppTextStyle.labelText.copyWith(fontSize: 11),
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> _buildDataRows() {
    return controller.transactionInfoList.map((trans) => DataRow(
      cells: [
        // Checkbox column
        DataCell(
          Center(
            child: Checkbox(
              value: controller.checkboxStates[trans.id ?? 0] ?? false,
              onChanged: (value) {
                controller.toggleCheckbox(trans.id ?? 0);
              },
            ),
          ),
        ),

        // Description column
        DataCell(
          Center(
            child: Text(
              _getTransactionDescription(trans),
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Amount column
        DataCell(
          Center(
            child: Text(
              _getAmountText(trans),
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 10,
                color: trans.amount! > 0 ? AppColor.primaryColor : AppColor.accentColor,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),

        // Purity column
        DataCell(
          Center(
            child: Text(
              trans.details?.isNotEmpty == true
                  ? '${trans.details!.first.carat ?? 0}'
                  : '-',
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
            ),
          ),
        ),

        // Weight 750 column
        DataCell(
          Center(
            child: Text(
              trans.details?.isNotEmpty == true
                  ? 'بد ${trans.details!.first.quantity ?? 0} گرم'
                  : '-',
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
            ),
          ),
        ),

        // Rate column
        DataCell(
          Center(
            child: Text(
              trans.mesghalPrice != null
                  ? '${trans.mesghalPrice.toString().seRagham()} ریال'
                  : '۰ ریال',
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),

        // Total amount column
        DataCell(
          Center(
            child: Text(
              trans.totalPrice != null
                  ? '${trans.totalPrice.toString().seRagham()} ریال'
                  : '۰ ریال',
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ],
    )).toList();
  }

  String _getTransactionDescription(TransactionInfoItemModel trans) {
    switch (trans.type) {
      case 'issue':
        return 'حواله ${trans.item?.name ?? ""}';
      case "receive":
        return 'دریافت ${trans.item?.name ?? ""}';
      case "payment":
        return 'پرداخت ${trans.item?.name ?? ""}';
      case "sell":
        return 'فروش ${trans.item?.name ?? ""}';
      case "buy":
        return 'خرید ${trans.item?.name ?? ""}';
      case "deposit":
        return 'واریز ${trans.item?.name ?? ""}';
      case "withdraw":
        return 'برداشت ${trans.item?.name ?? ""}';
      case "reciept":
        return 'دریافت حواله ${trans.item?.name ?? ""}';
      default:
        return 'نامشخص';
    }
  }

  String _getAmountText(TransactionInfoItemModel trans) {
    String prefix = trans.amount! > 0 ? 'بس' : 'بد';
    String amount = trans.amount!.abs().toString().seRagham();
    String unit = trans.item?.itemUnit?.id == 1
        ? ' عدد'
        : trans.item?.itemUnit?.id == 2
        ? ' گرم'
        : ' ریال';

    return '$prefix $amount$unit';
  }

  void _showSettingsDialog(BuildContext context, bool isDesktop) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.backGroundColor,
              ),
              width: isDesktop ? Get.width * 0.3 : Get.width * 0.9,
              height: isDesktop ? Get.height * 0.6 : Get.height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تنظیمات فیلتر',
                          style: AppTextStyle.labelText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: AppColor.textColor,
                    height: 0.2,
                  ),

                  const SizedBox(height: 20),

                  // Date filters
                  Expanded(
                    child: Column(
                      children: [
                        // Start date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'از تاریخ',
                              style: AppTextStyle.labelText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: AppColor.textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.dateStartController,
                              readOnly: true,
                              style: AppTextStyle.labelText,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: AppColor.textColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                              ),
                              onTap: () => controller.selectStartDate(context),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // End date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تا تاریخ',
                              style: AppTextStyle.labelText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: AppColor.textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.dateEndController,
                              readOnly: true,
                              style: AppTextStyle.labelText,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: AppColor.textColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                              ),
                              onTap: () => controller.selectEndDate(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            backgroundColor: WidgetStatePropertyAll(AppColor.accentColor),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          onPressed: () {
                            controller.clearFilter();
                            Get.back();
                          },
                          child: Text(
                            'حذف فیلتر',
                            style: AppTextStyle.labelText.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          onPressed: () {
                            controller.applyFilter();
                            Get.back();
                          },
                          child: Text(
                            'اعمال فیلتر',
                            style: AppTextStyle.labelText.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/transaction/controller/balance_dialog.controller.dart';
import 'package:hanigold_admin/src/domain/transaction/model/all_balances.model.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


class BalanceDialog extends StatelessWidget {
  final int entityId;
  final String entityType;
  final String entityName;
  final bool isDesktop;

  const BalanceDialog({
    Key? key,
    required this.entityId,
    required this.entityType,
    required this.entityName,
    required this.isDesktop,
  }) : super(key: key);

  // Constructor for OrderModel (backward compatibility)
  BalanceDialog.fromOrder({
    Key? key,
    required OrderModel order,
    required this.isDesktop,
  }) : entityId = order.account?.id ?? 0,
        entityType = 'account',
        entityName = order.account?.name ?? 'نامشخص',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get or create the controller
    final BalanceDialogController controller = Get.put(BalanceDialogController());

    // Load balances when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadBalances(
        id: entityId,
        type: entityType,
        name: entityName,
      );
    });

    return Dialog(
      backgroundColor: AppColor.backGroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: isDesktop ? Get.width * 0.4 : Get.width * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مانده',
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.clearData();
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColor.textColor, height: 1),
            const SizedBox(height: 20),

            // User Info
            /*Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.textFieldColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.textColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppColor.textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نام کاربر:',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                        Obx(() => Text(
                          controller.entityName.value,
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
            const SizedBox(height: 20),

            // Balance Content
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (controller.error.value.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.accentColor),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColor.accentColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'خطا در دریافت اطلاعات',
                        style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.error.value,
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 12,
                          color: AppColor.accentColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => controller.refreshBalances(),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(AppColor.accentColor),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        child: Text(
                          'تلاش مجدد',
                          style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Coin Balance (مانده سکه)
                        _buildBalanceSection(
                          title: 'مانده سکه',
                          icon: Icons.monetization_on,
                          balances: controller.coinBalances,
                          color: AppColor.primaryColor,
                        ),
                        const SizedBox(height: 16),

                        // Rial Balance (مانده ریالی)
                        _buildBalanceSection(
                          title: 'مانده ریالی',
                          icon: Icons.account_balance_wallet,
                          balances: controller.rialBalances,
                          color: AppColor.secondary2Color,
                        ),
                        const SizedBox(height: 16),

                        // Gold Balance (مانده طلایی)
                        _buildBalanceSection(
                          title: 'مانده طلایی',
                          icon: Icons.diamond,
                          balances: controller.goldBalances,
                          color: AppColor.secondary3Color,
                        ),
                        const SizedBox(height: 16),

                        // Currency Balance (مانده ارز)
                        _buildBalanceSection(
                          title: 'مانده ارز',
                          icon: Icons.currency_exchange,
                          balances: controller.currencyBalances,
                          color: AppColor.accentColor,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),

            const SizedBox(height: 20),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.clearData();
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: Text(
                    'بستن',
                    style: AppTextStyle.bodyText.copyWith(
                      color: AppColor.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection({
    required String title,
    required IconData icon,
    required List<AllBalancesModel> balances,
    required Color color,
  }) {
    // Calculate total for گرم units if this is the gold balance section
    double totalGram = 0.0;
    if (title == 'مانده طلایی') {
      totalGram = balances
          .where((balance) => balance.unitName == 'گرم')
          .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0));
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              // Show total for گرم units next to "مانده طلایی"
              if (title == 'مانده طلایی') ...[
                const SizedBox(width: 8),
                Text(
                  '(${totalGram.toStringAsFixed(3)} گرم)',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: totalGram > 0 ? AppColor.primaryColor : AppColor.accentColor,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (balances.isEmpty)
            Text(
              'هیچ مانده‌ای یافت نشد',
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 12,
                color: AppColor.textColor.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...balances.map((balance) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    balance.itemName ?? 'نامشخص',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(textDirection: TextDirection.ltr,
                        balance.unitName == 'ریال' || balance.unitName == 'دلار' || balance.unitName == 'یورو' || balance.unitName == 'پوند'
                            ? (balance.balance?.toInt().toString().seRagham(separator: ',') ?? '0')
                            : (balance.balance?.toString() ?? '0'),
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (balance.balance ?? 0) > 0 ? AppColor.primaryColor : AppColor.accentColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        balance.unitName ?? '',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 11,
                          color: AppColor.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )).toList(),
        ],
      ),
    );
  }
}
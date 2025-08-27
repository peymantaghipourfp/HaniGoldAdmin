import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:universal_html/html.dart' as html;

import '../config/const/app_color.dart';
import '../config/const/app_text_style.dart';
import 'socket_status_indicator.widget.dart';

void _openInNewTab(String route) {
  if (kIsWeb) {
    try {
      final currentUrl = html.window.location.href;
      final baseUrl = currentUrl.split('/#/')[0];
      final newUrl = '$baseUrl/#$route';
      html.window.open(newUrl, '_blank');

      // Show a brief snackbar to confirm the action
      Get.snackbar(
        'باز شد',
        'صفحه در تب جدید باز شد - اتصال سوکت در حال برقراری است',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryColor.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    } catch (e) {
      // Fallback to normal navigation if there's an error
      Get.offNamed(route);
    }
  }
}

class SideMenuFix extends StatelessWidget {
  const SideMenuFix({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColor.backGroundColor1,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(-2, 0), // Right-side shadow
          ),
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Obx(() =>
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Socket status indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SocketStatusIndicator(),
                  const SizedBox(width: 8),
                  Text(
                    'وضعیت اتصال',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      color: AppColor.textColor.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  // Test button for debugging
                  if (kDebugMode)
                    IconButton(
                      icon: const Icon(Icons.wifi_find, size: 16),
                      onPressed: () {
                        final socketService = Get.find<SocketService>();
                        socketService.testConnection();
                        Get.snackbar(
                          'تست اتصال',
                          'در حال تست اتصال سوکت...',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColor.primaryColor.withOpacity(0.9),
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      tooltip: 'تست اتصال سوکت',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuButton(
              title: 'سفارشات',
              icon: Icons.shopping_cart,
              menuKey: 'orders',
              subItems: [
                _buildSubMenuItem(
                  title: 'لیست سفارشات',
                  icon: Icons.list_alt,
                  route: '/orderList',
                ),
                _buildSubMenuItem(
                  title: 'ایجاد سفارش جدید',
                  icon: Icons.add_shopping_cart,
                  route: '/orderCreate',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'محصولات',
              icon: Icons.inventory,
              menuKey: 'products',
              subItems: [
                _buildSubMenuItem(
                  title: 'بروزرسانی قیمت',
                  icon: Icons.price_change,
                  route: '/productUpdatePrice',
                ),
                _buildSubMenuItem(
                  title: 'گردش موجودی محصولات',
                  icon: Icons.assessment,
                  route: '/productInventory',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'پنل ریالی',
              icon: Icons.account_balance_wallet,
              menuKey: 'rialPanel',
              subItems: [
                _buildSubMenuItem(
                  title: 'واریزی‌های در انتظار',
                  icon: Icons.pending_actions,
                  route: '/depositsPendingList',
                ),
                _buildSubMenuItem(
                  title: 'واریزی‌ها',
                  icon: Icons.payments,
                  route: '/depositsList',
                ),
                _buildSubMenuItem(
                  title: 'برداشت های در انتظار',
                  icon: Icons.pending_actions,
                  route: '/withdrawsPendingList',
                ),
                _buildSubMenuItem(
                  title: 'برداشت ها',
                  icon: Icons.money_off,
                  route: '/withdrawsList',
                ),
                _buildSubMenuItem(
                  title: 'ایجاد برداشت',
                  icon: Icons.add_card,
                  route: '/withdrawCreate',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'تراز معاملاتی',
              icon: Icons.balance,
              menuKey: 'balance',
              subItems: [
                _buildSubMenuItem(
                  title: 'تراز معاملاتی',
                  icon: Icons.scale,
                  route: '/tradingBalance',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'کاربران',
              icon: Icons.people_rounded,
              menuKey: 'users',
              subItems: [
                _buildSubMenuItem(
                  title: 'مانده کاربران',
                  icon: Icons.perm_contact_cal_outlined,
                  route: '/listUserInfoTransaction',
                ),
                _buildSubMenuItem(
                  title: 'لیست اکانت ها',
                  icon: Icons.list_alt,
                  route: '/userList',
                ),
                _buildSubMenuItem(
                  title: 'لیست کاربران',
                  icon: Icons.perm_identity_sharp,
                  route: '/personList',
                ),
                _buildSubMenuItem(
                    title: 'افزودن اکانت جدید',
                    icon: Icons.person_add_alt,
                    onTap: () {
                      Get.toNamed("/insertUser", parameters: {"id": 0.toString()});
                    }),
              ],
            ),
            _buildMenuButton(
              title: 'دریافت و پرداخت',
              icon: Icons.inventory,
              menuKey: 'inventory',
              subItems: [
                _buildSubMenuItem(
                  title: 'لیست دریافت و پرداخت',
                  icon: Icons.list_alt,
                  route: '/inventoryList',
                ),
                _buildSubMenuItem(
                  title: 'دریافت و پرداخت جدید',
                  icon: Icons.add_card,
                  route: '/inventoryCreate',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'حواله',
              icon: Icons.inventory,
              menuKey: 'remittance',
              subItems: [
                _buildSubMenuItem(
                  title: 'حواله های درخواستی',
                  icon: Icons.pending,
                  route: '/remittancesRequestList',
                ),
                _buildSubMenuItem(
                  title: 'حواله های در انتظار',
                  icon: Icons.pending_actions,
                  route: '/remittancesPendingList',
                ),
                _buildSubMenuItem(
                  title: 'لیست حواله',
                  icon: Icons.list_alt,
                  route: '/remittance',
                ),
                _buildSubMenuItem(
                  title: 'ایجاد حواله',
                  icon: Icons.add_card,
                  route: '/insertRemittance',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'آزمایشگاه',
              icon: Icons.biotech_sharp,
              menuKey: 'laboratory',
              subItems: [
                _buildSubMenuItem(
                  title: 'لیست آزمایشگاه',
                  icon: Icons.badge_outlined,
                  route: '/laboratory',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'تراکنش ها',
              icon: Icons.replay_circle_filled_outlined,
              menuKey: 'transaction',
              subItems: [
                _buildSubMenuItem(
                  title: 'لیست تراکنش های کاربران',
                  icon: Icons.refresh,
                  route: '/transactionList',
                ),
              ],
            ),
            _buildMenuButton(
              title: 'انتقال کیف پول',
              icon: Icons.transform,
              menuKey: 'transferWallet',
              subItems: [
                _buildSubMenuItem(
                  title: 'لیست انتقال ها',
                  icon: Icons.list_alt,
                  route: '/transferWalletList',
                ),
                _buildSubMenuItem(
                  title: 'انتقال پس فردایی به فردایی',
                  icon: Icons.add_card,
                  route: '/transferAfterTomorrowChange',
                ),
              ],
            ),

            _buildMenuButton(
              title: 'اعلان ها و اطلاعیه ها',
              icon: Icons.notifications,
              menuKey: 'notification',
              subItems: [
                _buildSubMenuItem(
                  title: 'لیست اعلان ها و اطلاعیه ها',
                  icon: Icons.list_alt,
                  route: '/notificationList',
                ),
                /*_buildSubMenuItem(
                  title: 'انتقال پس فردایی به فردایی',
                  icon: Icons.add_card,
                  route: '/transferAfterTomorrowChange',
                ),*/
              ],
            ),
            _buildMenuButton(
              title: 'تنظیمات',
              icon: Icons.settings,
              menuKey: 'tools',
              subItems: [
                _buildSubMenuItem(
                  title: 'ابزارها',
                  icon: Icons.build,
                  route: '/setting',
                ),
                _buildSubMenuItem(
                  title: 'خروج از سیستم',
                  icon: Icons.logout,
                  onTap: _showExitDialog,
                ),
                _buildSubMenuItem(
                  title: 'تغییر رمز عبور',
                  icon: Icons.change_circle_outlined,
                  onTap: _showChangePassword,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        )),
      ),
    );
  }
}

Widget _buildMenuButton({
  required String title,
  required IconData icon,
  required String menuKey,
  required List<Widget> subItems,
}) {
  final HomeController homeController = Get.find<HomeController>();
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: homeController.isSubMenuOpen(menuKey)
          ? AppColor.primaryColor.withOpacity(0.15)
          : Colors.transparent,
    ),
    child: Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColor.textColor, size: 22),
          title: Text(
            title,
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: homeController.isSubMenuOpen(menuKey) ? 0.5 : 0,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColor.textColor,
              size: 24,
            ),
          ),
          onTap: () => homeController.toggleSubMenu(menuKey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hoverColor: AppColor.primaryColor.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: homeController.isSubMenuOpen(menuKey) ? null : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: homeController.isSubMenuOpen(menuKey) ? 1.0 : 0.0,
            child: homeController.isSubMenuOpen(menuKey)
                ? Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 8.0, bottom: 8.0),
              child: Column(
                children: subItems,
              ),
            )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSubMenuItem({
  required String title,
  required IconData icon,
  String? route,
  VoidCallback? onTap,
}) {
  final showNewTabIcon = route != null && kIsWeb;
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent,
    ),
    child:
    Tooltip(
      message: showNewTabIcon ? '' : '',
      child: GestureDetector(
        onSecondaryTap: route != null ? () => _openInNewTab(route!) : null,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: AppColor.primaryColor),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    color: AppColor.textColor.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showNewTabIcon)
                const Icon(
                  Icons.open_in_new,
                  size: 14,
                  color: Colors.grey,
                ),
            ],
          ),
          onTap: onTap ?? () => Get.offNamed(route!),
          hoverColor: AppColor.primaryColor.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
    ),
    /*ListTile(
      leading: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColor.primaryColor),
      ),
      title: Text(
        title,
        style: AppTextStyle.bodyText.copyWith(
          fontSize: 12,
          color: AppColor.textColor.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap ?? () => Get.offNamed(route!),
      hoverColor: AppColor.primaryColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
      visualDensity: VisualDensity.compact,
    ),*/
  );
}

void _showExitDialog() {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColor.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('خروج از سیستم',
          style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor)),
      content:
      Text('آیا مطمئن هستید میخواهید خارج شوید؟', style: AppTextStyle.bodyText),
      actions: [
        TextButton(
          child: Text('انصراف', style: TextStyle(color: AppColor.primaryColor)),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('خروج', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            // Disconnect socket first
            final socketService = Get.find<SocketService>();
            await socketService.disconnect();
            // Clear stored token and user data
            final box = GetStorage();
            box.remove('Authorization');
            box.remove('id');
            box.remove('mobile');
            Get.offAllNamed("/login");
          },
        ),
      ],
    ),
  );
}

void _showChangePassword() {
  final HomeController controller = Get.find<HomeController>();
  final formKey = GlobalKey<FormState>();
  Get.dialog(
    Form(
      key: formKey,
      child: AlertDialog(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('تغییر رمز عبور',
            style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor)),
        content: SizedBox(
          height: Get.height * 0.5,
          child: Column(
            children: [
              const SizedBox(height: 24),
              TextFormField(
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 13,
                ),
                textDirection: TextDirection.rtl,
                controller: controller.passwordOldController,
                autofillHints: const [AutofillHints.password],
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  labelText: 'رمز عبور قبلی',
                  labelStyle: TextStyle(color: AppColor.textColor),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  prefixIconColor: AppColor.textColor,
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفا رمز عبور را وارد کنید';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // وارد کردن پسورد
              TextFormField(
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 13,
                ),
                textDirection: TextDirection.rtl,
                controller: controller.passwordController,
                autofillHints: const [AutofillHints.password],
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  labelText: 'رمز عبور جدید',
                  labelStyle: TextStyle(color: AppColor.textColor),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  prefixIconColor: AppColor.textColor,
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفا رمز عبور را وارد کنید';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 13,
                ),
                textDirection: TextDirection.rtl,
                controller: controller.retypePasswordController,
                autofillHints: const [AutofillHints.password],
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  labelText: 'تکرار رمز عبور جدید',
                  labelStyle: TextStyle(color: AppColor.textColor),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  prefixIconColor: AppColor.textColor,
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفا رمز عبور را وارد کنید';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child:
            Text('انصراف', style: TextStyle(color: AppColor.primaryColor)),
            onPressed: () {
              Get.back();
              controller.clearChangePasswordForm();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('تغییر رمز', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.changePassword();
                controller.clearChangePasswordForm();
                Get.back();
              }
            },
          ),
        ],
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:hanigold_admin/src/domain/home/widget/custom_text_button.widget.dart';
import 'package:hanigold_admin/src/domain/home/widget/desktop_layout.widget.dart';
import 'package:hanigold_admin/src/domain/home/widget/menu_card.widget.dart';
import 'package:hanigold_admin/src/domain/home/widget/dashboard_card.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:hanigold_admin/src/widget/background_image_total.widget.dart';
import '../widget/chat_dialog.widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Connect to socket when home view is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.connectToSocket();
    });
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    //final int mobileSelectedIndex = _selectedIndexForRoute(Get.currentRoute);
    return Scaffold(
      //backgroundColor: AppColor.backGroundColor,
      appBar:
      AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor),
          onPressed: () => Get.toNamed('/login'), // Default behavior if onBackTap is null
        ),*/
        //iconTheme: IconThemeData(color: AppColor.textColor),
        //leadingWidth: 60,
        title: Row(
          children: [
            //Image.asset('assets/images/logo.png', width: 120,height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("پنل مدیریتی",style: AppTextStyle.smallTitleText,),
            ),
            const Spacer(),
            userProfile(),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.secondaryColor, AppColor.backGroundColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body:
      Stack(
          children: [
            BackgroundImageTotal(),
            SafeArea(
              child:
              isMobile ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // سفارشات
                        MenuCard(
                          title: 'سفارشات',
                          icon: Icons.shopping_cart,
                          iconColor: Color(0xff3B82F6),
                          menuKey: 'orders',
                          isExpanded: controller.isSubMenuOpen('orders'),
                          onToggle: () => controller.toggleSubMenu('orders'),
                          subItems: [
                            MenuItem(
                              title: 'سفارشات',
                              onTap: () => Get.toNamed('/orderList'),
                              icon: Icons.list_alt,
                            ),
                            MenuItem(
                              title: 'ایجاد سفارش جدید',
                              onTap: () => Get.toNamed('/orderCreate'),
                              icon: Icons.add_shopping_cart,
                            ),
                            MenuItem(
                              title: 'گزارش لیست کارکرد',
                              onTap: () => Get.toNamed('/orderByAccountReportList'),
                              icon: Icons.assessment,
                            ),
                            MenuItem(
                              title: 'سفارش های ویرایش شده',
                              onTap: () => Get.toNamed('/orderEditedReportList'),
                              icon: Icons.list_alt,
                            ),
                          ],
                        ),
                        // گزارشات تحلیلی
                        MenuCard(
                          title: 'گزارشات تحلیلی',
                          icon: Icons.analytics,
                          iconColor: Color(0xff8B5CF6),
                          menuKey: 'reports',
                          isExpanded: controller.isSubMenuOpen('reports'),
                          onToggle: () => controller.toggleSubMenu('reports'),
                          subItems: [
                            MenuItem(
                              title: 'گزارش حجمی سفارشات',
                              onTap: () => Get.toNamed('/statisticsReportList'),
                              icon: Icons.assessment,
                            ),
                            MenuItem(
                              title: 'نمودار تغییر قیمت و حجم',
                              onTap: () => Get.toNamed('/candlePriceChart'),
                              icon: Icons.candlestick_chart,
                            ),
                          ],
                        ),
                        // محصولات
                        MenuCard(
                          title: 'محصولات',
                          icon: Icons.inventory,
                          iconColor: Color(0xff06B6D4),
                          menuKey: 'products',
                          isExpanded: controller.isSubMenuOpen('products'),
                          onToggle: () => controller.toggleSubMenu('products'),
                          subItems: [
                            MenuItem(
                              title: 'بروزرسانی قیمت محصولات',
                              onTap: () => Get.toNamed('/productUpdatePrice'),
                              icon: Icons.price_change,
                            ),
                            MenuItem(
                              title: 'گردش موجودی محصولات',
                              onTap: () => Get.toNamed('/productInventory'),
                              icon: Icons.trending_up,
                            ),
                            MenuItem(
                              title: 'موجودی محصولات',
                              onTap: () => Get.toNamed('/productInventoryQuantity'),
                              icon: Icons.inventory_2,
                            ),
                          ],
                        ),
                        // پنل ریالی
                        MenuCard(
                          title: 'پنل ریالی',
                          icon: Icons.account_balance_wallet,
                          iconColor: Color(0xff22C55E),
                          menuKey: 'rialPanel',
                          isExpanded: controller.isSubMenuOpen('rialPanel'),
                          onToggle: () => controller.toggleSubMenu('rialPanel'),
                          subItems: [
                            MenuItem(
                              title: 'واریز های در انتظار',
                              onTap: () => Get.toNamed('/depositsPendingList'),
                              icon: Icons.pending_actions,
                            ),
                            MenuItem(
                              title: 'واریزی‌ها',
                              onTap: () => Get.toNamed('/depositsList'),
                              icon: Icons.account_balance,
                            ),
                            MenuItem(
                              title: 'برداشت های در انتظار',
                              onTap: () => Get.toNamed('/withdrawsPendingList'),
                              icon: Icons.pending,
                            ),
                            MenuItem(
                              title: 'برداشت ها',
                              onTap: () => Get.toNamed('/withdrawsList'),
                              icon: Icons.money_off,
                            ),
                            MenuItem(
                              title: 'ایجاد برداشت',
                              onTap: () => Get.toNamed('/withdrawCreate'),
                              icon: Icons.add_card,
                            ),
                          ],
                        ),
                        // تراز معاملاتی
                        MenuCard(
                          title: 'تراز معاملاتی',
                          icon: Icons.balance,
                          iconColor: Color(0xffF59E0B),
                          menuKey: 'balance',
                          isExpanded: controller.isSubMenuOpen('balance'),
                          onToggle: () => controller.toggleSubMenu('balance'),
                          subItems: [
                            MenuItem(
                              title: 'تراز معاملاتی',
                              onTap: () => Get.toNamed('/tradingBalance'),
                              icon: Icons.balance,
                            ),
                          ],
                        ),
                        // کاربران
                        MenuCard(
                          title: 'کاربران',
                          icon: Icons.people,
                          iconColor: Color(0xff60A5FA),
                          menuKey: 'users',
                          isExpanded: controller.isSubMenuOpen('users'),
                          onToggle: () => controller.toggleSubMenu('users'),
                          subItems: [
                            MenuItem(
                              title: 'مانده کاربران',
                              onTap: () => Get.toNamed('/listUserInfoTransaction'),
                              icon: Icons.account_balance_wallet,
                            ),
                            MenuItem(
                              title: 'مانده کاربران طلایی',
                              onTap: () => Get.toNamed('/listUserInfoGoldTransaction'),
                              icon: Icons.star,
                            ),
                            MenuItem(
                              title: 'مانده کاربران (تاریخ)',
                              onTap: () => Get.toNamed('/userInfoDateTransaction'),
                              icon: Icons.history,
                            ),
                            MenuItem(
                              title: 'پیگیری مطالبات',
                              onTap: () => Get.toNamed('/transactionsWalletReceivables'),
                              icon: Icons.track_changes,
                            ),
                            MenuItem(
                              title: 'لیست اکانت ها',
                              onTap: () => Get.toNamed('/userList'),
                              icon: Icons.list_alt,
                            ),
                            MenuItem(
                              title: 'لیست کاربران',
                              onTap: () => Get.toNamed('/personList'),
                              icon: Icons.people_alt,
                            ),
                            MenuItem(
                              title: 'افزودن اکانت جدید',
                              onTap: () => Get.toNamed("/insertUser", parameters: {"id": 0.toString()}),
                              icon: Icons.person_add,
                            ),
                            MenuItem(
                              title: 'لیست سطوح کاربر',
                              onTap: () => Get.toNamed("/accountLevelList"),
                              icon: Icons.perm_identity_sharp,
                            ),
                          ],
                        ),
                        // اعتبارات
                        MenuCard(
                          title: 'اعتبارات',
                          icon: Icons.verified_user,
                          iconColor: Color(0xff10B981),
                          menuKey: 'credits',
                          isExpanded: controller.isSubMenuOpen('credits'),
                          onToggle: () => controller.toggleSubMenu('credits'),
                          subItems: [
                            MenuItem(
                              title: 'لیست اعتبارات کمکی',
                              onTap: () => Get.toNamed('/creditHelperList'),
                              icon: Icons.list_alt,
                            ),
                          ],
                        ),
                        // گروه بندی
                        MenuCard(
                          title: 'گروه بندی',
                          icon: Icons.groups_rounded,
                          iconColor: Color(0xff6366F1),
                          menuKey: 'group',
                          isExpanded: controller.isSubMenuOpen('group'),
                          onToggle: () => controller.toggleSubMenu('group'),
                          subItems: [
                            MenuItem(
                              title: 'لیست گروه های قیمت گذاری',
                              onTap: () => Get.toNamed('/accountSalesGroupList'),
                              icon: Icons.view_list_outlined,
                            ),
                            MenuItem(
                              title: 'ایجاد گروه قیمت گذاری',
                              onTap: () => Get.toNamed('/insertAccountSalesGroup'),
                              icon: Icons.group_add_rounded,
                            ),
                          ],
                        ),
                        // مدیریت دسترسی ها
                        /*MenuCard(
                          title: 'مدیریت دسترسی ها',
                          icon: Icons.security,
                          menuKey: 'roles',
                          isExpanded: controller.isSubMenuOpen('roles'),
                          onToggle: () => controller.toggleSubMenu('roles'),
                          subItems: [
                            MenuItem(
                              title: 'افزودن نقش جدید',
                              onTap: () => Get.toNamed('/roleCreation'),
                              icon: Icons.scale,
                            ),
                          ],
                        ),*/
                        // دریافت و پرداخت
                        MenuCard(
                          title: 'دریافت و پرداخت',
                          icon: Icons.swap_horiz,
                          iconColor: Color(0xff4ADE80),
                          menuKey: 'inventory',
                          isExpanded: controller.isSubMenuOpen('inventory'),
                          onToggle: () => controller.toggleSubMenu('inventory'),
                          subItems: [
                            MenuItem(
                              title: 'لیست دریافت و پرداخت',
                              onTap: () => Get.toNamed('/inventoryList'),
                              icon: Icons.list,
                            ),
                            MenuItem(
                              title: 'دریافت و پرداخت جدید',
                              onTap: () => Get.toNamed('/inventoryCreate'),
                              icon: Icons.add,
                            ),
                          ],
                        ),
                        // حواله
                        MenuCard(
                          title: 'حواله',
                          icon: Icons.send,
                          iconColor: Color(0xff14B8A6),
                          menuKey: 'remittance',
                          isExpanded: controller.isSubMenuOpen('remittance'),
                          onToggle: () => controller.toggleSubMenu('remittance'),
                          subItems: [
                            MenuItem(
                              title: 'حواله های درخواستی',
                              onTap: () => Get.toNamed('/remittancesRequestList'),
                              icon: Icons.pending_actions,
                            ),
                            MenuItem(
                              title: 'حواله های در انتظار',
                              onTap: () => Get.toNamed('/remittancesPendingList'),
                              icon: Icons.pending,
                            ),
                            MenuItem(
                              title: 'لیست حواله',
                              onTap: () => Get.toNamed('/remittance'),
                              icon: Icons.list_alt,
                            ),
                            MenuItem(
                              title: 'ایجاد حواله',
                              onTap: () => Get.toNamed('/insertRemittance'),
                              icon: Icons.add_circle,
                            ),
                          ],
                        ),
                        // آزمایشگاه
                        MenuCard(
                          title: 'آزمایشگاه',
                          icon: Icons.biotech_sharp,
                          iconColor: Color(0xffEC4899),
                          menuKey: 'laboratory',
                          isExpanded: controller.isSubMenuOpen('laboratory'),
                          onToggle: () => controller.toggleSubMenu('laboratory'),
                          subItems: [
                            MenuItem(
                              title: 'لیست آزمایشگاه',
                              onTap: () => Get.toNamed('/laboratory'),
                              icon: Icons.list,
                            ),
                          ],
                        ),
                        // تراکنش ها
                        MenuCard(
                          title: 'تراکنش ها',
                          icon: Icons.replay_circle_filled_outlined,
                          iconColor: Color(0xff2563EB),
                          menuKey: 'transaction',
                          isExpanded: controller.isSubMenuOpen('transaction'),
                          onToggle: () => controller.toggleSubMenu('transaction'),
                          subItems: [
                            MenuItem(
                              title: 'لیست تراکنش های کاربران',
                              onTap: () => Get.toNamed('/transactionList'),
                              icon: Icons.list_alt,
                            ),
                          ],
                        ),
                        // انتقال کیف پول
                        MenuCard(
                          title: 'انتقال کیف پول',
                          icon: Icons.transform,
                          iconColor: Color(0xff2DD4BF),
                          menuKey: 'transferWallet',
                          isExpanded: controller.isSubMenuOpen('transferWallet'),
                          onToggle: () => controller.toggleSubMenu('transferWallet'),
                          subItems: [
                            MenuItem(
                              title: 'لیست انتقال ها',
                              onTap: () => Get.toNamed('/transferWalletList'),
                              icon: Icons.list_alt,
                            ),
                            MenuItem(
                              title: 'انتقال پس فردایی به فردایی',
                              onTap: () => Get.toNamed('/transferAfterTomorrowChange'),
                              icon: Icons.swap_horiz,
                            ),
                          ],
                        ),
                        // اعلان ها و اطلاعیه ها
                        MenuCard(
                          title: 'اعلان ها و اطلاعیه ها',
                          icon: Icons.notifications,
                          iconColor: Color(0xffFB923C),
                          menuKey: 'notification',
                          isExpanded: controller.isSubMenuOpen('notification'),
                          onToggle: () => controller.toggleSubMenu('notification'),
                          subItems: [
                            MenuItem(
                              title: 'لیست اعلان ها و اطلاعیه ها',
                              onTap: () => Get.toNamed('/notificationList'),
                              icon: Icons.list_alt,
                            ),
                          ],
                        ),
                        // تنظیمات
                        MenuCard(
                          title: 'تنظیمات',
                          icon: Icons.settings,
                          iconColor: Color(0xff9CA3AF),
                          menuKey: 'tools',
                          isExpanded: controller.isSubMenuOpen('tools'),
                          onToggle: () => controller.toggleSubMenu('tools'),
                          subItems: [
                            MenuItem(
                              title: 'ابزارها',
                              onTap: () => Get.toNamed('/setting'),
                              icon: Icons.build,
                            ),
                            MenuItem(
                              title: 'خروج از برنامه',
                              onTap: () {
                                Get.defaultDialog(
                                  title: "خروج",
                                  titleStyle: TextStyle(color: AppColor.textColor),
                                  middleText: "آیا می خواهید از برنامه خارج شوید",
                                  middleTextStyle: TextStyle(color: AppColor.textColor),
                                  backgroundColor: AppColor.secondaryColor,
                                  textCancel: "خیر",
                                  onCancel: () => Get.back(),
                                  textConfirm: "بله",
                                  onConfirm: () {
                                    // Disconnect socket before logout
                                    controller.disconnectSocket();
                                    // Clear stored token and user data
                                    final box = GetStorage();
                                    box.remove('Authorization');
                                    box.remove('id');
                                    box.remove('mobile');
                                    Get.offAllNamed("/login");
                                  },
                                );
                              },
                              icon: Icons.exit_to_app,
                            ),
                            MenuItem(
                              title: 'تغییر رمز عبور',
                              onTap: () => _showChangePassword(),
                              icon: Icons.lock_reset,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ):
              buildDesktopLayout(),
            ),
          ]
      ),

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
      /* bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
        backgroundColor: AppColor.secondaryColor,
        surfaceTintColor: AppColor.secondaryColor,
        indicatorColor: AppColor.primaryColor.withOpacity(0.15),
        selectedIndex: mobileSelectedIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'سفارشات'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'دریافت/پرداخت'),
          NavigationDestination(icon: Icon(Icons.people_alt), label: 'کاربران'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'تنظیمات'),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Get.toNamed('/orderList');
              break;
            case 1:
              Get.toNamed('/inventoryList');
              break;
            case 2:
              Get.toNamed('/userList');
              break;
            case 3:
              Get.toNamed('/setting');
              break;
          }
        },
      ),*/
    );
  }
  /*int _selectedIndexForRoute(String? route) {
    switch (route) {
      case '/orderList':
      case '/orderCreate':
        return 0;
      case '/inventoryList':
      case '/inventoryCreate':
        return 1;
      case '/userList':
      case '/personList':
      case '/insertUser':
        return 2;
      case '/setting':
        return 3;
      default:
        return 0;
    }
  }*/
  Widget userProfile() {
    final box = GetStorage();
    return Row(
      children: [
        Icon(Icons.account_circle, color: AppColor.textColor, size: 30),
        const SizedBox(width: 10),
        Text(
          "${box.read('userName') ?? ''}",
          style: AppTextStyle.bodyText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 20),
      ],
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
}

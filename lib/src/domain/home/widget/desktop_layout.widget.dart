
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

Widget buildDesktopLayout() {

  return Row(
    children: [
      // Navigation Rail
      Container(
        width: 300,
        decoration: BoxDecoration(
          color: AppColor.secondaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 0),
            ),
          ],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                ],
              ),
              _buildMenuButton(
                title: 'پنل ریالی',
                icon: Icons.account_balance_wallet,
                menuKey: 'rialPanel',
                subItems: [
                  _buildSubMenuItem(
                    title: 'واریزی‌ها',
                    icon: Icons.payments,
                    route: '/depositsList',
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
                    //route: '/insertUser',
                    onTap: (){
                      Get.toNamed("/insertUser",parameters: {"id":0.toString()});
                    }
                  ),
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
                title: 'تنظیمات',
                icon: Icons.settings,
                menuKey: 'tools',
                subItems: [
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
            ],
          )),
        ),
      ),
      // Main Content Area
      Expanded(
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgHaniGold.png'),
              fit: BoxFit.fill,
              opacity: 0.1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'داشبورد مدیریتی',
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 28,
                  color: AppColor.primaryColor,
                ),
              ),
              SizedBox(height: 30),
              _buildStatsGrid(),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildMenuButton({
  required String title,
  required IconData icon,
  required String menuKey,
  required List<Widget> subItems,
}) {
  final HomeController homeController=Get.find<HomeController>();
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: homeController.isSubMenuOpen(menuKey)
          ? AppColor.primaryColor.withOpacity(0.2)
          : Colors.transparent,
    ),
    child: Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColor.textColor),
          title: Text(title, style: AppTextStyle.bodyText),
          trailing: Icon(
            homeController.isSubMenuOpen(menuKey)
                ? Icons.expand_less
                : Icons.expand_more,
            color: AppColor.textColor,
          ),
          onTap: () => homeController.toggleSubMenu(menuKey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hoverColor: AppColor.primaryColor.withOpacity(0.1),
        ),
        if (homeController.isSubMenuOpen(menuKey))
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              children: subItems,
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
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    margin: EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
    ),
    child: ListTile(
      leading: Icon(icon, size: 20, color: AppColor.circleColor),
      title: Text(
        title,
        style: AppTextStyle.bodyText.copyWith(fontSize: 14),
      ),
      onTap: onTap ?? () => Get.toNamed(route!),
      hoverColor: AppColor.primaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    ),
  );
}

Widget _buildStatsGrid() {
  return Expanded(
    child: GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('سفارشات امروز', '۱۲۳', Icons.shopping_basket),
        _buildStatCard('تراز', '۵۰۰٬۰۰۰ تومان', Icons.account_balance),
        _buildStatCard('کاربران فعال', '1', Icons.people_alt),
      ],
    ),
  );
}

Widget _buildStatCard(String title, String value, IconData icon) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: AppColor.secondaryColor,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 25, color: AppColor.primaryColor),
          Spacer(),
          Text(
            value,
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 18,
              color: AppColor.textColor,
            ),
          ),
          Text(
            title,
            style: AppTextStyle.bodyText.copyWith(
              color: AppColor.textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showExitDialog() {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColor.secondaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      title: Text('خروج از سیستم',
          style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor)),
      content: Text('آیا مطمئن هستید میخواهید خارج شوید؟',
          style: AppTextStyle.bodyText),
      actions: [
        TextButton(
          child: Text('انصراف',
              style: TextStyle(color: AppColor.primaryColor)),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text('خروج',
              style: TextStyle(color: Colors.white)),
          onPressed: () => Get.offAllNamed("/login"),
        ),
      ],
    ),
  );
}

var controller=Get.find<HomeController>();
void _showChangePassword() {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColor.secondaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
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
              autofillHints: [AutofillHints.password],
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                labelText: 'رمز عبور قبلی',
                labelStyle: TextStyle(color: AppColor.textColor),
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                prefixIconColor: AppColor.textColor,

                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
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
              autofillHints: [AutofillHints.password],
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                labelText: 'رمز عبور جدید',
                labelStyle: TextStyle(color: AppColor.textColor),
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                prefixIconColor: AppColor.textColor,

                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
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
              autofillHints: [AutofillHints.password],
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                labelText: 'تکرار رمز عبور جدید',
                labelStyle: TextStyle(color: AppColor.textColor),
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                prefixIconColor: AppColor.textColor,

                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
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
          child: Text('انصراف',
              style: TextStyle(color: AppColor.primaryColor)),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text('تغییر رمز',
              style: TextStyle(color: Colors.white)),
          onPressed: ()  {
            controller.changePassword();
            Get.back();
          },
        ),
      ],
    ),
  );
}
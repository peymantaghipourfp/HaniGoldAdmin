
import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/widget/side_menu_fix.widget.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import 'home_tabs_bar.widget.dart';

Widget buildDesktopLayout() {

  return Row(
    children: [
        // Navigation Rail
        SideMenuFix(),
        // Main Content Area
        Expanded(
          child: _MainContent(),
        ),
    ],
  );
}


class _MainContent extends StatelessWidget {
  const _MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final HomeTabsController tabsController = Get.put(HomeTabsController());
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bgHaniGold.png'),
          fit: BoxFit.fill,
          opacity: 0.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Internal tab bar (desktop only)
          const HomeTabsBar(),
          const SizedBox(height: 12),
          Text(
            'داشبورد مدیریتی',
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 28,
              color: AppColor.primaryColor,
            ),
          ),
          const SizedBox(height: 30),
          _buildStatsGrid(),
        ],
      ),
    );
  }
}


Widget _buildStatsGrid() {
  return Expanded(
    child: GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('سفارشات امروز', '', Icons.shopping_basket),
        _buildStatCard('تراز', '', Icons.account_balance),
        _buildStatCard('کاربران فعال', '', Icons.people_alt),
      ],
    ),
  );
}

Widget _buildStatCard(String title, String value, IconData icon) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColor.secondary100Color, AppColor.secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(50),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.transparent,
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
                color: AppColor.textColor.withAlpha(205),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/*void _showExitDialog() {
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
}*/

/*
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
}*/

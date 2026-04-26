import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final List<MenuItem> subItems;
  final String menuKey;
  final VoidCallback? onTap;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const MenuCard({
    Key? key,
    required this.title,
    required this.icon,
    this.iconColor,
    required this.subItems,
    required this.menuKey,
    this.onTap,
    this.isExpanded = false,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 8,
        shadowColor: AppColor.primaryColor.withAlpha(75),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColor.secondaryColor,
        child: Column(
          children: [
            // Main card header
            InkWell(
              onTap: onToggle ?? onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: isExpanded
                      ? LinearGradient(
                    colors: [
                      AppColor.backGroundColor1.withAlpha(80),
                      AppColor.buttonColor.withAlpha(30),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                ),
                child: Row(
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? AppColor.primaryColor.withAlpha(50)
                            : AppColor.buttonColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: isExpanded ? AppColor.primaryColor : iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyle.mediumTitleText.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isExpanded ? AppColor.primaryColor : AppColor.textColor,
                        ),
                      ),
                    ),
                    // Expand/collapse icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isExpanded ? AppColor.primaryColor : AppColor.textColor,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Submenu items
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Column(
                  children: subItems.map((item) => _buildSubMenuItem(item)).toList(),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.backGroundColor.withAlpha(75),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.secondary2Color.withAlpha(75),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColor.circleColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 11,
                    color: AppColor.textColor,
                  ),
                ),
              ),
              if (item.icon != null)
                Icon(
                  item.icon,
                  size: 12,
                  color: AppColor.circleColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const MenuItem({
    required this.title,
    required this.onTap,
    this.icon,
  });
}

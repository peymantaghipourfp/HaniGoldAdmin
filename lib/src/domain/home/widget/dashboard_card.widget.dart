import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? cardColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const DashboardCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.cardColor,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: AppColor.primaryColor.withAlpha(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: cardColor ?? AppColor.secondaryColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                (cardColor ?? AppColor.secondaryColor).withAlpha(200),
                (cardColor ?? AppColor.secondaryColor).withAlpha(150),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColor.primaryColor).withAlpha(50),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: iconColor ?? AppColor.primaryColor,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyle.mediumTitleText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColor,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 14,
                    color: AppColor.textColor.withAlpha(175),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? accentColor;

  const QuickActionCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: (accentColor ?? AppColor.buttonColor).withAlpha(75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColor.secondaryColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                (accentColor ?? AppColor.buttonColor).withAlpha(25),
                (accentColor ?? AppColor.buttonColor).withAlpha(12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (accentColor ?? AppColor.buttonColor).withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: accentColor ?? AppColor.buttonColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

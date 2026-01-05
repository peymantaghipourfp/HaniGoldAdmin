import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/const/app_color.dart';
import '../config/const/app_text_style.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColor.textColor.withAlpha(130),
                ),
                const SizedBox(width: 6),
                Text(
                  'نسخه ${packageInfo.version} (${packageInfo.buildNumber})',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 11,
                    color: AppColor.textColor.withAlpha(130),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/add_user_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EmptySidePanel extends StatelessWidget {
  const EmptySidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final controller = Get.find<ChatController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      margin: const EdgeInsets.only(left: 16),
      decoration: theme.panelDecoration(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: theme.accentContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 56,
                color: theme.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'یک گفتگو را انتخاب کنید',
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                isDesktop
                    ? 'از فهرست کنار یک کاربر انتخاب کنید یا با دکمه + گفتگوی جدید شروع کنید.'
                    : 'یک کاربر از لیست بالا انتخاب کنید یا گفتگوی جدید شروع کنید.',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 13,
                  color: theme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: () => showAddUserDialog(context, controller),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('گفتگوی جدید'),
              style: FilledButton.styleFrom(
                foregroundColor: theme.accent,
                backgroundColor: theme.accentContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

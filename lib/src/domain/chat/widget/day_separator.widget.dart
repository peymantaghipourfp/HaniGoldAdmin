import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_row.dart';

class DaySeparator extends StatelessWidget {
  const DaySeparator(this.day, {super.key});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.divider, height: 1)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.panelHeader,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.panelBorder),
            ),
            child: Text(
              formatDayLabel(day),
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                color: theme.onSurfaceMuted,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: theme.divider, height: 1)),
        ],
      ),
    );
  }
}

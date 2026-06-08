import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

class ChatStatusChip extends StatelessWidget {
  const ChatStatusChip({super.key, required this.chat});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final String label;
    final Color color;
    if (chat.status == 1) {
      label = 'بسته';
      color = theme.statusClosed;
    } else if (chat.adminRole == 2) {
      label = 'فقط مشاهده';
      color = theme.statusView;
    } else {
      label = 'باز';
      color = theme.statusOpen;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(36),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: AppTextStyle.bodyText.copyWith(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

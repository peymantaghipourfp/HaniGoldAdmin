import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

class ChatStatusBanner extends StatelessWidget {
  const ChatStatusBanner({super.key, required this.chat});

  final ChatModel? chat;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final selected = chat;
    if (selected == null) return const SizedBox.shrink();
    final closed = selected.status == 1;
    final viewOnly = selected.adminRole == 2;
    if (!closed && !viewOnly) return const SizedBox.shrink();

    final String message = closed
        ? 'این گفتگو بسته است؛ ارسال پیام ممکن نیست.'
        : 'فقط مشاهده: ارسال پیام برای این گفتگو غیرفعال است.';
    final IconData icon =
        closed ? Icons.lock_outline_rounded : Icons.visibility_outlined;
    final Color accent = closed ? theme.statusClosed : theme.statusView;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: accent.withAlpha(36),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withAlpha(120)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: accent.withAlpha(240)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 12,
                  color: theme.onSurface,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool canComposeInConversation(ChatModel? chat) {
  if (chat == null) return true;
  if (chat.status == 1) return false;
  if (chat.adminRole == 2) return false;
  return true;
}

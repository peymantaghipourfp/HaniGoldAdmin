import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

Future<void> showCloseChatConfirmation(
  BuildContext context,
  ChatController controller,
  ChatModel chat,
) async {
  final chatId = chat.chatId ?? '';
  if (chatId.isEmpty) return;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => ChatThemeScope(
      child: Builder(
        builder: (context) {
          final theme = context.chatTheme;
          return AlertDialog(
            backgroundColor: theme.menuSurface,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'بستن چت',
              style: AppTextStyle.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.onSurface,
              ),
            ),
            content: Text(
              'آیا می‌خواهید چت را ببندید؟',
              style: AppTextStyle.bodyText.copyWith(color: theme.onSurfaceVariant),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'خیر',
                  style: AppTextStyle.bodyText.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await controller.closeChatAndUpdateLists(chat);
                },
                child: Text(
                  'بله',
                  style: AppTextStyle.bodyText.copyWith(
                    color: theme.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

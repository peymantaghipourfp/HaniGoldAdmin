import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

/// Composer reply strip — shared M3 styling for quoted messages.
class ChatReplyPreviewBar extends StatelessWidget {
  const ChatReplyPreviewBar({
    super.key,
    required this.senderLabel,
    required this.bodyPreview,
    required this.onDismiss,
  });

  final String senderLabel;
  final String bodyPreview;
  final VoidCallback onDismiss;

  factory ChatReplyPreviewBar.fromMessage({
    required ChatMessageModel message,
    required String fallbackUserName,
    required VoidCallback onDismiss,
  }) {
    final sender = message.senderAccountName ??
        (message.senderType == 1 ? fallbackUserName : 'کاربر');
    final body = message.text?.trim().isNotEmpty == true
        ? message.text!.trim()
        : (message.seq != null ? 'پیام #${message.seq}' : 'پیام انتخاب‌شده');
    return ChatReplyPreviewBar(
      senderLabel: sender,
      bodyPreview: body,
      onDismiss: onDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.composerSurface.withAlpha(180),
        border: Border(
          bottom: BorderSide(color: theme.composerBorder),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: theme.bubbleReplyAccent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  senderLabel,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.bubbleReplyAccent,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  bodyPreview,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    color: theme.onBubbleMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            tooltip: 'لغو پاسخ',
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: theme.onBubbleMuted,
            ),
          ),
        ],
      ),
    );
  }
}

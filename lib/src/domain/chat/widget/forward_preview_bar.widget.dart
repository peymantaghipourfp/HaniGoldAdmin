import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/attachment_previews.widget.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';

/// Composer strip for a message being forwarded (Telegram-style caption below).
class ChatForwardPreviewBar extends StatelessWidget {
  const ChatForwardPreviewBar({
    super.key,
    required this.message,
    required this.fallbackUserName,
    required this.controller,
    required this.onDismiss,
  });

  final ChatMessageModel message;
  final String fallbackUserName;
  final ChatController controller;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final sender = message.senderAccountName ??
        (message.senderType == 1 ? fallbackUserName : 'کاربر');
    final snapshot = message.toForwardMessageSnapshot();
    final body = snapshot != null
        ? forwardEmbeddedMessagePreviewBody(snapshot)
        : (message.text?.trim() ?? '');
    final filesJson = snapshot?.filesJson ?? message.filesJson;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.composerSurface.withAlpha(180),
        border: Border(
          bottom: BorderSide(color: theme.composerBorder),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(
                'assets/svg/forward-left.svg',
                height: 18,
                colorFilter: ColorFilter.mode(
                  theme.bubbleReplyAccent,
                  BlendMode.srcIn,
                ),
              )
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'بازنشر پیام',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.bubbleReplyAccent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'بازنشر از $sender',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 11,
                    color: theme.onBubbleMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (filesJson != null && filesJson.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  AttachmentPreviews(
                    filesJson: filesJson,
                    controller: controller,
                  ),
                ],
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      color: theme.onBubbleMuted,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            tooltip: 'لغو بازنشر',
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

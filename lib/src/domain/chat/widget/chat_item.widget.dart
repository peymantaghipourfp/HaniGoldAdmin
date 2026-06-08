import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/close_chat_confirmation_dialog.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/forward_chat_dialog.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/grant_chat_dialog.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/pick_chat_confirmation_dialog.dart';
import 'package:hanigold_admin/src/domain/chat/widget/show_chat_history_info_dialog.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.controller,
    required this.chat,
  });

  final ChatController controller;
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final bool isClosed = chat.status == 1;
    final bool unPicked = chat.status == 3;
    final bool isView = chat.adminRole == 2;
    final bool isFreeTopic = chat.topicId == 6;
    final bool isOpen = !isClosed && !unPicked && !isView;
    final bool showGrant = !unPicked && !isView;
    final chatId = chat.chatId ?? '';

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: theme.threadCardDecoration(
                isClosed: isClosed,
                isView: isView,
              ),
              child: ListTile(
        onTap: () async {
          if (unPicked) {
            await showPickChatConfirmation(context, controller, chat);
            return;
          }
          await controller.openChatConversation(chat);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        title: Row(
          children: [
            if (isView)
              Container(
                margin: const EdgeInsets.only(left: 4),
                child: SvgPicture.asset(
                  'assets/svg/view-chat.svg',
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    theme.statusView,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            Icon(Icons.topic_outlined, size: 16, color: theme.topicAccent),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                chat.topicTitle ?? 'بدون موضوع',
                style: AppTextStyle.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showGrant && !isFreeTopic) ...[
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'ارسال مشاهده چت',
                icon: SvgPicture.asset(
                  'assets/svg/grant-chat.svg',
                  width: 28,
                  colorFilter: ColorFilter.mode(
                    theme.statusOpen.withAlpha(220),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  showGrantChatDialog(context, controller, chat);
                },
              ),
            ],
            if (isOpen && !isFreeTopic )
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'ارجاع چت',
                icon: SvgPicture.asset(
                  'assets/svg/forward.svg',
                  width: 28,
                  colorFilter: ColorFilter.mode(
                    theme.accent.withAlpha(220),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () =>
                    showForwardChatDialog(context, controller, chat),
              ),
            if (isOpen && !isFreeTopic)
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'بستن چت',
                icon: SvgPicture.asset(
                  'assets/svg/close.svg',
                  width: 28,
                  colorFilter: ColorFilter.mode(
                    theme.statusClosed.withAlpha(220),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () =>
                    showCloseChatConfirmation(context, controller, chat),
              ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chat.lastMessagePreview != null &&
                    chat.lastMessagePreview!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    (chat.lastMessagePreview ?? "").length > 35
                        ? "${(chat.lastMessagePreview ?? "").substring(0, 35)}..."
                        : (chat.lastMessagePreview ?? ""),
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      color: isClosed
                          ? theme.onSurfaceMuted
                          : unPicked
                              ? theme.onSurfaceVariant
                              : theme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  chat.lastMessageOn?.toPersianDate(
                          twoDigits: true, showTime: true, timeSeprator: '-') ??
                      '',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 11,
                    color: isClosed
                        ? theme.onSurfaceMuted.withAlpha(160)
                        : unPicked
                            ? theme.onSurfaceMuted
                            : theme.onSurfaceMuted,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((chat.unreadMessageCount ?? 0) > 0)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: _ChatThreadUnreadBadge(
                      count: chat.unreadMessageCount!,
                      theme: theme,
                    ),
                  ),
                ChatHistoryInfoButton(
                  chatId: chatId,
                  chatController: controller,
                  title: chat.topicTitle,
                ),
              ],
            ),
          ],
        ),
      ),
            ),
        ),
    );
  }
}


class _ChatThreadUnreadBadge extends StatelessWidget {
  const _ChatThreadUnreadBadge({
    required this.count,
    required this.theme,
  });

  final int count;
  final ChatThemeData theme;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '+99' : count.toString();
    return Badge(
      label: Text(
        label,
        style: AppTextStyle.bodyText.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: theme.onSurface,
        ),
      ),
      backgroundColor: theme.unreadBadge,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}

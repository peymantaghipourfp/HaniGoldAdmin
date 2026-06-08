import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_composer.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_row.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_status_banner.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/day_separator.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/close_chat_confirmation_dialog.dart';
import 'package:hanigold_admin/src/domain/chat/widget/jump_to_latest_pill.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/message_bubble.widget.dart'
    show MessageBubble, chatBubbleMaxWidthFraction;

import '../../../widget/hanigold_loading.widget.dart';
import 'conversation_message_search.widget.dart';

class ConversationPanel extends StatelessWidget {
  const ConversationPanel({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final chatAccount = controller.selectedChatAccount.value;
    final account = controller.selectedAccount.value;
    final chat = controller.selectedChat.value;

    final displayName =
        chatAccount?.accountName ?? account?.name ?? 'کاربر ناشناس';
    final topicName = chat?.topicTitle ?? controller.selectedTopic.value?.title;
    final bool isClosed = chat?.status == 1;
    final bool unPicked = chat?.status == 3;
    final bool isView = chat?.adminRole == 2;
    final bool isOpen = chat != null && !isClosed && !unPicked && !isView;

    final theme = context.chatTheme;

    return Container(
      margin: const EdgeInsets.only(left: 1,right: 1),
      decoration: theme.panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _ConversationSeenOnEnter(controller: controller),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.panelHeader,
              border: Border(bottom: BorderSide(color: theme.panelBorder)),
            ),
            child: Row(
              children: [
                Obx(() {
                  final hasThread = controller.selectedChat.value != null;
                  final draftingNewForAccount =
                      controller.selectedChatAccount.value != null &&
                          controller.selectedTopic.value != null &&
                          controller.selectedChat.value == null;
                  if (!hasThread && !draftingNewForAccount) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    onPressed: controller.goBackToChatList,
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.onSurfaceVariant,
                      size: 22,
                    ),
                    tooltip: 'بازگشت به لیست گفتگوها',
                  );
                }),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style: AppTextStyle.bodyText.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: theme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                      if (topicName != null)
                        Row(
                          children: [
                            Icon(
                              Icons.topic,
                              size: 12,
                              color: theme.topicAccent,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                topicName,
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 11,
                                  color: theme.topicAccent,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Obx(() {
                  final chatId = controller.selectedChat.value?.chatId;
                  if (chatId == null) return const SizedBox.shrink();
                  final expanded = controller.isMessageSearchExpanded.value;
                  return IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    tooltip: expanded ? 'بستن جستجو' : 'جستجو در پیام‌ها',
                    icon: Icon(
                      expanded ? Icons.search_off : Icons.search,
                      size: 24,
                      color: expanded
                          ? theme.accent
                          : theme.onSurfaceVariant,
                    ),
                    onPressed: controller.toggleMessageSearch,
                  );
                }),
                if (isOpen)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'بستن چت',
                      icon: Icon(
                        Icons.lock_outline,
                        size: 24,
                        color: theme.statusClosed.withAlpha(220),
                      ),
                      onPressed: () async {
                        await showCloseChatConfirmation(
                          context,
                          controller,
                          chat,
                        );
                      },
                    ),
                  ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: controller.clearSelections,
                  icon: Icon(
                    Icons.close,
                    color: theme.onSurfaceVariant,
                    size: 22,
                  ),
                  tooltip: 'بستن گفتگو',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ConversationMessageSearchBar(controller: controller),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxBubbleWidth = constraints.maxWidth *
                    chatBubbleMaxWidthFraction(context);
                return Stack(
                  children: [
                    Obx(() {
                      if (controller.isLoadingMessages.value) {
                        return Center(
                          child: HaniGoldLoading(color: theme.progress),
                        );
                      }
                      if (controller.chatMessages.isEmpty) {
                        final isSearching =
                            controller.isMessageSearchActive;
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSearching
                                    ? Icons.search_off
                                    : Icons.chat_bubble_outline,
                                size: 48,
                                color: theme.emptyStateIcon,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isSearching
                                    ? 'پیامی با این عبارت یافت نشد.'
                                    : 'هنوز پیامی رد و بدل نشده؛ اولین پیام را شما بنویسید.',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 13,
                                  color: theme.onSurfaceVariant,
                                ),
                              ),
                              if (isSearching) ...[
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed:
                                  controller.clearMessageSearchAndReload,
                                  icon: Icon(
                                    Icons.clear_all,
                                    size: 18,
                                    color: theme.accent,
                                  ),
                                  label: Text(
                                    'نمایش همه پیام‌ها',
                                    style: AppTextStyle.bodyText.copyWith(
                                      fontSize: 13,
                                      color: theme.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      final rows = buildChatRows(controller.chatMessages);
                      final hasMore = controller.hasMoreMessages.value &&
                          controller.selectedChat.value != null;
                      return _ConversationMessageList(
                        controller: controller,
                        rows: rows,
                        hasMore: hasMore,
                        theme: theme,
                        maxBubbleWidth: maxBubbleWidth,
                      );
                    }),
                    Obx(() {
                      final show = !controller.isNearBottom.value ||
                          controller.conversationUnreadCount.value > 0 ||
                          controller.pendingNewMessages.value > 0;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: show
                            ? Align(
                          key: const ValueKey('jump'),
                          alignment: AlignmentDirectional.bottomStart,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                              right: 12,
                              left: 12,
                            ),
                            child:
                            JumpToLatestPill(controller: controller),
                          ),
                        )
                            : const SizedBox.shrink(key: ValueKey('none')),
                      );
                    }),
                  ],
                );
                },

            ),

          ),

          ChatStatusBanner(chat: chat),

          ChatComposer(

            controller: controller,

            canCompose: canComposeInConversation(chat),

          ),

        ],

      ),

    );

  }

}

/// Sends one `chat.seen` with the latest [seq] when the panel opens (not on scroll).
class _ConversationSeenOnEnter extends StatefulWidget {
  const _ConversationSeenOnEnter({required this.controller});

  final ChatController controller;

  @override
  State<_ConversationSeenOnEnter> createState() =>
      _ConversationSeenOnEnterState();
}

class _ConversationSeenOnEnterState extends State<_ConversationSeenOnEnter> {
  late final Worker _seenOnEnterWorker;

  @override
  void initState() {
    super.initState();
    _seenOnEnterWorker = everAll(
      [
        widget.controller.isLoadingMessages,
        widget.controller.selectedChat,
      ],
          (_) => _tryMarkSeen(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryMarkSeen());
  }

  @override
  void dispose() {
    _seenOnEnterWorker.dispose();
    super.dispose();
  }

  void _tryMarkSeen() {
    unawaited(widget.controller.markConversationSeenOnEnter());
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Message list with initial scroll-to-last-read after the first frame.
class _ConversationMessageList extends StatefulWidget {
  const _ConversationMessageList({
    required this.controller,
    required this.rows,
    required this.hasMore,
    required this.theme,
    required this.maxBubbleWidth,
  });

  final ChatController controller;
  final List<ChatRow> rows;
  final bool hasMore;
  final ChatThemeData theme;
  final double maxBubbleWidth;

  @override
  State<_ConversationMessageList> createState() =>
      _ConversationMessageListState();
}

class _ConversationMessageListState extends State<_ConversationMessageList> {
  @override
  void initState() {
    super.initState();
    _scheduleInitialScroll();
    _requestFabTotals();
  }

  @override
  void didUpdateWidget(covariant _ConversationMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldChatId = oldWidget.controller.selectedChat.value?.chatId;
    final newChatId = widget.controller.selectedChat.value?.chatId;
    if (oldChatId != newChatId) {
      _scheduleInitialScroll();
      _requestFabTotals();
    }
  }

  void _requestFabTotals() {
    unawaited(widget.controller.requestChatUnreadTotal());
    unawaited(widget.controller.requestChatWaitingTotal());
  }

  void _scheduleInitialScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.applyInitialConversationScrollIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final rows = widget.rows;
    final hasMore = widget.hasMore;

    return ListView.builder(
      reverse: true,
      controller: controller.messagesScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: rows.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == rows.length) {
          if (controller.isLoadingMoreMessages.value) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: HaniGoldLoading.small()),
            );
          }
          if (hasMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.loadMoreMessages();
            });
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: HaniGoldLoading.small()),
            );
          }
          return const SizedBox.shrink();
        }
        final row = rows[index];
        if (row is DayHeaderRow) {
          return DaySeparator(row.day);
        }
        if (row is BubbleRow) {
          final isFromCurrentUser = row.msg.senderType == 1;
          final isFromSystem = row.msg.senderType == 2;
          return MessageBubble(
            key: controller.scrollKeyForBubble(row.msg),
            controller: controller,
            message: row.msg,
            isFromCurrentUser: isFromCurrentUser,
            isFromSystem: isFromSystem,
            maxBubbleWidth: widget.maxBubbleWidth,
            showSenderName: row.showSenderName,
            isTail: row.isTail,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

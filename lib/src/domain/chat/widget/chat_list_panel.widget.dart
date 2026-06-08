import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_item.widget.dart';

import '../../../widget/hanigold_loading.widget.dart';
import 'chat_list_topic_filter.widget.dart';
import 'dialogs/topic_selection_dialog.dart';

class ChatListPanel extends StatelessWidget {
  const ChatListPanel({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final chatAccount = controller.selectedChatAccount.value!;

    return Container(
      margin: const EdgeInsets.only(left: 1,right: 1),
      decoration: theme.panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.panelHeader,
              border: Border(bottom: BorderSide(color: theme.panelBorder)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chatAccount.accountName ?? 'کاربر ناشناس',
                        style: AppTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: theme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'لیست گفتگوها',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 12,
                          color: theme.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                ChatListTopicFilter(controller: controller),
                IconButton(
                  onPressed: () => showTopicSelectionDialog(
                    context,
                    controller,
                    chatAccount: chatAccount,
                  ),
                  icon: Icon(Icons.add_rounded, color: theme.accent, size: 22),
                  tooltip: 'گفتگوی جدید',
                ),
                IconButton(
                  onPressed: controller.clearSelections,
                  icon: Icon(
                    Icons.close_rounded,
                    color: theme.onSurfaceVariant,
                    size: 22,
                  ),
                  tooltip: 'بستن',
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingChats.value) {
                return Center(
                  child: HaniGoldLoading(color: theme.progress),
                );
              }

              if (controller.chatList.isEmpty) {
                final filter = controller.chatListTopicFilter.value;
                final filterLabel = filter?.title?.trim().isNotEmpty == true
                    ? filter!.title!.trim()
                    : filter?.code?.trim();
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        filterLabel != null
                            ? Icons.filter_list_off_outlined
                            : Icons.forum_outlined,
                        size: 48,
                        color: theme.emptyStateIcon,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        filterLabel != null
                            ? 'گفتگویی با موضوع «$filterLabel» یافت نشد'
                            : 'هیچ گفتگویی برای این کاربر وجود ندارد',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 13,
                          color: theme.onSurfaceVariant,
                        ),
                      ),
                      if (filterLabel != null) ...[
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () =>
                              controller.setChatListTopicFilter(null),
                          icon: Icon(
                            Icons.clear_all_rounded,
                            size: 18,
                            color: theme.accent,
                          ),
                          label: Text(
                            'حذف فیلتر موضوع',
                            style: AppTextStyle.bodyText.copyWith(
                              fontSize: 12,
                              color: theme.accent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.chatList.length,
                itemBuilder: (context, index) {
                  return ChatItem(
                    controller: controller,
                    chat: controller.chatList[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

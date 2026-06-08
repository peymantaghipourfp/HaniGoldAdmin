import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_account_item.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_search_field.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/add_user_dialog.dart';
import 'package:hanigold_admin/src/widget/hanigold_loading.widget.dart';

class ChatListContent extends StatelessWidget {
  const ChatListContent({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Column(
      children: [
        ChatSearchField(controller: controller),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingChatAccounts.value) {
              return Center(
                child: HaniGoldLoading(color: theme.progress),
              );
            }

            final filteredList = controller.filteredChatAccounts;
            final onOpenTab =
                controller.selectedChatTab.value == ChatAccountListTabs.open;

            if (controller.chatAccountList.isEmpty && onOpenTab) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 64,
                      color: theme.emptyStateIcon,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'هیچ گفتگویی یافت نشد',
                      style: AppTextStyle.bodyText.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => showAddUserDialog(context, controller),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('شروع گفتگوی جدید'),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.accent,
                        foregroundColor: theme.onAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (filteredList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 48,
                      color: theme.emptyStateIcon,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.chatAccountListEmptyHint,
                      style: AppTextStyle.bodyText.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredList.length +
                  (controller.hasMoreChatAccounts.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredList.length) {
                  if (controller.isLoadingMoreChatAccounts.value) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: HaniGoldLoading(color: theme.progress),
                      ),
                    );
                  } else if (controller.hasMoreChatAccounts.value) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => controller.loadMoreChatAccounts(),
                    );
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: HaniGoldLoading(color: theme.progress),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
                return ChatAccountItem(
                  controller: controller,
                  chatAccount: filteredList[index],
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

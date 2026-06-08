import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_account.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/topic_selection_dialog.dart';

import '../../../../widget/hanigold_loading.widget.dart';
import 'chat_dialog_list_tile.widget.dart';

void startForwardMessageFlow(
    BuildContext context,
    ChatController controller,
    ChatMessageModel message,
    ) {
  controller.beginForwardMessage(message);
  showAddUserDialog(context, controller);
}

void showAddUserDialog(BuildContext context, ChatController controller) {
  final theme = context.chatTheme;
  final forwardMsg = controller.pendingForwardMessage.value;
  Get.dialog(
    chatThemedDialog(
      Dialog(
      backgroundColor: theme.shellBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: theme.dialogDecoration(),
        width: Get.width * 0.6,
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'انتخاب کاربر',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (forwardMsg != null){
                      controller.cancelForward();
                    }
                    Get.back();
                  },
                  icon: Icon(Icons.close_rounded, color: theme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.searchController,
              onChanged: controller.filterAccounts,
              style: AppTextStyle.bodyText.copyWith(color: theme.onSurface),
              decoration: InputDecoration(
                hintText: 'جستجوی کاربر...',
                hintStyle: TextStyle(color: theme.onSurfaceMuted),
                prefixIcon: Icon(Icons.search_rounded, color: theme.onSurfaceMuted),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.searchController,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: Icon(Icons.clear_rounded, color: theme.onSurfaceMuted),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.filterAccounts('');
                      },
                    );
                  },
                ),
                filled: true,
                fillColor: theme.searchFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.searchOutline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.searchOutline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.accent, width: 1.2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingAccounts.value) {
                  return Center(
                    child: HaniGoldLoading(color: theme.progress),
                  );
                }
                if (controller.filteredAccountList.isEmpty) {
                  return Center(
                    child: Text(
                      'هیچ کاربری یافت نشد',
                      style: AppTextStyle.bodyText.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.filteredAccountList.length,
                  itemBuilder: (context, index) {
                    final account = controller.filteredAccountList[index];
                    final isInChatList =
                        controller.isAccountInChatList(account.id ?? 0);
                    return ChatDialogListTile(
                      theme: theme,
                      minTileHeight: 40,
                      onTap: () {
                        if (isInChatList) {
                          openExistingAccountChatFromAddDialog(
                            context,
                            controller,
                            account,
                          );
                        } else {
                          selectUserForChat(context, controller, account);
                        }
                      },
                      title: Text(
                        account.name ?? 'کاربر ناشناس',
                        style: AppTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.onSurface,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isInChatList) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.accentContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'در گفتگو',
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 10,
                                  color: theme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Icon(
                            Icons.arrow_forward_ios,
                            color: theme.accent,
                            size: 16,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    ),
    ),
    barrierDismissible: false,
  ).then((_) {
    controller.searchController.clear();
    controller.filterAccounts('');
  });
}

/// When the account already appears in [ChatController.chatAccountList] for the
/// active tab, drill down like [ChatAccountItem] instead of starting a new-topic flow.
void openExistingAccountChatFromAddDialog(
    BuildContext context,
    ChatController controller,
    AccountModel account,
    ) {
  final chatAccount = controller.chatAccountList.firstWhereOrNull(
        (ca) => ca.accountId == account.id,
  );
  if (chatAccount == null) {
    selectUserForChat(context, controller, account);
    return;
  }
  final pendingForward = controller.pendingForwardMessage.value;
  controller.searchController.clear();
  Get.back();
  controller.selectChatUserForExistingChat(chatAccount);
  controller.pendingForwardMessage.value = pendingForward;
}

void selectUserForChat(
  BuildContext context,
  ChatController controller,
  AccountModel account,
) {
  final pendingForward = controller.pendingForwardMessage.value;
  controller.clearSelections(clearPendingForward: false);
  controller.pendingForwardMessage.value = pendingForward;
  controller.selectAccount(account);
  Get.back();

  showTopicSelectionDialog(
    context,
    controller,
    chatAccount: ChatAccountModel(
      accountId: account.id,
      accountName: account.name,
      adminChatRole: 1,
      lastChatId: null,
      lastMessageOn: null,
      lastMessagePreview: null,
      rowNum: null,
      totalMessageCount: null,
      unreadMessageCount: null,
      chatStatus: null,
      unreadChatCount: null,
    ),
  );
}

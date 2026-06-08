import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_account.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

import '../../../../widget/hanigold_loading.widget.dart';
import 'chat_dialog_list_tile.widget.dart';

void showTopicSelectionDialog(
  BuildContext context,
  ChatController controller, {
  required ChatAccountModel chatAccount,
}) {
  final theme = context.chatTheme;
  final topicOwnerId = chatAccount.accountId;
  if (topicOwnerId != null) {
    controller.loadTopics();
  }
  Get.dialog(
    chatThemedDialog(
      Dialog(
      backgroundColor: theme.shellBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: theme.dialogDecoration(),
        width: Get.width * 0.5,
        height: Get.height * 0.6,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'انتخاب موضوع',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close_rounded, color: theme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTopics.value) {
                  return Center(
                    child: HaniGoldLoading(color: theme.progress),
                  );
                }
                if (controller.topicList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.topic_outlined,
                          size: 64,
                          color: theme.emptyStateIcon,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'هیچ موضوعی یافت نشد',
                          style: AppTextStyle.bodyText.copyWith(
                            color: theme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.topicList.length,
                  itemBuilder: (context, index) {
                    final topic = controller.topicList[index];
                    return ChatDialogListTile(
                      theme: theme,
                      onTap: () {
                        controller.selectTopic(topic);
                        Get.back();
                      },
                      leading: Icon(Icons.topic_outlined, color: theme.accent),
                      title: Text(
                        topic.title ?? 'موضوع ناشناس',
                        style: AppTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        topic.code ?? '',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 12,
                          color: theme.onSurfaceMuted,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_left_rounded,
                        color: theme.accent,
                        size: 22,
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
  );
}

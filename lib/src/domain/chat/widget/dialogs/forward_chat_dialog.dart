import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/model/account_admin.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';

import '../../../../widget/hanigold_loading.widget.dart';

Future<void> showForwardChatDialog(
  BuildContext context,
  ChatController controller,
  ChatModel chat,
) async {
  final topicCode = chat.topicCode?.trim() ?? '';
  if (topicCode.isEmpty) {
    Get.snackbar('خطا', 'کد موضوع برای ارجاع چت یافت نشد');
    return;
  }

  await controller.loadAccountAdminList(topicCode);

  final myAcc = int.tryParse(controller.currentUserId);
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      int? selectedToAdminAccountId;

      return ChatThemeScope(
        child: StatefulBuilder(
        builder: (context, setLocalState) {
          final theme = context.chatTheme;
          return AlertDialog(
            backgroundColor: theme.menuSurface,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'ارجاع چت',
              style: AppTextStyle.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.onSurface,
              ),
            ),
            content: SizedBox(
              width: Get.width * 0.4,
              height: Get.height * 0.5,
              child: Obx(() {
                if (controller.isLoadingAccountsAdmin.value) {
                  return Center(
                    child: HaniGoldLoading(color: theme.progress),
                  );
                }
                final candidates = controller.accountAdminList
                    .expand((a) => a.items ?? const <Item>[])
                    .where((it) {
                  final id = it.accountId;
                  if (id == null) return false;
                  if (myAcc != null && id == myAcc) return false;
                  return true;
                }).toList();

                if (candidates.isEmpty) {
                  return Center(
                    child: Text(
                      'ادمین دیگری برای ارجاع یافت نشد',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyText.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: candidates.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: theme.divider,
                  ),
                  itemBuilder: (context, index) {
                    final it = candidates[index];
                    final id = it.accountId!;
                    final title = it.name?.trim().isNotEmpty == true
                        ? it.name!.trim()
                        : 'اکانت $id';
                    return RadioGroup<int>(
                      groupValue: selectedToAdminAccountId,
                      onChanged: (int? value) {
                        setLocalState(() {
                          selectedToAdminAccountId = value;
                        });
                      },
                      child: RadioListTile<int>(
                        dense: true,
                        value: id,
                        activeColor: theme.accent,
                        title: Text(
                          title,
                          style: AppTextStyle.bodyText.copyWith(
                            color: theme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'انصراف',
                  style: AppTextStyle.bodyText.copyWith(
                    color: theme.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: selectedToAdminAccountId == null
                    ? null
                    : () async {
                        final toId = selectedToAdminAccountId!;
                        Navigator.of(dialogContext).pop();
                        await controller.forwardChatToAdmin(chat, toId);
                      },
                child: Text(
                  'ارجاع',
                  style: AppTextStyle.bodyText.copyWith(
                    color: selectedToAdminAccountId == null
                        ? theme.onSurfaceMuted
                        : theme.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      );
    },
  );
}

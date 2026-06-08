import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_account.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ChatAccountItem extends StatelessWidget {
  const ChatAccountItem({
    super.key,
    required this.controller,
    required this.chatAccount,
  });

  final ChatController controller;
  final ChatAccountModel chatAccount;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Obx(() {
      final isSelected = controller.selectedChatAccount.value?.accountId ==
          chatAccount.accountId;
      final unreadChatCount = controller.liveUnreadChatCountForAccount(
        chatAccount.accountId,
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: 4, left: 1, right: 1),
        child: Material(
          color: isSelected
              ? theme.listItemSelectedFill
              : Colors.transparent,
          elevation: isSelected ? 2 : 0,
          shadowColor: theme.listItemSelectedGlow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? theme.listItemSelectedBorder
                  : theme.panelBorder.withAlpha(80),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              controller.selectChatUserForExistingChat(chatAccount);
            },
            title: Text(
              chatAccount.accountName ?? 'کاربر ناشناس',
              style: AppTextStyle.bodyText.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.onSurface,
              ),
            ),
            subtitle: Text(
              chatAccount.lastMessageOn?.toPersianDate(
                  twoDigits: true, showTime: true, timeSeprator: '-') ??
                  '',
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 12,
                color: theme.onSurfaceMuted,
              ),
            ),
            trailing: unreadChatCount > 0
                ? Badge(
              label: Text(
                unreadChatCount > 99
                    ? '+99'
                    : unreadChatCount.toString(),
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.onSurface,
                ),
                    ),
              backgroundColor: theme.unreadBadge,
            )
                : null,
          ),
        ),
      );
    });
  }
}

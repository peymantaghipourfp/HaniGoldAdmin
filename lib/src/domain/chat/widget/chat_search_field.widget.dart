import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

class ChatSearchField extends StatelessWidget {
  const ChatSearchField({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Container(
      //padding: const EdgeInsets.only(bottom: 1, left: 1, right: 1),
      margin: const EdgeInsets.only(bottom: 5, left: 1, right: 1),
      child: TextField(
        controller: controller.chatAccountsSearchController,
        onChanged: (value) => controller.filterChatAccounts(value),
        style: AppTextStyle.bodyText.copyWith(color: theme.onSurface),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'جستجوی گفتگو...',
          hintStyle: AppTextStyle.bodyText.copyWith(
            color: theme.onSurfaceMuted,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: theme.onSurfaceMuted),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.chatAccountsSearchController,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.clear_rounded, color: theme.onSurfaceMuted),
                onPressed: () {
                  controller.chatAccountsSearchController.clear();
                  controller.filterChatAccounts('');
                },
              );
            },
          ),
          filled: true,
          fillColor: theme.searchFill,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.searchOutline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.accent, width: 1.2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

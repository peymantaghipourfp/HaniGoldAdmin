import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

/// Collapsible in-conversation message search (server-side Text filter).
class ConversationMessageSearchBar extends StatefulWidget {
  const ConversationMessageSearchBar({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  State<ConversationMessageSearchBar> createState() =>
      _ConversationMessageSearchBarState();
}

class _ConversationMessageSearchBarState
    extends State<ConversationMessageSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _didAutoFocus = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final c = widget.controller;

    return Obx(() {
      if (!c.isMessageSearchExpanded.value) {
        _didAutoFocus = false;
        return const SizedBox.shrink();
      }

      if (!_didAutoFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !c.isMessageSearchExpanded.value) return;
          _didAutoFocus = true;
          if (_focusNode.canRequestFocus) {
            _focusNode.requestFocus();
          }
        });
      }

      final applied = c.activeMessageSearchQuery.value.trim();

      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: _focusNode,
              controller: c.messagesSearchController,
              onChanged: c.onMessagesSearchChanged,
              style: AppTextStyle.bodyText.copyWith(color: theme.onSurface),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.search,
              onSubmitted: c.submitMessageSearch,
              decoration: InputDecoration(
                hintText: 'جستجو در پیام‌ها...',
                hintStyle: AppTextStyle.bodyText.copyWith(
                  color: theme.onSurfaceMuted,
                ),
                prefixIcon:
                Icon(Icons.search_rounded, color: theme.onSurfaceMuted),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: c.messagesSearchController,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: theme.onSurfaceMuted,
                      ),
                      tooltip: 'پاک کردن',
                      onPressed: c.clearMessageSearchAndReload,
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
                  vertical: 10,
                ),
              ),
            ),
            if (applied.isNotEmpty) ...[
              const SizedBox(height: 6),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: InputChip(
                  label: Text(
                    '«$applied»',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      color: theme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    size: 16,
                    color: theme.onSurfaceVariant,
                  ),
                  onDeleted: c.clearMessageSearchAndReload,
                  backgroundColor: theme.accentContainer.withAlpha(140),
                  side: BorderSide(color: theme.searchOutline),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

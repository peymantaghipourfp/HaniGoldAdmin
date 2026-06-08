import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/topic.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

/// Topic filter for [ChatListPanel] — drives [ChatController.chatListTopicFilter].
class ChatListTopicFilter extends StatelessWidget {
  const ChatListTopicFilter({super.key, required this.controller});

  final ChatController controller;

  static const Object _allTopicsValue = Object();

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Obx(() {
      final isLoading = controller.isLoadingTopics.value;
      final topics = controller.sortedTopicList;
      final hasTopics = topics.isNotEmpty;
      final active = controller.chatListTopicFilter.value;
      final label = active?.title?.trim().isNotEmpty == true
          ? active!.title!.trim()
          : (active?.code?.trim().isNotEmpty == true
          ? active!.code!.trim()
          : 'همه موضوعات');
      final isFiltered = active != null;

      if (!hasTopics && !isLoading) {
        return Tooltip(
          message: 'فیلتر موضوع — موضوعی برای نمایش وجود ندارد',
          child: IconButton(
            onPressed: () => controller.loadTopics(),
            icon: Icon(
              Icons.filter_list_off_outlined,
              color: theme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 22,
            ),
          ),
        );
      }

      return PopupMenuButton<Object>(
        tooltip: 'فیلتر بر اساس موضوع',
        enabled: hasTopics || isLoading,
        onOpened: () {
          if (!controller.isLoadingTopics.value && controller.topicList.isEmpty) {
            controller.loadTopics();
          }
        },
        onSelected: (value) {
          if (value == _allTopicsValue) {
            controller.setChatListTopicFilter(null);
            return;
          }
          if (value is TopicModel) {
            controller.setChatListTopicFilter(value);
          }
        },
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: theme.menuSurface,
        itemBuilder: (context) {
          final items = <PopupMenuEntry<Object>>[
            PopupMenuItem<Object>(
              value: _allTopicsValue,
              child: _TopicFilterMenuRow(
                theme: theme,
                title: 'همه موضوعات',
                subtitle: 'نمایش تمام گفتگوها',
                selected: active == null,
                icon: Icons.layers_outlined,
              ),
            ),
            const PopupMenuDivider(),
          ];

          for (final topic in topics) {
            final code = topic.code?.trim() ?? '';
            items.add(
              PopupMenuItem<Object>(
                value: topic,
                child: _TopicFilterMenuRow(
                  theme: theme,
                  title: topic.title?.trim().isNotEmpty == true
                      ? topic.title!.trim()
                      : 'موضوع ناشناس',
                  subtitle: code.isNotEmpty ? code : null,
                  selected: active?.code != null &&
                      code.isNotEmpty &&
                      active!.code!.trim() == code,
                  icon: Icons.topic_outlined,
                ),
              ),
            );
          }
          return items;
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 140),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isFiltered
                    ? theme.topicAccent.withValues(alpha: 0.12)
                    : theme.searchFill,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isFiltered ? theme.topicAccent : theme.searchOutline,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.progress,
                      ),
                    )
                  else
                    Icon(
                      Icons.filter_list_rounded,
                      size: 18,
                      color: isFiltered ? theme.topicAccent : theme.onSurfaceVariant,
                    ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: 12,
                        fontWeight:
                        isFiltered ? FontWeight.w600 : FontWeight.normal,
                        color: isFiltered ? theme.topicAccent : theme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 20,
                    color: isFiltered ? theme.topicAccent : theme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _TopicFilterMenuRow extends StatelessWidget {
  const _TopicFilterMenuRow({
    required this.theme,
    required this.title,
    required this.icon,
    required this.selected,
    this.subtitle,
  });

  final ChatThemeData theme;
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          selected ? Icons.check_rounded : icon,
          size: 20,
          color: selected ? theme.accent : theme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: theme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 11,
                    color: theme.onSurfaceMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

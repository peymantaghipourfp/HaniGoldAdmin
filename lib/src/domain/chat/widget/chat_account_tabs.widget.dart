import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_dialog_internals.dart';

int _tabBadgeCount(int tabIndex, int selectedIndex, int listLength) =>
    selectedIndex == tabIndex ? listLength : 0;

class VerticalChatAccountTabs extends StatelessWidget {
  const VerticalChatAccountTabs({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedChatTab.value;
      final len = controller.chatAccountList.length;

      return SizedBox(
        width: 60,
        child: Column(
          children: [
            for (var i = 0; i < kChatAccountTabSpecs.length; i++) ...[
              if (i > 0) const SizedBox(height: 4),
              _VerticalTabItem(
                controller: controller,
                index: kChatAccountTabSpecs[i].index,
                title: kChatAccountTabSpecs[i].label,
                icon: kChatAccountTabSpecs[i].icon,
                isSelected: selected == kChatAccountTabSpecs[i].index,
                count: _tabBadgeCount(
                  kChatAccountTabSpecs[i].index,
                  selected,
                  len,
                ),
              ),
            ],
            const Spacer(),
          ],
        ),
      );
    });
  }
}

class _VerticalTabItem extends StatelessWidget {
  const _VerticalTabItem({
    required this.controller,
    required this.index,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.count,
  });

  final ChatController controller;
  final int index;
  final String title;
  final IconData icon;
  final bool isSelected;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return GestureDetector(
      onTap: () => controller.changeChatAccountTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 52,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.tabSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.tabSelected.withAlpha(90),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? theme.onSurface : theme.onSurfaceMuted,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? theme.onSurface : theme.onSurfaceMuted,
              ),
            ),
           /* if (count > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.tabBadge.withAlpha(120)
                      : theme.tabTrack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? theme.onSurface : theme.onSurfaceMuted,
                  ),
                ),
              ),
            ],*/
          ],
        ),
      ),
    );
  }
}

class HorizontalChatAccountTabs extends StatelessWidget {
  const HorizontalChatAccountTabs({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Obx(() {
      final selected = controller.selectedChatTab.value;
      final len = controller.chatAccountList.length;

      return Container(
        margin: const EdgeInsets.only(bottom: 5, left: 1, right: 1),
        //padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: theme.tabTrack,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.panelBorder.withAlpha(100)),
        ),
        child: Row(
          children: [
            for (var i = 0; i < kChatAccountTabSpecs.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              _HorizontalTabItem(
                controller: controller,
                index: kChatAccountTabSpecs[i].index,
                icon: kChatAccountTabSpecs[i].icon,
                isSelected: selected == kChatAccountTabSpecs[i].index,
                count: _tabBadgeCount(
                  kChatAccountTabSpecs[i].index,
                  selected,
                  len,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _HorizontalTabItem extends StatelessWidget {
  const _HorizontalTabItem({
    required this.controller,
    required this.index,
    required this.icon,
    required this.isSelected,
    required this.count,
  });

  final ChatController controller;
  final int index;
  final IconData icon;
  final bool isSelected;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeChatAccountTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? theme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? theme.onAccent : theme.onSurfaceMuted,
              ),
              /*if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.onAccent.withAlpha(40)
                        : theme.tabTrack,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 11,
                      color: isSelected ? theme.onAccent : theme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],*/
            ],
          ),
        ),
      ),
    );
  }
}

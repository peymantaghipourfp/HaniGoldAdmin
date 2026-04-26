import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/open_in_new_tab.dart';
import 'package:hanigold_admin/src/domain/home/controller/home_tabs.controller.dart';

/// Chrome-like horizontal tab bar for the desktop layout.
class HomeTabsBar extends StatelessWidget {
  const HomeTabsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeTabsController controller = Get.put(HomeTabsController());

    return Obx(() {
      final tabs = controller.tabs;
      final activeId = controller.activeTabId.value;

      if (tabs.isEmpty) {
        // Nothing open yet – render a subtle placeholder.
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      }

      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          onReorder: controller.reorderTabs,
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final tab = tabs[index];
            final isActive = tab.id == activeId;
            return ReorderableDragStartListener(
              key: ValueKey(tab.id),
              index: index,
              child: _TabTile(
                tab: tab,
                isActive: isActive,
                onSelect: () => controller.activateTab(tab.id),
                onClose: () => controller.closeTab(tab.id),
                onTearOff: () async {
                  controller.closeTab(tab.id);
                  await openRouteInNewTab(
                    tab.route,
                    title: tab.title,
                    iconCodePoint: tab.icon?.codePoint,
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }
}

class _TabTile extends StatelessWidget {
  const _TabTile({
    required this.tab,
    required this.isActive,
    required this.onSelect,
    required this.onClose,
    required this.onTearOff,
  });

  final HomeTab tab;
  final bool isActive;
  final VoidCallback onSelect;
  final VoidCallback onClose;
  final Future<void> Function() onTearOff;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Listener(
      onPointerDown: (PointerDownEvent event) {
        // Middle-click closes the tab.
        if ((event.buttons & kMiddleMouseButton) != 0) {
          onClose();
        }
      },
      child: LongPressDraggable<HomeTab>(
        data: tab,
        feedback: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(6),
          color: Colors.blueGrey,
          child: Opacity(
            opacity: 0.9,
            child: _buildTileContent(colorScheme, isGhost: true),
          ),
        ),
        childWhenDragging: _buildTileContent(colorScheme, isGhost: true),
        onDragEnd: (details) async {
          // If the drag finished far away vertically from the tab strip area,
          // treat it as a "tear off" and open in a new window.
          // This is a heuristic similar to browsers.
          final dy = details.offset.dy;
          if (!details.wasAccepted && (dy < 0 || dy > 120)) {
            await onTearOff();
          }
        },
        child: GestureDetector(
          onTap: onSelect,
          child: _buildTileContent(colorScheme),
        ),
      ),
    );
  }

  Widget _buildTileContent(ColorScheme colorScheme, {bool isGhost = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary.withOpacity(isGhost ? 0.12 : 0.16)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isGhost
            ? Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 1,
        )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                tab.icon,
                size: 16,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              tab.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? colorScheme.onSecondary
                    : colorScheme.onSecondary.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.close,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


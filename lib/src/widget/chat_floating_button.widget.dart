import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_dialog.widget.dart';

import '../domain/chat/controller/chat_fab.controller.dart';

class ChatFloatingButton extends StatefulWidget {
  const ChatFloatingButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.chat,
    this.tooltip,
    this.heroTag = 'chat_fab',
  });

  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData icon;
  final String? tooltip;
  final Object? heroTag;

  @override
  State<ChatFloatingButton> createState() => _ChatFloatingButtonState();
}

class _ChatFloatingButtonState extends State<ChatFloatingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _highlightController;
  late final ChatFabController _chatFabController;
  Worker? _highlightWorker;

  @override
  void initState() {
    super.initState();
    _chatFabController = Get.find<ChatFabController>();
    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _highlightWorker = ever(_chatFabController.chatFabHighlight, _syncHighlightAnimation);
    _syncHighlightAnimation(_chatFabController.chatFabHighlight.value);
  }

  void _syncHighlightAnimation(bool highlight) {
    if (!mounted) return;
    if (highlight) {
      if (!_highlightController.isAnimating) {
        _highlightController.repeat(reverse: true);
      }
      return;
    }
    _highlightController
      ..stop()
      ..value = 0;
  }

  @override
  void dispose() {
    _highlightWorker?.dispose();
    _highlightController.dispose();
    super.dispose();
  }

  void _openChat() {
    if (widget.onPressed != null) {
      widget.onPressed!();
      return;
    }
    Get.dialog(const ChatDialog());
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.backgroundColor ?? AppColor.buttonColor;
    const alertColor = AppColor.errorColor;

    return Obx(() {
      final unreadCount = _chatFabController.chatFabUnreadCount.value;
      final highlight = _chatFabController.chatFabHighlight.value;
      final waitingCount = _chatFabController.chatFabWaitingCount.value;

      return AnimatedBuilder(
        animation: _highlightController,
        builder: (context, child) {
          final pulse = highlight ? _highlightController.value : 0.0;
          final backgroundColor = Color.lerp(baseColor, alertColor, pulse * 0.85) ?? baseColor;
          //final backgroundColor = baseColor;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),side: BorderSide(color: AppColor.dividerColor,width: 1.5)),
                heroTag: widget.heroTag,
                tooltip: widget.tooltip,
                onPressed: _openChat,
                backgroundColor: backgroundColor,
                child: child,
              ),
              if (unreadCount > 0)
                PositionedDirectional(
                  top: -4,
                  end: -4,
                  child: _ChatFabCountBadge(
                    count: unreadCount,
                    backgroundColor: AppColor.errorColor,
                  ),
                ),
              if (waitingCount > 0)
                PositionedDirectional(
                  top: -4,
                  start: -4,
                  child: _ChatFabCountBadge(
                    count: waitingCount,
                    backgroundColor: AppColor.purpleColor,
                  ),
                ),
            ],
          );
        },
        child: Icon(
          widget.icon,
          color: widget.iconColor ?? Colors.white,
        ),
      );
    });
  }
}

class _ChatFabCountBadge extends StatelessWidget {
  const _ChatFabCountBadge({
    required this.count,
    required this.backgroundColor,
  });

  final int count;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '+99' : count.toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.textColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTextStyle.bodyText.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColor.textColor,
          height: 1.1,
        ),
      ),
    );
  }
}

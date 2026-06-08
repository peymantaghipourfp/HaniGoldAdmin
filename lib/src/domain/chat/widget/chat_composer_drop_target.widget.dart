import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

/// Wraps the chat composer and accepts OS file drops (Windows, macOS, Linux, web).
class ChatComposerDropTarget extends StatefulWidget {
  const ChatComposerDropTarget({
    super.key,
    required this.controller,
    required this.enabled,
    required this.child,
  });

  final ChatController controller;
  final bool enabled;
  final Widget child;

  /// Desktop and web only; mobile uses the attachment menu instead.
  static bool get isPlatformSupported {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux =>
      true,
      _ => false,
    };
  }

  @override
  State<ChatComposerDropTarget> createState() => _ChatComposerDropTargetState();
}

class _ChatComposerDropTargetState extends State<ChatComposerDropTarget> {
  bool _dragging = false;

  Future<void> _onDragDone(DropDoneDetails detail) async {
    if (!widget.enabled) return;
    final files = _collectDropFiles(detail);
    if (files.isEmpty) return;
    await widget.controller.addAttachmentsFromDrop(files);
  }

  List<XFile> _collectDropFiles(DropDoneDetails detail) {
    final files = <XFile>[];
    for (final item in detail.files) {
      _collectDropItem(item, files);
    }
    return files;
  }

  void _collectDropItem(DropItem item, List<XFile> out) {
    if (item is DropItemDirectory) {
      for (final child in item.children) {
        _collectDropItem(child, out);
      }
      return;
    }
    out.add(item);
  }

  @override
  Widget build(BuildContext context) {
    if (!ChatComposerDropTarget.isPlatformSupported) {
      return widget.child;
    }

    final theme = context.chatTheme;
    final canAccept = widget.enabled;

    return DropTarget(
      enable: canAccept,
      onDragEntered: (_) {
        if (!canAccept) return;
        setState(() => _dragging = true);
      },
      onDragExited: (_) {
        if (_dragging) setState(() => _dragging = false);
      },
      onDragDone: (detail) async {
        if (_dragging) setState(() => _dragging = false);
        await _onDragDone(detail);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_dragging,
              child: AnimatedOpacity(
                opacity: _dragging ? 1 : 0,
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.accent.withAlpha(38),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: theme.accent.withAlpha(200),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_download_outlined,
                          size: 36,
                          color: theme.bubbleSenderNameAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'فایل‌ها را اینجا رها کنید',
                          style: AppTextStyle.bodyText.copyWith(
                            color: theme.bubbleSenderNameAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        /*const SizedBox(height: 4),
                        Text(
                          'تصویر، ویدئو، صدا، سند، PDF یا آرشیو',
                          style: AppTextStyle.bodyText.copyWith(
                            color: theme.onSurfaceMuted,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

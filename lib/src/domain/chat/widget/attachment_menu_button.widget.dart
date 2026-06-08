import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_dialog_internals.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AttachmentMenuButton extends StatelessWidget {
  const AttachmentMenuButton({
    super.key,
    required this.controller,
    required this.enabled,
  });

  final ChatController controller;
  final bool enabled;

  static const _options = <_AttachmentOption>[
    _AttachmentOption('image', Icons.image_outlined, 'تصویر'),
    _AttachmentOption('video', Icons.videocam_outlined, 'ویدئو'),
    _AttachmentOption('audio', Icons.audiotrack_outlined, 'صدا'),
    _AttachmentOption('document', Icons.insert_drive_file_outlined, 'سند'),
    _AttachmentOption('archive', Icons.folder_zip_outlined, 'آرشیو'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return PopupMenuButton<String>(
      enabled: enabled,
      tooltip: 'پیوست فایل',
      constraints: isDesktop ? null : BoxConstraints(minWidth: 20, minHeight: 20),
      icon: Icon(
        Icons.add_circle_outline_rounded,
        color: enabled ? theme.menuIconAccent : theme.onBubbleMuted,
        size: isDesktop ? 24 : 30,
      ),
      position: PopupMenuPosition.over,
      offset: const Offset(0, -250),
      color: theme.menuSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) async {
        switch (value) {
          case 'image':
            await controller.pickImageAttachments();
          case 'video':
            await controller.pickVideoAttachments();
          case 'audio':
            await controller.pickAudioAttachments();
          case 'document':
            await controller.pickDocumentAttachments();
          case 'archive':
            await controller.pickArchiveAttachments();
        }
      },
      onCanceled: controller.scheduleRefocusMessageComposer,
      itemBuilder: (_) => _options
          .map(
            (o) => PopupMenuItem<String>(
              value: o.value,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.menuIconAccent.withAlpha(36),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      kAttachmentTypeIcons[o.value] ?? o.icon,
                      size: 20,
                      color: theme.menuIconAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    kAttachmentTypeLabels[o.value] ?? o.label,
                    style: AppTextStyle.bodyText.copyWith(
                      color: theme.onBubble,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AttachmentOption {
  const _AttachmentOption(this.value, this.icon, this.label);
  final String value;
  final IconData icon;
  final String label;
}

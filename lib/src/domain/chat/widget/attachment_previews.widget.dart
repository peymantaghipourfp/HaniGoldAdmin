import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

import '../controller/chat.controller.dart';
import 'attachment_download_chip.widget.dart';
import '../utils/chat_attachment_utils.dart';
import 'chat_audio_player.widget.dart';
import 'chat_dialog_internals.dart';
import 'chat_image_thumbnail.widget.dart';

class AttachmentPreviews extends StatelessWidget {
  const AttachmentPreviews({
    super.key,
    required this.filesJson,
    required this.controller,
  });

  final String filesJson;
  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    List<dynamic> items;
    try {
      items = json.decode(filesJson) as List<dynamic>;
    } catch (_) {
      return const SizedBox.shrink();
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        final parsed = parseAttachmentEntry(item);
        final recordId = parsed.recordId;
        final fileType = parsed.fileType;
        final cached =
            recordId != null ? controller.getCachedAttachment(recordId) : null;
        final resolvedName = recordId != null
            ? controller.resolvedAttachmentFileName(
          recordId,
          fromFilesJson: parsed.fileName,
        )
            : parsed.fileName;

        if (recordId != null && fileType == 'audio') {
          return ChatAudioPlayer(
            controller: controller,
            recordId: recordId,
            cached: cached,
          );
        }

        if (recordId != null && fileType == 'image') {
          final pixelSize = parsed.imagePixelSize;
          if (cached?.bytes != null) {
            return chatImageAttachmentThumbnail(
              context: context,
              bytes: cached!.bytes!,
              saveFileName: cached.name,
              pixelSize: pixelSize,
            );
          }
          return ChatImageThumbnail(
            controller: controller,
            recordId: recordId,
            fileName: resolvedName,
            pixelSize: pixelSize,
          );
        }

        if (recordId != null) {
          return AttachmentDownloadChip(
            controller: controller,
            recordId: recordId,
            fileType: fileType,
            fileName: resolvedName,
            cached: cached,
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withAlpha(35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  kAttachmentTypeIcons[fileType] ??
                      Icons.insert_drive_file_outlined,
                  size: 18,
                  color: Colors.white.withAlpha(200),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    kAttachmentTypeLabels[fileType] ?? 'پیوست',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

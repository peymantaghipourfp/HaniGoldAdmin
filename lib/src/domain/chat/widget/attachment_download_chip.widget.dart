import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

import '../controller/chat.controller.dart';
import '../utils/chat_attachment_utils.dart';
import 'chat_dialog_internals.dart';

class AttachmentDownloadChip extends StatefulWidget {
  const AttachmentDownloadChip({
    super.key,
    required this.controller,
    required this.recordId,
    required this.fileType,
    this.fileName,
    this.cached,
  });

  final ChatController controller;
  final String recordId;
  final String fileType;
  final String? fileName;
  final ChatPendingAttachment? cached;

  @override
  State<AttachmentDownloadChip> createState() => _AttachmentDownloadChipState();
}

class _AttachmentDownloadChipState extends State<AttachmentDownloadChip> {
  bool _downloading = false;
  bool _failed = false;

  String? get _resolvedFileName =>
      widget.controller.resolvedAttachmentFileName(
        widget.recordId,
        fromFilesJson: widget.fileName,
      ) ??
          chatAttachmentResolvedFileName(
            fileName: widget.fileName,
            cached: widget.cached,
          );

  Future<void> _onTapDownload() async {
    if (_downloading) return;
    setState(() {
      _downloading = true;
      _failed = false;
    });
    try {
      final bytes =
          await widget.controller.fetchChatAttachmentBytes(widget.recordId);
      if (!mounted) return;
      if (bytes == null) {
        setState(() {
          _downloading = false;
          _failed = true;
        });
        return;
      }
      final saveName = _resolvedFileName;
      await saveChatAttachmentBytesToDisk(
        bytes: bytes,
        recordId: widget.recordId,
        fileType: widget.fileType,
        fileName: saveName,
        cached: widget.cached,
      );
      if (!mounted) return;
      Get.snackbar(
        'ذخیره',
        'فایل ذخیره شد',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        'خطا',
        'دانلود ناموفق: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      _failed = true;
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _resolvedFileName ??
        kAttachmentTypeLabels[widget.fileType] ??
        'پیوست';
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _downloading ? null : _onTapDownload,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _failed
                    ? Colors.redAccent.withAlpha(160)
                    : Colors.white.withAlpha(35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  kAttachmentTypeIcons[widget.fileType] ??
                      Icons.insert_drive_file_outlined,
                  size: 22,
                  color: Colors.white.withAlpha(200),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 12,
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                      if (widget.cached != null)
                        Text(
                          formatAttachmentSize(widget.cached!.sizeBytes),
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 10,
                            color: Colors.white.withAlpha(140),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                if (_downloading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white54,
                    ),
                  )
                else
                  Icon(
                    Icons.download_outlined,
                    size: 22,
                    color: Colors.white.withAlpha(200),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

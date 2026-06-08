import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/utils/chat_attachment_utils.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_dialog_internals.dart';

class AttachmentChip extends StatelessWidget {
  const AttachmentChip({
    super.key,
    required this.attachment,
    required this.isUploading,
    required this.onRemove,
  });

  final ChatPendingAttachment attachment;
  final bool isUploading;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final failed = attachment.failed.value;
      final progress = attachment.progress.value;
      final borderColor =
          failed ? Colors.red.withAlpha(200) : AppColor.textColor.withAlpha(50);

      return Container(
        margin: const EdgeInsets.only(left: 8),
        constraints: const BoxConstraints(maxWidth: 160),
        decoration: BoxDecoration(
          color: failed
              ? Colors.red.withAlpha(30)
              : AppColor.secondary50Color.withAlpha(180),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 4, 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    kAttachmentTypeIcons[attachment.fileType] ??
                        Icons.insert_drive_file_outlined,
                    size: 16,
                    color: failed ? Colors.red : AppColor.buttonColor,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          attachment.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 11,
                            color: AppColor.textColor,
                          ),
                        ),
                        Text(
                          failed
                              ? 'آپلود ناموفق'
                              : formatAttachmentSize(attachment.sizeBytes),
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 10,
                            color: failed
                                ? Colors.red
                                : AppColor.textColor.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onRemove,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: onRemove != null
                            ? AppColor.textColor.withAlpha(170)
                            : AppColor.textColor.withAlpha(60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isUploading && !failed && progress > 0 && progress < 1.0)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: AppColor.textColor.withAlpha(30),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor.buttonColor),
                ),
              ),
          ],
        ),
      );
    });
  }
}

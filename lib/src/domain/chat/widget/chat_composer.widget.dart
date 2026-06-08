import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/attachment_chip.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/attachment_menu_button.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_composer_drop_target.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_composer_input_trailing.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_emoji_picker_sheet.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/forward_preview_bar.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/reply_preview_bar.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.canCompose,
  });

  final ChatController controller;
  final bool canCompose;

  @override
  Widget build(BuildContext context) {
    if (!canCompose) return const SizedBox.shrink();

    return _ChatComposerShell(controller: controller);
  }
}

class _ChatComposerShell extends StatefulWidget {
  const _ChatComposerShell({required this.controller});

  final ChatController controller;

  @override
  State<_ChatComposerShell> createState() => _ChatComposerShellState();
}

class _ChatComposerShellState extends State<_ChatComposerShell> {
  bool _emojiPanelOpen = false;
  bool _voiceRecording = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final theme = context.chatTheme;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() {
      final replyMsg = controller.replyToMessage.value;
      final forwardMsg = controller.pendingForwardMessage.value;
      final isSending = controller.isSendingMessage.value;
      final isUploading = controller.isUploadingAttachments.value;
      final isBusy = isSending || isUploading;
      final isEmpty = controller.isComposerEmpty.value;
      final hasAttachments = controller.pendingAttachments.isNotEmpty;
      final canSendWithoutText = forwardMsg != null || replyMsg != null;
      final customerTyping =
          controller.isCustomerTyping.value && isEmpty;
      final composerHint = customerTyping
          ? 'در حال تایپ...'
          : hasAttachments
          ? 'کپشن (اختیاری)...'
          : forwardMsg != null
          ? 'کپشن (اختیاری)...'
          : replyMsg != null
          ? 'پاسخ خود را بنویسید...'
          : 'پیام خود را بنویسید...';

      return Padding(
        padding: isDesktop ? EdgeInsets.fromLTRB(12, 0, 12, 12) : EdgeInsets.fromLTRB(4, 0, 4, 10),
        child: ChatComposerDropTarget(
          controller: controller,
          enabled: !isBusy && !_voiceRecording,
          child: Material(
            color: theme.composerSurface,
            elevation: 2,
            shadowColor: Colors.black.withAlpha(60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(color: theme.composerBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (forwardMsg != null)
                  ChatForwardPreviewBar(
                    message: forwardMsg,
                    fallbackUserName: controller.currentUserName,
                    controller: controller,
                    onDismiss: controller.cancelForward,
                  )
                else if (replyMsg != null)
                  ChatReplyPreviewBar.fromMessage(
                    message: replyMsg,
                    fallbackUserName: controller.currentUserName,
                    onDismiss: controller.cancelReply,
                  ),
                if (hasAttachments)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: theme.composerBorder),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          controller.pendingAttachments.length,
                          (i) => AttachmentChip(
                            key: ValueKey(i),
                            attachment: controller.pendingAttachments[i],
                            isUploading: isUploading,
                            onRemove: isBusy
                                ? null
                                : () => controller.removeAttachment(i),
                          ),
                        ),
                      ),
                    ),
                  ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.fastOutSlowIn,
                  alignment: Alignment.topCenter,
                  child: _emojiPanelOpen
                      ? SizedBox(
                          height: 260,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ChatEmojiPickerPanel(
                              textController: controller.messageController,
                              onClose: () {
                                setState(() => _emojiPanelOpen = false);
                                controller.scheduleRefocusMessageComposer();
                              },
                              onRestoreComposerFocus:
                              controller.scheduleRefocusMessageComposer,
                            ),
                          ),
                        )
                      : const SizedBox(height: 0, width: double.infinity),
                ),
                Padding(
                  padding: isDesktop ? EdgeInsets.fromLTRB(4, 4, 6, 6) : EdgeInsets.fromLTRB(2, 4, 1, 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: _emojiPanelOpen ? 'بستن ایموجی' : 'ایموجی',
                        child: IconButton(
                          padding: isDesktop ? null : EdgeInsetsDirectional.only(end: 0),
                          visualDensity:isDesktop ? null : VisualDensity.compact,
                          constraints: isDesktop ? null : BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          onPressed: isBusy || _voiceRecording ? null
                              : () {
                            setState(
                                  () => _emojiPanelOpen = !_emojiPanelOpen,
                            );
                            controller.scheduleRefocusMessageComposer();
                          },
                          icon: Icon(
                            _emojiPanelOpen
                                ? Icons.emoji_emotions_rounded
                                : Icons.emoji_emotions_outlined,
                            color: _emojiPanelOpen
                                ? theme.bubbleReplyAccent
                                : theme.onBubbleMuted,
                            size: isDesktop ? 24 : 30,
                          ),
                        ),
                      ),
                      AttachmentMenuButton(
                        controller: controller,
                        enabled: !isBusy && !_voiceRecording,
                      ),
                      Expanded(
                        child: ChatComposerInputTrailing(
                          controller: controller,
                          isDesktop: isDesktop,
                          isBusy: isBusy,
                          isEmpty: isEmpty,
                          hasAttachments: hasAttachments,
                          canSendWithoutText: canSendWithoutText,
                          composerHint: composerHint,
                          customerTyping: customerTyping,
                          onVoiceRecordingChanged: (recording) {
                            if (_emojiPanelOpen && recording) {
                              setState(() => _emojiPanelOpen = false);
                            }
                            setState(() => _voiceRecording = recording);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

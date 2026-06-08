import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/widget/attachment_previews.widget.dart';
import 'package:hanigold_admin/src/domain/chat/widget/dialogs/add_user_dialog.dart';
import 'package:hanigold_admin/src/domain/chat/widget/swipe_toReply.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../utils/chat_emoji_grapheme.dart';
import '../utils/chat_message_time.dart';


void showChatMessageActions(
  BuildContext context,
  ChatController controller,
  ChatMessageModel msg,
) {
  final theme = context.chatTheme;
  final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
  final actions = <Widget>[
    ListTile(
      leading: Icon(Icons.reply_rounded, color: theme.bubbleReplyAccent),
      title: const Text('پاسخ'),
      onTap: () {
        Navigator.of(context).pop();
        controller.setReplyMessage(msg);
      },
    ),
    if (msg.isDeleted != true)
      ListTile(
        leading:
        SvgPicture.asset(
          'assets/svg/forward-left.svg',
          height: 18,
          colorFilter: ColorFilter.mode(
            theme.bubbleReplyAccent,
            BlendMode.srcIn,
          ),
        ),
        title: const Text('بازنشر'),
        onTap: () {
          Navigator.of(context).pop();
          startForwardMessageFlow(context, controller, msg);
        },
      ),
    if (msg.text?.isNotEmpty == true)
      ListTile(
        leading: const Icon(Icons.copy_rounded),
        title: const Text('کپی'),
        onTap: () async {
          Navigator.of(context).pop();
          await Clipboard.setData(ClipboardData(text: msg.text ?? ''));
          Get.snackbar(
            '',
            'متن کپی شد',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColor.secondary50Color,
            colorText: AppColor.textColor,
          );
        },
      ),
  ];

  if (isDesktop) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + box.size.width,
        offset.dy + box.size.height,
      ),
      items:
          actions.map((w) => PopupMenuItem(enabled: false, child: w)).toList(),
      color: theme.menuSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  } else {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.menuSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.onBubbleMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ...actions,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Max bubble width as a fraction of the conversation message-area width (tablet+).
const double kChatBubbleMaxWidthFraction = 0.5;

/// Max bubble width on mobile (at most this fraction of the message-area width).
const double kChatBubbleMaxWidthFractionMobile = 0.85;

double chatBubbleMaxWidthFraction(BuildContext context) {
  if (ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
    return kChatBubbleMaxWidthFraction;
  }
  return kChatBubbleMaxWidthFractionMobile;
}

/// One chat row: bubble + optional swipe-to-reply.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.controller,
    required this.message,
    required this.isFromCurrentUser,
    required this.isFromSystem,
    required this.maxBubbleWidth,
    this.showSenderName = true,
    this.isTail = true,
  });

  final ChatController controller;
  final ChatMessageModel message;
  final bool isFromCurrentUser;
  final bool isFromSystem;
  final double maxBubbleWidth;
  final bool showSenderName;
  final bool isTail;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final bottomMargin = isTail ? 8.0 : 3.0;
    final replyMessage = message.replyMessage;
    final forwardMessage = message.forwardMessage;
    final isForwarded = message.isForwarded;


    const messageBodyBaseFont = 13.0;
    final messageBodyBaseStyle = AppTextStyle.bodyText.copyWith(
      color: theme.onBubble,
      fontSize: messageBodyBaseFont,
      height: 1.45,
    );
    final messageBodyEmojiStyle = messageBodyBaseStyle.copyWith(
      fontSize: messageBodyBaseFont * 1.55,
    );

    final bubbleColor = isFromCurrentUser
        ? theme.bubbleOutgoing
        : isFromSystem
            ? theme.bubbleSystem
            : theme.bubbleIncoming;

    final replyAccent = isFromCurrentUser
        ? theme.bubbleReplyAccent
        : isFromSystem
            ? theme.bubbleReplyQuoteSystem
            : theme.bubbleReplyQuoteIncoming;

    final bubbleBorderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(
        isFromCurrentUser || isFromSystem ? 18 : (isTail ? 4 : 18),
      ),
      bottomRight: Radius.circular(
        isFromCurrentUser || isFromSystem ? (isTail ? 4 : 18) : 18,
      ),
    );

    final Widget bubbleContent = Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Column(
        crossAxisAlignment: isFromCurrentUser || isFromSystem
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Obx(() {
            final highlighted = controller.highlightedBubbleId.value ==
                controller.bubbleIdentity(message);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: bubbleBorderRadius,
                border: highlighted
                    ? Border.all(color: theme.bubbleReplyAccent, width: 2.5)
                    : null,
                gradient: isFromCurrentUser ? theme.bubbleOutgoingGradient : null,
                color: isFromCurrentUser && theme.bubbleOutgoingGradient != null
                    ? null
                    : (highlighted
                    ? Color.alphaBlend(
                  theme.bubbleReplyAccent.withAlpha(72),
                  bubbleColor,
                )
                    : bubbleColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(28),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  if (highlighted)
                    BoxShadow(
                      color: theme.bubbleReplyAccent.withAlpha(140),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showSenderName &&
                        !isFromCurrentUser &&
                        message.senderAccountName != null) ...[
                      Text(
                        message.senderAccountName!,
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.bubbleSenderNameAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (isForwarded) ...[
                      /*Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.forward_rounded,
                            size: 13,
                            color: theme.onBubbleMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'بازنشر',
                            style: AppTextStyle.bodyText.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.onBubbleMuted,
                            ),
                          ),
                        ],
                      ),*/
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/forward-left.svg',
                            height: 13,
                            colorFilter: ColorFilter.mode(
                              theme.bubbleSenderNameAccent.withAlpha(200),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'بازنشر از ${message.forwardFromSenderName ?? forwardMessage?.senderAccountName ?? 'کاربر'}',
                            style: AppTextStyle.bodyText.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.bubbleReplyAccent,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (replyMessage != null) ...[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () =>
                              controller.scrollToReplyParent(message),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: theme.onBubble.withAlpha(18),
                              borderRadius: BorderRadius.circular(10),
                              border: Border(
                                right: BorderSide(color: replyAccent, width: 3),
                              ),
                            ),
                            child: Text(
                              replyEmbeddedMessagePreviewBody(replyMessage),
                              style: AppTextStyle.bodyText.copyWith(
                                fontSize: 11,
                                color: theme.onBubbleMuted,
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (isForwarded && forwardMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: theme.onBubble.withAlpha(18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            right: BorderSide(color: replyAccent, width: 3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (forwardMessage.filesJson != null &&
                                forwardMessage.filesJson!.isNotEmpty) ...[
                              AttachmentPreviews(
                                filesJson: forwardMessage.filesJson!,
                                controller: controller,
                              ),
                              if (forwardMessage.text?.isNotEmpty == true)
                                const SizedBox(height: 6),
                            ],
                            if (forwardMessage.text?.isNotEmpty == true)
                              Text(
                                forwardEmbeddedMessagePreviewBody(
                                  forwardMessage,
                                ),
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 11,
                                  color: theme.onBubbleMuted,
                                  height: 1.35,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    if (!isForwarded &&
                        message.filesJson != null &&
                        message.filesJson!.isNotEmpty) ...[
                      AttachmentPreviews(
                        filesJson: message.filesJson!,
                        controller: controller,
                      ),
                      if (message.text?.isNotEmpty == true)
                        const SizedBox(height: 6),
                    ],
                    if (message.text?.isNotEmpty == true)
                      Text.rich(
                        TextSpan(
                          style: messageBodyBaseStyle,
                          children: buildEmojiAwareTextSpans(
                            message.text!,
                            messageBodyBaseStyle,
                            messageBodyEmojiStyle,
                          ),
                        ),
                      ),
                    if (isTail) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatChatMessageBubbleTime(message.createdOnUtc),
                            style: AppTextStyle.bodyText.copyWith(
                              fontSize: 10,
                              color: theme.onBubbleMuted,
                            ),
                          ),
                          if (isFromCurrentUser) ...[
                            const SizedBox(width: 4),
                            Icon(
                              message.seen == true || message.seenOnUtc != null
                                  ? Icons.done_all_rounded
                                  : Icons.done_rounded,
                              size: 15,
                              color: message.seen == true || message.seenOnUtc != null
                                  ? theme.bubbleReplyAccent
                                  : theme.onBubbleMuted,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            );
          }),
        ],
      ),
    );
    final forwardButton = message.isDeleted == true || isFromSystem
        ? const SizedBox.shrink()
        : IconButton(
      onPressed: () =>
          startForwardMessageFlow(context, controller, message),
      tooltip: 'بازنشر',
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      icon:isFromCurrentUser ? SvgPicture.asset(
        'assets/svg/forward-left.svg',
        height: 18,
        colorFilter: ColorFilter.mode(
          theme.onSurfaceVariant.withAlpha(200),
          BlendMode.srcIn,
        ),
      ) : SvgPicture.asset(
        'assets/svg/forward-right.svg',
        height: 18,
        colorFilter: ColorFilter.mode(
          theme.onSurfaceVariant.withAlpha(200),
          BlendMode.srcIn,
        ),
      ),
    );

    final Widget messageContent = Align(
      alignment: isFromCurrentUser || isFromSystem
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: isFromCurrentUser || isFromSystem
            ? [bubbleContent, forwardButton]
            : [forwardButton, bubbleContent],
      ),
    );

    return GestureDetector(
      onLongPress: () {
        if(isFromSystem) return null;
        showChatMessageActions(context, controller, message);
        },
      child: SwipeToReply(
        enabled: !isFromSystem,
        alignment: isFromCurrentUser
            ? SwipeToReplyAlignment.outgoing
            : SwipeToReplyAlignment.incoming,
        onSwipe: () => controller.setReplyMessage(message),
        child: messageContent,
      ),
    );
  }
}

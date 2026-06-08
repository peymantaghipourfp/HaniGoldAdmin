import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';

/// Outbound `chat.admin.send` body fields after applying forward fallbacks.
class ForwardAdminSendPayload {
  const ForwardAdminSendPayload({this.text, this.filesJson});

  final String? text;
  final String? filesJson;
}

/// Server requires non-null [text] or [filesJson]. For caption-less forwards,
/// copy the source message body from [forwardSource].
ForwardAdminSendPayload resolveForwardAdminSendPayload({
  required String? userCaption,
  required String? userFilesJson,
  required ChatMessageModel? forwardSource,
}) {
  var text = userCaption?.trim();
  var filesJson = userFilesJson?.trim();

  if (forwardSource == null) {
    return ForwardAdminSendPayload(
      text: (text != null && text.isNotEmpty) ? text : null,
      filesJson: (filesJson != null && filesJson.isNotEmpty) ? filesJson : null,
    );
  }

  final snapshot = forwardSource.toForwardMessageSnapshot();
  final sourceText = snapshot?.text?.trim();
  final sourceFiles = snapshot?.filesJson?.trim();

  if ((text == null || text.isEmpty) &&
      sourceText != null &&
      sourceText.isNotEmpty) {
    text = sourceText;
  }
  if ((filesJson == null || filesJson.isEmpty) &&
      sourceFiles != null &&
      sourceFiles.isNotEmpty) {
    filesJson = sourceFiles;
  }

  return ForwardAdminSendPayload(
    text: (text != null && text.isNotEmpty) ? text : null,
    filesJson: (filesJson != null && filesJson.isNotEmpty) ? filesJson : null,
  );
}

/// Hides duplicate top-level [ChatMessageModel.text] when the server echoes
/// source body in `text` for a caption-less forward transport.
ChatMessageModel finalizeCaptionlessForwardDisplay(
    ChatMessageModel message, {
      ChatMessageModel? optimisticFallback,
    }) {
  if (!message.isForwarded || message.forwardMessage == null) return message;

  final hadUserCaption = optimisticFallback?.text?.trim().isNotEmpty == true;
  if (hadUserCaption) return message;

  final top = message.text?.trim();
  final embedded = message.forwardMessage!.text?.trim();
  if (top == null || top.isEmpty || embedded == null || top != embedded) {
    return message;
  }

  return ChatMessageModel(
    rowNum: message.rowNum,
    chatId: message.chatId,
    messageGuid: message.messageGuid,
    replyToMessageGuid: message.replyToMessageGuid,
    replyMessage: message.replyMessage,
    forwardFromMessageGuid: message.forwardFromMessageGuid,
    forwardFromSenderName: message.forwardFromSenderName,
    forwardMessage: message.forwardMessage,
    seq: message.seq,
    senderType: message.senderType,
    senderAccountId: message.senderAccountId,
    senderUserId: message.senderUserId,
    messageType: message.messageType,
    text: null,
    createdOnUtc: message.createdOnUtc,
    isDeleted: message.isDeleted,
    deliveredOnUtc: message.deliveredOnUtc,
    seenOnUtc: message.seenOnUtc,
    seen: message.seen,
    senderAccountName: message.senderAccountName,
    replyToSeq: message.replyToSeq,
    forwardFromSeq: message.forwardFromSeq,
    filesJson: message.filesJson,
  );
}

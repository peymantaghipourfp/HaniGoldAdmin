import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';

/// Messages in [messages] with [seq] strictly greater than [seenUpToSeq].
int countMessagesWithSeqAbove(
    Iterable<ChatMessageModel> messages,
    int seenUpToSeq,
    ) {
  var n = 0;
  for (final m in messages) {
    final s = m.seq;
    if (s != null && s > seenUpToSeq) n++;
  }
  return n;
}

/// Pill badge count after the admin has read up to [newSeenSeq].
///
/// Uses loaded messages when they cover the thread tail; otherwise decrements
/// [serverUnread] by how far [newSeenSeq] advanced past [anchorSeenSeq].
int conversationUnreadAfterSeen({
  required int serverUnread,
  required int anchorSeenSeq,
  required int newSeenSeq,
  required Iterable<ChatMessageModel> loadedMessages,
  required int lastMessageSeq,
  required int maxLoadedSeq,
}) {
  if (newSeenSeq <= anchorSeenSeq) {
    return serverUnread.clamp(0, 999999);
  }

  if (maxLoadedSeq >= lastMessageSeq && lastMessageSeq > 0) {
    return countMessagesWithSeqAbove(loadedMessages, newSeenSeq);
  }

  final progressed = (newSeenSeq - anchorSeenSeq).clamp(0, serverUnread);
  return (serverUnread - progressed).clamp(0, serverUnread);
}

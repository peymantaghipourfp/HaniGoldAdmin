import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/chat/utils/chat_open_conversation_match.dart';

/// Locates the local optimistic row to replace when a `chat.message` echo arrives.
int indexOfOutgoingOptimisticMatch({
  required List<ChatMessageModel> messages,
  required String chatId,
  required String? incomingMessageGuid,
  required String pendingReqId,
}) {
  final incomingGuid = incomingMessageGuid?.trim();
  if (incomingGuid != null && incomingGuid.isNotEmpty) {
    final byGuid = messages.indexWhere(
          (m) =>
      m.messageGuid == incomingGuid &&
          (m.chatId == kOptimisticNewChatPlaceholderChatId ||
              chatIdsEqual(m.chatId, chatId)),
    );
    if (byGuid != -1) return byGuid;
  }

  final req = pendingReqId.trim();
  if (req.isEmpty) return -1;

  return messages.indexWhere(
        (m) =>
    m.messageGuid == req &&
        (m.senderType == 1 || m.senderType == 2) &&
        (m.chatId == kOptimisticNewChatPlaceholderChatId ||
            chatIdsEqual(m.chatId, chatId)),
  );
}

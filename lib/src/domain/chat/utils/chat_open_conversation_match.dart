import 'package:hanigold_admin/src/domain/chat/utils/chat_typing_match.dart';

/// Normalized comparison for server/client chat GUID strings.
bool chatIdsEqual(String? a, String? b) {
  if (a == null || b == null) return false;
  final na = a.trim();
  final nb = b.trim();
  if (na.isEmpty || nb.isEmpty) return false;
  return na.toLowerCase() == nb.toLowerCase();
}

/// Placeholder [ChatMessageModel.chatId] for the first outbound message before pick.
const String kOptimisticNewChatPlaceholderChatId = '__pending_new_chat__';

/// Whether an inbound `chat.message` belongs in the currently visible conversation.
bool incomingChatMessageMatchesOpenConversation({
  required String incomingChatId,
  required String? selectedChatId,
  required Iterable<String?> loadedMessageChatIds,
  required bool hasOpenComposerConversation,
  required int? messageCustomerAccountId,
  required String? messageTopicCode,
  required String? messageTopicKey,
  required int? openCustomerAccountId,
  required String? openTopicCode,
  required String? openTopicKey,
  required bool hasOptimisticDraftForMessageGuid,
}) {
  if (chatIdsEqual(selectedChatId, incomingChatId)) return true;

  final normalizedIncoming = incomingChatId.trim().toLowerCase();
  for (final raw in loadedMessageChatIds) {
    final id = raw?.trim().toLowerCase();
    if (id == null || id.isEmpty) continue;
    if (id == kOptimisticNewChatPlaceholderChatId) continue;
    if (id == normalizedIncoming) return true;
  }

  if (hasOptimisticDraftForMessageGuid) return true;

  if (!hasOpenComposerConversation) return false;
  if (!chatTypingMatchesOpenConversation(
    eventCustomerAccountId: messageCustomerAccountId,
    eventTopicCode: messageTopicCode,
    eventTopicKey: messageTopicKey,
    openCustomerAccountId: openCustomerAccountId,
    openTopicCode: openTopicCode,
    openTopicKey: openTopicKey,
  )) {
    return false;
  }

  if (selectedChatId == null || selectedChatId.trim().isEmpty) return true;
  return chatIdsEqual(selectedChatId, incomingChatId);
}

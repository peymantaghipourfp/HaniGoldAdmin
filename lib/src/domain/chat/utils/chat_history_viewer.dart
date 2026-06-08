import 'package:hanigold_admin/src/domain/chat/model/chat_history.model.dart';

/// Returns a copy of [history] without the viewer matching [accountId].
/// Used for optimistic UI after a successful revoke.
ChatHistoryModel chatHistoryRemovingViewer(
    ChatHistoryModel history,
    int accountId,
    ) {
  final old = history.viewers;
  if (old == null || old.isEmpty) return history;
  final filtered = old
      .where((v) => v.adminAccountId != accountId)
      .toList(growable: false);
  if (filtered.length == old.length) return history;
  return ChatHistoryModel(
    chatId: history.chatId,
    customerAccountId: history.customerAccountId,
    customerAccountName: history.customerAccountName,
    topicId: history.topicId,
    topicCode: history.topicCode,
    topicTitle: history.topicTitle,
    topicKey: history.topicKey,
    status: history.status,
    currentOwnerAdminAccountId: history.currentOwnerAdminAccountId,
    currentOwnerAdminUserId: history.currentOwnerAdminUserId,
    currentOwnerAdminName: history.currentOwnerAdminName,
    createdOn: history.createdOn,
    lastActivity: history.lastActivity,
    closedOn: history.closedOn,
    firstPicker: history.firstPicker,
    closedBy: history.closedBy,
    forwards: history.forwards,
    viewers: filtered.isEmpty ? null : filtered,
  );
}

/// Whether [myAdminAccountId] may revoke [viewer]'s access on [history].
bool canRevokeChatHistoryViewer({
  required int? myAdminAccountId,
  required ChatHistoryModel history,
  required Viewer viewer,
}) {
  if (myAdminAccountId == null || viewer.adminAccountId == null) return false;
  if (viewer.hasCurrentAccess == false) return false;
  final owner = history.currentOwnerAdminAccountId;
  final grantedBy = viewer.grantedByAdminAccountId;
  return myAdminAccountId == owner || myAdminAccountId == grantedBy;
}

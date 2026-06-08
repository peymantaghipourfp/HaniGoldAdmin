import 'dart:convert';

import 'package:hanigold_admin/src/domain/chat/model/socket_chat_typing.model.dart'
as typing;
import 'package:hanigold_admin/src/domain/chat/utils/chat_typing_match.dart';

const String kChatTypingChannel = 'chat.typing';

/// Decodes a socket frame; returns inner `data` when [channel] is [kChatTypingChannel].
Map<String, dynamic>? chatTypingDataFromSocketFrame(dynamic rawData) {
  final dynamic decoded = rawData is String ? json.decode(rawData) : rawData;
  if (decoded is! Map<String, dynamic>) return null;
  if (decoded['channel']?.toString() != kChatTypingChannel) return null;
  final data = decoded['data'];
  if (data is! Map<String, dynamic>) return null;
  return data;
}

/// `true` = customer typing on, `false` = off, `null` = ignore for current composer.
bool? customerTypingFlagFromSocketData({
  required Map<String, dynamic> data,
  required int? openCustomerAccountId,
  required String? openTopicCode,
  required String? openTopicKey,
}) {
  final code = openTopicCode?.trim();
  if (openCustomerAccountId == null || code == null || code.isEmpty) {
    return null;
  }

  final payload = typing.Data.fromJson(data);
  if (!chatTypingMatchesOpenConversation(
    eventCustomerAccountId: payload.customerAccountId,
    eventTopicCode: payload.topicCode,
    eventTopicKey: payload.topicKey,
    openCustomerAccountId: openCustomerAccountId,
    openTopicCode: openTopicCode,
    openTopicKey: openTopicKey,
  )) {
    return null;
  }

  if (payload.isTyping == true) return true;
  if (payload.isTyping == false) return false;
  return null;
}

/// Full `chat.typing` frame → typing flag for the open composer, or `null`.
bool? customerTypingFlagFromSocketFrame({
  required dynamic rawData,
  required int? openCustomerAccountId,
  required String? openTopicCode,
  required String? openTopicKey,
}) {
  final data = chatTypingDataFromSocketFrame(rawData);
  if (data == null) return null;
  return customerTypingFlagFromSocketData(
    data: data,
    openCustomerAccountId: openCustomerAccountId,
    openTopicCode: openTopicCode,
    openTopicKey: openTopicKey,
  );
}

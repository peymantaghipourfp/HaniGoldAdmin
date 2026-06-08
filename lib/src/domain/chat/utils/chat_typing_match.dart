/// Whether a `chat.typing` payload targets the conversation open in the composer.
bool chatTypingMatchesOpenConversation({
  required int? eventCustomerAccountId,
  required String? eventTopicCode,
  required String? eventTopicKey,
  required int? openCustomerAccountId,
  required String? openTopicCode,
  required String? openTopicKey,
}) {
  if (eventCustomerAccountId == null || openCustomerAccountId == null) {
    return false;
  }
  if (eventCustomerAccountId != openCustomerAccountId) return false;

  final eventCode = eventTopicCode?.trim();
  final openCode = openTopicCode?.trim();
  if (eventCode == null ||
      eventCode.isEmpty ||
      openCode == null ||
      openCode.isEmpty) {
    return false;
  }
  if (eventCode != openCode) return false;

  final eventKey = eventTopicKey?.trim();
  final openKey = openTopicKey?.trim();
  if (eventKey != null &&
      eventKey.isNotEmpty &&
      openKey != null &&
      openKey.isNotEmpty) {
    return eventKey == openKey;
  }
  return true;
}

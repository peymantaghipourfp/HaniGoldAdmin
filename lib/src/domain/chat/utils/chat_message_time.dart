import 'package:persian_number_utility/persian_number_utility.dart';

/// API/socket fields named `*Utc` are UTC instants; UI and grouping use device local time.
DateTime? chatMessageLocalTime(DateTime? value) {
  if (value == null) return null;
  return value.isUtc ? value.toLocal() : value;
}

/// Bubble footer timestamp (Persian calendar, local wall clock).
String formatChatMessageBubbleTime(DateTime? createdOnUtc) {
  final local = chatMessageLocalTime(createdOnUtc);
  return local?.toPersianDate(
    twoDigits: true,
    showTime: true,
    timeSeprator: ':',
  ) ??
      '';
}
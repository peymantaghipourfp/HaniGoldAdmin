import 'package:persian_number_utility/persian_number_utility.dart';

import '../model/chat_message.model.dart';
import '../utils/chat_message_time.dart';

sealed class ChatRow {}

class DayHeaderRow extends ChatRow {
  DayHeaderRow(this.day);
  final DateTime day;
}

class BubbleRow extends ChatRow {
  BubbleRow({
    required this.msg,
    required this.showSenderName,
    required this.isTail,
  });
  final ChatMessageModel msg;

  /// Show the sender-name label above this bubble (first message in a run).
  final bool showSenderName;

  /// Last message in a consecutive run → render timestamp + full tail radius.
  final bool isTail;
}

/// Builds a flat list of [ChatRow] items from a **reverse-ordered** message
/// list (index 0 = newest). With [ListView.reverse] = true, larger row indices
/// render **above** smaller ones; day headers are appended after the last
/// (oldest-in-list) bubble of each calendar day so the tag sits above that
/// day's message block. Consecutive same-sender runs are merged for labels.
List<ChatRow> buildChatRows(List<ChatMessageModel> messages) {
  final rows = <ChatRow>[];

  // Same-sender run detection (1-minute window).
  bool sameSenderRun(ChatMessageModel? a, ChatMessageModel? b) {
    if (a == null || b == null) return false;
    if (a.senderType != b.senderType) return false;
    if (a.senderAccountId != b.senderAccountId) return false;
    final ta = chatMessageLocalTime(a.createdOnUtc);
    final tb = chatMessageLocalTime(b.createdOnUtc);
    if (ta == null || tb == null) return false;
    return ta.difference(tb).abs() < const Duration(minutes: 1);
  }

  DateTime? dateOnlyLocal(ChatMessageModel m) {
    final d = chatMessageLocalTime(m.createdOnUtc);
    if (d == null) return null;
    return DateTime(d.year, d.month, d.day);
  }

  for (int i = 0; i < messages.length; i++) {
    final msg = messages[i];
    final prevMsg = (i + 1 < messages.length) ? messages[i + 1] : null;
    final nextMsg = (i - 1 >= 0) ? messages[i - 1] : null;

    final showSenderName = !sameSenderRun(msg, prevMsg);
    final isTail = !sameSenderRun(msg, nextMsg);

    rows.add(
      BubbleRow(msg: msg, showSenderName: showSenderName, isTail: isTail),
    );

    final dHere = dateOnlyLocal(msg);
    final dOlder = prevMsg == null ? null : dateOnlyLocal(prevMsg);
    final isLastChunkOfDay = i == messages.length - 1 ||
        (dHere != null && dOlder != null && dHere != dOlder);
    if (isLastChunkOfDay && dHere != null) {
      rows.add(DayHeaderRow(dHere));
    }
  }

  return rows;
}

/// ListView row index of the bubble that displays [target], or null if not found.
/// Used with [ScrollController.jumpTo] before [Scrollable.ensureVisible] so lazy
/// [ListView.builder] children get built.
int? indexOfBubbleRowForMessage(List<ChatMessageModel> messages, ChatMessageModel target) {
  final rows = buildChatRows(messages);
  final tg = target.messageGuid?.trim().toLowerCase();
  final cid = target.chatId?.toString().trim();
  for (var i = 0; i < rows.length; i++) {
    if (rows[i] is! BubbleRow) continue;
    final m = (rows[i] as BubbleRow).msg;
    if (tg != null && tg.isNotEmpty) {
      if (m.messageGuid?.trim().toLowerCase() == tg) return i;
    } else if (target.seq != null &&
        m.seq == target.seq &&
        m.chatId?.toString().trim() == cid) {
      return i;
    }
  }
  return null;
}

/// Formats a local [DateTime] into Persian "امروز" / "دیروز" / date.
String formatDayLabel(DateTime day) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == today) return 'امروز';
  if (day == yesterday) return 'دیروز';
  return day.toPersianDate(twoDigits: true, showTime: false);
}

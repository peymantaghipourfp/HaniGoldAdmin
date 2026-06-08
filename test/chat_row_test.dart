import 'package:flutter_test/flutter_test.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_row.dart';

void main() {
  group('buildChatRows', () {
    test('merges consecutive same-sender bubbles', () {
      final t = DateTime.utc(2026, 5, 20, 12, 0);
      ChatMessageModel row({
        required int seq,
        required DateTime createdOnUtc,
      }) =>
          ChatMessageModel(
            rowNum: seq,
            chatId: 'c1',
            messageGuid: 'g$seq',
            replyToMessageGuid: null,
            replyMessage: null,
            forwardFromMessageGuid: null,
            forwardFromSenderName: null,
            forwardMessage: null,
            seq: seq,
            senderType: 2,
            senderAccountId: 10,
            senderUserId: null,
            messageType: 1,
            text: 'hi',
            createdOnUtc: createdOnUtc,
            isDeleted: false,
            deliveredOnUtc: null,
            seenOnUtc: null,
            seen: null,
            senderAccountName: 'User',
            replyToSeq: null,
            forwardFromSeq: null,
          );

      final messages = [
        row(seq: 2, createdOnUtc: t),
        row(seq: 1, createdOnUtc: t.subtract(const Duration(minutes: 1))),
      ];

      final rows = buildChatRows(messages);
      final bubbles = rows.whereType<BubbleRow>().toList();

      expect(bubbles.length, 2);
      // Newest-first list: first row is newest message in the run (no tail).
      expect(bubbles.first.isTail, isTrue);
      expect(bubbles.last.showSenderName, isTrue);
      expect(bubbles.last.isTail, isFalse);
    });
  });
}

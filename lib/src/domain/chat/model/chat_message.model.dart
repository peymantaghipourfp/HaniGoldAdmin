import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../utils/chat_attachment_pick.dart';

part 'chat_message.model.g.dart';

List<ChatMessageModel> chatMessageModelFromJson(String str) => List<ChatMessageModel>.from(json.decode(str).map((x) => ChatMessageModel.fromJson(x)));

String chatMessageModelToJson(List<ChatMessageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Converts the server's `filesJson` field to a canonical JSON string.
///
/// The API returns either:
///   - A JSON **array**  (history endpoint) — encoded back to a string.
///   - A JSON **string** (local optimistic path) — passed through as-is.
///   - `null` / empty array — returned as null.
/// Public entry for socket/API payloads (same rules as [_filesJsonFromJson]).
String? normalizeChatMessageFilesJson(dynamic value) =>
    _filesJsonFromJson(value);

String? _filesJsonFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final s = value.trim();
    if (s.isEmpty) return null;
    // Server may double-encode as a JSON string, or embed PascalCase keys.
    // Decode and re-run normalisation so the widget always sees camelCase JSON.
    try {
      final decoded = json.decode(s);
      final nested = _filesJsonFromJson(decoded);
      return nested ?? s;
    } catch (_) {
      return s;
    }
  }
  if (value is List) {
    if (value.isEmpty) return null;
    // Normalise PascalCase keys coming from the server to camelCase so that
    // the bubble widget can use a single code-path.
    final normalised = value.map((e) {
      if (e is Map) {
        final fileName = (e['fileName'] ?? e['FileName'])?.toString().trim();
        final rawType =
        (e['fileType'] ?? e['FileType'] ?? 'document').toString();
        final fileType = resolveAttachmentPreviewFileType(
          rawType.toLowerCase(),
          fileName:
          (fileName == null || fileName.isEmpty) ? null : fileName,
        );
        final sizeRaw = e['size'] ?? e['Size'];
        final sizeText = sizeRaw?.toString().trim();
        return {
          'recordId': e['recordId'] ?? e['RecordId'],
          'fileType': fileType,
          if (fileName != null && fileName.isNotEmpty) 'fileName': fileName,
          if (fileType == 'image' &&
              sizeText != null &&
              sizeText.isNotEmpty)
            'size': sizeText,
        };
      }
      return e;
    }).toList();
    return jsonEncode(normalised);
  }
  if (value is Map) {
    return _filesJsonFromJson(<dynamic>[value]);
  }
  return null;
}

String? _filesJsonToJson(String? value) => value;

Map<String, dynamic> _normalizeReplyMessageJson(Map<String, dynamic> json) {
  if (json.isEmpty) return json;
  final m = Map<String, dynamic>.from(json);
  void copyIfNull(String camel, String pascal) {
    if (m[camel] != null) return;
    final v = m[pascal];
    if (v != null) m[camel] = v;
  }

  copyIfNull('chatId', 'ChatId');
  copyIfNull('messageGuid', 'MessageGuid');
  copyIfNull('seq', 'Seq');
  copyIfNull('senderType', 'SenderType');
  copyIfNull('senderAccountId', 'SenderAccountId');
  copyIfNull('senderUserId', 'SenderUserId');
  copyIfNull('messageType', 'MessageType');
  copyIfNull('text', 'Text');
  copyIfNull('replyToMessageGuid', 'ReplyToMessageGuid');
  copyIfNull('createdOnUtc', 'CreatedOnUtc');
  copyIfNull('isDeleted', 'IsDeleted');
  copyIfNull('senderAccountName', 'SenderAccountName');
  if (m.containsKey('filesJson') || m.containsKey('FilesJson')) {
    m['filesJson'] = _filesJsonFromJson(m['filesJson'] ?? m['FilesJson']);
    m.remove('FilesJson');
  }
  final created = m['createdOnUtc'];
  if (created is DateTime) {
    m['createdOnUtc'] = created.toUtc().toIso8601String();
  }
  return m;
}

/// `Chat/getChatMessagesByChatId` may return PascalCase property names; the
/// generated parser only reads camelCase keys.
Map<String, dynamic> _normalizeChatMessageJson(Map<String, dynamic> json) {
  if (json.isEmpty) return json;
  final m = Map<String, dynamic>.from(json);
  void copyIfNull(String camel, String pascal) {
    if (m[camel] != null) return;
    final v = m[pascal];
    if (v != null) m[camel] = v;
  }

  copyIfNull('replyToSeq', 'ReplyToSeq');
  copyIfNull('forwardFromSeq', 'ForwardFromSeq');
  copyIfNull('replyToMessageGuid', 'ReplyToMessageGuid');
  copyIfNull('replyMessage', 'ReplyMessage');
  copyIfNull('forwardFromMessageGuid', 'ForwardFromMessageGuid');
  copyIfNull('forwardFromSenderName', 'ForwardFromSenderName');
  copyIfNull('forwardMessage', 'ForwardMessage');
  copyIfNull('seenOnUtc', 'SeenOnUtc');
  copyIfNull('seen', 'Seen');
  final replyMessage = m['replyMessage'];
  if (replyMessage is Map) {
    m['replyMessage'] = _normalizeReplyMessageJson(
      Map<String, dynamic>.from(replyMessage),
    );
  }
  final forwardMessage = m['forwardMessage'];
  if (forwardMessage is Map) {
    m['forwardMessage'] = _normalizeForwardMessageJson(
      Map<String, dynamic>.from(forwardMessage),
    );
  }
  return m;
}

Map<String, dynamic> _normalizeForwardMessageJson(Map<String, dynamic> json) =>
    _normalizeReplyMessageJson(json);

ReplyMessage? _forwardMessageFromJson(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    return ReplyMessage.fromJson(
      _normalizeForwardMessageJson(Map<String, dynamic>.from(value)),
    );
  }
  return null;
}

Object? _forwardMessageToJson(ReplyMessage? value) => value?.toJson();

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "chatId")
  final String? chatId;
  @JsonKey(name: "messageGuid")
  final String? messageGuid;
  @JsonKey(name: "replyToMessageGuid")
  final String? replyToMessageGuid;
  @JsonKey(name: "replyMessage")
  final ReplyMessage? replyMessage;
  @JsonKey(name: "forwardFromMessageGuid")
  final String? forwardFromMessageGuid;
  @JsonKey(name: "forwardFromSenderName")
  final String? forwardFromSenderName;
  @JsonKey(
    name: "forwardMessage",
    fromJson: _forwardMessageFromJson,
    toJson: _forwardMessageToJson,
  )
  final ReplyMessage? forwardMessage;
  @JsonKey(name: "seq")
  final int? seq;
  @JsonKey(name: "senderType")
  final int? senderType;
  @JsonKey(name: "senderAccountId")
  final int? senderAccountId;
  @JsonKey(name: "senderUserId")
  final int? senderUserId;
  @JsonKey(name: "messageType")
  final int? messageType;
  @JsonKey(name: "text")
  final String? text;
  @JsonKey(name: "createdOnUtc")
  final DateTime? createdOnUtc;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "deliveredOnUtc")
  final DateTime? deliveredOnUtc;
  @JsonKey(name: "seenOnUtc")
  final DateTime? seenOnUtc;
  @JsonKey(name: "seen")
  final bool? seen;
  @JsonKey(name: "senderAccountName")
  final String? senderAccountName;
  @JsonKey(name: "replyToSeq")
  final int? replyToSeq;
  @JsonKey(name: "forwardFromSeq")
  final int? forwardFromSeq;
  /// JSON-encoded list of attachment descriptors, e.g.
  /// `[{"recordId":"…","fileType":"image","size":"1920x1080"}]`.
  /// The converter handles both a raw JSON array from the server and a
  /// pre-encoded string from the local optimistic-send path, normalising
  /// all keys to camelCase.
  @JsonKey(
    name: "filesJson",
    fromJson: _filesJsonFromJson,
    toJson: _filesJsonToJson,
  )
  final String? filesJson;

  ChatMessageModel({
    required this.rowNum,
    required this.chatId,
    required this.messageGuid,
    required this.replyToMessageGuid,
    required this.replyMessage,
    required this.forwardFromMessageGuid,
    required this.forwardFromSenderName,
    required this.forwardMessage,
    required this.seq,
    required this.senderType,
    required this.senderAccountId,
    required this.senderUserId,
    required this.messageType,
    required this.text,
    required this.createdOnUtc,
    required this.isDeleted,
    required this.deliveredOnUtc,
    required this.seenOnUtc,
    required this.seen,
    required this.senderAccountName,
    required this.replyToSeq,
    required this.forwardFromSeq,
    this.filesJson,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(_normalizeChatMessageJson(json));

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  /// Snapshot for [replyMessage] on optimistic sends and socket echoes.
  ReplyMessage? toReplyMessageSnapshot() {
    if (messageGuid == null && seq == null && (text == null || text!.isEmpty)) {
      return null;
    }
    return ReplyMessage(
      chatId: chatId,
      messageGuid: messageGuid,
      seq: seq,
      senderType: senderType,
      senderAccountId: senderAccountId,
      senderUserId: senderUserId,
      messageType: messageType,
      text: text,
      replyToMessageGuid: replyToMessageGuid,
      filesJson: filesJson,
      createdOnUtc: createdOnUtc?.toUtc().toIso8601String(),
      isDeleted: isDeleted,
      senderAccountName: senderAccountName,
    );
  }

  /// Snapshot for [forwardMessage] on optimistic sends and socket echoes.
  ReplyMessage? toForwardMessageSnapshot() {
    final embedded = forwardMessage;
    if (embedded != null) return embedded;
    if (messageGuid == null &&
        seq == null &&
        (text == null || text!.isEmpty) &&
        (filesJson == null || filesJson!.trim().isEmpty)) {
      return null;
    }
    return ReplyMessage(
      chatId: chatId,
      messageGuid: messageGuid,
      seq: seq,
      senderType: senderType,
      senderAccountId: senderAccountId,
      senderUserId: senderUserId,
      messageType: messageType,
      text: text,
      replyToMessageGuid: replyToMessageGuid,
      filesJson: filesJson,
      createdOnUtc: createdOnUtc?.toUtc().toIso8601String(),
      isDeleted: isDeleted,
      senderAccountName: senderAccountName,
    );
  }

  bool get isForwarded =>
      forwardFromMessageGuid != null ||
          forwardMessage != null ||
          forwardFromSeq != null;
}

@JsonSerializable()
class ReplyMessage {
  @JsonKey(name: "chatId")
  final String? chatId;
  @JsonKey(name: "messageGuid")
  final String? messageGuid;
  @JsonKey(name: "seq")
  final int? seq;
  @JsonKey(name: "senderType")
  final int? senderType;
  @JsonKey(name: "senderAccountId")
  final int? senderAccountId;
  @JsonKey(name: "senderUserId")
  final int? senderUserId;
  @JsonKey(name: "messageType")
  final int? messageType;
  @JsonKey(name: "text")
  final String? text;
  @JsonKey(name: "replyToMessageGuid")
  final String? replyToMessageGuid;
  @JsonKey(
    name: "filesJson",
    fromJson: _filesJsonFromJson,
    toJson: _filesJsonToJson,
  )
  final String? filesJson;
  @JsonKey(name: "createdOnUtc")
  final String? createdOnUtc;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "senderAccountName")
  final String? senderAccountName;

  ReplyMessage({
    required this.chatId,
    required this.messageGuid,
    required this.seq,
    required this.senderType,
    required this.senderAccountId,
    required this.senderUserId,
    required this.messageType,
    required this.text,
    required this.replyToMessageGuid,
    required this.filesJson,
    required this.createdOnUtc,
    required this.isDeleted,
    required this.senderAccountName,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) =>
      _$ReplyMessageFromJson(_normalizeReplyMessageJson(json));

  Map<String, dynamic> toJson() => _$ReplyMessageToJson(this);
}

/// Embedded snapshot of the forwarded source message (same shape as [ReplyMessage]).
typedef ForwardMessage = ReplyMessage;

/// Preview line when the server embeds [ReplyMessage] without a local parent row.
String replyEmbeddedMessagePreviewBody(ReplyMessage reply) {
  final t = reply.text?.trim();
  if (t != null && t.isNotEmpty) return t;
  if (reply.filesJson != null && reply.filesJson!.trim().isNotEmpty) {
    return 'ضمیمه';
  }
  if (reply.seq != null) return 'پیام #${reply.seq}';
  return 'پیام';
}

/// Preview line for an embedded [ForwardMessage] block inside a bubble.
String forwardEmbeddedMessagePreviewBody(ForwardMessage forward) =>
    replyEmbeddedMessagePreviewBody(forward);

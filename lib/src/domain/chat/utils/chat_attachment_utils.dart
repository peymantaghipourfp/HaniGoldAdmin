import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

import '../controller/chat.controller.dart';
import 'chat_attachment_pick.dart' show resolveAttachmentPreviewFileType;


/// Pixel dimensions for a chat image attachment (`filesJson` `size` field).
typedef ChatImagePixelSize = ({int width, int height});

const double kChatImageThumbnailMaxWidth = 220;
const double kChatImageThumbnailMaxHeight = 200;

int? _positiveIntFromJson(dynamic value) {
  if (value is int && value > 0) return value;
  if (value is num && value > 0) return value.round();
  final parsed = int.tryParse(value?.toString() ?? '');
  if (parsed != null && parsed > 0) return parsed;
  return null;
}

/// Encodes image dimensions for `filesJson` (e.g. `"1920x1080"`).
String formatChatImageSizeField(int width, int height) => '${width}x$height';

/// Reads `size` / `Size` from API or outbound JSON (string, map, or `[w,h]`).
ChatImagePixelSize? parseChatImageSizeField(dynamic raw) {
  if (raw == null) return null;
  if (raw is Map) {
    final m = Map<String, dynamic>.from(raw);
    final w = _positiveIntFromJson(m['width'] ?? m['Width']);
    final h = _positiveIntFromJson(m['height'] ?? m['Height']);
    if (w != null && h != null) return (width: w, height: h);
    return null;
  }
  if (raw is List && raw.length >= 2) {
    final w = _positiveIntFromJson(raw[0]);
    final h = _positiveIntFromJson(raw[1]);
    if (w != null && h != null) return (width: w, height: h);
    return null;
  }
  final text = raw.toString().trim();
  if (text.isEmpty) return null;
  final match = RegExp(r'^(\d+)\s*[x×,]\s*(\d+)$', caseSensitive: false)
      .firstMatch(text);
  if (match == null) return null;
  final w = int.tryParse(match.group(1)!);
  final h = int.tryParse(match.group(2)!);
  if (w == null || h == null || w <= 0 || h <= 0) return null;
  return (width: w, height: h);
}

/// Scales intrinsic pixels into the chat bubble thumbnail box.
({double width, double height}) chatImageThumbnailBoxSize({
  ChatImagePixelSize? pixelSize,
  double maxWidth = kChatImageThumbnailMaxWidth,
  double maxHeight = kChatImageThumbnailMaxHeight,
}) {
  if (pixelSize == null) {
    return (width: maxWidth, height: maxHeight);
  }
  var w = pixelSize.width.toDouble();
  var h = pixelSize.height.toDouble();
  if (w <= 0 || h <= 0) return (width: maxWidth, height: maxHeight);
  if (w > maxWidth) {
    h *= maxWidth / w;
    w = maxWidth;
  }
  if (h > maxHeight) {
    w *= maxHeight / h;
    h = maxHeight;
  }
  return (
  width: w.clamp(1.0, maxWidth),
  height: h.clamp(1.0, maxHeight),
  );
}

Future<ChatImagePixelSize?> decodeChatImagePixelSizeFromBytes(
    Uint8List bytes,
    ) async {
  if (bytes.isEmpty) return null;
  try {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final w = frame.image.width;
    final h = frame.image.height;
    frame.image.dispose();
    if (w <= 0 || h <= 0) return null;
    return (width: w, height: h);
  } catch (_) {
    return null;
  }
}

/// Parses one attachment entry from API (PascalCase) or client (camelCase) JSON.

({
String? recordId,
String fileType,
String? fileName,
ChatImagePixelSize? imagePixelSize,
}) parseAttachmentEntry(
    dynamic item,
    ) {
  if (item is! Map) {
    return (
    recordId: null,
    fileType: 'document',
    fileName: null,
    imagePixelSize: null,
    );
  }
  final m = Map<String, dynamic>.from(item);
  final ridRaw = m['recordId'] ?? m['RecordId'];
  final ftRaw = m['fileType'] ?? m['FileType'];
  final fnRaw = m['fileName'] ?? m['FileName'];
  final rid = ridRaw?.toString();
  final fn = fnRaw?.toString().trim();
  final fileName = (fn == null || fn.isEmpty) ? null : fn;
  final fileType = resolveAttachmentPreviewFileType(
    (ftRaw?.toString() ?? 'document').toLowerCase(),
    fileName: fileName,
  );
  final recordId = (rid == null || rid.isEmpty) ? null : rid;
  final imagePixelSize = fileType == 'image'
      ? parseChatImageSizeField(m['size'] ?? m['Size'])
      : null;
  return (
  recordId: recordId,
  fileType: fileType,
  fileName: fileName,
  imagePixelSize: imagePixelSize,
  );
}

/// Merges server [incoming] with outbound [optimistic] `filesJson`.
///
/// Keeps the outbound `recordId` (the id used at upload time) when both lists
/// align by index, while filling `fileName` / `fileType` from either side.
String? mergeChatFilesJsonFromOutbound(
    String? incoming,
    String? optimistic,
    ) {
  if (optimistic == null || optimistic.trim().isEmpty) {
    return mergeChatFilesJsonPreservingFileNames(incoming, null);
  }
  if (incoming == null || incoming.trim().isEmpty) return optimistic;
  try {
    final inItems = json.decode(incoming) as List<dynamic>;
    final outItems = json.decode(optimistic) as List<dynamic>;
    final merged = <dynamic>[];
    for (var i = 0; i < inItems.length; i++) {
      final inEntry = inItems[i];
      final outEntry = i < outItems.length ? outItems[i] : null;
      if (inEntry is! Map) {
        merged.add(inEntry);
        continue;
      }
      final inMap = Map<String, dynamic>.from(inEntry);
      Map<String, dynamic>? outMap;
      if (outEntry is Map) {
        outMap = Map<String, dynamic>.from(outEntry);
      }
      final outRecordId =
      (outMap?['recordId'] ?? outMap?['RecordId'])?.toString().trim();
      final inRecordId =
      (inMap['recordId'] ?? inMap['RecordId'])?.toString().trim();
      final recordId = (outRecordId != null && outRecordId.isNotEmpty)
          ? outRecordId
          : inRecordId;
      final fileName = (inMap['fileName'] ??
          inMap['FileName'] ??
          outMap?['fileName'] ??
          outMap?['FileName'])
          ?.toString()
          .trim();
      final rawType = (inMap['fileType'] ??
          inMap['FileType'] ??
          outMap?['fileType'] ??
          outMap?['FileType'] ??
          'document')
          .toString()
          .toLowerCase();
      final fileType = resolveAttachmentPreviewFileType(
        rawType,
        fileName: (fileName == null || fileName.isEmpty) ? null : fileName,
      );
      final entry = <String, dynamic>{
        'recordId': recordId,
        'fileType': fileType,
      };
      if (fileName != null && fileName.isNotEmpty) {
        entry['fileName'] = fileName;
      }
      final sizeRaw = inMap['size'] ??
          inMap['Size'] ??
          outMap?['size'] ??
          outMap?['Size'];
      final pixelSize = parseChatImageSizeField(sizeRaw);
      if (pixelSize != null && fileType == 'image') {
        entry['size'] = formatChatImageSizeField(
          pixelSize.width,
          pixelSize.height,
        );
      }
      merged.add(entry);
    }
    return jsonEncode(merged);
  } catch (_) {
    return mergeChatFilesJsonPreservingFileNames(incoming, optimistic);
  }
}

/// Keeps [incoming] but fills missing `fileName` per `recordId` from [fallback].
String? mergeChatFilesJsonPreservingFileNames(
    String? incoming,
    String? fallback,
    ) {
  if (fallback == null || fallback.trim().isEmpty) return incoming;
  if (incoming == null || incoming.trim().isEmpty) return fallback;
  try {
    final inItems = json.decode(incoming) as List<dynamic>;
    final fbItems = json.decode(fallback) as List<dynamic>;
    final namesByRecordId = <String, String>{};
    for (final e in fbItems) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final id = (m['recordId'] ?? m['RecordId'])?.toString();
      final fn = (m['fileName'] ?? m['FileName'])?.toString().trim();
      if (id != null && id.isNotEmpty && fn != null && fn.isNotEmpty) {
        namesByRecordId[id] = fn;
      }
    }
    if (namesByRecordId.isEmpty) return incoming;
    final merged = inItems.map((e) {
      if (e is! Map) return e;
      final m = Map<String, dynamic>.from(e);
      final id = (m['recordId'] ?? m['RecordId'])?.toString();
      final existing = (m['fileName'] ?? m['FileName'])?.toString().trim();
      if ((existing == null || existing.isEmpty) &&
          id != null &&
          namesByRecordId.containsKey(id)) {
        m['fileName'] = namesByRecordId[id];
      }
      return m;
    }).toList();
    return jsonEncode(merged);
  } catch (_) {
    return incoming;
  }
}

/// Original file name for display and download (cache, then [fileName] from filesJson).
String? chatAttachmentResolvedFileName({
  String? fileName,
  ChatPendingAttachment? cached,
}) {
  final fromCache = cached?.name.trim();
  if (fromCache != null && fromCache.isNotEmpty) return fromCache;
  final fromJson = fileName?.trim();
  if (fromJson != null && fromJson.isNotEmpty) return fromJson;
  return null;
}

/// Lower-case extension without a leading dot, or null.
String? chatExtensionFromFileName(String? fileName) {
  if (fileName == null) return null;
  final ext = p.extension(fileName.trim()).replaceFirst('.', '').toLowerCase();
  return ext.isEmpty ? null : ext;
}

/// Maps a file extension to save metadata (used when the real name is known).
(String ext, MimeType mime) chatSaveMetaByExtension(String extension) {
  switch (extension) {
    case 'pdf':
      return ('pdf', MimeType.pdf);
    case 'xlsx':
    case 'xls':
      return ('xlsx', MimeType.microsoftExcel);
    case 'csv':
      return ('csv', MimeType.csv);
    case 'txt':
      return ('txt', MimeType.text);
    case 'docx':
    case 'doc':
      return ('docx', MimeType.microsoftWord);
    case 'pptx':
    case 'ppt':
      return ('pptx', MimeType.microsoftPresentation);
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
    case 'webp':
      return ('png', MimeType.png);
    case 'mp3':
      return ('mp3', MimeType.mp3);
    case 'mp4':
      return ('mp4', MimeType.mp4Video);
    case 'zip':
    case 'rar':
    case '7z':
      return ('zip', MimeType.zip);
    default:
      return (extension, MimeType.other);
  }
}

/// Maps a [fileType] string to save-file extension + MimeType (fallback when no filename).
(String ext, MimeType mime) chatSaveMeta(String fileType) {
  switch (fileType) {
    case 'pdf':
      return ('pdf', MimeType.pdf);
    case 'image':
      return ('png', MimeType.png);
    case 'audio':
      return ('mp3', MimeType.mp3);
    case 'video':
      return ('mp4', MimeType.mp4Video);
    case 'archive':
      return ('zip', MimeType.zip);
    default:
      return ('bin', MimeType.other);
  }
}

/// Resolves extension/MIME from [fileName] when present, else [fileType].
(String ext, MimeType mime) resolveChatAttachmentSaveMeta(
    String fileType, {
      String? fileName,
    }) {
  final fromName = chatExtensionFromFileName(fileName);
  if (fromName != null) return chatSaveMetaByExtension(fromName);
  return chatSaveMeta(fileType);
}

/// Base name for [FileSaver] (extension is passed separately).
String chatAttachmentSaveBaseName(String recordId, {String? fileName}) {
  final trimmed = fileName?.trim();
  if (trimmed != null && trimmed.isNotEmpty) {
    final base = p.basenameWithoutExtension(trimmed);
    if (base.isNotEmpty) return base;
  }
  final id = recordId.length >= 8 ? recordId.substring(0, 8) : recordId;
  return 'chat_$id';
}

Future<void> saveChatAttachmentBytesToDisk({
  required Uint8List bytes,
  required String recordId,
  required String fileType,
  ChatPendingAttachment? cached,
  String? fileName,
}) async {
  final effectiveFileName = fileName ?? cached?.name;
  final meta = resolveChatAttachmentSaveMeta(
    fileType,
    fileName: effectiveFileName,
  );
  final name = chatAttachmentSaveBaseName(
    recordId,
    fileName: effectiveFileName,
  );
  await FileSaver.instance.saveFile(
    name: name,
    bytes: bytes,
    fileExtension: meta.$1,
    mimeType: meta.$2,
  );
}

String formatChatAudioDuration(Duration d) {
  final totalSeconds = d.inSeconds.clamp(0, 1 << 31);
  final mm = (totalSeconds ~/ 60).toString().padLeft(2, '0');
  final ss = (totalSeconds % 60).toString().padLeft(2, '0');
  return '$mm:$ss';
}

void showChatImageDialog(BuildContext context, Uint8List bytes) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      final size = MediaQuery.sizeOf(dialogContext);
      final maxW = size.width * 0.9;
      final maxH = size.height * 0.9;
      return Dialog(
        backgroundColor: Colors.black87,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
                child: Image.memory(bytes, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> saveChatImageAttachment(
    Uint8List bytes, {
      String? suggestedName,
    }) async {
  final base = suggestedName?.trim();
  final name = (base != null && base.isNotEmpty)
      ? base.replaceAll(
    RegExp(r'\.(png|jpe?g|gif|webp)$', caseSensitive: false),
    '',
  )
      : 'chat_image';
  try {
    await FileSaver.instance.saveFile(
      name: name,
      bytes: bytes,
      fileExtension: 'png',
      mimeType: MimeType.png,
    );
    Get.snackbar(
      'ذخیره',
      'فایل ذخیره شد',
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    Get.snackbar(
      'خطا',
      'ذخیره ناموفق: $e',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

Widget chatImageAttachmentThumbnail({
  required BuildContext context,
  required Uint8List bytes,
  String? saveFileName,
  ChatImagePixelSize? pixelSize,
}) {
  final box = chatImageThumbnailBoxSize(pixelSize: pixelSize);
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: box.width,
        height: box.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => showChatImageDialog(context, bytes),
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Material(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => saveChatImageAttachment(
                      bytes,
                      suggestedName: saveFileName,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.download_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String formatAttachmentSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

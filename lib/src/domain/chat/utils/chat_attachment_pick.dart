import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as p;

/// Extensions accepted by the chat composer (menu pickers + drag-and-drop).
const Set<String> kChatAttachmentAllowedExtensions = {
  'jpg',
  'jpeg',
  'png',
  'gif',
  'bmp',
  'webp',
  'heic',
  'heif',
  'mp4',
  'mov',
  'avi',
  'mkv',
  'webm',
  '3gp',
  'flv',
  'mp3',
  'aac',
  'ogg',
  'wav',
  'flac',
  'm4a',
  'opus',
  'wma',
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'txt',
  'csv',
  'zip',
  'rar',
  '7z',
  'tar',
  'gz',
};

/// Classifies a file-name extension into the server-accepted [fileType] string.
String classifyChatAttachmentFileType(String ext) {
  const imageExt = {'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic', 'heif'};
  const videoExt = {'mp4', 'mov', 'avi', 'mkv', 'webm', '3gp', 'flv'};
  const audioExt = {'mp3', 'aac', 'ogg', 'wav', 'flac', 'm4a', 'opus', 'wma'};
  const archiveExt = {'zip', 'rar', '7z', 'tar', 'gz'};
  const documentExt = {'xls', 'xlsx', 'csv', 'pdf', 'txt', 'doc', 'docx', 'ppt', 'pptx'};

  final e = ext.toLowerCase();
  if (imageExt.contains(e)) return 'image';
  if (videoExt.contains(e)) return 'video';
  if (audioExt.contains(e)) return 'audio';
  if (archiveExt.contains(e)) return 'archive';
  if (e == 'pdf') return 'pdf';
  if (documentExt.contains(e)) return 'document';
  return 'document';
}

/// Resolves the UI preview category from server [fileType] and optional [fileName].
///
/// The API often sends `document` even for images; extension-based inference
/// matches upload-time classification in [classifyChatAttachmentFileType].
String resolveAttachmentPreviewFileType(
    String fileType, {
      String? fileName,
    }) {
  final ft = fileType.trim().toLowerCase();
  if (ft == 'image' || ft == 'photo' || ft == 'picture' || ft == 'img') {
    return 'image';
  }
  final name = fileName?.trim();
  if (name != null && name.isNotEmpty) {
    final ext = chatAttachmentExtensionFromName(name);
    if (ext != null) {
      return classifyChatAttachmentFileType(ext);
    }
  }
  return ft.isEmpty ? 'document' : ft;
}

/// True when [bytes] begin with a common raster image signature (JPEG/PNG/GIF/WebP/BMP).
bool isRasterImageBytes(Uint8List bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return true;
  }
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    return true;
  }
  if (bytes.length >= 6 &&
      bytes[0] == 0x47 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46) {
    return true;
  }
  if (bytes.length >= 12 &&
      bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46 &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50) {
    return true;
  }
  if (bytes.length >= 2 && bytes[0] == 0x42 && bytes[1] == 0x4D) {
    return true;
  }
  return false;
}

/// Whether to sniff downloaded bytes for a raster image when [fileType] is ambiguous.
bool shouldSniffAttachmentBytesForImage(String fileType) {
  switch (fileType) {
    case 'image':
      return false;
    case 'video':
    case 'audio':
    case 'pdf':
    case 'archive':
      return false;
    default:
      return true;
  }
}

String? chatAttachmentExtensionFromName(String name) {
  final ext = p.extension(name.trim()).replaceFirst('.', '').toLowerCase();
  return ext.isEmpty ? null : ext;
}

bool isChatAttachmentExtensionAllowed(String? extension) {
  if (extension == null || extension.isEmpty) return false;
  return kChatAttachmentAllowedExtensions.contains(extension.toLowerCase());
}

bool isChatAttachmentFileNameAllowed(String fileName) {
  return resolveChatAttachmentExtension(fileName: fileName) != null;
}

/// Maps browser / OS MIME types to a file extension for dropped files.
String? chatAttachmentExtensionFromMimeType(String? mimeType) {
  if (mimeType == null || mimeType.trim().isEmpty) return null;
  final mime = mimeType.split(';').first.trim().toLowerCase();
  const map = <String, String>{
    'image/png': 'png',
    'image/jpeg': 'jpg',
    'image/jpg': 'jpg',
    'image/gif': 'gif',
    'image/bmp': 'bmp',
    'image/webp': 'webp',
    'image/heic': 'heic',
    'image/heif': 'heif',
    'video/mp4': 'mp4',
    'video/quicktime': 'mov',
    'video/x-msvideo': 'avi',
    'video/x-matroska': 'mkv',
    'video/webm': 'webm',
    'audio/mpeg': 'mp3',
    'audio/mp3': 'mp3',
    'audio/aac': 'aac',
    'audio/ogg': 'ogg',
    'audio/opus': 'opus',
    'audio/wav': 'wav',
    'audio/x-wav': 'wav',
    'audio/flac': 'flac',
    'audio/mp4': 'm4a',
    'application/pdf': 'pdf',
    'application/msword': 'doc',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
    'docx',
    'application/vnd.ms-excel': 'xls',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'xlsx',
    'application/vnd.ms-powerpoint': 'ppt',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation':
    'pptx',
    'text/plain': 'txt',
    'text/csv': 'csv',
    'application/zip': 'zip',
    'application/x-rar-compressed': 'rar',
    'application/x-7z-compressed': '7z',
    'application/gzip': 'gz',
    'application/x-tar': 'tar',
  };
  return map[mime];
}

/// True when [path] is a browser blob/http URL, not a real filesystem path.
bool isOpaqueDropUri(String path) {
  final lower = path.trim().toLowerCase();
  return lower.startsWith('blob:') ||
      lower.startsWith('http://') ||
      lower.startsWith('https://');
}

/// Resolves extension from [fileName], then [mimeType].
String? resolveChatAttachmentExtension({
  required String fileName,
  String? mimeType,
}) {
  final fromName = chatAttachmentExtensionFromName(fileName);
  if (isChatAttachmentExtensionAllowed(fromName)) return fromName;
  final fromMime = chatAttachmentExtensionFromMimeType(mimeType);
  if (isChatAttachmentExtensionAllowed(fromMime)) return fromMime;
  return null;
}

/// Last path segment of a `blob:` / `http:` URI (often a UUID), or null.
String? opaqueDropUriStem(String uri) {
  if (!isOpaqueDropUri(uri)) return null;
  final segment = p.basename(uri.split('?').first).trim();
  return segment.isEmpty ? null : segment;
}

/// Display name for a dropped file from [name], [path], and optional [mimeType].
///
/// On web, [path] is often a `blob:` URI (basename is a UUID) while [name]
/// keeps the original file name from the drag source (e.g. `chat_b2cbc128.png`).
String resolveDroppedAttachmentFileNameFromParts({
  required String name,
  required String path,
  String? mimeType,
}) {
  final candidates = <String>[];

  final trimmedName = name.trim();
  if (trimmedName.isNotEmpty && !isOpaqueDropUri(trimmedName)) {
    candidates.add(trimmedName);
  }

  if (path.isNotEmpty && !isOpaqueDropUri(path)) {
    final base = p.basename(path).trim();
    if (base.isNotEmpty && !candidates.contains(base)) {
      candidates.add(base);
    }
  }

  for (final candidate in candidates) {
    final extFromName = chatAttachmentExtensionFromName(candidate);
    if (isChatAttachmentExtensionAllowed(extFromName)) {
      return candidate;
    }
  }

  final mimeExt = chatAttachmentExtensionFromMimeType(mimeType);
  if (mimeExt != null) {
    for (final candidate in candidates) {
      if (!candidate.contains('.')) {
        return '$candidate.$mimeExt';
      }
    }
    final stem =
        opaqueDropUriStem(trimmedName) ?? opaqueDropUriStem(path);
    if (stem != null) {
      return '$stem.$mimeExt';
    }
    return 'attachment.$mimeExt';
  }

  if (candidates.isNotEmpty) return candidates.first;
  if (trimmedName.isNotEmpty) return trimmedName;
  if (path.isNotEmpty) return p.basename(path);
  return 'file';
}

/// Display name for a dropped [XFile].
String resolveDroppedAttachmentFileName(XFile file) {
  return resolveDroppedAttachmentFileNameFromParts(
    name: file.name,
    path: file.path,
    mimeType: file.mimeType,
  );
}

/// Whether a dropped file is allowed (name and/or MIME).
bool isDroppedChatAttachmentAllowed(XFile file) {
  final name = resolveDroppedAttachmentFileName(file);
  return resolveChatAttachmentExtension(
    fileName: name,
    mimeType: file.mimeType,
  ) !=
      null;
}

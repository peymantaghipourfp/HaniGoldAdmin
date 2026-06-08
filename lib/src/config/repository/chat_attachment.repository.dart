import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/dio_client.dart';
import 'package:hanigold_admin/src/config/repository/chat_attachment_download.dart';

/// Handles upload and download of chat attachments via the dedicated
/// `Attachment/uploadChatAttachment` and `Attachment/downloadChatAttachment`
/// endpoints.
///
/// Upload body contains only `file` (multipart) and `recordId`.
/// Download is keyed by `recordId` query parameter.
class ChatAttachmentRepository {
  ChatAttachmentRepository();

  Dio get _dio => DioClient.instance;

  static const _uploadPath = 'Attachment/uploadChatAttachment';
  static const _downloadPath = 'Attachment/downloadChatAttachment';

  Future<void> uploadChatAttachment({
    required Uint8List bytes,
    required String fileName,
    required String recordId,
    String? mimeType,
  }) async {
    final DioMediaType? contentType =
    mimeType != null ? DioMediaType.parse(mimeType) : null;
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: contentType,
      ),
      'recordId': recordId,
    });
    final response = await _dio.post(
      _uploadPath,
      data: formData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('آپلود ناموفق: ${response.statusMessage}');
    }
  }

  Future<Uint8List> downloadChatAttachment({
    required String recordId,
  }) {
    return downloadChatAttachmentBytes(_dio, _downloadPath, recordId);
  }
}

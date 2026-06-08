import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Native / desktop: binary GET via Dio (bytes in memory).
Future<Uint8List> downloadChatAttachmentBytes(
    Dio dio,
    String downloadPath,
    String recordId,
    ) async {
  final response = await dio.get<Uint8List>(
    downloadPath,
    queryParameters: {'recordId': recordId},
    options: Options(
      responseType: ResponseType.bytes,
      receiveTimeout: const Duration(seconds: 120),
    ),
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('دانلود ناموفق: ${response.statusMessage}');
  }
  final data = response.data;
  if (data == null) {
    throw Exception('دانلود ناموفق: بدون داده');
  }
  return data;
}

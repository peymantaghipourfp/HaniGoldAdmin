

import 'package:dio/dio.dart';

class DownloadRepository{
  final Dio downloadDio=Dio();

  Future<String> downloadFile(String url, String savePath) async {
    try {
      final response = await downloadDio.download(
        url,
        savePath,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      print(response);
      return savePath;
    } catch (e) {
      throw Exception('دانلود ناموفق: $e');
    }
  }
}
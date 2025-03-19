

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

class UploadRepository{

  final Dio uploadDio=Dio();

  UploadRepository(){
    uploadDio.options.baseUrl=BaseUrl.baseUrl;

  }

  Future<bool> uploadImage({
    required File imageFile,
    required String recordId,
    required String type,
    required String entityType,
  }) async {

      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
        "recordId": recordId,
        "type": type,
        "entityType": entityType,
      });
      print(fileName);
      print(recordId);
      print(type);
      print(entityType);
      final response = await uploadDio.get("Attachment/uploadAttachment", data: formData,
        options: Options(headers: {
        "Content-Type": "multipart/form-data",
        },
      ),
      );
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("خطا در ارسال تصویر: ${response.statusMessage}");
      }

  }
}


import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

class UploadRepository{

  final Dio uploadDio=Dio();

  UploadRepository(){
    uploadDio.options.baseUrl=BaseUrl.baseUrl;

  }

  Future<String> uploadImage({
    required File imageFile,
    required String recordId,
    required String type,
    required String entityType,
  }) async {

      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });
      print(fileName);
      print(recordId);
      print(type);
      print(entityType);
      final response = await uploadDio.post("Attachment/uploadAttachment", data: formData,
        options: Options(headers: {
        "Content-Type": "multipart/form-data","recordId": recordId, "type": type, "entityType": entityType,
        },
      ),
      );
      print('Status Code uploadImage: ${response.statusCode}');
      print('Response Data uploadImage: ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("خطا در ارسال تصویر: ${response.statusMessage}");
      }
  }
}

class UploadRepositoryDesktop{

  final Dio uploadDio=Dio();

  UploadRepositoryDesktop(){
    uploadDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<String> uploadImageDesktop({
    required Uint8List imageBytes,
    required String fileName,
    required String recordId,
    required String type,
    required String entityType,
  }) async {

    final multipartFile = MultipartFile.fromBytes(
      imageBytes,
      filename: fileName,
    );
    FormData formData = FormData.fromMap({
      "file": multipartFile,
    });
    print(fileName);
    print(recordId);
    print(type);
    print(entityType);
    final response = await uploadDio.post("Attachment/uploadAttachment", data: formData,
      options: Options(headers: {
        "Content-Type": "multipart/form-data","recordId": recordId, "type": type, "entityType": entityType,
      },
      ),
    );
    print('Status Code uploadImageDesktop: ${response.statusCode}');
    print('Response Data uploadImageDesktop: ${response.data}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception("خطا در ارسال تصویر: ${response.statusMessage}");
    }

  }
}
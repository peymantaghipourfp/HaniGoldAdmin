import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:web/web.dart' as web;

/// Runs [fetch] inside a dedicated [Worker] so extensions that patch
/// `window.fetch` on the main thread (e.g. some IDM rules) do not see this
/// request. [dio] is unused but kept for the conditional-export API.
Future<Uint8List> downloadChatAttachmentBytes(
    Dio dio, // ignore: unused_parameter
    String downloadPath,
    String recordId,
    ) async {
  final box = GetStorage();
  final token = box.read('Authorization');
  final uri = Uri.parse(BaseUrl.baseUrl).resolve(downloadPath).replace(
    queryParameters: {'recordId': recordId},
  );

  final headers = <String, String>{'Accept': '*/*'};
  if (token != null && token.toString().isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  final payload = jsonEncode(<String, Object?>{
    'u': uri.toString(),
    'h': headers,
  });

  const workerJs =
      "self.onmessage=async function(e){try{var j=JSON.parse(e.data);"
      "var h=new Headers(j.h||{});var r=await fetch(j.u,{headers:h});"
      "if(!r.ok){self.postMessage('ERR:'+r.status);return;}"
      "self.postMessage(new Uint8Array(await r.arrayBuffer()));"
      '}catch(x){self.postMessage("ERR:"+String(x));}};';

  final blobParts = [workerJs.toJS].toJS;
  final blob = web.Blob(
    blobParts,
    web.BlobPropertyBag(type: 'application/javascript'),
  );
  final objectUrl = web.URL.createObjectURL(blob);
  web.Worker? worker;
  try {
    worker = web.Worker(objectUrl.toJS);
    final completer = Completer<Uint8List>();
    var settled = false;

    void settleError(Object err) {
      if (!settled) {
        settled = true;
        completer.completeError(err);
      }
    }

    void settleOk(Uint8List bytes) {
      if (!settled) {
        settled = true;
        completer.complete(bytes);
      }
    }

    void onMessage(web.Event event) {
      if (settled) return;
      final raw = (event as JSObject)['data'];
      if (raw == null) {
        settleError(Exception('دانلود ناموفق: بدون داده'));
        return;
      }
      if (raw.typeofEquals('string')) {
        final s = (raw as JSString).toDart;
        settleError(Exception('دانلود ناموفق: $s'));
        return;
      }
      settleOk((raw as JSUint8Array).toDart);
    }

    void onError(web.Event _) {
      settleError(Exception('دانلود ناموفق: worker'));
    }

    final onMessageJs = onMessage.toJS;
    final onErrorJs = onError.toJS;

    worker.addEventListener('message', onMessageJs);
    worker.addEventListener('error', onErrorJs);
    worker.postMessage(payload.toJS);
    try {
      return await completer.future.timeout(
        const Duration(seconds: 120),
        onTimeout: () => throw TimeoutException('دانلود ناموفق: زمان تمام شد'),
      );
    } finally {
      worker.removeEventListener('message', onMessageJs);
      worker.removeEventListener('error', onErrorJs);
    }
  } finally {
    worker?.terminate();
    web.URL.revokeObjectURL(objectUrl);
  }
}

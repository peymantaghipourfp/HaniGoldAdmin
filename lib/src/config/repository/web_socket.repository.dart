/*


import 'dart:async';

import 'package:hanigold_admin/src/config/repository/url/web_socket_url.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketRepository{

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  // اتصال به سوکت
  WebSocketChannel connect(
      String url, {
        Duration pingInterval = const Duration(seconds: 30),
      }) {
    _channel = WebSocketChannel.connect(
      Uri.parse("wss://172.30.25.225:10000/ws"),
    );
    return _channel!;
  }

  // ارسال پیام
  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  // مدیریت رویدادهای سوکت
  void listen(
      void Function(dynamic) onData, {
        Function? onError,
        void Function()? onDone,
      }) {
    _subscription = _channel?.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
  }

  // قطع اتصال
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

}*/

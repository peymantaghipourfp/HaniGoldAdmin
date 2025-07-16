import 'dart:async';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  WebSocketChannel? _channel;
  final RxString _connectionStatus = 'disconnected'.obs;
  final RxString _lastError = ''.obs;
  final _messageStream = StreamController<dynamic>.broadcast();

  Stream<dynamic> get messageStream => _messageStream.stream;
  String get connectionStatus => _connectionStatus.value;
  String get lastError => _lastError.value;

  Future<void> connect(String url) async {
    try {
      _connectionStatus.value = 'connecting';

      _channel = WebSocketChannel.connect(
        Uri.parse(url),
      );

      _channel!.stream.listen(
            (data) => _messageStream.add(data),
        onError: (error) {
          _lastError.value = 'Error: $error';
          _messageStream.addError(error);
          _reconnect(url);
        },
        onDone: () {
          _connectionStatus.value = 'disconnected';
          _messageStream.add('Connection closed');
          _reconnect(url);
        },
      );

      _connectionStatus.value = 'connected';
      print('WebSocket متصل شد');
      //Get.snackbar('اتصال', 'WebSocket متصل شد', duration: 2.seconds);
    } catch (e) {
      _connectionStatus.value = 'error';
      _lastError.value = 'Connection error: $e';
      _reconnect(url);
    }
  }

  void _reconnect(String url,) {
    if (_connectionStatus.value != 'disconnected') {
      _connectionStatus.value = 'reconnecting';
      Future.delayed(3.seconds, () => connect(url));
    }
  }

  void send(dynamic message) {
    if (_channel != null && _connectionStatus.value == 'connected') {
      try {
        _channel!.sink.add(message);
      } catch (e) {
        _lastError.value = 'Send error: $e';
      }
    }
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _connectionStatus.value = 'disconnected';
    _messageStream.close();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
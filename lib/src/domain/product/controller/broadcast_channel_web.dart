// Web-specific BroadcastChannel implementation
// This file is only imported on web platforms

import 'dart:convert';
import 'dart:html' as html;

class BroadcastChannelHandler {
  html.BroadcastChannel? _channel;

  void setup(String channelName, Function(dynamic data) onMessage) {
    try {
      _channel = html.BroadcastChannel(channelName);
      _channel!.onMessage.listen((event) {
        try {
          final data = json.decode(event.data);
          onMessage(data);
        } catch (e) {
          print('Error handling broadcast message: $e');
        }
      });
    } catch (e) {
      print('BroadcastChannel setup failed: $e');
    }
  }

  void sendMessage(String channelName, dynamic data) {
    try {
      if (_channel != null) {
        _channel!.postMessage(json.encode(data));
      }
    } catch (e) {
      print('Error sending broadcast message: $e');
    }
  }

  void close() {
    _channel?.close();
    _channel = null;
  }
}

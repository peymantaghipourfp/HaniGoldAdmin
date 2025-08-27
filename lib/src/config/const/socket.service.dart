import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../repository/url/web_socket_url.dart';

// Mixin for views that need socket connection
mixin SocketConnectionMixin {
  Future<void> ensureSocketConnection() async {
    try {
      final socketService = Get.find<SocketService>();
      await socketService.initializeForNewTab();
    } catch (e) {
      print('Error ensuring socket connection: $e');
    }
  }
}

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  WebSocketChannel? _channel;
  final RxString _connectionStatus = 'disconnected'.obs;
  final RxString _lastError = ''.obs;
  final _messageStream = StreamController<dynamic>.broadcast();
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  Timer? _connectionTimeoutTimer;
  Timer? _healthCheckTimer;

  // Configuration
  static const int _reconnectDelay = 3; // seconds
  static const int _heartbeatInterval = 30; // seconds
  static const int _connectionTimeout = 10; // seconds
  static const int _maxReconnectAttempts = 5;
  static const int _healthCheckInterval = 60; // seconds

  int _reconnectAttempts = 0;
  String? _lastUrl;
  String? _clientId;
  bool _isManualDisconnect = false;
  DateTime? _lastHeartbeatResponse;

  Stream<dynamic> get messageStream => _messageStream.stream;
  String get connectionStatus => _connectionStatus.value;
  String get lastError => _lastError.value;
  bool get isConnected => _connectionStatus.value == 'connected';

  // Method to get detailed connection info for debugging
  Map<String, dynamic> get connectionInfo => {
    'status': _connectionStatus.value,
    'lastError': _lastError.value,
    'isConnected': isConnected,
    'lastUrl': _lastUrl,
    'clientId': _clientId,
    'reconnectAttempts': _reconnectAttempts,
    'isManualDisconnect': _isManualDisconnect,
  };

  // Method to test socket connection
  Future<void> testConnection() async {
    try {
      print('WebSocket: Testing connection...');
      print('WebSocket: Connection info: $connectionInfo');

      if (isConnected) {
        // Send a test message
        final testMessage = {
          'type': 'test',
          'message': 'Socket connection test from new tab',
          'timestamp': DateTime.now().toIso8601String(),
        };
        send(testMessage);
        print('WebSocket: Test message sent successfully');
      } else {
        print('WebSocket: Not connected, attempting to connect...');
        await ensureConnected();
      }
    } catch (e) {
      print('WebSocket: Error testing connection: $e');
    }
  }

  Future<void> connect(String url, {String? clientId}) async {
    if (_connectionStatus.value == 'connecting') {
      print('WebSocket: Already connecting, skipping...');
      return;
    }

    if (_isManualDisconnect) {
      print('WebSocket: Manual disconnect in progress, skipping connection');
      return;
    }

    try {
      _lastUrl = url;
      _clientId = clientId;
      _cancelTimers();
      _connectionStatus.value = 'connecting';
      _lastError.value = '';

      print('WebSocket: Attempting to connect to $url');

      _channel = WebSocketChannel.connect(
        Uri.parse(url),
      );

      // Set connection timeout
      _connectionTimeoutTimer = Timer(Duration(seconds: _connectionTimeout), () {
        if (_connectionStatus.value == 'connecting') {
          print('WebSocket: Connection timeout');
          _handleConnectionError('Connection timeout');
        }
      });

      _channel!.stream.listen(
            (data) {
          _connectionTimeoutTimer?.cancel();
          _handleMessage(data);
        },
        onError: (error) {
          _connectionTimeoutTimer?.cancel();
          _handleConnectionError('Stream error: $error');
        },
        onDone: () {
          _connectionTimeoutTimer?.cancel();
          _handleConnectionClosed();
        },
        cancelOnError: false,
      );

      _connectionStatus.value = 'connected';
      _reconnectAttempts = 0;
      print('WebSocket: Connected successfully');
      // Send user identification if userId is provided
      if (clientId != null && clientId.isNotEmpty) {
        _sendUserIdentification(clientId);
      }

      // Start heartbeat
      _startHeartbeat();

    } catch (e) {
      _connectionTimeoutTimer?.cancel();
      _handleConnectionError('Connection error: $e');
    }
  }

  void _handleMessage(dynamic data) {
    try {
      // Handle heartbeat response
      if (data is String && data == 'pong') {
        print('WebSocket: Heartbeat received');
        _lastHeartbeatResponse = DateTime.now();
        return;
      }

      _messageStream.add(data);
    } catch (e) {
      print('WebSocket: Error handling message: $e');
    }
  }

  void _handleConnectionError(String error) {
    if (_isManualDisconnect) return;

    _lastError.value = error;
    _connectionStatus.value = 'error';
    print('WebSocket: $error');

    _reconnect();
  }

  void _handleConnectionClosed() {
    if (_isManualDisconnect) return;

    _connectionStatus.value = 'disconnected';
    print('WebSocket: Connection closed');

    _reconnect();
  }

  void _reconnect() {
    if (_isManualDisconnect) {
      print('WebSocket: Manual disconnect in progress, skipping reconnection');
      return;
    }

    if (_lastUrl == null || _reconnectAttempts >= _maxReconnectAttempts) {
      print('WebSocket: Max reconnection attempts reached or no URL available');
      _connectionStatus.value = 'disconnected';
      return;
    }

    if (_reconnectTimer?.isActive == true) {
      print('WebSocket: Reconnect timer already active');
      return;
    }

    _reconnectAttempts++;
    _connectionStatus.value = 'reconnecting';
    print('WebSocket: Attempting to reconnect (${_reconnectAttempts}/$_maxReconnectAttempts)');

    _reconnectTimer = Timer(Duration(seconds: _reconnectDelay), () {
      if (!_isManualDisconnect) {
        connect(_lastUrl!, clientId: _clientId);
      }
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: _heartbeatInterval), (timer) {
      if (_connectionStatus.value == 'connected' && !_isManualDisconnect) {
        //send('ping');
      } else {
        timer.cancel();
      }
    });

    // Start health check timer
    _startHealthCheck();
  }

  void _startHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(Duration(seconds: _healthCheckInterval), (timer) {
      if (_connectionStatus.value == 'connected' && !_isManualDisconnect) {
        // Check if we've received a heartbeat response recently
        if (_lastHeartbeatResponse != null) {
          final timeSinceLastHeartbeat = DateTime.now().difference(_lastHeartbeatResponse!);
          if (timeSinceLastHeartbeat.inSeconds > _heartbeatInterval * 2) {
            print('WebSocket: No heartbeat response for ${timeSinceLastHeartbeat.inSeconds} seconds, reconnecting...');
            _handleConnectionError('Heartbeat timeout');
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _cancelTimers() {
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _connectionTimeoutTimer?.cancel();
    _healthCheckTimer?.cancel();
  }

  void _sendUserIdentification(String clientId) {
    try {
      final identificationMessage = {
        'type': 'identification',
        'clientId': clientId,
        'timestamp': DateTime.now().toIso8601String(),
      };
      send(identificationMessage);
      print('WebSocket: Sent client identification for clientId: $clientId');
    } catch (e) {
      print('WebSocket: Error sending client identification: $e');
    }
  }

  void send(dynamic message) {
    if (_channel != null && _connectionStatus.value == 'connected' && !_isManualDisconnect) {
      try {
        final messageToSend = message is Map ? json.encode(message) : message;
        _channel!.sink.add(messageToSend);
        print('WebSocket: Sent message: $messageToSend');
      } catch (e) {
        _lastError.value = 'Send error: $e';
        print('WebSocket: Send error: $e');
        // If send fails, it might indicate connection issues
        if (!_isManualDisconnect) {
          _handleConnectionError('Send error: $e');
        }
      }
    } else {
      print('WebSocket: Cannot send message - not connected or manual disconnect in progress');
    }
  }

  Future<void> disconnect() async {
    print('WebSocket: Manual disconnect initiated...');
    _isManualDisconnect = true;
    _cancelTimers();
    _connectionStatus.value = 'disconnected';
    _reconnectAttempts = 0;
    _lastUrl = null;
    _clientId = null;

    try {
      await _channel?.sink.close();
    } catch (e) {
      print('WebSocket: Error during disconnect: $e');
    }

    _channel = null;
    print('WebSocket: Disconnected');
  }

  // Method to reset manual disconnect flag (useful for reconnection after logout/login)
  void resetManualDisconnect() {
    _isManualDisconnect = false;
  }
  // Method to ensure socket is connected (useful for new tabs or direct navigation)
  Future<void> ensureConnected({String? clientId}) async {
    if (_connectionStatus.value == 'connected') {
      print('WebSocket: Already connected');
      return;
    }

    if (_connectionStatus.value == 'connecting') {
      print('WebSocket: Already connecting, waiting...');
      // Wait for connection to complete
      while (_connectionStatus.value == 'connecting') {
        await Future.delayed(Duration(milliseconds: 100));
      }
      return;
    }

    if (_lastUrl != null) {
      print('WebSocket: Ensuring connection to $_lastUrl');
      await connect(_lastUrl!, clientId: clientId);
    } else {
      print('WebSocket: No URL available, using default WebSocket URL');
      await connect(WebSocketUrl.webSocketUrl, clientId: clientId);
    }
  }

  // Method to initialize socket for new tabs with stored user data
  Future<void> initializeForNewTab() async {
    try {
      final box = GetStorage();
      final userId = box.read('id');
      final token = box.read('Authorization');

      print('WebSocket: initializeForNewTab called - userId: $userId, token: ${token != null ? 'present' : 'missing'}');

      if (userId != null && token != null) {
        print('WebSocket: Initializing for new tab with userId: $userId');

        // Connect directly with the URL and client ID
        await connect(WebSocketUrl.webSocketUrl, clientId: userId.toString());

        // Send user identification if connected
        if (_connectionStatus.value == 'connected') {
          print('WebSocket: Sending user identification for new tab');
          _sendUserIdentification(userId.toString());
        } else {
          print('WebSocket: Connection not established for new tab, status: ${_connectionStatus.value}');
        }
      } else {
        print('WebSocket: No user data found for new tab initialization');
      }
    } catch (e) {
      print('WebSocket: Error initializing for new tab: $e');
    }
  }

  // Method to handle app lifecycle changes
  void onAppLifecycleChanged(String state) {
    switch (state) {
      case 'resumed':
      // App came to foreground - ensure connection is active
        if (_lastUrl != null && _connectionStatus.value == 'disconnected' && !_isManualDisconnect) {
          print('WebSocket: App resumed, attempting to reconnect...');
          connect(_lastUrl!);
        }
        break;
      case 'paused':
      // App went to background - keep connection alive but don't send messages
        print('WebSocket: App paused, keeping connection alive');
        break;
      case 'inactive':
      // App is inactive - keep connection alive
        print('WebSocket: App inactive, keeping connection alive');
        break;
      case 'detached':
      // App is being terminated - this will be handled by onClose
        print('WebSocket: App detached');
        break;
    }
  }

  @override
  void onClose() {
    disconnect();
    _messageStream.close();
    super.onClose();
  }
}
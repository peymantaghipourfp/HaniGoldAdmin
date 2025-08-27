import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../config/const/socket.service.dart';
import '../../config/repository/url/web_socket_url.dart';

// Base controller that ensures socket connection for all controllers
class BaseController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final box = GetStorage();

  // Reactive variable to track socket connection status
  final RxBool isSocketConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Only ensure socket connection if user is logged in
    if (isLoggedIn) {
      _ensureSocketConnection();
    }
    _listenToSocketStatus();
  }

  void _listenToSocketStatus() {
    // Check socket status periodically since _connectionStatus is private
    Timer.periodic(Duration(seconds: 2), (timer) {
      final wasConnected = isSocketConnected.value;
      final isNowConnected = socketService.isConnected;

      if (wasConnected != isNowConnected) {
        isSocketConnected.value = isNowConnected;
        print('BaseController: Socket status changed to: ${isNowConnected ? 'connected' : 'disconnected'}');
      }

      // Stop timer if controller is disposed
      if (!Get.isRegistered<BaseController>()) {
        timer.cancel();
      }
    });
  }

  Future<void> _ensureSocketConnection() async {
    try {
      // Check if user is logged in
      final userId = box.read('id');
      final token = box.read('Authorization');

      if (userId != null && token != null) {
        print('BaseController: Ensuring socket connection for userId: $userId');
        // Ensure socket is connected
        await socketService.ensureConnected(clientId: userId.toString());

        // If this is a new tab and socket was just connected, send identification
        if (socketService.connectionStatus == 'connected') {
          socketService.send('{"clientId": "$userId"}');
          print('BaseController: Socket connected and identification sent');
        }
      } else {
        print('BaseController: No user data found for socket connection');
      }
    } catch (e) {
      print('Error ensuring socket connection in BaseController: $e');
    }
  }

  // Method to get current user ID
  int? get currentUserId => box.read('id');

  // Method to check if user is logged in
  bool get isLoggedIn {
    final token = box.read('Authorization');
    return token != null;
  }
}

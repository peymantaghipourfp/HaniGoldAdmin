// Stub implementation for non-web platforms
// This file is imported on mobile platforms where BroadcastChannel is not available

class BroadcastChannelHandler {
  void setup(String channelName, Function(dynamic data) onMessage) {
    // No-op on mobile platforms
    print('BroadcastChannel: Not available on mobile platforms');
  }

  void sendMessage(String channelName, dynamic data) {
    // No-op on mobile platforms
    print('BroadcastChannel: Not available on mobile platforms');
  }

  void close() {
    // No-op on mobile platforms
  }
}

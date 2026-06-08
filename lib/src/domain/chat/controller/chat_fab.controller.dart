import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/config/logger/app_logger.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/socket_chat_message.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/socket_chat_unread_total.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/socket_chat_waiting_total.model.dart';

/// Global chat FAB badge state and chat socket fan-out for the chat floating button.
///
/// Listens to [SocketService.messageStream] independently of [HomeController].
class ChatFabController extends GetxController {
  /// [GetStorage] key for login / socket-synchronized FAB unread total.
  static const String chatFabUnreadStorageKey = 'totalUnreadMessageCount';

  /// [GetStorage] key for login / socket-synchronized FAB waiting-chat total.
  static const String chatFabWaitingStorageKey = 'waitingChatCount';

  final box = GetStorage();
  StreamSubscription<dynamic>? _socketSubscription;

  /// Global unread count for the chat FAB (`chat.message` or `ack` for unread total).
  final chatFabUnreadCount = 0.obs;

  /// Global waiting-chat count for the chat FAB (`chat.message` or `ack` for waiting total).
  final chatFabWaitingCount = 0.obs;

  /// Pending `reqId` values for in-flight `chat.admin.unread.total` requests.
  final _pendingUnreadTotalReqIds = <String>{};

  /// Pending `reqId` values for in-flight `chat.admin.waiting.total` requests.
  final _pendingWaitingTotalReqIds = <String>{};

  /// Drives FAB attention animation when [chatFabUnreadCount] > 0.
  final chatFabHighlight = false.obs;

  @override
  void onInit() {
    hydrateChatFabFromStorage();
    _subscribeToSocket();
    super.onInit();
  }

  void _subscribeToSocket() {
    if (!Get.isRegistered<SocketService>()) return;
    _socketSubscription?.cancel();
    _socketSubscription = SocketService.to.messageStream.listen(
          (message) {
        if (message is! String) return;
        try {
          final decoded = json.decode(message);
          if (decoded is Map) {
            handleSocketEnvelope(Map<String, dynamic>.from(decoded));
          }
        } catch (e) {
          Get.log('Error processing socket message in ChatFabController: $e');
        }
      },
      onError: (error) {
        Get.log('Socket stream error in ChatFabController: $error');
      },
    );
  }

  /// Routes chat-related socket envelopes (used by the stream listener and tests).
  void handleSocketEnvelope(Map<String, dynamic> envelope) {
    final channel = envelope['channel'];
    if (channel == 'chat.message') {
      updateChatFabFromChatMessage(envelope);
      _forwardChatSocketEnvelope(envelope);
    } else if (channel == 'ack') {
      updateChatFabFromSocketAck(envelope);
      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().handleSocketAckEnvelope(envelope);
      }
    } else if (channel is String && channel.startsWith('chat.')) {
      _forwardChatSocketEnvelope(envelope);
    } else if (channel == 'error' && Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().handleSocketErrorEnvelope(envelope);
    }
  }

  /// Tracks [reqId] until the matching `ack` for `chat.admin.unread.total` arrives.
  void registerUnreadTotalRequest(String reqId) {
    final id = reqId.trim();
    if (id.isEmpty) return;
    _pendingUnreadTotalReqIds.add(id);
  }

  /// Tracks [reqId] until the matching `ack` for `chat.admin.waiting.total` arrives.
  void registerWaitingTotalRequest(String reqId) {
    final id = reqId.trim();
    if (id.isEmpty) return;
    _pendingWaitingTotalReqIds.add(id);
  }

  /// Applies FAB badge/highlight and persists [count] for the next session.
  void applyChatFabUnreadCount(int? count) {
    final safeCount = (count ?? 0).clamp(0, 999999);
    chatFabUnreadCount.value = safeCount;
    chatFabHighlight.value = safeCount > 0;
    box.write(chatFabUnreadStorageKey, safeCount);
  }

  /// Applies FAB waiting badge and persists [count] for the next session.
  void applyChatFabWaitingCount(int? count) {
    final safeCount = (count ?? 0).clamp(0, 999999);
    chatFabWaitingCount.value = safeCount;
    box.write(chatFabWaitingStorageKey, safeCount);
  }

  /// Restores FAB state after login or app start (before socket `chat.message`).
  void hydrateChatFabFromStorage() {
    final storedUnread = box.read(chatFabUnreadStorageKey);
    if (storedUnread is int) {
      applyChatFabUnreadCount(storedUnread);
    } else if (storedUnread is num) {
      applyChatFabUnreadCount(storedUnread.toInt());
    }

    final storedWaiting = box.read(chatFabWaitingStorageKey);
    if (storedWaiting is int) {
      applyChatFabWaitingCount(storedWaiting);
    } else if (storedWaiting is num) {
      applyChatFabWaitingCount(storedWaiting.toInt());
    }
  }

  void _forwardChatSocketEnvelope(Map<String, dynamic> envelope) {
    if (!Get.isRegistered<ChatController>()) {
      debugPrint(
        '[chat.message] ChatController not registered; channel=${envelope['channel']}',
      );
      return;
    }
    Get.find<ChatController>().handleSocketChatEnvelope(
      Map<String, dynamic>.from(envelope),
    );
  }

  /// Updates FAB badge/highlight from `chat.message` → [SocketChatMessagePayload.totalUnreadMessageCount].
  void updateChatFabFromChatMessage(Map<String, dynamic> envelope) {
    try {
      final payload = SocketChatMessageModel.fromJson(envelope);
      AppLogger.d(
        '[chat.message] SocketChatMessageModel:\n'
            '${const JsonEncoder.withIndent('  ').convert(payload.toJson())}',
      );
      final totalUnread = payload.data?.message?.totalUnreadMessageCount;
      if (totalUnread != null) {
        applyChatFabUnreadCount(totalUnread);
      }
      final waiting = payload.data?.message?.waitingChatCount;
      if (waiting != null) {
        applyChatFabWaitingCount(waiting);
      }
    } catch (e) {
      Get.log('updateChatFabFromChatMessage: $e');
    }
  }

  /// Dispatches `ack` envelopes to unread / waiting total handlers by [reqId].
  void updateChatFabFromSocketAck(Map<String, dynamic> envelope) {
    updateChatFabFromUnreadTotalAck(envelope);
    updateChatFabFromWaitingTotalAck(envelope);
  }

  /// Updates FAB from `ack` response to `chat.admin.unread.total` → [SocketChatUnreadTotalModel].
  void updateChatFabFromUnreadTotalAck(Map<String, dynamic> envelope) {
    try {
      final reqId = envelope['reqId']?.toString();
      if (reqId == null || !_pendingUnreadTotalReqIds.remove(reqId)) {
        return;
      }
      final payload = SocketChatUnreadTotalModel.fromJson(envelope);
      final totalUnread = payload.data?.totalUnreadMessageCount;
      if (totalUnread == null) return;
      applyChatFabUnreadCount(totalUnread);
    } catch (e) {
      Get.log('updateChatFabFromUnreadTotalAck: $e');
    }
  }

  /// Updates FAB from `ack` response to `chat.admin.waiting.total` → [SocketChatWaitingTotalModel].
  void updateChatFabFromWaitingTotalAck(Map<String, dynamic> envelope) {
    try {
      final reqId = envelope['reqId']?.toString();
      if (reqId == null || !_pendingWaitingTotalReqIds.remove(reqId)) {
        return;
      }
      final payload = SocketChatWaitingTotalModel.fromJson(envelope);
      final waiting = payload.data?.waitingChatCount;
      if (waiting == null) return;
      applyChatFabWaitingCount(waiting);
    } catch (e) {
      Get.log('updateChatFabFromWaitingTotalAck: $e');
    }
  }

  @override
  void onClose() {
    _socketSubscription?.cancel();
    super.onClose();
  }
}

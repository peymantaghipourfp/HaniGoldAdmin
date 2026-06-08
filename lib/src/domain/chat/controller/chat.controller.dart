import 'dart:async';
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/const/toast.service.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/chat.repository.dart';
import 'package:hanigold_admin/src/config/repository/chat_attachment.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/account_admin.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_account.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_history.model.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:flutter/foundation.dart';
import '../model/socket_chat_admin_send.model.dart' as admin_send;
import '../model/socket_chat_pick.model.dart' as pick;
import '../model/socket_chat_pick_broadcast.model.dart' as pick_bc;
import '../model/socket_chat_close.model.dart' as close;
import '../model/socket_chat_close_broadcast.model.dart' as close_bc;
import '../model/socket_chat_forward.model.dart' as forward;
import '../model/socket_chat_forward_broadcast.model.dart' as forward_bc;
import '../model/socket_chat_grant.model.dart' as grant;
import '../model/socket_chat_grant_broadcast.model.dart' as grant_bc;
import '../model/socket_chat_revoke.model.dart' as revoke;
import '../model/socket_chat_revoke_broadcast.model.dart' as revoke_bc;
import '../model/socket_chat_typing.model.dart' as typing;
import '../model/socket_chat_message.model.dart' as socket_msg;
import '../model/socket_chat_seen.model.dart' as seen;
import '../model/socket_chat_seen_broadcast.model.dart' as seen_bc;
import '../model/socket_chat_unread_total.model.dart' as unread_total;
import '../model/socket_chat_waiting_total.model.dart' as waiting_total;
import 'package:uuid/uuid.dart';

import '../model/chat_message.model.dart';
import '../model/topic.model.dart';
import '../utils/chat_attachment_pick.dart';
import '../utils/chat_voice_recording.dart';
import '../utils/chat_composer_text_editing.dart';
import '../utils/chat_open_conversation_match.dart';
import '../utils/chat_outbound_optimistic.dart';
import '../utils/chat_typing_match.dart';
import '../utils/chat_attachment_utils.dart';
import '../utils/chat_forward_outbound.dart';
import '../utils/chat_reply_resolver.dart';
import '../utils/chat_conversation_unread.dart';
import '../widget/chat_row.dart';
import 'chat_fab.controller.dart';

// ─── Pending attachment model ────────────────────────────────────────────────

class ChatPendingAttachment {
  ChatPendingAttachment({
    required this.name,
    required this.sizeBytes,
    required this.fileType,
    this.bytes,
    this.path,
  });

  final String name;
  final int sizeBytes;

  /// Server-accepted file-type string: image | video | audio | pdf | document | archive
  final String fileType;

  /// File bytes (always populated on web; also used on desktop when loaded).
  final Uint8List? bytes;

  /// Native file path (desktop/mobile only; null on web).
  final String? path;

  /// Set by [ChatController._uploadAttachment] after a successful upload.
  String? recordId;

  final RxDouble progress = 0.0.obs;
  final RxBool failed = false.obs;
}

/// Tab indices for the chat-account sidebar. **Order in UI:** تعیین‌نشده، همه، باز، بسته.
/// Each maps to `chatAccountStatus` for `Chat/getChatAccount` via [apiStatusFilter].
abstract final class ChatAccountListTabs {
  /// API filter value `3` (unpicked / not assigned). **Default tab** — index `0`, shown first.
  static const int unpicked = 0;
  static const int all = 1;
  static const int open = 2;
  static const int closed = 3;

  /// `null` means no `Predicate` on chat status (All tab).
  static int? apiStatusFilter(int tabIndex) {
    switch (tabIndex) {
      case unpicked:
        return 3;
      case all:
        return null;
      case open:
        return 0;
      case closed:
        return 1;
      default:
        return null;
    }
  }
}

class ChatController extends GetxController {
  final ChatRepository chatRepository = ChatRepository();
  final AccountRepository accountRepository = AccountRepository();
  final box = GetStorage();
  var uuid = Uuid();
  var reqId="".obs;

  // Observable variables
  RxList<ChatAccountModel> chatAccountList = <ChatAccountModel>[].obs;
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxList<ChatMessageModel> chatMessages = <ChatMessageModel>[].obs;
  RxList<AccountModel> accountList = <AccountModel>[].obs;
  RxList<AccountAdminModel> accountAdminList = <AccountAdminModel>[].obs;
  RxList<TopicModel> topicList = <TopicModel>[].obs;
  RxList<AccountModel> filteredAccountList = <AccountModel>[].obs;
  RxList<ChatAccountModel> filteredChatAccountList = <ChatAccountModel>[].obs;

  // Selected items
  Rxn<ChatAccountModel> selectedChatAccount = Rxn<ChatAccountModel>();
  Rxn<ChatModel> selectedChat = Rxn<ChatModel>();          // ← NEW
  Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  Rxn<TopicModel> selectedTopic = Rxn<TopicModel>();
  /// Topic filter for the per-account chat list panel (not the active conversation).
  Rxn<TopicModel> chatListTopicFilter = Rxn<TopicModel>();
  Rxn<ChatMessageModel> replyToMessage = Rxn<ChatMessageModel>();
  /// Message being forwarded into another conversation (composer preview + send).
  Rxn<ChatMessageModel> pendingForwardMessage = Rxn<ChatMessageModel>();

  // Controllers
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController chatAccountsSearchController = TextEditingController();
  final TextEditingController messagesSearchController = TextEditingController();
  final ScrollController messagesScrollController = ScrollController();

  final RxBool isMessageSearchExpanded = false.obs;
  final RxString activeMessageSearchQuery = ''.obs;
  Timer? _messageSearchDebounce;
  static const Duration _messageSearchDebounceDelay = Duration(milliseconds: 400);

  bool get isMessageSearchActive =>
      activeMessageSearchQuery.value.trim().isNotEmpty;

  // Scroll / composer UX state
  final RxBool isNearBottom = true.obs;
  final RxInt pendingNewMessages = 0.obs;
  /// Unread count for [JumpToLatestPill]; seeded from [ChatModel.unreadMessageCount], then
  /// updated locally as the admin scrolls (separate from outgoing double-check / seen ticks).
  final RxInt conversationUnreadCount = 0.obs;

  int _adminMarkedSeenSeq = 0;
  int _conversationUnreadAnchorSeq = 0;
  Timer? _seenScrollDebounce;
  static const Duration _seenScrollDebounceDelay = Duration(milliseconds: 120);

  /// Scroll to [ChatModel.clientSeenSeq] once the message [ListView] has mounted.
  int? _pendingConversationAnchorSeq;
  String? _initialScrollAppliedChatId;
  int _initialScrollRetryCount = 0;
  static const int _maxInitialScrollRetries = 24;
  final RxBool isComposerEmpty = true.obs;
  final RxBool isCustomerTyping = false.obs;

  Timer? _customerTypingIdleTimer;
  static const Duration _customerTypingIdle = Duration(seconds: 4);

  // Attachment state
  final RxList<ChatPendingAttachment> pendingAttachments =
      <ChatPendingAttachment>[].obs;
  final RxBool isUploadingAttachments = false.obs;
  final ChatAttachmentRepository _chatAttachmentRepo = ChatAttachmentRepository();

  /// Stable keys for [Scrollable.ensureVisible] when jumping to a message bubble.
  final Map<String, GlobalKey> _messageBubbleScrollKeys = {};
  /// Identity for scroll keys and reply-parent highlight (guid or chatId+seq).
  final Rx<String?> highlightedBubbleId = Rx<String?>(null);
  Timer? _replyHighlightTimer;
  static const Duration _replyHighlightDuration = Duration(milliseconds: 2000);
  static const int _bringMessageIntoViewAttempts = 40;

  /// Blocks loader-driven [loadMoreMessages] during programmatic scroll jumps.
  bool _suppressMessagePagination = false;

  void _clearMessageBubbleScrollKeys() {
    _messageBubbleScrollKeys.clear();
    _clearReplyHighlight();
  }

  void _clearReplyHighlight() {
    _replyHighlightTimer?.cancel();
    _replyHighlightTimer = null;
    highlightedBubbleId.value = null;
  }

  /// Same id as [scrollKeyForBubble] — used by [MessageBubble] for highlight paint.
  String bubbleIdentity(ChatMessageModel m) => _bubbleScrollKeyId(m);

  void _highlightReplyParent(ChatMessageModel target) {
    highlightedBubbleId.value = _bubbleScrollKeyId(target);
    _replyHighlightTimer?.cancel();
    _replyHighlightTimer = Timer(_replyHighlightDuration, () {
      if (highlightedBubbleId.value == _bubbleScrollKeyId(target)) {
        highlightedBubbleId.value = null;
      }
    });
  }

  /// Per-message key for the message list (see [scrollToReplyParent]).
  GlobalKey scrollKeyForBubble(ChatMessageModel m) {
    final id = _bubbleScrollKeyId(m);
    return _messageBubbleScrollKeys.putIfAbsent(id, GlobalKey.new);
  }

  String _bubbleScrollKeyId(ChatMessageModel m) {
    final g = normalizeReplyGuid(m.messageGuid);
    if (g != null) return 'g:$g';
    return 's:${m.chatId?.toString().trim()}:${m.seq}';
  }

  /// Brings a message bubble into view in the reversed list, then centers it.
  ///
  /// Variable-height media bubbles make absolute offset estimates unstable
  /// (`maxScrollExtent` oscillates as lazy rows build/unbuild). Instead we step
  /// the scroll offset forward monotonically (toward older messages = larger
  /// offset) by a viewport fraction each frame so intermediate rows build
  /// progressively and the target element materialises without backward jumps.
  Future<bool> _bringMessageIntoView(
      ChatMessageModel target, {
        Duration ensureVisibleDuration = const Duration(milliseconds: 380),
      }) async {
    final c = messagesScrollController;
    if (!c.hasClients) return false;

    final rowIndex = indexOfBubbleRowForMessage(chatMessages, target);
    if (rowIndex == null) return false;

    final key = scrollKeyForBubble(target);
    var stalledSteps = 0;

    for (var attempt = 0; attempt < _bringMessageIntoViewAttempts; attempt++) {
      final ctx = key.currentContext;
      if (ctx != null) {
        await Scrollable.ensureVisible(
          ctx,
          alignment: 0.38,
          duration: ensureVisibleDuration,
          curve: Curves.easeInOut,
        );
        return true;
      }

      if (!c.hasClients) return false;

      final pos = c.position;
      final max = pos.maxScrollExtent;
      final current = pos.pixels;
      // Step < viewport + cacheExtent so we never skip the target unbuilt.
      final step = pos.viewportDimension * 0.7;
      final next = (current + step).clamp(0.0, max);

      if (next <= current + 0.5) {
        // Reached the end of the list without building the target.
        if (++stalledSteps >= 2) break;
      } else {
        stalledSteps = 0;
      }

      c.jumpTo(next);
      await WidgetsBinding.instance.endOfFrame;
    }

    return false;
  }

  /// Session-scoped cache: recordId → attachment (with bytes).
  /// Used by the bubble renderer to display image thumbnails for
  /// just-sent optimistic messages without a server round-trip.
  final Map<String, ChatPendingAttachment> _sentAttachmentsCache = {};

  /// Original upload file names keyed by [recordId] (survives socket/API without fileName).
  final Map<String, String> _attachmentFileNameByRecordId = {};

  /// Downloaded attachment bytes for history / non-image previews (keyed by recordId).
  final Map<String, Uint8List> _chatAttachmentBytesCache = {};

  /// When the server echoes a different [recordId] than the outbound upload id,
  /// maps server id → client upload id so downloads can still resolve bytes.
  final Map<String, String> _attachmentRecordIdAliases = {};

  /// Returns cached attachment data for [recordId], or null if not in cache.
  ChatPendingAttachment? getCachedAttachment(String recordId) {
    final id = recordId.trim();
    final hit = _sentAttachmentsCache[id];
    if (hit != null) return hit;
    final aliased = _attachmentRecordIdAliases[id];
    if (aliased != null) return _sentAttachmentsCache[aliased];
    return null;
  }

  /// Resolved original file name for display and download.
  String? resolvedAttachmentFileName(
      String recordId, {
        String? fromFilesJson,
      }) {
    final id = recordId.trim();
    final cached = getCachedAttachment(id)?.name.trim();
    if (cached != null && cached.isNotEmpty) return cached;
    final stored = _attachmentFileNameByRecordId[id]?.trim() ??
        _attachmentFileNameByRecordId[_attachmentRecordIdAliases[id] ?? '']?.trim();
    if (stored != null && stored.isNotEmpty) return stored;
    final fromJson = fromFilesJson?.trim();
    if (fromJson != null && fromJson.isNotEmpty) return fromJson;
    return null;
  }

  /// Fetches bytes for [recordId] via [Attachment/downloadChatAttachment],
  /// with in-memory de-duplication so scrolling does not re-hit the network.
  Future<Uint8List?> fetchChatAttachmentBytes(String recordId) async {
    final normalizedId = recordId.trim();
    if (normalizedId.isEmpty) return null;

    final hit = _chatAttachmentBytesCache[normalizedId];
    if (hit != null) return hit;
    final pending = _sentAttachmentsCache[normalizedId]?.bytes;
    if (pending != null) {
      _chatAttachmentBytesCache[normalizedId] = pending;
      return pending;
    }

    final aliased = _attachmentRecordIdAliases[normalizedId];
    if (aliased != null) {
      final aliasedBytes = _chatAttachmentBytesCache[aliased] ??
          _sentAttachmentsCache[aliased]?.bytes;
      if (aliasedBytes != null) {
        _chatAttachmentBytesCache[normalizedId] = aliasedBytes;
        return aliasedBytes;
      }
    }
    try {
      final bytes = await _chatAttachmentRepo.downloadChatAttachment(
        recordId: normalizedId,
      );
      _chatAttachmentBytesCache[normalizedId] = bytes;
      return bytes;
    } catch (_) {
      return null;
    }
  }

  void _registerAttachmentRecordIdAlias(String serverId, String uploadId) {
    final s = serverId.trim();
    final u = uploadId.trim();
    if (s.isEmpty || u.isEmpty || s == u) return;
    _attachmentRecordIdAliases[s] = u;
  }

  void _remapAttachmentCachesForRecordIdAlias(String serverId, String uploadId) {
    _registerAttachmentRecordIdAlias(serverId, uploadId);
    final pending = _sentAttachmentsCache.remove(uploadId);
    if (pending != null) {
      _sentAttachmentsCache[serverId] = pending;
      if (pending.bytes != null) {
        _chatAttachmentBytesCache[serverId] = pending.bytes!;
      }
    }
    final name = _attachmentFileNameByRecordId.remove(uploadId);
    if (name != null) {
      _attachmentFileNameByRecordId[serverId] = name;
    }
    final bytes = _chatAttachmentBytesCache.remove(uploadId);
    if (bytes != null) {
      _chatAttachmentBytesCache[serverId] = bytes;
    }
  }

  void _syncAttachmentRecordIdAliasesFromFilesJson(
      String? incoming,
      String? optimistic,
      ) {
    if (incoming == null || optimistic == null) return;
    try {
      final inItems = json.decode(incoming) as List<dynamic>;
      final outItems = json.decode(optimistic) as List<dynamic>;
      final limit = inItems.length < outItems.length
          ? inItems.length
          : outItems.length;
      for (var i = 0; i < limit; i++) {
        final inEntry = inItems[i];
        final outEntry = outItems[i];
        if (inEntry is! Map || outEntry is! Map) continue;
        final inMap = Map<String, dynamic>.from(inEntry);
        final outMap = Map<String, dynamic>.from(outEntry);
        final inId =
        (inMap['recordId'] ?? inMap['RecordId'])?.toString().trim();
        final outId =
        (outMap['recordId'] ?? outMap['RecordId'])?.toString().trim();
        if (inId == null ||
            outId == null ||
            inId.isEmpty ||
            outId.isEmpty ||
            inId == outId) {
          continue;
        }
        _remapAttachmentCachesForRecordIdAlias(inId, outId);
      }
    } catch (_) {}
  }

  // State variables
  RxBool isLoadingChatAccounts = false.obs;
  RxBool isLoadingChats = false.obs;
  RxBool isLoadingMessages = false.obs;
  RxBool isLoadingAccounts = false.obs;
  RxBool isLoadingAccountsAdmin = false.obs;
  RxBool isLoadingTopics = false.obs;
  RxBool isSendingMessage = false.obs;

  // Pagination variables
  RxBool isLoadingMoreChatAccounts = false.obs;
  RxBool isLoadingMoreChats = false.obs;
  RxBool isLoadingMoreMessages = false.obs;
  RxBool hasMoreChatAccounts = true.obs;
  RxBool hasMoreChats = true.obs;
  RxBool hasMoreMessages = true.obs;
  int chatAccountPage = 1;
  int chatPage = 1;
  int messagePage = 1;
  final int pageSize = 10;


  RxInt selectedChatTab = ChatAccountListTabs.unpicked.obs;
  int? _chatAccountStatusFilter;

  /// Empty-state hint when the filtered list has no rows (search may still apply).
  String get chatAccountListEmptyHint {
    switch (selectedChatTab.value) {
      case ChatAccountListTabs.open:
        return 'هیچ اکانت گفتگوی بازی یافت نشد';
      case ChatAccountListTabs.closed:
        return 'هیچ اکانت گفتگوی بسته‌ای یافت نشد';
      case ChatAccountListTabs.unpicked:
        return 'هیچ اکانت گفتگوی انتخاب ‌نشده‌ای یافت نشد';
      default:
        return 'هیچ اکانت گفتگویی یافت نشد';
    }
  }

  List<ChatAccountModel> get filteredChatAccounts {
    // Read Rx length so [Obx] listeners (e.g. [ChatListContent]) rebuild when
    // [filterChatAccounts] updates the list while search text lives on a plain
    // [TextEditingController], not an [Rx] string.
    filteredChatAccountList.length;
    final q = chatAccountsSearchController.text.trim();
    if (q.isEmpty) {
      return chatAccountList;
    }
    return filteredChatAccountList;
  }

  // Current user ID
  String get currentUserId => box.read('id').toString();
  String get currentUserName => box.read('userName') ?? 'کاربر';

  late final FocusNode messageFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.isShiftPressed) {
        if (!isSendingMessage.value) {
          Future.microtask(() {
            final value = messageController.value;
            var text = value.text;
            if (text.endsWith('\n')) {
              text = text.substring(0, text.length - 1);
            }
            messageController.value = value.copyWith(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
              composing: TextRange.empty,
            );
            sendMessage();
          });
        }
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );

  /// Returns keyboard focus to the message field so [messageFocusNode.onKeyEvent]
  /// (Enter to send) keeps working after emoji/attachment UI interactions.
  void refocusMessageComposer() {
    if (!messageFocusNode.canRequestFocus) return;
    messageFocusNode.requestFocus();
  }

  void scheduleRefocusMessageComposer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refocusMessageComposer();
    });
  }

  void _onMessageComposerTextChanged() {
    isComposerEmpty.value = messageController.text.trim().isEmpty;
    final value = messageController.value;
    if (value.composing.isValid) return;
    final normalized = normalizeComposerTextEditingValue(value);
    if (normalized == value) return;
    messageController.value = normalized;
  }

  @override
  void onInit() {
    loadAccountList();
    loadChatAccountList(refresh: true);
    _initializeSocketListener();
    messageController.addListener(_onMessageComposerTextChanged);
    messagesScrollController.addListener(_onMessagesScrollChanged);
    super.onInit();
  }

  @override
  void onClose() {
    _clearCustomerTyping();
    _clearReplyHighlight();
    messageController.removeListener(_onMessageComposerTextChanged);
    messagesScrollController.dispose();
    searchController.dispose();
    chatAccountsSearchController.dispose();
    _messageSearchDebounce?.cancel();
    _seenScrollDebounce?.cancel();
    messagesSearchController.dispose();
    messageFocusNode.dispose();
    super.onClose();
  }

  void _onMessagesScrollChanged() {
    if (!messagesScrollController.hasClients) return;
    isNearBottom.value = messagesScrollController.position.pixels < 80;
    _seenScrollDebounce?.cancel();
    _seenScrollDebounce = Timer(_seenScrollDebounceDelay, () {
      unawaited(_syncSeenFromScrollPosition());
    });
  }

  /// Advances admin read cursor from scroll position (debounced). Unread pill decreases
  /// as newer messages enter the viewport; does not run on panel open.
  Future<void> _syncSeenFromScrollPosition() async {
    final chatId = selectedChat.value?.chatId?.trim();
    if (chatId == null || chatId.isEmpty) return;
    if (isLoadingMessages.value || chatMessages.isEmpty) return;

    final upToSeq = isNearBottom.value
        ? _maxLoadedMessageSeq()
        : _maxVisibleMessageSeqInViewport();
    if (upToSeq == null || upToSeq <= _adminMarkedSeenSeq) return;

    await markMessagesSeenUpTo(upToSeq);
  }

  int? _maxVisibleMessageSeqInViewport() {
    if (!messagesScrollController.hasClients) return null;

    final scrollContext =
        messagesScrollController.position.context.notificationContext;
    if (scrollContext == null) return null;

    final viewportRender = scrollContext.findRenderObject() as RenderBox?;
    if (viewportRender == null || !viewportRender.hasSize) return null;

    final viewportRect = Rect.fromPoints(
      viewportRender.localToGlobal(Offset.zero),
      viewportRender.localToGlobal(viewportRender.size.bottomRight(Offset.zero)),
    );

    final chatId = selectedChat.value?.chatId?.trim();
    int? maxSeq;

    for (final entry in _messageBubbleScrollKeys.entries) {
      final bubbleCtx = entry.value.currentContext;
      if (bubbleCtx == null) continue;

      final box = bubbleCtx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached || !box.hasSize) continue;

      final bubbleRect = Rect.fromPoints(
        box.localToGlobal(Offset.zero),
        box.localToGlobal(box.size.bottomRight(Offset.zero)),
      );
      if (!bubbleRect.overlaps(viewportRect)) continue;

      final seq = _seqForBubbleScrollKeyId(entry.key, chatId);
      if (seq == null) continue;
      if (maxSeq == null || seq > maxSeq) maxSeq = seq;
    }

    return maxSeq;
  }

  int? _seqForBubbleScrollKeyId(String keyId, String? chatId) {
    if (keyId.startsWith('s:')) {
      final parts = keyId.split(':');
      if (parts.length != 3) return null;
      if (chatId != null && parts[1] != chatId) return null;
      return int.tryParse(parts[2]);
    }

    for (final m in chatMessages) {
      if (_bubbleScrollKeyId(m) != keyId) continue;
      if (chatId != null && m.chatId?.toString().trim() != chatId) continue;
      return m.seq;
    }
    return null;
  }

  /// Smoothly scrolls the (reversed) message list to the newest message.
  void scrollToLatest({bool animate = true}) {
    if (!messagesScrollController.hasClients) return;
    if (animate) {
      messagesScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      messagesScrollController.jumpTo(0.0);
    }
  }

  /// Jumps to latest and marks every loaded message as read (jump pill).
  Future<void> jumpToLatestAndMarkAllRead() async {
    scrollToLatest();
    pendingNewMessages.value = 0;
    final maxSeq = _maxLoadedMessageSeq();
    if (maxSeq != null) {
      await markMessagesSeenUpTo(maxSeq, force: true);
    } else {
      conversationUnreadCount.value = 0;
    }
  }

  int? _maxLoadedMessageSeq() {
    int? max;
    for (final m in chatMessages) {
      final s = m.seq;
      if (s != null && (max == null || s > max)) max = s;
    }
    return max;
  }

  void _syncConversationUnreadFromChat(ChatModel chat) {
    final unread = chat.unreadMessageCount ?? 0;
    conversationUnreadCount.value = unread;
  }

  void _updateConversationUnreadAfterSeen(int upToSeq) {
    final chat = selectedChat.value;
    final serverUnread =
        chat?.unreadMessageCount ?? conversationUnreadCount.value;
    conversationUnreadCount.value = conversationUnreadAfterSeen(
      serverUnread: serverUnread,
      anchorSeenSeq: _conversationUnreadAnchorSeq,
      newSeenSeq: upToSeq,
      loadedMessages: chatMessages,
      lastMessageSeq: chat?.lastMessageSeq ?? 0,
      maxLoadedSeq: _maxLoadedMessageSeq() ?? 0,
    );
  }

  Future<void> markMessagesSeenUpTo(int upToSeq, {bool force = false}) async {
    if (upToSeq <= 0) return;
    if (!force && upToSeq <= _adminMarkedSeenSeq) return;

    final chatId = selectedChat.value?.chatId?.trim();
    if (chatId == null || chatId.isEmpty) return;

    final prevMarked = _adminMarkedSeenSeq;
    _adminMarkedSeenSeq = upToSeq;
    _updateConversationUnreadAfterSeen(upToSeq);

    final sent = await sendSeenChatRequest(chatId, upToSeq);
    if (!sent) {
      _adminMarkedSeenSeq = prevMarked;
      _syncConversationUnreadFromChat(selectedChat.value!);
      return;
    }

    _mergeSeenIntoChatLists(
      chatId: chatId,
      upToSeq: upToSeq,
      unreadMessageCount: conversationUnreadCount.value,
    );
    unawaited(requestChatUnreadTotal());
    unawaited(requestChatWaitingTotal());
  }

  /// Sends `chat.admin.seen` ([SocketChatSeenModel]); [upToSeq] maps to `UpToSeq` in JSON.
  Future<bool> sendSeenChatRequest(String chatId, int upToSeq) async {
    if (chatId.isEmpty || upToSeq <= 0) return false;
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final payload = seen.SocketChatSeenModel(
        channel: 'chat.admin.seen',
        reqId: uuid.v4(),
        data: seen.Data(
          chatId: chatId,
          upToSeq: upToSeq,
        ),
      );
      SocketService.to.send(payload.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('[chat.admin.seen] send failed: $e');
      return false;
    }
  }

  /// Requests global unread total; server replies on `ack` with matching [reqId].
  Future<void> requestChatUnreadTotal() async {
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final reqId = uuid.v4();
      if (Get.isRegistered<ChatFabController>()) {
        Get.find<ChatFabController>().registerUnreadTotalRequest(reqId);
      }
      final payload = unread_total.SocketChatUnreadTotalRequest(reqId: reqId);
      SocketService.to.send(payload.toJson());
    } catch (e) {
      if (kDebugMode) debugPrint('[chat.admin.unread.total] send failed: $e');
    }
  }

  /// Requests global waiting-chat total; server replies on `ack` with matching [reqId].
  Future<void> requestChatWaitingTotal() async {
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final reqId = uuid.v4();
      if (Get.isRegistered<ChatFabController>()) {
        Get.find<ChatFabController>().registerWaitingTotalRequest(reqId);
      }
      final payload = waiting_total.SocketChatWaitingTotalRequest(reqId: reqId);
      SocketService.to.send(payload.toJson());
    } catch (e) {
      if (kDebugMode) debugPrint('[chat.admin.waiting.total] send failed: $e');
    }
  }

  /// Updates double-check state on admin outgoing rows when the customer has read up to [upToSeq].
  void _applyOutgoingSeenByCustomer({required int upToSeq}) {
    var changed = false;
    final now = DateTime.now();
    for (var i = 0; i < chatMessages.length; i++) {
      final m = chatMessages[i];
      if (m.senderType != 1) continue;
      final seq = m.seq;
      if (seq == null || seq > upToSeq) continue;
      if (m.seen == true || m.seenOnUtc != null) continue;
      chatMessages[i] = ChatMessageModel(
        rowNum: m.rowNum,
        chatId: m.chatId,
        messageGuid: m.messageGuid,
        replyToMessageGuid: m.replyToMessageGuid,
        replyMessage: m.replyMessage,
        seq: m.seq,
        senderType: m.senderType,
        senderAccountId: m.senderAccountId,
        senderUserId: m.senderUserId,
        messageType: m.messageType,
        text: m.text,
        createdOnUtc: m.createdOnUtc,
        isDeleted: m.isDeleted,
        deliveredOnUtc: m.deliveredOnUtc ?? now,
        seenOnUtc: now,
        seen: true,
        senderAccountName: m.senderAccountName,
        replyToSeq: m.replyToSeq,
        forwardFromSeq: m.forwardFromSeq,
        forwardFromMessageGuid: m.forwardFromMessageGuid,
        forwardFromSenderName: m.forwardFromSenderName,
        forwardMessage: m.forwardMessage,
        filesJson: m.filesJson,
      );
      changed = true;
    }
    if (changed) chatMessages.refresh();
  }

  void _mergeSeenIntoChatLists({
    required String chatId,
    required int upToSeq,
    required int unreadMessageCount,
    int? customerAccountId,
    int? totalUnreadMessageCount,
  }) {
    int? accountId = customerAccountId;
    var previousChatUnread = 0;
    final idx = chatList.indexWhere((c) => c.chatId == chatId);
    if (idx != -1) {
      final c = chatList[idx];
      accountId ??= c.accountId;
      previousChatUnread = c.unreadMessageCount ?? 0;
      chatList[idx] = ChatModel(
        rowNum: c.rowNum,
        chatId: c.chatId,
        accountId: c.accountId,
        topicId: c.topicId,
        topicCode: c.topicCode,
        topicTitle: c.topicTitle,
        status: c.status,
        createdOn: c.createdOn,
        lastActivity: c.lastActivity,
        accountName: c.accountName,
        lastMessageSeq: c.lastMessageSeq,
        lastSeenSeq: c.lastSeenSeq,
        clientSeenSeq: upToSeq,
        lastMessagePreview: c.lastMessagePreview,
        lastMessageOn: c.lastMessageOn,
        totalMessageCount: c.totalMessageCount,
        unreadMessageCount: unreadMessageCount,
        topicKey: c.topicKey,
        assignedAdminAccountId: c.assignedAdminAccountId,
        assignedAdminUserId: c.assignedAdminUserId,
        closedOn: c.closedOn,
        assignedAdminName: c.assignedAdminName,
        userId: c.userId,
        adminRole: c.adminRole,
        adminRoleTitle: c.adminRoleTitle,
      );
    }

    final sel = selectedChat.value;
    if (sel?.chatId == chatId) {
      selectedChat.value = ChatModel(
        rowNum: sel!.rowNum,
        chatId: sel.chatId,
        accountId: sel.accountId,
        topicId: sel.topicId,
        topicCode: sel.topicCode,
        topicTitle: sel.topicTitle,
        status: sel.status,
        createdOn: sel.createdOn,
        lastActivity: sel.lastActivity,
        accountName: sel.accountName,
        lastMessageSeq: sel.lastMessageSeq,
        lastSeenSeq: sel.lastSeenSeq,
        clientSeenSeq: upToSeq,
        lastMessagePreview: sel.lastMessagePreview,
        lastMessageOn: sel.lastMessageOn,
        totalMessageCount: sel.totalMessageCount,
        unreadMessageCount: unreadMessageCount,
        topicKey: sel.topicKey,
        assignedAdminAccountId: sel.assignedAdminAccountId,
        assignedAdminUserId: sel.assignedAdminUserId,
        closedOn: sel.closedOn,
        assignedAdminName: sel.assignedAdminName,
        userId: sel.userId,
        adminRole: sel.adminRole,
        adminRoleTitle: sel.adminRoleTitle,
      );
      accountId ??= sel.accountId;
      if (idx == -1) {
        previousChatUnread = sel.unreadMessageCount ?? 0;
      }
    }

    _syncAccountUnreadAfterChatSeen(
      accountId: accountId,
      previousChatUnread: previousChatUnread,
      newChatUnread: unreadMessageCount,
      totalUnreadMessageCount: totalUnreadMessageCount,
    );
  }

  /// Keeps [chatAccountList] / [selectedChatAccount] [unreadChatCount] in sync when a thread is read.
  void _syncAccountUnreadAfterChatSeen({
    required int? accountId,
    required int previousChatUnread,
    required int newChatUnread,
    int? totalUnreadMessageCount,
  }) {
    if (accountId == null) return;

    final accountIndex =
    chatAccountList.indexWhere((a) => a.accountId == accountId);
    if (accountIndex == -1) return;

    final current = chatAccountList[accountIndex];
    var unreadChatCount = current.unreadChatCount ?? 0;
    if (previousChatUnread > 0 && newChatUnread == 0) {
      unreadChatCount = unreadChatCount > 0 ? unreadChatCount - 1 : 0;
    }

    final updatedAccount = ChatAccountModel(
      rowNum: current.rowNum,
      accountId: current.accountId,
      accountName: current.accountName,
      lastChatId: current.lastChatId,
      lastMessageOn: current.lastMessageOn,
      lastMessagePreview: current.lastMessagePreview,
      totalMessageCount: current.totalMessageCount,
      unreadMessageCount:
      totalUnreadMessageCount ?? current.unreadMessageCount,
      unreadChatCount: unreadChatCount,
      adminChatRole: current.adminChatRole,
      chatStatus: current.chatStatus,
    );
    chatAccountList[accountIndex] = updatedAccount;

    if (selectedChatAccount.value?.accountId == accountId) {
      selectedChatAccount.value = updatedAccount;
    }
    filterChatAccounts(chatAccountsSearchController.text);
  }

  /// Live unread-thread count for an account row; use inside [Obx].
  int liveUnreadChatCountForAccount(int? accountId) {
    if (accountId == null) return 0;
    chatAccountList.length;
    filteredChatAccountList.length;
    final row =
    chatAccountList.firstWhereOrNull((a) => a.accountId == accountId);
    return row?.unreadChatCount ?? 0;
  }

  void _handleSeenBroadcast(Map<String, dynamic> data) {
    try {
      final payload = seen_bc.SocketChatSeenBroadcastModel(
        channel: 'chat.seen',
        data: seen_bc.Data.fromJson(data),
      );
      final d = payload.data;
      if (d == null) return;

      final chatId = d.chatId?.trim();
      if (chatId == null || chatId.isEmpty) return;

      final upToSeq = d.upToSeq;
      final unread = d.unreadMessageCount ?? 0;

      if (upToSeq != null) {
        _mergeSeenIntoChatLists(
          chatId: chatId,
          upToSeq: upToSeq,
          unreadMessageCount: unread,
          customerAccountId: d.customerAccountId,
          totalUnreadMessageCount: d.totalUnreadMessageCount,
        );
      } else {
        int? accountId = d.customerAccountId;
        var previousChatUnread = 0;
        final idx = chatList.indexWhere((c) => c.chatId == chatId);
        if (idx != -1) {
          final c = chatList[idx];
          accountId ??= c.accountId;
          previousChatUnread = c.unreadMessageCount ?? 0;
          chatList[idx] = ChatModel(
            rowNum: c.rowNum,
            chatId: c.chatId,
            accountId: c.accountId,
            topicId: c.topicId,
            topicCode: c.topicCode,
            topicTitle: c.topicTitle,
            status: c.status,
            createdOn: c.createdOn,
            lastActivity: c.lastActivity,
            accountName: c.accountName,
            lastMessageSeq: c.lastMessageSeq,
            lastSeenSeq: c.lastSeenSeq,
            clientSeenSeq: c.clientSeenSeq,
            lastMessagePreview: c.lastMessagePreview,
            lastMessageOn: c.lastMessageOn,
            totalMessageCount: c.totalMessageCount,
            unreadMessageCount: unread,
            topicKey: c.topicKey,
            assignedAdminAccountId: c.assignedAdminAccountId,
            assignedAdminUserId: c.assignedAdminUserId,
            closedOn: c.closedOn,
            assignedAdminName: c.assignedAdminName,
            userId: c.userId,
            adminRole: c.adminRole,
            adminRoleTitle: c.adminRoleTitle,
          );
        }
        final sel = selectedChat.value;
        if (sel?.chatId == chatId) {
          selectedChat.value = ChatModel(
            rowNum: sel!.rowNum,
            chatId: sel.chatId,
            accountId: sel.accountId,
            topicId: sel.topicId,
            topicCode: sel.topicCode,
            topicTitle: sel.topicTitle,
            status: sel.status,
            createdOn: sel.createdOn,
            lastActivity: sel.lastActivity,
            accountName: sel.accountName,
            lastMessageSeq: sel.lastMessageSeq,
            lastSeenSeq: sel.lastSeenSeq,
            clientSeenSeq: sel.clientSeenSeq,
            lastMessagePreview: sel.lastMessagePreview,
            lastMessageOn: sel.lastMessageOn,
            totalMessageCount: sel.totalMessageCount,
            unreadMessageCount: unread,
            topicKey: sel.topicKey,
            assignedAdminAccountId: sel.assignedAdminAccountId,
            assignedAdminUserId: sel.assignedAdminUserId,
            closedOn: sel.closedOn,
            assignedAdminName: sel.assignedAdminName,
            userId: sel.userId,
            adminRole: sel.adminRole,
            adminRoleTitle: sel.adminRoleTitle,
          );
          accountId ??= sel.accountId;
          if (idx == -1) {
            previousChatUnread = sel.unreadMessageCount ?? 0;
          }
        }

        _syncAccountUnreadAfterChatSeen(
          accountId: accountId,
          previousChatUnread: previousChatUnread,
          newChatUnread: unread,
          totalUnreadMessageCount: d.totalUnreadMessageCount,
        );
      }

      if (selectedChat.value?.chatId == chatId) {
        conversationUnreadCount.value = unread;
        final myUserId = int.tryParse(currentUserId);
        final readerIsCustomer =
            d.byUserId != null && myUserId != null && d.byUserId != myUserId;
        if (upToSeq != null) {
          if (!readerIsCustomer && upToSeq > _adminMarkedSeenSeq) {
            _adminMarkedSeenSeq = upToSeq;
          }
          if (readerIsCustomer) {
            _applyOutgoingSeenByCustomer(upToSeq: upToSeq);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[chat.seen] broadcast parse error: $e');
    }
  }

  Future<void> _ensureAnchorMessageLoaded(String chatId, int anchorSeq) async {
    if (anchorSeq <= 0) return;
    const maxPages = 24;
    for (var i = 0; i < maxPages; i++) {
      if (chatMessages.any((m) => m.seq == anchorSeq)) return;
      final oldest = chatMessages.isEmpty
          ? null
          : chatMessages
          .map((m) => m.seq)
          .whereType<int>()
          .fold<int?>(null, (a, b) => a == null || b < a ? b : a);
      if (oldest != null && oldest <= anchorSeq) return;
      if (!hasMoreMessages.value) return;
      final before = chatMessages.length;
      await loadChatMessages(chatId);
      if (chatMessages.length <= before) return;
    }
  }

  ChatMessageModel? _messageForSeq(int seq) {
    final chatId = selectedChat.value?.chatId?.toString().trim();
    return chatMessages.firstWhereOrNull(
          (m) => m.seq == seq && m.chatId?.toString().trim() == chatId,
    );
  }

  bool _shouldAnchorToLastRead(ChatModel chat) {
    final anchorSeq = chat.clientSeenSeq ?? 0;
    if (anchorSeq <= 0) return false;
    final lastMsgSeq = chat.lastMessageSeq ?? 0;
    final unread = chat.unreadMessageCount ?? 0;
    return unread > 0 || lastMsgSeq > anchorSeq;
  }

  void _scheduleInitialConversationScroll(ChatModel chat) {
    _initialScrollRetryCount = 0;
    _initialScrollAppliedChatId = null;
    if (_shouldAnchorToLastRead(chat)) {
      _pendingConversationAnchorSeq = chat.clientSeenSeq ?? 0;
      isNearBottom.value = false;
    } else {
      _pendingConversationAnchorSeq = null;
      isNearBottom.value = true;
    }
  }

  void _completeInitialScrollSession(String chatId) {
    _initialScrollAppliedChatId = chatId;
    _pendingConversationAnchorSeq = null;
    _initialScrollRetryCount = 0;
    if (messagesScrollController.hasClients) {
      isNearBottom.value = messagesScrollController.position.pixels < 80;
    }
  }

  /// Called from [ConversationPanel] after the reversed [ListView] is built.
  Future<void> applyInitialConversationScrollIfNeeded() async {
    final chatId = selectedChat.value?.chatId?.trim();
    if (chatId == null || chatId.isEmpty) return;
    if (_initialScrollAppliedChatId == chatId) return;
    if (isLoadingMessages.value || chatMessages.isEmpty) return;

    final anchorSeq = _pendingConversationAnchorSeq;
    if (anchorSeq == null || anchorSeq <= 0) {
      if (messagesScrollController.hasClients) {
        scrollToLatest(animate: false);
      }
      _completeInitialScrollSession(chatId);
      await _syncSeenFromScrollPosition();
      return;
    }

    if (!messagesScrollController.hasClients) {
      if (_initialScrollRetryCount++ < _maxInitialScrollRetries) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(applyInitialConversationScrollIfNeeded());
        });
      }
      return;
    }

    await _ensureAnchorMessageLoaded(chatId, anchorSeq);
    final target = _messageForSeq(anchorSeq);
    if (target == null) {
      _completeInitialScrollSession(chatId);
      return;
    }

    _suppressMessagePagination = true;
    try {
      await _bringMessageIntoView(
        target,
        ensureVisibleDuration: Duration.zero,
      );
    } finally {
      _suppressMessagePagination = false;
    }

    _completeInitialScrollSession(chatId);
    await _syncSeenFromScrollPosition();
  }

  void _prepareConversationState(ChatModel chat) {
    _clearCustomerTyping();
    _clearMessageSearchState();
    chatMessages.clear();
    _clearMessageBubbleScrollKeys();
    replyToMessage.value = null;
    messageController.clear();
    pendingNewMessages.value = 0;
    _seenScrollDebounce?.cancel();

    final lastSeen = chat.clientSeenSeq ?? 0;
    _adminMarkedSeenSeq = lastSeen;
    _conversationUnreadAnchorSeq = lastSeen;
    _syncConversationUnreadFromChat(chat);
    _scheduleInitialConversationScroll(chat);

    if (chat.topicTitle != null) {
      final matchingTopic = topicList.firstWhereOrNull(
            (t) => t.title == chat.topicTitle,
      );
      if (matchingTopic != null) {
        selectedTopic.value = matchingTopic;
      }
    }
  }

  Future<void> _initializeSocketListener() async {
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      // `chat.*` events are handled via [ChatFabController] socket fan-out
      // only — avoids double-processing the broadcast [SocketService.messageStream].
    } catch (_) {
      // Keep controller resilient; UI remains functional with repository fallback loads.
    }
  }

  // TEMP(debug): remove after realtime `chat.message` investigation.
  void _debugChatMessage(String message) {
    if (kDebugMode) debugPrint(message);
  }

  /// Entry for [ChatFabController] socket fan-out and the local subscription.
  void handleSocketChatEnvelope(Map<String, dynamic> envelope) {
    _handleSocketMessage(envelope);
  }

  final Set<String> _pendingAdminSendReqIds = <String>{};
  final Map<String, ChatMessageModel> _outboundForwardSourceByReqId = {};

  /// Handles `ack` for in-flight `chat.admin.send` requests ([reqId]).
  void handleSocketAckEnvelope(Map<String, dynamic> envelope) {
    final id = envelope['reqId']?.toString().trim();
    if (id == null || id.isEmpty || !_pendingAdminSendReqIds.remove(id)) {
      return;
    }
    final data = envelope['data'];
    if (data is! Map) return;
    final m = Map<String, dynamic>.from(data);
    final success = m['success'] ?? m['Success'] ?? m['ok'] ?? m['Ok'];
    if (success == false) {
      final message = (m['message'] ?? m['Message'] ?? m['error'] ?? m['Error'])
          ?.toString()
          .trim();
      _rollbackFailedOutboundSend(id);
      ToastService().error(
        message == null || message.isEmpty
            ? 'ارسال پیام توسط سرور رد شد'
            : message,
      );
    } else {
      _outboundForwardSourceByReqId.remove(id);
    }
  }

  /// Handles server `error` envelopes tied to a failed `chat.admin.send`.
  void handleSocketErrorEnvelope(Map<String, dynamic> envelope) {
    final id = envelope['reqId']?.toString().trim();
    if (id == null || id.isEmpty) return;
    if (!_pendingAdminSendReqIds.remove(id)) return;

    final data = envelope['data'];
    String? message;
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      message = (m['message'] ?? m['Message'] ?? m['error'] ?? m['Error'])
          ?.toString()
          .trim();
    }
    message ??= envelope['message']?.toString().trim();

    _rollbackFailedOutboundSend(id);
    ToastService().error(
      message == null || message.isEmpty ? 'ارسال پیام ناموفق بود' : message,
    );
  }

  void _rollbackFailedOutboundSend(String reqId) {
    chatMessages.removeWhere((m) => m.messageGuid == reqId);
    chatMessages.refresh();
    final forwardSource = _outboundForwardSourceByReqId.remove(reqId);
    if (forwardSource != null) {
      pendingForwardMessage.value = forwardSource;
    }
  }

  void _handleSocketMessage(dynamic rawData) {
    try {
      final dynamic decoded = rawData is String ? json.decode(rawData) : rawData;
      if (decoded is! Map) return;
      final envelope = Map<String, dynamic>.from(decoded);

      final channel = envelope['channel']?.toString();
      final rawPayload = envelope['data'];
      if (channel == null || rawPayload is! Map) {
        if (channel == 'chat.message') {
          _debugChatMessage(
            '[chat.message] dropped: data is not a Map (${rawPayload.runtimeType})',
          );
        }
        return;
      }
      final data = Map<String, dynamic>.from(rawPayload);

      switch (channel) {
        case 'chat.message':
          _handleIncomingChatMessage(data);
          break;
        case 'chat.pick':
          _handlePickBroadcast(data);
          break;
        case 'chat.close':
          _handleCloseBroadcast(data);
          break;
        case 'chat.forward':
          _handleForwardBroadcast(data);
          break;
        case 'chat.grant':
          _handleGrantBroadcast(data);
          break;
        case 'chat.revoke':
          _handleRevokeBroadcast(data);
          break;
        case 'chat.typing':
          _handleTypingEvent(data);
          break;
        case 'chat.seen':
          _handleSeenBroadcast(data);
          break;
      }
    } catch (e, s) {
      _debugChatMessage('[chat.message] _handleSocketMessage error: $e\n$s');
    }
  }

  int? get _openCustomerAccountId =>
      selectedAccount.value?.id ??
          selectedChatAccount.value?.accountId ??
          selectedChat.value?.accountId;

  String? get _openTopicCode =>
      selectedTopic.value?.code ?? selectedChat.value?.topicCode;

  String? get _openTopicKey => selectedChat.value?.topicKey;

  bool get _hasOpenComposerConversation {
    final code = _openTopicCode?.trim();
    return _openCustomerAccountId != null && code != null && code.isNotEmpty;
  }

  void _clearCustomerTyping() {
    _customerTypingIdleTimer?.cancel();
    _customerTypingIdleTimer = null;
    isCustomerTyping.value = false;
  }

  void _markCustomerTypingActive() {
    isCustomerTyping.value = true;
    _customerTypingIdleTimer?.cancel();
    _customerTypingIdleTimer = Timer(_customerTypingIdle, _clearCustomerTyping);
  }

  void _handleTypingEvent(Map<String, dynamic> data) {
    if (!_hasOpenComposerConversation) return;

    final payload = typing.Data.fromJson(data);
    if (!chatTypingMatchesOpenConversation(
      eventCustomerAccountId: payload.customerAccountId,
      eventTopicCode: payload.topicCode,
      eventTopicKey: payload.topicKey,
      openCustomerAccountId: _openCustomerAccountId,
      openTopicCode: _openTopicCode,
      openTopicKey: _openTopicKey,
    )) {
      return;
    }

    //use by chat_typing_handler.dart
    /* void _handleTypingEvent(Map<String, dynamic> data) {
      final flag = customerTypingFlagFromSocketData(
        data: data,
        openCustomerAccountId: _openCustomerAccountId,
        openTopicCode: _openTopicCode,
        openTopicKey: _openTopicKey,
      );
      if (flag == true) {
        _markCustomerTypingActive();
      } else if (flag == false) {
        _clearCustomerTyping();
      }
    }*/

    if (payload.isTyping == true) {
      _markCustomerTypingActive();
    } else if (payload.isTyping == false) {
      _clearCustomerTyping();
    }
  }

  /// Parses `chat.message` [data] (nested `message` / optional `chat`) or legacy flat maps.
  socket_msg.SocketChatMessageData? _parseChatMessageSocketData(
      Map<String, dynamic> data) {
    final normalized = socket_msg.normalizeSocketChatMessageDataJson(data);
    final rawMessage = normalized['message'];
    if (rawMessage is Map) {
      return socket_msg.SocketChatMessageData.fromJson(normalized);
    }
    // Legacy: message fields at the root of `data`.
    final flat = socket_msg.normalizeSocketChatMessagePayloadJson(normalized);
    if (flat['chatId'] != null) {
      return socket_msg.SocketChatMessageData(
        isNewChat: false,
        chat: null,
        message: socket_msg.SocketChatMessagePayload.fromJson(flat),
      );
    }
    return null;
  }

  /// Inserts or refreshes a thread row when the server signals [isNewChat].
  void _upsertChatFromSocket(socket_msg.SocketChatMessageChat chat) {
    final chatId = chat.chatId?.trim();
    if (chatId == null || chatId.isEmpty) return;

    final customerId = chat.customerAccountId ?? chat.accountId;
    final selectedAccountId = selectedChatAccount.value?.accountId;
    if (selectedAccountId != null &&
        customerId != null &&
        selectedAccountId != customerId) {
      return;
    }

    final incoming = chat.toChatModel();
    final idx = chatList.indexWhere((c) => c.chatId == chatId);
    if (idx == -1) {
      chatList.insert(0, incoming);
      return;
    }

    final current = chatList[idx];
    chatList[idx] = ChatModel(
      rowNum: current.rowNum,
      chatId: current.chatId,
      accountId: incoming.accountId ?? current.accountId,
      topicId: incoming.topicId ?? current.topicId,
      topicCode: incoming.topicCode ?? current.topicCode,
      topicTitle: incoming.topicTitle ?? current.topicTitle,
      status: incoming.status,
      createdOn: incoming.createdOn ?? current.createdOn,
      lastActivity: incoming.lastActivity ?? current.lastActivity,
      accountName: incoming.accountName ?? current.accountName,
      lastMessageSeq: incoming.lastMessageSeq ?? current.lastMessageSeq,
      lastSeenSeq: incoming.lastSeenSeq ?? current.lastSeenSeq,
      clientSeenSeq: incoming.clientSeenSeq ?? current.clientSeenSeq,
      lastMessagePreview:
      incoming.lastMessagePreview ?? current.lastMessagePreview,
      lastMessageOn: incoming.lastMessageOn ?? current.lastMessageOn,
      totalMessageCount: incoming.totalMessageCount ?? current.totalMessageCount,
      unreadMessageCount:
      incoming.unreadMessageCount ?? current.unreadMessageCount,
      topicKey: incoming.topicKey ?? current.topicKey,
      assignedAdminAccountId:
      incoming.assignedAdminAccountId ?? current.assignedAdminAccountId,
      assignedAdminUserId:
      incoming.assignedAdminUserId ?? current.assignedAdminUserId,
      closedOn: current.closedOn,
      assignedAdminName:
      incoming.assignedAdminName ?? current.assignedAdminName,
      userId: current.userId,
      adminRole: incoming.adminRole ?? current.adminRole,
      adminRoleTitle: incoming.adminRoleTitle ?? current.adminRoleTitle,
    );
  }

  void _handleIncomingChatMessage(Map<String, dynamic> data) {
    _debugChatMessage('[chat.message] handler entered');

    final socketPayload = _parseChatMessageSocketData(data);
    if (socketPayload == null) {
      _debugChatMessage('[chat.message] parse returned null');
      return;
    }

    if (socketPayload.isNewChat == true && socketPayload.chat != null) {
      _upsertChatFromSocket(socketPayload.chat!);
    }

    final messagePayload = socketPayload.message;
    if (messagePayload == null) {
      _debugChatMessage('[chat.message] no nested message in payload');
      return;
    }

    final chatId = messagePayload.chatId?.trim() ??
        socketPayload.chat?.chatId?.trim();
    if (chatId == null || chatId.isEmpty) {
      _debugChatMessage(
        '[chat.message] missing chatId (message=${messagePayload.chatId} '
            'chat=${socketPayload.chat?.chatId})',
      );
      return;
    }

    var incomingMessage =
    messagePayload.toChatMessageModel(chatIdOverride: chatId);
    var filesJson = incomingMessage.filesJson;

    final guid = incomingMessage.messageGuid?.trim();
    final optimisticIdxPreview = indexOfOutgoingOptimisticMatch(
      messages: chatMessages,
      chatId: chatId,
      incomingMessageGuid: guid,
      pendingReqId: reqId.value,
    );
    final hasOptimisticDraft = optimisticIdxPreview != -1;

    final isCurrentChatOpen = incomingChatMessageMatchesOpenConversation(
      incomingChatId: chatId,
      selectedChatId: selectedChat.value?.chatId,
      loadedMessageChatIds: chatMessages.map((m) => m.chatId),
      hasOpenComposerConversation: _hasOpenComposerConversation,
      messageCustomerAccountId: messagePayload.customerAccountId,
      messageTopicCode: messagePayload.topicCode,
      messageTopicKey: messagePayload.topicKey,
      openCustomerAccountId: _openCustomerAccountId,
      openTopicCode: _openTopicCode,
      openTopicKey: _openTopicKey,
      hasOptimisticDraftForMessageGuid: hasOptimisticDraft,
    );

    // TEMP(debug): remove after realtime `chat.message` investigation.
    final selectedChatId = selectedChat.value?.chatId;
    _debugChatMessage(
      '[chat.message] isCurrentChatOpen=$isCurrentChatOpen '
          'selectedChatId=$selectedChatId incomingChatId=$chatId '
          'isMessageSearchActive=$isMessageSearchActive',
    );

    var debugMessageListAction = 'no-append';
    if (isCurrentChatOpen && !isMessageSearchActive) {
      final senderType = incomingMessage.senderType;
      if (senderType != null && senderType != 1 && senderType != 2) {
        _clearCustomerTyping();
      }
      final optimisticIdx = indexOfOutgoingOptimisticMatch(
        messages: chatMessages,
        chatId: chatId,
        incomingMessageGuid: guid,
        pendingReqId: reqId.value,
      );
      if (optimisticIdx != -1) {
        final optimistic = chatMessages[optimisticIdx];
        _syncAttachmentRecordIdAliasesFromFilesJson(
          filesJson,
          optimistic.filesJson,
        );
        filesJson = mergeChatFilesJsonFromOutbound(
          filesJson,
          optimistic.filesJson,
        );
        final mergedReply = mergeIncomingReplyFields(
          incoming: incomingMessage,
          threadMessages: chatMessages,
          fallback: optimistic,
        );
        chatMessages[optimisticIdx] = ChatMessageModel(
          rowNum: incomingMessage.rowNum,
          chatId: incomingMessage.chatId,
          messageGuid: incomingMessage.messageGuid,
          replyToMessageGuid: mergedReply.replyToMessageGuid,
          replyMessage: mergedReply.replyMessage,
          forwardFromMessageGuid: mergedReply.forwardFromMessageGuid,
          forwardFromSenderName: mergedReply.forwardFromSenderName,
          forwardMessage: mergedReply.forwardMessage,
          seq: incomingMessage.seq,
          senderType: incomingMessage.senderType,
          senderAccountId: incomingMessage.senderAccountId,
          senderUserId: incomingMessage.senderUserId,
          messageType: incomingMessage.messageType,
          text: incomingMessage.text,
          createdOnUtc: incomingMessage.createdOnUtc,
          isDeleted: incomingMessage.isDeleted,
          deliveredOnUtc: incomingMessage.deliveredOnUtc,
          seenOnUtc: incomingMessage.seenOnUtc,
          seen: incomingMessage.seen ?? incomingMessage.seenOnUtc != null,
          senderAccountName: incomingMessage.senderAccountName,
          replyToSeq: mergedReply.replyToSeq,
          forwardFromSeq: mergedReply.forwardFromSeq,
          filesJson: filesJson ?? optimistic.filesJson,
        );
        chatMessages.refresh();
        debugMessageListAction = 'replaced-optimistic';
        _outboundForwardSourceByReqId.remove(reqId.value);
        _maybeAdoptRealChatAfterFirstIncomingMessage(chatId, incomingMessage);
        if (isNearBottom.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) => scrollToLatest());
          final seq = incomingMessage.seq;
          if (seq != null) {
            unawaited(markMessagesSeenUpTo(seq));
          }
        } else {
          pendingNewMessages.value++;
          _updateConversationUnreadAfterSeen(_adminMarkedSeenSeq);
        }
      } else {
        final exists = chatMessages.any((m) =>
        (incomingMessage.messageGuid != null &&
            incomingMessage.messageGuid!.isNotEmpty &&
            m.messageGuid == incomingMessage.messageGuid) ||
            (incomingMessage.seq != null &&
                incomingMessage.seq! > 0 &&
                m.seq == incomingMessage.seq &&
                chatIdsEqual(m.chatId, chatId)));
        if (!exists) {
          chatMessages.insert(
            0,
            mergeIncomingReplyFields(
              incoming: incomingMessage,
              threadMessages: chatMessages,
            ),
          );
          chatMessages.refresh();
          debugMessageListAction = 'inserted';
          if (selectedChat.value == null) {
            _maybeAdoptRealChatAfterFirstIncomingMessage(
              chatId,
              incomingMessage,
            );
          }
          if (isNearBottom.value) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => scrollToLatest());
            final seq = incomingMessage.seq;
            if (seq != null) {
              unawaited(markMessagesSeenUpTo(seq));
            }
          } else {
            pendingNewMessages.value++;
            _updateConversationUnreadAfterSeen(_adminMarkedSeenSeq);
          }
        } else {
          debugMessageListAction = 'duplicate-skipped';
        }
      }
    } else if (!isCurrentChatOpen) {
      debugMessageListAction = 'not-open-conversation';
    } else if (isMessageSearchActive) {
      debugMessageListAction = 'search-active-skipped';
    }

    // TEMP(debug): remove after realtime `chat.message` investigation.
    _debugChatMessage(
      '[chat.message] chatMessages.length=${chatMessages.length} '
          'action=$debugMessageListAction',
    );

    _applyRealtimeListUpdates(
      chatId: chatId,
      messageText: incomingMessage.text,
      messageTime: incomingMessage.createdOnUtc ?? DateTime.now(),
      incrementUnread: !isCurrentChatOpen,
    );
  }

  /// Binds [selectedChat] (and [chatList] if missing) after the first real `chat.message`
  /// for a thread that was opened as topic-only (no [ChatModel] yet).
  void _maybeAdoptRealChatAfterFirstIncomingMessage(
      String chatId,
      ChatMessageModel firstMessage,
      ) {
    if (selectedChat.value != null) return;
    final topic = selectedTopic.value;
    if (topic == null) return;

    final fromList = chatList.firstWhereOrNull((c) => c.chatId == chatId);
    if (fromList != null) {
      selectedChat.value = fromList;
      hasMoreMessages.value = chatMessages.length >= pageSize;
      unawaited(
        _syncOpenTabAndAccountSelectionAfterNewThread(
          chatId: chatId,
          customerAccountId: fromList.accountId,
        ),
      );
      return;
    }

    final accountId =
        selectedAccount.value?.id ?? selectedChatAccount.value?.accountId;
    final name = selectedChatAccount.value?.accountName ??
        selectedAccount.value?.name;
    final when = firstMessage.createdOnUtc ?? DateTime.now();

    final stub = ChatModel(
      rowNum: null,
      chatId: chatId,
      accountId: accountId,
      topicId: null,
      topicCode: topic.code,
      topicTitle: topic.title,
      status: 0,
      createdOn: when,
      lastActivity: when,
      accountName: name,
      lastMessageSeq: firstMessage.seq,
      lastSeenSeq: fromList?.lastSeenSeq,
      clientSeenSeq: fromList?.clientSeenSeq,
      lastMessagePreview: firstMessage.text,
      lastMessageOn: when,
      totalMessageCount: 1,
      unreadMessageCount: 0,
      topicKey: null,
      assignedAdminAccountId: null,
      assignedAdminUserId: null,
      closedOn: null,
      assignedAdminName: null,
      userId: null,
      adminRole: null,
      adminRoleTitle: null,
    );
    selectedChat.value = stub;

    final listIdx = chatList.indexWhere((c) => c.chatId == chatId);
    if (listIdx == -1) {
      chatList.insert(0, stub);
    }
    // Avoid pagination footer + spinner until a thread id exists; then infer from
    // how many rows we already have vs [pageSize] (no history fetch yet).
    hasMoreMessages.value = chatMessages.length >= pageSize;
    unawaited(
      _syncOpenTabAndAccountSelectionAfterNewThread(
        chatId: chatId,
        customerAccountId: accountId,
      ),
    );
  }

  /// Open-tab sidebar + thread list reload after a draft thread gets a real [chatId]
  /// (same UX as [_activateOpenTabAfterPick] after [pickChatAndEnter]).
  Future<void> _syncOpenTabAndAccountSelectionAfterNewThread({
    required String chatId,
    required int? customerAccountId,
  }) async {
    await _activateOpenTabAfterPick(customerAccountId: customerAccountId);
    final merged = chatList.firstWhereOrNull((c) => c.chatId == chatId);
    if (merged != null) {
      selectedChat.value = merged;
    }
  }

  void _handlePickBroadcast(Map<String, dynamic> data) {
    try {
      final model = pick_bc.SocketChatPickBroadcastModel.fromJson({
        'channel': 'chat.pick',
        'data': data,
      });
      final d = model.data;
      final id = d?.chatId?.toString();
      if (id == null || id.isEmpty) return;

      final idx = chatList.indexWhere((c) => c.chatId == id);
      final ChatModel updated;
      if (idx != -1) {
        final cur = chatList[idx];
        updated = ChatModel(
          rowNum: cur.rowNum,
          chatId: cur.chatId,
          accountId: cur.accountId,
          topicId: d?.topicId ?? cur.topicId,
          topicCode: d?.topicCode ?? cur.topicCode,
          topicTitle: cur.topicTitle,
          status: 0,
          createdOn: cur.createdOn,
          lastActivity: cur.lastActivity,
          accountName: cur.accountName,
          lastMessageSeq: cur.lastMessageSeq,
          lastSeenSeq: cur.lastSeenSeq,
          clientSeenSeq: cur.clientSeenSeq,
          lastMessagePreview: cur.lastMessagePreview,
          lastMessageOn: cur.lastMessageOn,
          totalMessageCount: cur.totalMessageCount,
          unreadMessageCount: cur.unreadMessageCount,
          topicKey: d?.topicKey ?? cur.topicKey,
          assignedAdminAccountId:
          d?.assignedAdminAccountId ?? cur.assignedAdminAccountId,
          assignedAdminUserId:
          d?.assignedAdminUserId ?? cur.assignedAdminUserId,
          closedOn: cur.closedOn,
          assignedAdminName: cur.assignedAdminName,
          userId: cur.userId,
          adminRole: cur.adminRole,
          adminRoleTitle: cur.adminRoleTitle,
        );
      } else {
        final sel = selectedChat.value;
        final sc = selectedChatAccount.value;
        final aid = d?.customerAccountId ?? sel?.accountId ?? sc?.accountId;
        updated = ChatModel(
          rowNum: sel?.rowNum,
          chatId: id,
          accountId: aid,
          topicId: d?.topicId ?? sel?.topicId,
          topicCode: d?.topicCode ?? sel?.topicCode,
          topicTitle: sel?.topicTitle,
          status: 0,
          createdOn: sel?.createdOn,
          lastActivity: sel?.lastActivity,
          accountName: sel?.accountName ?? sc?.accountName,
          lastMessageSeq: sel?.lastMessageSeq,
          lastSeenSeq: sel?.lastSeenSeq,
          clientSeenSeq: sel?.clientSeenSeq,
          lastMessagePreview: sel?.lastMessagePreview,
          lastMessageOn: sel?.lastMessageOn,
          totalMessageCount: sel?.totalMessageCount,
          unreadMessageCount: sel?.unreadMessageCount,
          topicKey: d?.topicKey ?? sel?.topicKey,
          assignedAdminAccountId:
          d?.assignedAdminAccountId ?? sel?.assignedAdminAccountId,
          assignedAdminUserId:
          d?.assignedAdminUserId ?? sel?.assignedAdminUserId,
          closedOn: sel?.closedOn,
          assignedAdminName: sel?.assignedAdminName,
          userId: sel?.userId,
          adminRole: sel?.adminRole,
          adminRoleTitle: sel?.adminRoleTitle,
        );
      }
      final touch = d?.on ?? DateTime.now();
      final accountId = d?.customerAccountId ?? updated.accountId;
      _mergePickIntoLists(
        chatId: id,
        updatedChat: updated,
        customerAccountId: accountId,
        listTouchTime: touch,
      );
      if (selectedChat.value?.chatId == id) {
        selectedChat.value = updated;
      }
    } catch (_) {}
  }

  void _handleCloseBroadcast(Map<String, dynamic> data) {
    try {
      final model = close_bc.SocketChatCloseBroadcastModel.fromJson({
        'channel': 'chat.close',
        'data': data,
      });
      final d = model.data;
      final id = d?.chatId?.toString();
      if (id == null || id.isEmpty) return;

      final idx = chatList.indexWhere((c) => c.chatId == id);
      final ChatModel updated;
      if (idx != -1) {
        final cur = chatList[idx];
        updated = ChatModel(
          rowNum: cur.rowNum,
          chatId: cur.chatId,
          accountId: cur.accountId,
          topicId: d?.topicId ?? cur.topicId,
          topicCode: d?.topicCode ?? cur.topicCode,
          topicTitle: cur.topicTitle,
          status: 1,
          createdOn: cur.createdOn,
          lastActivity: cur.lastActivity,
          accountName: cur.accountName,
          lastMessageSeq: cur.lastMessageSeq,
          lastSeenSeq: cur.lastSeenSeq,
          clientSeenSeq: cur.clientSeenSeq,
          lastMessagePreview: cur.lastMessagePreview,
          lastMessageOn: cur.lastMessageOn,
          totalMessageCount: cur.totalMessageCount,
          unreadMessageCount: cur.unreadMessageCount,
          topicKey: d?.topicKey ?? cur.topicKey,
          assignedAdminAccountId: cur.assignedAdminAccountId,
          assignedAdminUserId: cur.assignedAdminUserId,
          closedOn: d?.closedOn ?? DateTime.now(),
          assignedAdminName: cur.assignedAdminName,
          userId: cur.userId,
          adminRole: cur.adminRole,
          adminRoleTitle: cur.adminRoleTitle,
        );
      } else {
        final sel = selectedChat.value;
        final sc = selectedChatAccount.value;
        final aid = d?.customerAccountId ?? sel?.accountId ?? sc?.accountId;
        updated = ChatModel(
          rowNum: sel?.rowNum,
          chatId: id,
          accountId: aid,
          topicId: d?.topicId ?? sel?.topicId,
          topicCode: d?.topicCode ?? sel?.topicCode,
          topicTitle: sel?.topicTitle,
          status: 1,
          createdOn: sel?.createdOn,
          lastActivity: sel?.lastActivity,
          accountName: sel?.accountName ?? sc?.accountName,
          lastMessageSeq: sel?.lastMessageSeq,
          lastSeenSeq: sel?.lastSeenSeq,
          clientSeenSeq: sel?.clientSeenSeq,
          lastMessagePreview: sel?.lastMessagePreview,
          lastMessageOn: sel?.lastMessageOn,
          totalMessageCount: sel?.totalMessageCount,
          unreadMessageCount: sel?.unreadMessageCount,
          topicKey: d?.topicKey ?? sel?.topicKey,
          assignedAdminAccountId: sel?.assignedAdminAccountId,
          assignedAdminUserId: sel?.assignedAdminUserId,
          closedOn: d?.closedOn ?? DateTime.now(),
          assignedAdminName: sel?.assignedAdminName,
          userId: sel?.userId,
          adminRole: sel?.adminRole,
          adminRoleTitle: sel?.adminRoleTitle,
        );
      }
      final touch = (d?.closedOn ?? DateTime.now());
      final accountId = d?.customerAccountId ?? updated.accountId;
      _mergeCloseIntoLists(
        chatId: id,
        updatedChat: updated,
        customerAccountId: accountId,
        listTouchTime: touch,
      );
      if (selectedChat.value?.chatId == id) {
        goBackToChatList();
      }
    } catch (_) {}
  }

  void _handleForwardBroadcast(Map<String, dynamic> data) {
    try {
      final model = forward_bc.SocketChatForwardBroadcastModel.fromJson({
        'channel': 'chat.forward',
        'data': data,
      });
      final d = model.data;
      final id = d?.chatId?.toString();
      if (id == null || id.isEmpty) return;

      final myAccountId = int.tryParse(currentUserId);
      final touch = d?.on ?? DateTime.now();
      final fromId = d?.fromAdminAccountId;
      final toId = d?.toAdminAccountId;

      final idx = chatList.indexWhere((c) => c.chatId == id);
      final ChatModel base;
      if (idx != -1) {
        base = chatList[idx];
      } else {
        final sel = selectedChat.value;
        final sc = selectedChatAccount.value;
        base = ChatModel(
          rowNum: sel?.rowNum,
          chatId: id,
          accountId: d?.customerAccountId ?? sel?.accountId ?? sc?.accountId,
          topicId: d?.topicId ?? sel?.topicId,
          topicCode: d?.topicCode ?? sel?.topicCode,
          topicTitle: sel?.topicTitle,
          status: sel?.status ?? 0,
          createdOn: sel?.createdOn,
          lastActivity: sel?.lastActivity,
          accountName: sel?.accountName ?? sc?.accountName,
          lastMessageSeq: sel?.lastMessageSeq,
          lastSeenSeq: sel?.lastSeenSeq,
          clientSeenSeq: sel?.clientSeenSeq,
          lastMessagePreview: sel?.lastMessagePreview,
          lastMessageOn: sel?.lastMessageOn,
          totalMessageCount: sel?.totalMessageCount,
          unreadMessageCount: sel?.unreadMessageCount,
          topicKey: d?.topicKey ?? sel?.topicKey,
          assignedAdminAccountId: sel?.assignedAdminAccountId,
          assignedAdminUserId: sel?.assignedAdminUserId,
          closedOn: sel?.closedOn,
          assignedAdminName: sel?.assignedAdminName,
          userId: sel?.userId,
          adminRole: sel?.adminRole,
          adminRoleTitle: sel?.adminRoleTitle,
        );
      }

      if (myAccountId != null && fromId == myAccountId) {
        final updated = ChatModel(
          rowNum: base.rowNum,
          chatId: base.chatId,
          accountId: base.accountId,
          topicId: d?.topicId ?? base.topicId,
          topicCode: d?.topicCode ?? base.topicCode,
          topicTitle: base.topicTitle,
          status: base.status,
          createdOn: base.createdOn,
          lastActivity: base.lastActivity,
          accountName: base.accountName,
          lastMessageSeq: d?.forwardMessageSeq ?? base.lastMessageSeq,
          lastSeenSeq: base.lastSeenSeq,
          clientSeenSeq: base.clientSeenSeq,
          lastMessagePreview: base.lastMessagePreview,
          lastMessageOn: base.lastMessageOn,
          totalMessageCount: base.totalMessageCount,
          unreadMessageCount: base.unreadMessageCount,
          topicKey: d?.topicKey ?? base.topicKey,
          assignedAdminAccountId: toId ?? base.assignedAdminAccountId,
          assignedAdminUserId: base.assignedAdminUserId,
          closedOn: base.closedOn,
          assignedAdminName: base.assignedAdminName,
          userId: base.userId,
          adminRole: 2,
          adminRoleTitle: base.adminRoleTitle,
        );
        _mergeForwardOutForSender(
          chatId: id,
          updatedChat: updated,
          customerAccountId: d?.customerAccountId ?? updated.accountId,
          listTouchTime: touch,
        );
        if (selectedChat.value?.chatId == id) {
          goBackToChatList();
        }
        return;
      }

      if (myAccountId != null && toId == myAccountId) {
        final updated = ChatModel(
          rowNum: base.rowNum,
          chatId: base.chatId,
          accountId: base.accountId,
          topicId: d?.topicId ?? base.topicId,
          topicCode: d?.topicCode ?? base.topicCode,
          topicTitle: base.topicTitle,
          status: 0,
          createdOn: base.createdOn,
          lastActivity: base.lastActivity,
          accountName: base.accountName,
          lastMessageSeq: d?.forwardMessageSeq ?? base.lastMessageSeq,
          lastSeenSeq: base.lastSeenSeq,
          clientSeenSeq: base.clientSeenSeq,
          lastMessagePreview: base.lastMessagePreview,
          lastMessageOn: base.lastMessageOn,
          totalMessageCount: base.totalMessageCount,
          unreadMessageCount: base.unreadMessageCount,
          topicKey: d?.topicKey ?? base.topicKey,
          assignedAdminAccountId: toId ?? base.assignedAdminAccountId,
          assignedAdminUserId: base.assignedAdminUserId,
          closedOn: base.closedOn,
          assignedAdminName: base.assignedAdminName,
          userId: base.userId,
          adminRole: 1,
          adminRoleTitle: base.adminRoleTitle,
        );
        _mergePickIntoLists(
          chatId: id,
          updatedChat: updated,
          customerAccountId: d?.customerAccountId ?? updated.accountId,
          listTouchTime: touch,
        );
        if (selectedChat.value?.chatId == id) {
          selectedChat.value = updated;
        }
        return;
      }

      if (idx != -1) {
        final updated = ChatModel(
          rowNum: base.rowNum,
          chatId: base.chatId,
          accountId: base.accountId,
          topicId: d?.topicId ?? base.topicId,
          topicCode: d?.topicCode ?? base.topicCode,
          topicTitle: base.topicTitle,
          status: base.status,
          createdOn: base.createdOn,
          lastActivity: base.lastActivity,
          accountName: base.accountName,
          lastMessageSeq: d?.forwardMessageSeq ?? base.lastMessageSeq,
          lastSeenSeq: base.lastSeenSeq,
          clientSeenSeq: base.clientSeenSeq,
          lastMessagePreview: base.lastMessagePreview,
          lastMessageOn: base.lastMessageOn,
          totalMessageCount: base.totalMessageCount,
          unreadMessageCount: base.unreadMessageCount,
          topicKey: d?.topicKey ?? base.topicKey,
          assignedAdminAccountId: toId ?? base.assignedAdminAccountId,
          assignedAdminUserId: base.assignedAdminUserId,
          closedOn: base.closedOn,
          assignedAdminName: base.assignedAdminName,
          userId: base.userId,
          adminRole: base.adminRole,
          adminRoleTitle: base.adminRoleTitle,
        );
        chatList.removeWhere((c) => c.chatId == id);
        chatList.insert(0, updated);
        if (selectedChat.value?.chatId == id) {
          selectedChat.value = updated;
        }
      }
    } catch (_) {}
  }

  void _handleGrantBroadcast(Map<String, dynamic> data) {
    try {
      final model = grant_bc.SocketChatGrantBroadcastModel.fromJson({
        'channel': 'chat.grant',
        'data': data,
      });
      final d = model.data;
      final id = d?.chatId?.toString();
      if (id == null || id.isEmpty) return;

      final myAccountId = int.tryParse(currentUserId);
      final touch = d?.on ?? DateTime.now();
      final targetId = d?.targetAdminAccountId;
      final idx = chatList.indexWhere((c) => c.chatId == id);
      final ChatModel base;
      if (idx != -1) {
        base = chatList[idx];
      } else {
        final sel = selectedChat.value;
        final sc = selectedChatAccount.value;
        base = ChatModel(
          rowNum: sel?.rowNum,
          chatId: id,
          accountId: d?.customerAccountId ?? sel?.accountId ?? sc?.accountId,
          topicId: d?.topicId ?? sel?.topicId,
          topicCode: d?.topicCode ?? sel?.topicCode,
          topicTitle: sel?.topicTitle,
          status: sel?.status ?? 0,
          createdOn: sel?.createdOn,
          lastActivity: sel?.lastActivity,
          accountName: sel?.accountName ?? sc?.accountName,
          lastMessageSeq: sel?.lastMessageSeq,
          lastSeenSeq: sel?.lastSeenSeq,
          clientSeenSeq: sel?.clientSeenSeq,
          lastMessagePreview: sel?.lastMessagePreview,
          lastMessageOn: sel?.lastMessageOn,
          totalMessageCount: sel?.totalMessageCount,
          unreadMessageCount: sel?.unreadMessageCount,
          topicKey: d?.topicKey ?? sel?.topicKey,
          assignedAdminAccountId: sel?.assignedAdminAccountId,
          assignedAdminUserId: sel?.assignedAdminUserId,
          closedOn: sel?.closedOn,
          assignedAdminName: sel?.assignedAdminName,
          userId: sel?.userId,
          adminRole: sel?.adminRole,
          adminRoleTitle: sel?.adminRoleTitle,
        );
      }

      final viewerRole = d?.role ?? 2;

      if (myAccountId != null && targetId == myAccountId) {
        final updated = ChatModel(
          rowNum: base.rowNum,
          chatId: base.chatId,
          accountId: base.accountId,
          topicId: d?.topicId ?? base.topicId,
          topicCode: d?.topicCode ?? base.topicCode,
          topicTitle: base.topicTitle,
          status: base.status,
          createdOn: base.createdOn,
          lastActivity: touch,
          accountName: base.accountName,
          lastMessageSeq: base.lastMessageSeq,
          lastSeenSeq: base.lastSeenSeq,
          clientSeenSeq: base.clientSeenSeq,
          lastMessagePreview: base.lastMessagePreview,
          lastMessageOn: base.lastMessageOn,
          totalMessageCount: base.totalMessageCount,
          unreadMessageCount: base.unreadMessageCount,
          topicKey: d?.topicKey ?? base.topicKey,
          assignedAdminAccountId: base.assignedAdminAccountId,
          assignedAdminUserId: d?.targetAdminUserId ?? base.assignedAdminUserId,
          closedOn: base.closedOn,
          assignedAdminName: base.assignedAdminName,
          userId: base.userId,
          adminRole: viewerRole,
          adminRoleTitle: base.adminRoleTitle,
        );
        _mergePickIntoLists(
          chatId: id,
          updatedChat: updated,
          customerAccountId: d?.customerAccountId ?? updated.accountId,
          listTouchTime: touch,
        );
        if (selectedChat.value?.chatId == id) {
          selectedChat.value = updated;
        }
        return;
      }

      final updatedObserver = ChatModel(
        rowNum: base.rowNum,
        chatId: base.chatId,
        accountId: base.accountId,
        topicId: d?.topicId ?? base.topicId,
        topicCode: d?.topicCode ?? base.topicCode,
        topicTitle: base.topicTitle,
        status: base.status,
        createdOn: base.createdOn,
        lastActivity: touch,
        accountName: base.accountName,
        lastMessageSeq: base.lastMessageSeq,
        lastSeenSeq: base.lastSeenSeq,
        clientSeenSeq: base.clientSeenSeq,
        lastMessagePreview: base.lastMessagePreview,
        lastMessageOn: base.lastMessageOn,
        totalMessageCount: base.totalMessageCount,
        unreadMessageCount: base.unreadMessageCount,
        topicKey: d?.topicKey ?? base.topicKey,
        assignedAdminAccountId: base.assignedAdminAccountId,
        assignedAdminUserId: base.assignedAdminUserId,
        closedOn: base.closedOn,
        assignedAdminName: base.assignedAdminName,
        userId: base.userId,
        adminRole: base.adminRole,
        adminRoleTitle: base.adminRoleTitle,
      );
      _mergeGrantGranterLists(
        chatId: id,
        updatedChat: updatedObserver,
        customerAccountId: d?.customerAccountId ?? updatedObserver.accountId,
        listTouchTime: touch,
      );
      if (selectedChat.value?.chatId == id) {
        selectedChat.value = updatedObserver;
      }
    } catch (_) {}
  }

  void _handleRevokeBroadcast(Map<String, dynamic> data) {
    try {
      final model = revoke_bc.SocketChatRevokeBroadcastModel.fromJson({
        'channel': 'chat.revoke',
        'data': data,
      });
      final d = model.data;
      final id = d?.chatId?.toString();
      if (id == null || id.isEmpty) return;

      final myAccountId = int.tryParse(currentUserId);
      final touch = d?.on ?? DateTime.now();
      final targetId = d?.targetAdminAccountId;
      final idx = chatList.indexWhere((c) => c.chatId == id);
      final ChatModel base;
      if (idx != -1) {
        base = chatList[idx];
      } else {
        final sel = selectedChat.value;
        final sc = selectedChatAccount.value;
        base = ChatModel(
          rowNum: sel?.rowNum,
          chatId: id,
          accountId: d?.customerAccountId ?? sel?.accountId ?? sc?.accountId,
          topicId: d?.topicId ?? sel?.topicId,
          topicCode: d?.topicCode ?? sel?.topicCode,
          topicTitle: sel?.topicTitle,
          status: sel?.status ?? 0,
          createdOn: sel?.createdOn,
          lastActivity: sel?.lastActivity,
          accountName: sel?.accountName ?? sc?.accountName,
          lastMessageSeq: sel?.lastMessageSeq,
          lastSeenSeq: sel?.lastSeenSeq,
          clientSeenSeq: sel?.clientSeenSeq,
          lastMessagePreview: sel?.lastMessagePreview,
          lastMessageOn: sel?.lastMessageOn,
          totalMessageCount: sel?.totalMessageCount,
          unreadMessageCount: sel?.unreadMessageCount,
          topicKey: d?.topicKey ?? sel?.topicKey,
          assignedAdminAccountId: sel?.assignedAdminAccountId,
          assignedAdminUserId: sel?.assignedAdminUserId,
          closedOn: sel?.closedOn,
          assignedAdminName: sel?.assignedAdminName,
          userId: sel?.userId,
          adminRole: sel?.adminRole,
          adminRoleTitle: sel?.adminRoleTitle,
        );
      }

      if (myAccountId != null && targetId == myAccountId) {
        _mergeRevokeForTarget(
          chatId: id,
          customerAccountId: d?.customerAccountId ?? base.accountId,
        );
        return;
      }

      final updatedObserver = ChatModel(
        rowNum: base.rowNum,
        chatId: base.chatId,
        accountId: base.accountId,
        topicId: d?.topicId ?? base.topicId,
        topicCode: d?.topicCode ?? base.topicCode,
        topicTitle: base.topicTitle,
        status: base.status,
        createdOn: base.createdOn,
        lastActivity: touch,
        accountName: base.accountName,
        lastMessageSeq: base.lastMessageSeq,
        lastSeenSeq: base.lastSeenSeq,
        clientSeenSeq: base.clientSeenSeq,
        lastMessagePreview: base.lastMessagePreview,
        lastMessageOn: base.lastMessageOn,
        totalMessageCount: base.totalMessageCount,
        unreadMessageCount: base.unreadMessageCount,
        topicKey: d?.topicKey ?? base.topicKey,
        assignedAdminAccountId: base.assignedAdminAccountId,
        assignedAdminUserId: base.assignedAdminUserId,
        closedOn: base.closedOn,
        assignedAdminName: base.assignedAdminName,
        userId: base.userId,
        adminRole: base.adminRole,
        adminRoleTitle: base.adminRoleTitle,
      );
      _mergeGrantGranterLists(
        chatId: id,
        updatedChat: updatedObserver,
        customerAccountId: d?.customerAccountId ?? updatedObserver.accountId,
        listTouchTime: touch,
      );
      if (selectedChat.value?.chatId == id) {
        selectedChat.value = updatedObserver;
      }
    } catch (_) {}
  }

  /// Removes the chat row for a revoked **viewer** and reconciles the account sidebar (open tab).
  void _mergeRevokeForTarget({
    required String chatId,
    required int? customerAccountId,
  }) {
    final tabFilter = ChatAccountListTabs.apiStatusFilter(selectedChatTab.value);
    final aid = customerAccountId ?? selectedChatAccount.value?.accountId;
    const int openSessionStatus = 0;
    final int? openTabApiFilter =
    ChatAccountListTabs.apiStatusFilter(ChatAccountListTabs.open);

    final int otherOpenForAccount = (aid != null && tabFilter == openTabApiFilter)
        ? chatList
        .where((c) =>
    c.accountId == aid &&
        c.chatId != chatId &&
        c.status == openSessionStatus)
        .length
        : 0;

    chatList.removeWhere((c) => c.chatId == chatId);

    if (selectedChat.value?.chatId == chatId) {
      goBackToChatList();
    }

    if (aid == null) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    final existing =
    chatAccountList.firstWhereOrNull((a) => a.accountId == aid);
    filteredChatAccountList.removeWhere((a) => a.accountId == aid);
    chatAccountList.removeWhere((a) => a.accountId == aid);

    if (tabFilter == openTabApiFilter && otherOpenForAccount > 0) {
      if (existing != null) {
        chatAccountList.insert(0, existing);
      }
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    if (tabFilter == openTabApiFilter) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    if (existing != null) {
      chatAccountList.insert(0, existing);
    }
    filterChatAccounts(chatAccountsSearchController.text);
  }

  /// After the current admin forwards a chat away: drop it from the **Open** tab list
  /// (same UX as close on that tab); keep a **view** row on the **All** tab only.
  void _mergeForwardOutForSender({
    required String chatId,
    required ChatModel updatedChat,
    required int? customerAccountId,
    required DateTime listTouchTime,
  }) {
    final tabFilter = ChatAccountListTabs.apiStatusFilter(selectedChatTab.value);
    final aid = customerAccountId ?? selectedChatAccount.value?.accountId;
    const int openSessionStatus = 0;
    final int? openTabApiFilter =
    ChatAccountListTabs.apiStatusFilter(ChatAccountListTabs.open);

    final int otherOpenForAccount = (aid != null && tabFilter == openTabApiFilter)
        ? chatList
        .where((c) =>
    c.accountId == aid &&
        c.chatId != chatId &&
        c.status == openSessionStatus)
        .length
        : 0;

    chatList.removeWhere((c) => c.chatId == chatId);
    final bool insertOnAllTab = tabFilter == null;
    if (insertOnAllTab) {
      chatList.insert(0, updatedChat);
    }

    if (aid == null) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    final existing =
    chatAccountList.firstWhereOrNull((a) => a.accountId == aid);
    filteredChatAccountList.removeWhere((a) => a.accountId == aid);
    chatAccountList.removeWhere((a) => a.accountId == aid);

    if (tabFilter == openTabApiFilter && otherOpenForAccount > 0) {
      if (existing != null) {
        chatAccountList.insert(0, existing);
        filterChatAccounts(chatAccountsSearchController.text);
      }
      return;
    }

    if (tabFilter == openTabApiFilter) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    if (tabFilter == null) {
      const int openAccountListStatus = 0;
      final sc = selectedChatAccount.value;
      final updatedAccount = ChatAccountModel(
        rowNum: existing?.rowNum ?? sc?.rowNum,
        accountId: aid,
        accountName: existing?.accountName ??
            sc?.accountName ??
            updatedChat.accountName,
        lastChatId: chatId,
        lastMessageOn: listTouchTime,
        lastMessagePreview:
        existing?.lastMessagePreview ?? updatedChat.lastMessagePreview,
        totalMessageCount:
        existing?.totalMessageCount ?? updatedChat.totalMessageCount,
        unreadMessageCount: existing?.unreadMessageCount,
        unreadChatCount: existing?.unreadChatCount,
        adminChatRole: existing?.adminChatRole ?? sc?.adminChatRole ?? 1,
        chatStatus: openAccountListStatus,
      );
      chatAccountList.insert(0, updatedAccount);
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    filterChatAccounts(chatAccountsSearchController.text);
  }

  /// Bumps [chatList] / [chatAccountList] for the granter after `chat.grant` (no hand-off like forward).
  void _mergeGrantGranterLists({
    required String chatId,
    required ChatModel updatedChat,
    required int? customerAccountId,
    required DateTime listTouchTime,
  }) {
    final tabFilter = ChatAccountListTabs.apiStatusFilter(selectedChatTab.value);
    final aid = customerAccountId ?? selectedChatAccount.value?.accountId;

    chatList.removeWhere((c) => c.chatId == chatId);
    if (_chatSessionMatchesAccountTab(updatedChat.status, tabFilter)) {
      chatList.insert(0, updatedChat);
    }

    if (aid == null) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    final accountIndex = chatAccountList.indexWhere((a) => a.accountId == aid);
    if (accountIndex != -1) {
      final current = chatAccountList[accountIndex];
      final updatedAccount = ChatAccountModel(
        rowNum: current.rowNum,
        accountId: current.accountId,
        accountName: current.accountName,
        lastChatId: chatId,
        lastMessageOn: listTouchTime,
        lastMessagePreview:
        current.lastMessagePreview ?? updatedChat.lastMessagePreview,
        totalMessageCount: current.totalMessageCount,
        unreadMessageCount: current.unreadMessageCount,
        unreadChatCount: current.unreadChatCount,
        adminChatRole: current.adminChatRole,
        chatStatus: current.chatStatus,
      );
      chatAccountList.removeAt(accountIndex);
      chatAccountList.insert(0, updatedAccount);
    }
    filterChatAccounts(chatAccountsSearchController.text);
  }

  /// Same predicate as [loadChatList] / [loadChatAccountList] for the active tab.
  bool _chatSessionMatchesAccountTab(int? chatSessionStatus, int? tabFilter) {
    if (tabFilter == null) return true;
    return chatSessionStatus == tabFilter;
  }

  /// Updates [chatList] / [chatAccountList] after pick: rows that no longer match
  /// the active account tab (e.g. unpicked → open) are removed; open tab can show the account.
  void _mergePickIntoLists({
    required String chatId,
    required ChatModel updatedChat,
    required int? customerAccountId,
    required DateTime listTouchTime,
  }) {
    final tabFilter = ChatAccountListTabs.apiStatusFilter(selectedChatTab.value);
    final aid = customerAccountId ?? selectedChatAccount.value?.accountId;
    final unpickedSessionStatus =
    ChatAccountListTabs.apiStatusFilter(ChatAccountListTabs.unpicked);

    final int otherUnpickedForAccount = (aid != null && tabFilter == unpickedSessionStatus)
        ? chatList
        .where((c) =>
    c.accountId == aid &&
        c.chatId != chatId &&
        c.status == unpickedSessionStatus)
        .length
        : 0;

    chatList.removeWhere((c) => c.chatId == chatId);
    if (_chatSessionMatchesAccountTab(updatedChat.status, tabFilter)) {
      chatList.insert(0, updatedChat);
    }

    const int pickedAccountListStatus = 0;
    if (aid == null) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    final existing =
    chatAccountList.firstWhereOrNull((a) => a.accountId == aid);
    filteredChatAccountList.removeWhere((a) => a.accountId == aid);
    chatAccountList.removeWhere((a) => a.accountId == aid);

    if (tabFilter == unpickedSessionStatus && otherUnpickedForAccount > 0) {
      if (existing != null) {
        chatAccountList.insert(0, existing);
        filterChatAccounts(chatAccountsSearchController.text);
      }
      return;
    }

    if (!_chatSessionMatchesAccountTab(pickedAccountListStatus, tabFilter)) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    final sc = selectedChatAccount.value;
    final updatedAccount = ChatAccountModel(
      rowNum: existing?.rowNum ?? sc?.rowNum,
      accountId: aid,
      accountName: existing?.accountName ??
          sc?.accountName ??
          updatedChat.accountName,
      lastChatId: chatId,
      lastMessageOn: listTouchTime,
      lastMessagePreview:
      existing?.lastMessagePreview ?? updatedChat.lastMessagePreview,
      totalMessageCount:
      existing?.totalMessageCount ?? updatedChat.totalMessageCount,
      unreadMessageCount: existing?.unreadMessageCount,
      unreadChatCount: existing?.unreadChatCount,
      adminChatRole: existing?.adminChatRole ?? sc?.adminChatRole ?? 1,
      chatStatus: pickedAccountListStatus,
    );
    chatAccountList.insert(0, updatedAccount);
    filterChatAccounts(chatAccountsSearchController.text);
  }

  /// Updates [chatList] / [chatAccountList] after close: open sessions leave the Open tab
  /// list; Closed / All tabs can show the closed row and account with `chatStatus == 1`.
  void _mergeCloseIntoLists({
    required String chatId,
    required ChatModel updatedChat,
    required int? customerAccountId,
    required DateTime listTouchTime,
  }) {
    final tabFilter = ChatAccountListTabs.apiStatusFilter(selectedChatTab.value);
    final aid = customerAccountId ?? selectedChatAccount.value?.accountId;
    const int openSessionStatus = 0;
    final int? openTabApiFilter =
    ChatAccountListTabs.apiStatusFilter(ChatAccountListTabs.open);
    final int? closedTabApiFilter =
    ChatAccountListTabs.apiStatusFilter(ChatAccountListTabs.closed);

    final int otherOpenForAccount = (aid != null && tabFilter == openTabApiFilter)
        ? chatList
        .where((c) =>
    c.accountId == aid &&
        c.chatId != chatId &&
        c.status == openSessionStatus)
        .length
        : 0;

    chatList.removeWhere((c) => c.chatId == chatId);
    if (_chatSessionMatchesAccountTab(updatedChat.status, tabFilter)) {
      chatList.insert(0, updatedChat);
    }

    if (aid == null) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    final existing =
    chatAccountList.firstWhereOrNull((a) => a.accountId == aid);
    filteredChatAccountList.removeWhere((a) => a.accountId == aid);
    chatAccountList.removeWhere((a) => a.accountId == aid);

    if (tabFilter == openTabApiFilter && otherOpenForAccount > 0) {
      if (existing != null) {
        chatAccountList.insert(0, existing);
        filterChatAccounts(chatAccountsSearchController.text);
      }
      return;
    }

    if (tabFilter == openTabApiFilter) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    if (tabFilter != null && tabFilter != closedTabApiFilter) {
      filterChatAccounts(chatAccountsSearchController.text);
      return;
    }

    const int closedAccountListStatus = 1;
    final sc = selectedChatAccount.value;
    final updatedAccount = ChatAccountModel(
      rowNum: existing?.rowNum ?? sc?.rowNum,
      accountId: aid,
      accountName: existing?.accountName ??
          sc?.accountName ??
          updatedChat.accountName,
      lastChatId: chatId,
      lastMessageOn: listTouchTime,
      lastMessagePreview:
      existing?.lastMessagePreview ?? updatedChat.lastMessagePreview,
      totalMessageCount:
      existing?.totalMessageCount ?? updatedChat.totalMessageCount,
      unreadMessageCount: existing?.unreadMessageCount,
      unreadChatCount: existing?.unreadChatCount,
      adminChatRole: existing?.adminChatRole ?? sc?.adminChatRole ?? 1,
      chatStatus: closedAccountListStatus,
    );
    chatAccountList.insert(0, updatedAccount);
    filterChatAccounts(chatAccountsSearchController.text);
  }

  /// After a local pick, move the account sidebar to the **Open** tab and reload
  /// lists so filters match `status == 0` sessions (does not use [changeChatAccountTab]
  /// to avoid clearing the in-progress chat selection).
  Future<void> _activateOpenTabAfterPick({required int? customerAccountId}) async {
    final reloadAccounts = selectedChatTab.value != ChatAccountListTabs.open;
    selectedChatTab.value = ChatAccountListTabs.open;
    if (reloadAccounts) {
      try {
        await loadChatAccountList(
          refresh: true,
          chatStatus:
          ChatAccountListTabs.apiStatusFilter(ChatAccountListTabs.open),
        );
      } catch (_) {}
    }

    final accIdStr =
        customerAccountId?.toString() ??
            selectedChatAccount.value?.accountId?.toString();
    if (accIdStr != null && accIdStr.isNotEmpty) {
      try {
        await loadChatList(accIdStr, refresh: true);
      } catch (_) {}
    }

    final aid = selectedChatAccount.value?.accountId ?? customerAccountId;
    if (aid != null) {
      final row = chatAccountList.firstWhereOrNull((a) => a.accountId == aid);
      if (row != null) {
        selectedChatAccount.value = row;
      }
    }
  }

  /// Sends `chat.pick`, updates [chatList] + [chatAccountList], then opens the chat.
  Future<void> pickChatAndEnter(ChatModel chat) async {
    final id = chat.chatId?.toString();
    if (id == null || id.isEmpty) return;
    final sent = await sendPickChatRequest(id);
    if (!sent) return;
    final accountId = chat.accountId ?? selectedChatAccount.value?.accountId;
    await _activateOpenTabAfterPick(customerAccountId: accountId);

    final touched = DateTime.now();
    final updatedChat = ChatModel(
      rowNum: chat.rowNum,
      chatId: chat.chatId,
      accountId: chat.accountId,
      topicId: chat.topicId,
      topicCode: chat.topicCode,
      topicTitle: chat.topicTitle,
      status: 0,
      createdOn: chat.createdOn,
      lastActivity: chat.lastActivity,
      accountName: chat.accountName,
      lastMessageSeq: chat.lastMessageSeq,
      lastSeenSeq: chat.lastSeenSeq,
      clientSeenSeq: chat.clientSeenSeq,
      lastMessagePreview: chat.lastMessagePreview,
      lastMessageOn: chat.lastMessageOn,
      totalMessageCount: chat.totalMessageCount,
      unreadMessageCount: chat.unreadMessageCount,
      topicKey: chat.topicKey,
      assignedAdminAccountId: chat.assignedAdminAccountId,
      assignedAdminUserId: chat.assignedAdminUserId,
      closedOn: chat.closedOn,
      assignedAdminName: chat.assignedAdminName,
      userId: chat.userId,
      adminRole: chat.adminRole,
      adminRoleTitle: chat.adminRoleTitle,
    );

    _mergePickIntoLists(
      chatId: id,
      updatedChat: updatedChat,
      customerAccountId: accountId,
      listTouchTime: touched,
    );
    selectChat(updatedChat);
  }

  /// Sends `chat.pick` over the socket ([SocketChatPickModel]); [chatId] maps to `ChatId` in JSON.
  /// Returns `false` if the send failed (snackbar shown).
  Future<bool> sendPickChatRequest(String chatId) async {
    if (chatId.isEmpty) return false;
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final payload = pick.SocketChatPickModel(
        channel: 'chat.pick',
        reqId: uuid.v4(),
        data: pick.Data(
          chatId: chatId,
          note: null,
        ),
      );
      SocketService.to.send(payload.toJson());
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال درخواست انتخاب چت: $e');
      return false;
    }
  }

  /// Sends `chat.close` ([SocketChatCloseModel]); [chatId] maps to `ChatId` in JSON.
  Future<bool> sendCloseChatRequest(String chatId) async {
    if (chatId.isEmpty) return false;
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final payload = close.SocketChatCloseModel(
        channel: 'chat.close',
        reqId: uuid.v4(),
        data: close.Data(
          chatId: chatId,
          note: null,
        ),
      );
      SocketService.to.send(payload.toJson());
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال درخواست بستن چت: $e');
      return false;
    }
  }

  /// Sends close over the socket and merges lists (mirrors pick optimistic update).
  Future<void> closeChatAndUpdateLists(ChatModel chat) async {
    final id = chat.chatId?.toString();
    if (id == null || id.isEmpty) return;
    final sent = await sendCloseChatRequest(id);
    if (!sent) return;

    final accountId = chat.accountId ?? selectedChatAccount.value?.accountId;
    final touched = DateTime.now();
    final updatedChat = ChatModel(
      rowNum: chat.rowNum,
      chatId: chat.chatId,
      accountId: chat.accountId,
      topicId: chat.topicId,
      topicCode: chat.topicCode,
      topicTitle: chat.topicTitle,
      status: 1,
      createdOn: chat.createdOn,
      lastActivity: chat.lastActivity,
      accountName: chat.accountName,
      lastMessageSeq: chat.lastMessageSeq,
      lastSeenSeq: chat.lastSeenSeq,
      clientSeenSeq: chat.clientSeenSeq,
      lastMessagePreview: chat.lastMessagePreview,
      lastMessageOn: chat.lastMessageOn,
      totalMessageCount: chat.totalMessageCount,
      unreadMessageCount: chat.unreadMessageCount,
      topicKey: chat.topicKey,
      assignedAdminAccountId: chat.assignedAdminAccountId,
      assignedAdminUserId: chat.assignedAdminUserId,
      closedOn: touched,
      assignedAdminName: chat.assignedAdminName,
      userId: chat.userId,
      adminRole: chat.adminRole,
      adminRoleTitle: chat.adminRoleTitle,
    );

    _mergeCloseIntoLists(
      chatId: id,
      updatedChat: updatedChat,
      customerAccountId: accountId,
      listTouchTime: touched,
    );
    if (selectedChat.value?.chatId == id) {
      goBackToChatList();
    }
  }

  /// Sends `chat.forward` ([SocketChatForwardModel]); outbound keys `ChatId`, `ToAdminAccountId`, `ForwardMessageSeq`.
  Future<bool> sendForwardChatRequest({
    required String chatId,
    required int toAdminAccountId,
    required int forwardMessageSeq,
  }) async {
    if (chatId.isEmpty) return false;
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final payload = forward.SocketChatForwardModel(
        channel: 'chat.forward',
        reqId: uuid.v4(),
        data: forward.Data(
          chatId: chatId,
          toAdminAccountId: toAdminAccountId,
          forwardMessageSeq: forwardMessageSeq,
          note: null,
        ),
      );
      SocketService.to.send(payload.toJson());
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال درخواست ارجاع چت: $e');
      return false;
    }
  }

  /// Sends forward over the socket and merges lists for the forwarding admin.
  Future<void> forwardChatToAdmin(ChatModel chat, int toAdminAccountId) async {
    final id = chat.chatId?.toString();
    if (id == null || id.isEmpty) return;
    final seq = chat.lastMessageSeq ?? 0;
    final sent = await sendForwardChatRequest(
      chatId: id,
      toAdminAccountId: toAdminAccountId,
      forwardMessageSeq: seq,
    );
    if (!sent) return;

    final accountId = chat.accountId ?? selectedChatAccount.value?.accountId;
    final touched = DateTime.now();
    final updatedChat = ChatModel(
      rowNum: chat.rowNum,
      chatId: chat.chatId,
      accountId: chat.accountId,
      topicId: chat.topicId,
      topicCode: chat.topicCode,
      topicTitle: chat.topicTitle,
      status: chat.status,
      createdOn: chat.createdOn,
      lastActivity: chat.lastActivity,
      accountName: chat.accountName,
      lastMessageSeq: seq,
      lastSeenSeq: chat.lastSeenSeq,
      clientSeenSeq: chat.clientSeenSeq,
      lastMessagePreview: chat.lastMessagePreview,
      lastMessageOn: chat.lastMessageOn,
      totalMessageCount: chat.totalMessageCount,
      unreadMessageCount: chat.unreadMessageCount,
      topicKey: chat.topicKey,
      assignedAdminAccountId: toAdminAccountId,
      assignedAdminUserId: chat.assignedAdminUserId,
      closedOn: chat.closedOn,
      assignedAdminName: chat.assignedAdminName,
      userId: chat.userId,
      adminRole: 2,
      adminRoleTitle: chat.adminRoleTitle,
    );

    _mergeForwardOutForSender(
      chatId: id,
      updatedChat: updatedChat,
      customerAccountId: accountId,
      listTouchTime: touched,
    );
    if (selectedChat.value?.chatId == id) {
      goBackToChatList();
    }
  }

  /// Sends `chat.grant` ([SocketChatGrantModel]); outbound keys `ChatId`, `TargetAdminAccountId`.
  Future<bool> sendGrantChatRequest({
    required String chatId,
    required int targetAdminAccountId,
  }) async {
    if (chatId.isEmpty) return false;
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final payload = grant.SocketChatGrantModel(
        channel: 'chat.grant',
        reqId: uuid.v4(),
        data: grant.Data(
          chatId: chatId,
          targetAdminAccountId: targetAdminAccountId,
          note: null,
        ),
      );
      SocketService.to.send(payload.toJson());
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال درخواست اعطای مشاهده: $e');
      return false;
    }
  }

  /// Sends grant over the socket and bumps lists for the granter (assignee unchanged).
  Future<void> grantChatViewToAdmin(ChatModel chat, int targetAdminAccountId) async {
    final id = chat.chatId?.toString();
    if (id == null || id.isEmpty) return;
    final sent = await sendGrantChatRequest(
      chatId: id,
      targetAdminAccountId: targetAdminAccountId,
    );
    if (!sent) return;

    final accountId = chat.accountId ?? selectedChatAccount.value?.accountId;
    final touched = DateTime.now();
    final updatedChat = ChatModel(
      rowNum: chat.rowNum,
      chatId: chat.chatId,
      accountId: chat.accountId,
      topicId: chat.topicId,
      topicCode: chat.topicCode,
      topicTitle: chat.topicTitle,
      status: chat.status,
      createdOn: chat.createdOn,
      lastActivity: touched,
      accountName: chat.accountName,
      lastMessageSeq: chat.lastMessageSeq,
      lastSeenSeq: chat.lastSeenSeq,
      clientSeenSeq: chat.clientSeenSeq,
      lastMessagePreview: chat.lastMessagePreview,
      lastMessageOn: chat.lastMessageOn,
      totalMessageCount: chat.totalMessageCount,
      unreadMessageCount: chat.unreadMessageCount,
      topicKey: chat.topicKey,
      assignedAdminAccountId: chat.assignedAdminAccountId,
      assignedAdminUserId: chat.assignedAdminUserId,
      closedOn: chat.closedOn,
      assignedAdminName: chat.assignedAdminName,
      userId: chat.userId,
      adminRole: chat.adminRole,
      adminRoleTitle: chat.adminRoleTitle,
    );

    _mergeGrantGranterLists(
      chatId: id,
      updatedChat: updatedChat,
      customerAccountId: accountId,
      listTouchTime: touched,
    );
    if (selectedChat.value?.chatId == id) {
      selectedChat.value = updatedChat;
    }
  }

  /// Sends `chat.revoke` ([SocketChatRevokeModel]); outbound keys `ChatId`, `TargetAdminAccountId`.
  Future<bool> sendRevokeChatRequest({
    required String chatId,
    required int targetAdminAccountId,
  }) async {
    if (chatId.isEmpty) return false;
    try {
      await SocketService.to.ensureConnected(clientId: currentUserId);
      final payload = revoke.SocketChatRevokeModel(
        channel: 'chat.revoke',
        reqId: uuid.v4(),
        data: revoke.Data(
          chatId: chatId,
          targetAdminAccountId: targetAdminAccountId,
          note: null,
        ),
      );
      SocketService.to.send(payload.toJson());
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال درخواست لغو دسترسی مشاهده: $e');
      return false;
    }
  }

  /// Revokes view access for [targetAdminAccountId]; granter list bump mirrors [grantChatViewToAdmin].
  /// Returns `false` if the request was not sent; `true` after local merge (or when no chat row to bump).
  Future<bool> revokeChatViewFromAdmin(
      String chatId,
      int targetAdminAccountId,
      ) async {
    if (chatId.isEmpty) return false;
    final sent = await sendRevokeChatRequest(
      chatId: chatId,
      targetAdminAccountId: targetAdminAccountId,
    );
    if (!sent) return false;

    final touched = DateTime.now();
    final cur = chatList.firstWhereOrNull((c) => c.chatId == chatId) ??
        (selectedChat.value?.chatId == chatId ? selectedChat.value : null);
    if (cur == null) {
      filterChatAccounts(chatAccountsSearchController.text);
      return true;
    }

    final id = cur.chatId?.toString();
    if (id == null || id.isEmpty) return true;
    final accountId = cur.accountId ?? selectedChatAccount.value?.accountId;
    final updatedChat = ChatModel(
      rowNum: cur.rowNum,
      chatId: cur.chatId,
      accountId: cur.accountId,
      topicId: cur.topicId,
      topicCode: cur.topicCode,
      topicTitle: cur.topicTitle,
      status: cur.status,
      createdOn: cur.createdOn,
      lastActivity: touched,
      accountName: cur.accountName,
      lastMessageSeq: cur.lastMessageSeq,
      lastSeenSeq: cur.lastSeenSeq,
      clientSeenSeq: cur.clientSeenSeq,
      lastMessagePreview: cur.lastMessagePreview,
      lastMessageOn: cur.lastMessageOn,
      totalMessageCount: cur.totalMessageCount,
      unreadMessageCount: cur.unreadMessageCount,
      topicKey: cur.topicKey,
      assignedAdminAccountId: cur.assignedAdminAccountId,
      assignedAdminUserId: cur.assignedAdminUserId,
      closedOn: cur.closedOn,
      assignedAdminName: cur.assignedAdminName,
      userId: cur.userId,
      adminRole: cur.adminRole,
      adminRoleTitle: cur.adminRoleTitle,
    );

    _mergeGrantGranterLists(
      chatId: id,
      updatedChat: updatedChat,
      customerAccountId: accountId,
      listTouchTime: touched,
    );
    if (selectedChat.value?.chatId == id) {
      selectedChat.value = updatedChat;
    }
    return true;
  }

  void _applyRealtimeListUpdates({
    required String chatId,
    required String? messageText,
    required DateTime messageTime,
    required bool incrementUnread,
  }) {
    final chatIndex = chatList.indexWhere((c) => c.chatId == chatId);
    if (chatIndex != -1) {
      final current = chatList[chatIndex];
      final updatedChat = ChatModel(
        rowNum: current.rowNum,
        chatId: current.chatId,
        accountId: current.accountId,
        topicId: current.topicId,
        topicCode: current.topicCode,
        topicTitle: current.topicTitle,
        status: current.status,
        createdOn: current.createdOn,
        lastActivity: messageTime,
        accountName: current.accountName,
        lastMessageSeq: current.lastMessageSeq,
        lastSeenSeq: current.lastSeenSeq,
        clientSeenSeq: current.clientSeenSeq,
        lastMessagePreview: messageText ?? current.lastMessagePreview,
        lastMessageOn: messageTime,
        totalMessageCount: current.totalMessageCount,
        unreadMessageCount: incrementUnread
            ? ((current.unreadMessageCount ?? 0) + 1)
            : current.unreadMessageCount,
        topicKey: current.topicKey,
        assignedAdminAccountId: current.assignedAdminAccountId,
        assignedAdminUserId: current.assignedAdminUserId,
        closedOn: current.closedOn,
        assignedAdminName: current.assignedAdminName,
        userId: current.userId,
        adminRole: current.adminRole,
        adminRoleTitle: current.adminRoleTitle,
      );
      chatList.removeAt(chatIndex);
      chatList.insert(0, updatedChat);
    }

    final selectedAccountId = selectedChatAccount.value?.accountId;
    if (selectedAccountId != null) {
      final accountIndex = chatAccountList.indexWhere((a) => a.accountId == selectedAccountId);
      if (accountIndex != -1) {
        final current = chatAccountList[accountIndex];
        final updatedAccount = ChatAccountModel(
          rowNum: current.rowNum,
          accountId: current.accountId,
          accountName: current.accountName,
          lastChatId: chatId,
          lastMessageOn: messageTime,
          lastMessagePreview: messageText ?? current.lastMessagePreview,
          totalMessageCount: current.totalMessageCount,
          unreadMessageCount: incrementUnread
              ? ((current.unreadMessageCount ?? 0) + 1)
              : current.unreadMessageCount,
          unreadChatCount: incrementUnread
              ? ((current.unreadChatCount ?? 0) + 1)
              : current.unreadChatCount,
          adminChatRole: current.adminChatRole,
          chatStatus: current.chatStatus,
        );
        chatAccountList.removeAt(accountIndex);
        chatAccountList.insert(0, updatedAccount);
      }
    }
  }

  // ─── Load chat account list ───
  Future<void> loadChatAccountList({
    bool refresh = false,
    int? chatStatus,
  }) async {
    try {
      if (refresh) {
        // Preserve current tab when [chatStatus] is omitted (e.g. header refresh).
        _chatAccountStatusFilter =
            chatStatus ?? ChatAccountListTabs.apiStatusFilter(selectedChatTab.value);
      } else if (chatStatus != null) {
        _chatAccountStatusFilter = chatStatus;
      }
      if (refresh) {
        chatAccountPage = 1;
        hasMoreChatAccounts.value = true;
        chatAccountList.clear();
        filteredChatAccountList.clear();
      }
      if (!hasMoreChatAccounts.value || isLoadingMoreChatAccounts.value) return;
      if (refresh) {
        isLoadingChatAccounts.value = true;
      } else {
        isLoadingMoreChatAccounts.value = true;
      }

      final startIndex = (chatAccountPage - 1) * pageSize + 1;
      final toIndex = chatAccountPage * pageSize;

      final chats = await chatRepository.getChatAccountList(
        startIndex: startIndex,
        toIndex: toIndex,
        chatAccountStatus: _chatAccountStatusFilter,
      );

      if (refresh) {
        chatAccountList.assignAll(chats);
      } else {
        chatAccountList.addAll(chats);
      }

      hasMoreChatAccounts.value = chats.length == pageSize;
      if (hasMoreChatAccounts.value) chatAccountPage++;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری لیست چت ‌اکانت ها: $e');
    } finally {
      isLoadingChatAccounts.value = false;
      isLoadingMoreChatAccounts.value = false;
    }
  }

  Future<void> changeChatAccountTab(int index) async {
    if (index < ChatAccountListTabs.unpicked ||
        index > ChatAccountListTabs.closed) {
      return;
    }
    if (selectedChatTab.value == index) return;
    selectedChatTab.value = index;
    chatAccountsSearchController.clear();
    filteredChatAccountList.clear();
    await loadChatAccountList(
      refresh: true,
      chatStatus: ChatAccountListTabs.apiStatusFilter(index),
    );
    clearSelections();
  }

  // ─── Load chat list ───
  Future<void> loadChatList(String accountId, {bool refresh = false}) async {
    try {
      if (refresh) {
        chatPage = 1;
        hasMoreChats.value = true;
        chatList.clear();
      }
      if (!hasMoreChats.value || isLoadingMoreChats.value) return;
      if (refresh) {
        isLoadingChats.value = true;
      } else {
        isLoadingMoreChats.value = true;
      }

      final startIndex = (chatPage - 1) * pageSize + 1;
      final toIndex = chatPage * pageSize;

      final topicCode = chatListTopicFilter.value?.code?.trim();
      final chats = await chatRepository.getChatList(
        accountId,
        startIndex: startIndex,
        toIndex: toIndex,
        chatStatus: _chatAccountStatusFilter,
        topicCode: topicCode != null && topicCode.isNotEmpty ? topicCode : null,
      );

      if (refresh) {
        chatList.assignAll(chats);
      } else {
        chatList.addAll(chats);
      }

      hasMoreChats.value = chats.length == pageSize;
      if (hasMoreChats.value) chatPage++;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری لیست چت ها: $e');
    } finally {
      isLoadingChats.value = false;
      isLoadingMoreChats.value = false;
    }
  }

  // Method to fetch tooltip chat history
  Future<ChatHistoryModel?> getChatHistoryInfo(String chatId) async {
    try {
      final tooltipChatHistory = await chatRepository.getChatHistoryInfo(chatId);
      return tooltipChatHistory;
    } catch (e) {
      print('Error fetching tooltip chat history: $e');
      return null;
    }
  }

  // ─── Load account list ───
  Future<void> loadAccountList() async {
    try {
      isLoadingAccounts.value = true;
      final accounts = await accountRepository.getAccountList('');
      accountList.assignAll(accounts);
      filteredAccountList.assignAll(accounts);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری لیست کاربران: $e');
    } finally {
      isLoadingAccounts.value = false;
    }
  }

  // ─── Load account admin list ───
  Future<void> loadAccountAdminList(String topicCode) async {
    try {
      isLoadingAccountsAdmin.value = true;
      final accountsAdmin = await chatRepository.getAccountAdminList(topicCode);
      accountAdminList.assignAll(accountsAdmin);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری لیست کاربران ادمین: $e');
    } finally {
      isLoadingAccountsAdmin.value = false;
    }
  }

  // ─── Chat list topic filter ───
  Future<void> setChatListTopicFilter(TopicModel? topic) async {
    chatListTopicFilter.value = topic;
    final accountId = selectedChatAccount.value?.accountId?.toString();
    if (accountId == null || accountId.isEmpty || selectedChat.value != null) {
      return;
    }
    await loadChatList(accountId, refresh: true);
  }

  List<TopicModel> get sortedTopicList {
    final copy = List<TopicModel>.from(topicList);
    copy.sort((a, b) {
      final ao = a.sortOrder ?? 0;
      final bo = b.sortOrder ?? 0;
      if (ao != bo) return ao.compareTo(bo);
      return (a.title ?? '').compareTo(b.title ?? '');
    });
    return copy;
  }

  // ─── Load topics ───
  Future<void> loadTopics() async {
    try {
      isLoadingTopics.value = true;
      final topics = await chatRepository.getTopics();
      topicList.assignAll(topics);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری موضوعات: $e');
    } finally {
      isLoadingTopics.value = false;
    }
  }

  void toggleMessageSearch() {
    if (isMessageSearchExpanded.value) {
      collapseMessageSearch();
      return;
    }
    isMessageSearchExpanded.value = true;
  }

  void collapseMessageSearch({bool clearQuery = false}) {
    isMessageSearchExpanded.value = false;
    if (clearQuery) {
      _resetMessageSearchQuery(reload: true);
    }
  }

  void _resetMessageSearchQuery({bool reload = false}) {
    _messageSearchDebounce?.cancel();
    messagesSearchController.clear();
    final hadQuery = activeMessageSearchQuery.value.trim().isNotEmpty;
    activeMessageSearchQuery.value = '';
    if (reload && hadQuery) {
      final chatId = selectedChat.value?.chatId?.toString();
      if (chatId != null && chatId.isNotEmpty) {
        loadChatMessages(chatId, refresh: true);
      }
    }
  }

  void clearMessageSearchAndReload() {
    _resetMessageSearchQuery(reload: true);
  }

  void _clearMessageSearchState({bool collapse = true}) {
    _messageSearchDebounce?.cancel();
    messagesSearchController.clear();
    activeMessageSearchQuery.value = '';
    if (collapse) {
      isMessageSearchExpanded.value = false;
    }
  }

  void onMessagesSearchChanged(String value) {
    _messageSearchDebounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      if (activeMessageSearchQuery.value.isNotEmpty) {
        _resetMessageSearchQuery(reload: true);
      }
      return;
    }
    _messageSearchDebounce = Timer(_messageSearchDebounceDelay, () {
      submitMessageSearch(messagesSearchController.text);
    });
  }

  void submitMessageSearch(String value) {
    _messageSearchDebounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      _resetMessageSearchQuery(reload: true);
      return;
    }
    if (trimmed == activeMessageSearchQuery.value.trim()) return;
    activeMessageSearchQuery.value = trimmed;
    final chatId = selectedChat.value?.chatId?.toString();
    if (chatId == null || chatId.isEmpty) return;
    loadChatMessages(chatId, refresh: true);
  }

  // ─── Load chat messages ───
  Future<void> loadChatMessages(
      String chatId, {
        bool refresh = false,
        bool searchFallbackRetry = false,
      }) async {
    final searchText = activeMessageSearchQuery.value.trim();
    try {
      if (refresh) {
        messagePage = 1;
        hasMoreMessages.value = true;
        _clearMessageBubbleScrollKeys();
        chatMessages.clear();
      }
      if (!hasMoreMessages.value || isLoadingMoreMessages.value) return;
      if (refresh) {
        isLoadingMessages.value = true;
      } else {
        isLoadingMoreMessages.value = true;
      }

      final startIndex = (messagePage - 1) * pageSize + 1;
      final toIndex = messagePage * pageSize;

      final messages = await chatRepository.getChatMessages(
        chatId,
        startIndex: startIndex,
        toIndex: toIndex,
        textSearch: searchText.isNotEmpty ? searchText : null,
      );

      if (refresh) {
        chatMessages.assignAll(messages);
      } else {
        chatMessages.addAll(messages);
      }

      hasMoreMessages.value = messages.length == pageSize;
      if (hasMoreMessages.value) messagePage++;
    } catch (e) {
      if (searchText.isNotEmpty && !searchFallbackRetry) {
        _messageSearchDebounce?.cancel();
        messagesSearchController.clear();
        activeMessageSearchQuery.value = '';
        ToastService().info('جستجو در دسترس نیست؛ نمایش همه پیام‌ها');
        await loadChatMessages(
          chatId,
          refresh: refresh,
          searchFallbackRetry: true,
        );
        return;
      }
      if (!searchFallbackRetry) {
        Get.snackbar('خطا', 'خطا در بارگذاری پیام‌ها: $e');
      }
    } finally {
      isLoadingMessages.value = false;
      isLoadingMoreMessages.value = false;
      if (refresh && selectedChat.value?.chatId?.toString() == chatId) {
        _scheduleInitialConversationScroll(selectedChat.value!);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(applyInitialConversationScrollIfNeeded());
        });
      }
    }
  }

  // ─── Attachment helpers ─────────────────────────────────────────────────────

    /// Sends a single voice clip immediately (hold-to-record flow).
  Future<void> sendVoiceMessage(Uint8List bytes, String fileName) async {
    if (bytes.isEmpty) return;
    if (isSendingMessage.value || isUploadingAttachments.value) return;

    final ext = chatAttachmentExtensionFromName(fileName);
    if (ext == null || !isChatAttachmentExtensionAllowed(ext)) {
      ToastService().error('فرمت فایل صوتی پشتیبانی نمی‌شود');
      return;
    }

    pendingAttachments.clear();
    pendingAttachments.add(
      ChatPendingAttachment(
        name: fileName,
        sizeBytes: bytes.length,
        //fileType: classifyChatAttachmentFileType(ext),
        fileType: 'audio',
        bytes: bytes,
      ),
    );
    //await sendMessage();
  }

  Future<void> pickImageAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );
      if (result == null) return;
      _addPickedFiles(result.files);
    } catch (e) {
      ToastService().error('خطا در انتخاب تصویر: $e');
    } finally {
      scheduleRefocusMessageComposer();
    }
  }

  Future<void> pickVideoAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
        withData: true,
      );
      if (result == null) return;
      _addPickedFiles(result.files);
    } catch (e) {
      ToastService().error('خطا در انتخاب ویدئو: $e');
    } finally {
      scheduleRefocusMessageComposer();
    }
  }

  Future<void> pickAudioAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
        withData: true,
      );
      if (result == null) return;
      _addPickedFiles(result.files);
    } catch (e) {
      ToastService().error('خطا در انتخاب صدا: $e');
    } finally {
      scheduleRefocusMessageComposer();
    }
  }

  Future<void> pickDocumentAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'csv',
        ],
        allowMultiple: true,
        withData: true,
      );
      if (result == null) return;
      _addPickedFiles(result.files);
    } catch (e) {
      ToastService().error('خطا در انتخاب سند: $e');
    } finally {
      scheduleRefocusMessageComposer();
    }
  }

  Future<void> pickArchiveAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'rar', '7z', 'tar', 'gz'],
        allowMultiple: true,
        withData: true,
      );
      if (result == null) return;
      _addPickedFiles(result.files);
    } catch (e) {
      ToastService().error('خطا در انتخاب آرشیو: $e');
    } finally {
      scheduleRefocusMessageComposer();
    }
  }

  void _addPickedFiles(List<PlatformFile> files) {
    for (final f in files) {
      final ext = (f.extension ??
          resolveChatAttachmentExtension(fileName: f.name) ??
          chatAttachmentExtensionFromName(f.name) ??
          '')
          .toLowerCase();
      if (!isChatAttachmentExtensionAllowed(ext)) {
        ToastService().error('نوع فایل «${f.name}» پشتیبانی نمی‌شود');
        continue;
      }
      final fileType = classifyChatAttachmentFileType(ext);
      final bytes = f.bytes;
      if (bytes == null || bytes.isEmpty) {
        ToastService().error('خواندن فایل «${f.name}» ناموفق بود');
        continue;
      }
      pendingAttachments.add(ChatPendingAttachment(
        name: f.name,
        sizeBytes: f.size > 0 ? f.size : bytes.length,
        fileType: fileType,
        bytes: bytes,
        path: f.path,
      ));
    }
  }

  /// Adds files dropped onto the composer (desktop / web). Same pipeline as menu pickers.
  Future<void> addAttachmentsFromDrop(List<XFile> droppedFiles) async {
    if (droppedFiles.isEmpty) return;
    try {
      final platformFiles = <PlatformFile>[];
      for (final file in droppedFiles) {
        final name = resolveDroppedAttachmentFileName(file);
        if (!isDroppedChatAttachmentAllowed(file)) {
          ToastService().error('نوع فایل «$name» پشتیبانی نمی‌شود');
          continue;
        }
        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) {
          ToastService().error('فایل «$name» خالی است');
          continue;
        }
        platformFiles.add(
          PlatformFile(
            name: name,
            size: bytes.length,
            bytes: bytes,
            path: file.path,
          ),
        );
      }
      if (platformFiles.isNotEmpty) {
        _addPickedFiles(platformFiles);
      }
    } catch (e) {
      ToastService().error('خطا در افزودن فایل: $e');
    } finally {
      scheduleRefocusMessageComposer();
    }
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < pendingAttachments.length) {
      pendingAttachments.removeAt(index);
    }
  }

  void clearAttachments() {
    pendingAttachments.clear();
    isUploadingAttachments.value = false;
  }

  /// Uploads a single attachment via the dedicated chat endpoint and sets
  /// its [ChatPendingAttachment.recordId].  Returns true on success.
  Future<bool> _uploadAttachment(ChatPendingAttachment attachment) async {
    try {
      attachment.recordId = uuid.v4();
      attachment.failed.value = false;
      attachment.progress.value = 0.1;

      final bytes = attachment.bytes;
      if (bytes == null) {
        throw Exception('داده‌های فایل در دسترس نیست');
      }

      attachment.progress.value = 0.4;

      final ext = chatAttachmentExtensionFromName(attachment.name);
      await _chatAttachmentRepo.uploadChatAttachment(
        bytes: bytes,
        fileName: attachment.name,
        recordId: attachment.recordId!,
        mimeType: ext != null
            ? chatVoiceRecordingUploadMimeType(ext)
            : null,
      );

      _chatAttachmentBytesCache[attachment.recordId!] = bytes;
      attachment.progress.value = 1.0;
      return true;
    } catch (e) {
      attachment.failed.value = true;
      attachment.progress.value = 0;
      return false;
    }
  }

  // ─── Send message ─── (MODIFIED)
  Future<void> sendMessage() async {
    final hasAttachments = pendingAttachments.isNotEmpty;
    final hasText = messageController.text.trim().isNotEmpty;

    final forwardSource = pendingForwardMessage.value;
    final hasForward = forwardSource != null;
    if (!hasText && !hasAttachments && replyToMessage.value == null && !hasForward) {
      return;
    }

    if (selectedAccount.value == null && selectedChatAccount.value == null) {
      Get.snackbar('خطا', 'کاربر انتخاب نشده است');
      return;
    }

    if (selectedTopic.value == null) {
      Get.snackbar('خطا', 'لطفا ابتدا موضوع گفتگو را انتخاب کنید');
      return;
    }

    try {
      isSendingMessage.value = true;
      final customerAccountId =
          selectedAccount.value?.id ?? selectedChatAccount.value?.accountId;
      if (customerAccountId == null) {
        Get.snackbar('خطا', 'شناسه کاربر نامعتبر است');
        return;
      }

      // ─── Upload pending attachments first ───
      String? filesJsonStr;
      if (pendingAttachments.isNotEmpty) {
        isUploadingAttachments.value = true;
        bool anyFailed = false;
        for (final attachment in pendingAttachments) {
          final ok = await _uploadAttachment(attachment);
          if (!ok) anyFailed = true;
        }
        if (anyFailed) {
          ToastService().error('آپلود برخی فایل‌ها ناموفق بود. فایل‌های قرمز را حذف کرده و دوباره تلاش کنید.');
          isUploadingAttachments.value = false;
          isSendingMessage.value = false;
          return;
        }
        isUploadingAttachments.value = false;

        // Cache each attachment by its recordId for in-bubble rendering.
        for (final a in pendingAttachments) {
          if (a.recordId != null) {
            _sentAttachmentsCache[a.recordId!] = a;
            _attachmentFileNameByRecordId[a.recordId!] = a.name;
          }
        }

        // Build the JSON-encoded string that the server expects.
        final fileEntries = <Map<String, dynamic>>[];
        for (final a in pendingAttachments) {
          final entry = <String, dynamic>{
            'recordId': a.recordId,
            'fileType': a.fileType,
            'fileName': a.name,
          };
          if (a.fileType == 'image') {
            final bytes = a.bytes;
            if (bytes != null && bytes.isNotEmpty) {
              final dims = await decodeChatImagePixelSizeFromBytes(bytes);
              if (dims != null) {
                entry['size'] = formatChatImageSizeField(
                  dims.width,
                  dims.height,
                );
              }
            }
          }
          fileEntries.add(entry);
        }
        filesJsonStr = jsonEncode(fileEntries);
      }

      // Conservative assumptions:
      // - `TopicKey` may be null for "new chat" flows; we send null if unknown.
      // - `TopicCode` comes from the selected topic; fallback to selected chat.
      final topicCode = selectedTopic.value?.code ?? selectedChat.value?.topicCode;
      final topicKey = selectedChat.value?.topicKey;
      reqId.value = uuid.v4();
      _pendingAdminSendReqIds.add(reqId.value);

      await SocketService.to.ensureConnected(clientId: currentUserId);

      final messageText = messageController.text.trim();
      final outboundBody = resolveForwardAdminSendPayload(
        userCaption: messageText,
        userFilesJson: filesJsonStr,
        forwardSource: forwardSource,
      );
      if (hasForward &&
          outboundBody.text == null &&
          outboundBody.filesJson == null) {
        ToastService().error('محتوای پیام بازنشرشده یافت نشد');
        isSendingMessage.value = false;
        return;
      }
      if (hasForward) {
        _outboundForwardSourceByReqId[reqId.value] = forwardSource;
      }

      final payload = admin_send.SocketChatAdminSendModel(
        channel: 'chat.admin.send',
        reqId: reqId.value,
        data: admin_send.Data(
          customerAccountId: customerAccountId,
          topicCode: topicCode,
          topicKey: topicKey,
          text: outboundBody.text,
          dataJson: null,
          filesJson: outboundBody.filesJson,
          replyToMessageGuid: replyToMessage.value?.messageGuid,
          forwardFromMessageGuid: forwardSource?.messageGuid,
          forwardFromSenderName: _forwardSenderName(forwardSource),
          referenceType: null,
          referenceId: null,
        ),
      );

      final localNow = DateTime.now();
      final persistedChatId = selectedChat.value?.chatId?.toString();
      final bool draftNewThread =
          persistedChatId == null && selectedTopic.value != null;
      final optimisticChatId = draftNewThread
          ? kOptimisticNewChatPlaceholderChatId
          : persistedChatId;

      if (optimisticChatId != null) {
        final localMessage = ChatMessageModel(
          rowNum: null,
          chatId: optimisticChatId,
          messageGuid: reqId.value,
          replyToMessageGuid: replyToMessage.value?.messageGuid,
          replyMessage: replyToMessage.value?.toReplyMessageSnapshot(),
          forwardFromMessageGuid: forwardSource?.messageGuid,
          forwardFromSenderName: _forwardSenderName(forwardSource),
          forwardMessage: forwardSource?.toForwardMessageSnapshot(),
          seq: null,
          senderType: 1,
          senderAccountId: int.tryParse(currentUserId),
          senderUserId: int.tryParse(currentUserId),
          messageType: 0,
          text: messageText.isEmpty ? null : messageText,
          createdOnUtc: localNow,
          isDeleted: false,
          deliveredOnUtc: null,
          seenOnUtc: null,
          seen: false,
          senderAccountName: currentUserName,
          replyToSeq: replyToMessage.value?.seq,
          forwardFromSeq: forwardSource?.seq,
          filesJson: filesJsonStr,
        );
        chatMessages.insert(0, localMessage);
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollToLatest());
        if (persistedChatId != null) {
          _applyRealtimeListUpdates(
            chatId: persistedChatId,
            messageText: localMessage.text,
            messageTime: localNow,
            incrementUnread: false,
          );
        }
      }

      SocketService.to.send(payload.toJson());

      messageController.clear();
      replyToMessage.value = null;
      pendingForwardMessage.value = null;
      pendingAttachments.clear();
      if (selectedAccount.value != null && selectedChatAccount.value == null) {
        await addNewChatAccount(selectedAccount.value!);
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال پیام: $e');
    } finally {
      isSendingMessage.value = false;
      isUploadingAttachments.value = false;
    }
  }

  // ─── Select chat account → loads CHAT LIST ─── (MODIFIED)
  void selectChatUserForExistingChat(ChatAccountModel chatAccount) {
    _clearCustomerTyping();
    // پاک‌سازی وضعیت قبلی
    chatMessages.clear();
    _clearMessageBubbleScrollKeys();
    chatList.clear();
    selectedChat.value = null;
    selectedTopic.value = null;
    chatListTopicFilter.value = null;
    replyToMessage.value = null;
    messageController.clear();

    selectedChatAccount.value = chatAccount;

    final account = findAccountById(chatAccount.accountId ?? 0);
    if (account != null) {
      selectedAccount.value = account;
    }

    // ← MODIFIED: بارگذاری لیست چت به جای پیام‌ها
    loadChatList(chatAccount.accountId.toString(), refresh: true);
    loadTopics();
    cancelForward();
  }

  // ─── Select a specific chat → loads MESSAGES ─── (NEW)
  void selectChat(ChatModel chat) {
    unawaited(openChatConversation(chat));
  }

  /// Loads messages, opens [ConversationPanel], and scrolls to [ChatModel.lastSeenSeq] when unread.
  Future<void> openChatConversation(ChatModel chat) async {
    final chatId = chat.chatId?.toString().trim();
    if (chatId == null || chatId.isEmpty) return;

    _prepareConversationState(chat);
    await loadChatMessages(chatId, refresh: true);
    selectedChat.value = chat;
    _scheduleInitialConversationScroll(chat);
  }

  // ─── بازگشت از پیام‌ها به لیست چت‌ها ─── (NEW)
  void goBackToChatList() {
    _clearCustomerTyping();
    _clearMessageSearchState();
    selectedChat.value = null;
    selectedTopic.value = null;
    replyToMessage.value = null;
    pendingForwardMessage.value = null;
    chatMessages.clear();
    _clearMessageBubbleScrollKeys();
    messageController.clear();
    pendingNewMessages.value = 0;
    conversationUnreadCount.value = 0;
    isNearBottom.value = true;
    _adminMarkedSeenSeq = 0;
    _conversationUnreadAnchorSeq = 0;
    _seenScrollDebounce?.cancel();
    _pendingConversationAnchorSeq = null;
    _initialScrollAppliedChatId = null;
    _initialScrollRetryCount = 0;
    messagePage = 1;
    hasMoreMessages.value = true;
    final accountId = selectedChatAccount.value?.accountId?.toString();
    if (accountId != null &&
        accountId.isNotEmpty &&
        chatList.isEmpty) {
      Future.microtask(() => _reconcileEmptyChatListAfterBack(accountId));
    }
  }

  /// After pick, [chatList] can be empty on the Unpicked tab while [selectedChatAccount]
  /// stays set — back would show a misleading empty state. Reload; if still empty, exit drill-down.
  Future<void> _reconcileEmptyChatListAfterBack(String accountId) async {
    try {
      await loadChatList(accountId, refresh: true);
    } catch (_) {}
    if (chatList.isNotEmpty) return;

    selectedChatAccount.value = null;
    selectedAccount.value = null;
    chatList.clear();
    try {
      await loadChatAccountList(refresh: true);
    } catch (_) {}
  }

  // ─── Select account for new chat ───
  void selectAccount(AccountModel account) {
    _clearCustomerTyping();
    chatMessages.clear();
    _clearMessageBubbleScrollKeys();
    chatList.clear();
    selectedChatAccount.value = null;
    selectedChat.value = null;    // ← NEW
    selectedAccount.value = account;
    loadTopics();
  }

  // ─── Select topic ─── (MODIFIED)
  void selectTopic(TopicModel topic) {
    _clearCustomerTyping();
    if (selectedChatAccount.value != null && selectedChat.value == null) {
      final existing = _findOpenChatMatchingTopicInList(topic);
      if (existing != null) {
        selectChat(existing);
        selectedTopic.value = topic;
        return;
      }
    }
    selectedTopic.value = topic;
    // فقط اگر چت انتخاب شده باشد پیام‌ها را بارگذاری کن
    if (selectedChat.value != null) {
      loadChatMessages(selectedChat.value!.chatId.toString(), refresh: true);
    }
  }

  /// Active thread: not closed (1), not unpicked (3), not viewer-only (adminRole 2).
  ChatModel? _findOpenChatMatchingTopicInList(TopicModel topic) {
    final code = topic.code?.trim();
    final title = topic.title?.trim();
    return chatList.firstWhereOrNull((c) {
      if (c.status == 1 || c.status == 3 || c.adminRole == 2) {
        return false;
      }
      if (code != null && code.isNotEmpty) {
        return c.topicCode?.trim() == code;
      }
      if (title != null && title.isNotEmpty) {
        return c.topicTitle?.trim() == title;
      }
      return false;
    });
  }

  // ─── Filter accounts ───
  void filterAccounts(String query) {
    if (query.isEmpty) {
      filteredAccountList.assignAll(accountList);
    } else {
      final filtered = accountList
          .where((account) =>
      account.name?.toLowerCase().contains(query.toLowerCase()) ??
          false)
          .toList();
      filteredAccountList.assignAll(filtered);
    }
  }

  // ─── Filter accounts ───
  void filterChatAccounts(String query) {
    final q = query.trim();
    if (q.isEmpty) {
      filteredChatAccountList.assignAll(chatAccountList);
    } else {
      final filtered = chatAccountList
          .where((chatAccount) =>
      chatAccount.accountName?.toLowerCase().contains(q.toLowerCase()) ??
          false)
          .toList();
      filteredChatAccountList.assignAll(filtered);
    }
  }

  // ─── Clear selections ─── (MODIFIED)
  void clearSelections({bool clearPendingForward = true}) {
    _clearCustomerTyping();
    _clearMessageSearchState();
    selectedChatAccount.value = null;
    selectedAccount.value = null;
    selectedChat.value = null;     // ← NEW
    selectedTopic.value = null;
    chatListTopicFilter.value = null;
    replyToMessage.value = null;
    if (clearPendingForward) {
      pendingForwardMessage.value = null;
    }
    chatMessages.clear();
    _clearMessageBubbleScrollKeys();
    chatList.clear();              // ← NEW
    messageController.clear();
    clearAttachments();
    _chatAttachmentBytesCache.clear();
    _attachmentRecordIdAliases.clear();
    _pendingAdminSendReqIds.clear();
    _outboundForwardSourceByReqId.clear();
    pendingNewMessages.value = 0;
    conversationUnreadCount.value = 0;
    _adminMarkedSeenSeq = 0;
    _conversationUnreadAnchorSeq = 0;
    _seenScrollDebounce?.cancel();
    _pendingConversationAnchorSeq = null;
    _initialScrollAppliedChatId = null;
    _initialScrollRetryCount = 0;
  }

  bool isAccountInChatList(int accountId) {
    return chatAccountList.any((ca) => ca.accountId == accountId);
  }

  AccountModel? findAccountById(int accountId) {
    try {
      return accountList.firstWhere((account) => account.id == accountId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addNewChatAccount(AccountModel account) async {
    try {
      if (!isAccountInChatList(account.id ?? 0)) {
        final newChatAccount = ChatAccountModel(
          accountId: account.id,
          accountName: account.name,
          adminChatRole: 1,
          lastChatId: null,
          lastMessageOn: null,
          lastMessagePreview: null,
          rowNum: null,
          totalMessageCount: null,
          unreadMessageCount: null,
          chatStatus: null,
          unreadChatCount: null,
        );
        chatAccountList.insert(0, newChatAccount);
        selectedChatAccount.value = newChatAccount;
      }
    } catch (e) {
      print('Error adding new chat user: $e');
    }
  }

  // ─── Reset ─── (MODIFIED)
  void resetChatState() {
    clearSelections(); // also calls clearAttachments()
    selectedChatTab.value = ChatAccountListTabs.unpicked;
    isLoadingChatAccounts.value = false;
    isLoadingChats.value = false;   // ← NEW
    isLoadingMessages.value = false;
    isLoadingAccounts.value = false;
    isLoadingTopics.value = false;
    isSendingMessage.value = false;
  }
  /// Parent row in [chatMessages] for tap-to-scroll, resolved from [ChatMessageModel.replyMessage].
  ChatMessageModel? findReplyTargetMessage(ChatMessageModel reply) =>
      findReplyParentInList(chatMessages, reply);

  /// Scrolls the reversed message list to the parent of [reply] and highlights it.
  Future<void> scrollToReplyParent(ChatMessageModel reply) async {

    final embedded = reply.replyMessage;
    if (embedded == null) return;

    final chatId = selectedChat.value?.chatId?.toString().trim();
    if (chatId == null || chatId.isEmpty) return;

    final parentSeq = embedded.seq;
    if (parentSeq != null) {
      await _ensureAnchorMessageLoaded(chatId, parentSeq);
    } else {
      for (var i = 0; i < 8 && hasMoreMessages.value; i++) {
        if (findReplyTargetMessage(reply) != null) break;
        final before = chatMessages.length;
        await loadChatMessages(chatId);
        if (chatMessages.length <= before) break;
      }
    }
    final target = findReplyTargetMessage(reply);
    if (target == null) {
      ToastService().info('پیام اصلی یافت نشد');
      return;
    }

    if (!messagesScrollController.hasClients) return;

    _suppressMessagePagination = true;
    try {
      await _bringMessageIntoView(target);
      _highlightReplyParent(target);
    } finally {
      _suppressMessagePagination = false;
    }
  }

  void setReplyMessage(ChatMessageModel message) {
    pendingForwardMessage.value = null;
    replyToMessage.value = message;
  }

  void cancelReply() {
    replyToMessage.value = null;
  }

  void beginForwardMessage(ChatMessageModel message) {
    if (message.isDeleted == true) return;
    replyToMessage.value = null;
    pendingForwardMessage.value = message;
  }

  void cancelForward() {
    pendingForwardMessage.value = null;
  }

  String? _forwardSenderName(ChatMessageModel? message) {
    if (message == null) return null;
    final name = message.senderAccountName?.trim();
    if (name != null && name.isNotEmpty) return name;
    if (message.senderType == 1) return currentUserName;
    return 'کاربر';
  }

  String getCurrentConversationId() {
    final currentUser = currentUserId;
    final otherUser = selectedAccount.value?.id?.toString() ??
        selectedChatAccount.value?.accountId?.toString() ??
        'unknown';
    return "$currentUser-$otherUser";
  }

  // ─── Pagination: chat accounts ─── (RENAMED)
  Future<void> loadMoreChatAccounts() async {
    if (hasMoreChatAccounts.value && !isLoadingMoreChatAccounts.value) {
      await loadChatAccountList(chatStatus: _chatAccountStatusFilter);
    }
  }

  // ─── Pagination: chat items ─── (NEW)
  Future<void> loadMoreChatItems() async {
    if (hasMoreChats.value &&
        !isLoadingMoreChats.value &&
        selectedChatAccount.value != null) {
      await loadChatList(selectedChatAccount.value!.accountId.toString());
    }
  }

  // ─── Pagination: messages ─── (MODIFIED - بدون پارامتر)
  Future<void> loadMoreMessages() async {
    if (_suppressMessagePagination) return;
    if (hasMoreMessages.value &&
        !isLoadingMoreMessages.value &&
        selectedChat.value != null) {
      await loadChatMessages(selectedChat.value!.chatId.toString());
    }
  }

  Future<bool> ensureTopicSelected() async {
    if (selectedTopic.value != null) return true;

    if (selectedAccount.value != null) {
      await loadTopics();
      if (topicList.isNotEmpty && selectedTopic.value == null) {
        Get.snackbar(
          'انتخاب موضوع',
          'لطفا موضوع گفتگو را انتخاب کنید.',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.orange.withAlpha(200),
        );
        return false;
      }
    }
    return selectedTopic.value != null;
  }
}

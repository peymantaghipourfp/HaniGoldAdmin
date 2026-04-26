import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/chat.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_account.model.dart';

import '../model/chat_message.model.dart';
import '../model/topic.model.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository = ChatRepository();
  final AccountRepository accountRepository = AccountRepository();
  final box = GetStorage();

  // Observable variables
  RxList<ChatAccountModel> chatAccountList = <ChatAccountModel>[].obs;
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxList<ChatMessageModel> chatMessages = <ChatMessageModel>[].obs;
  RxList<AccountModel> accountList = <AccountModel>[].obs;
  RxList<TopicModel> topicList = <TopicModel>[].obs;
  RxList<AccountModel> filteredAccountList = <AccountModel>[].obs;
  RxList<ChatAccountModel> filteredChatAccountList = <ChatAccountModel>[].obs;

  // Selected items
  Rxn<ChatAccountModel> selectedChatAccount = Rxn<ChatAccountModel>();
  Rxn<ChatModel> selectedChat = Rxn<ChatModel>();          // ← NEW
  Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  Rxn<TopicModel> selectedTopic = Rxn<TopicModel>();
  Rxn<ChatMessageModel> replyToMessage = Rxn<ChatMessageModel>();

  // Controllers
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController chatAccountsSearchController = TextEditingController();

  // State variables
  RxBool isLoadingChatAccounts = false.obs;
  RxBool isLoadingChats = false.obs;
  RxBool isLoadingMessages = false.obs;
  RxBool isLoadingAccounts = false.obs;
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

  RxInt selectedChatTab = 0.obs;

  List<ChatAccountModel> get filteredChatAccountsByStatus {
    final source = filteredChatAccountList.isEmpty && chatAccountsSearchController.text.isEmpty
        ? chatAccountList
        : filteredChatAccountList;
    return source
        .where((a) => a.chatStatus == selectedChatTab.value)
        .toList();
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
            final text = messageController.text;
            if (text.endsWith('\n')) {
              messageController.text = text.substring(0, text.length - 1);
            }
            sendMessage();
          });
        }
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );

  @override
  void onInit() {
    loadAccountList();
    loadChatAccountList(refresh: true);
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    chatAccountsSearchController.dispose();
    messageFocusNode.dispose();
    super.onClose();
  }

  // ─── Load chat account list ───
  Future<void> loadChatAccountList({bool refresh = false}) async {
    try {
      if (refresh) {
        chatAccountPage = 1;
        hasMoreChatAccounts.value = true;
        chatAccountList.clear();
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

      final chats = await chatRepository.getChatList(
        accountId,
        startIndex: startIndex,
        toIndex: toIndex,
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

  // ─── Load chat messages ───
  Future<void> loadChatMessages(String chatId, {bool refresh = false}) async {
    try {
      if (refresh) {
        messagePage = 1;
        hasMoreMessages.value = true;
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
      );

      if (refresh) {
        chatMessages.assignAll(messages);
      } else {
        chatMessages.addAll(messages);
      }

      hasMoreMessages.value = messages.length == pageSize;
      if (hasMoreMessages.value) messagePage++;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری پیام‌ها: $e');
    } finally {
      isLoadingMessages.value = false;
      isLoadingMoreMessages.value = false;
    }
  }

  // ─── Send message ─── (MODIFIED)
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

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

      final recipientId = selectedAccount.value?.id ??
          selectedChatAccount.value?.accountId ?? 0;
      final recipientName = selectedAccount.value?.name ??
          selectedChatAccount.value?.accountName ?? '';

      final sendData = {
        "fromUser": {
          "contact": {
            "account": {
              "accountGroup": {"infos": []},
              "accountSubGroup": {"infos": []},
              "infos": []
            },
            "infos": []
          },
          "name": currentUserName,
          "id": int.parse(currentUserId),
          "infos": []
        },
        "toUser": {
          "contact": {
            "account": {
              "accountGroup": {"infos": []},
              "accountSubGroup": {"infos": []},
              "infos": []
            },
            "infos": []
          },
          "name": recipientName,
          "id": recipientId,
          "infos": []
        },
        "date": DateTime.now().toIso8601String(),
        "topic": selectedTopic.value?.topicId,
        "messageContent": messageController.text.trim(),
        "type": 0,
        "seen": false,
        "delivered": true,
        "rowNum": 1,
        "id": DateTime.now().millisecondsSinceEpoch,
        "infos": []
      };

      final success = await chatRepository.sendMessage(sendData);
      if (success) {
        messageController.clear();
        replyToMessage.value = null;

        // ← MODIFIED: اکانت جدید به لیست اضافه شود
        if (selectedAccount.value != null && selectedChatAccount.value == null) {
          await addNewChatAccount(selectedAccount.value!);
        }

        // ← MODIFIED: ریلود پیام‌ها با chatId واقعی
        if (selectedChat.value != null) {
          await loadChatMessages(
            selectedChat.value!.chatId.toString(),
            refresh: true,
          );
        }

        // ← MODIFIED: ریلود لیست چت‌ها
        if (selectedChatAccount.value != null) {
          await loadChatList(
            selectedChatAccount.value!.accountId.toString(),
            refresh: true,
          );
        }

        await loadChatAccountList(refresh: true);
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال پیام: $e');
    } finally {
      isSendingMessage.value = false;
    }
  }

  // ─── Select chat account → loads CHAT LIST ─── (MODIFIED)
  void selectChatUserForExistingChat(ChatAccountModel chatAccount) {
    // پاک‌سازی وضعیت قبلی
    chatMessages.clear();
    chatList.clear();
    selectedChat.value = null;
    selectedTopic.value = null;
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
  }

  // ─── Select a specific chat → loads MESSAGES ─── (NEW)
  void selectChat(ChatModel chat) {
    selectedChat.value = chat;
    chatMessages.clear();
    replyToMessage.value = null;
    messageController.clear();

    // تنظیم خودکار موضوع بر اساس چت انتخاب‌شده
    if (chat.topicTitle != null) {
      final matchingTopic = topicList.firstWhereOrNull(
            (t) => t.title == chat.topicTitle,
      );
      if (matchingTopic != null) {
        selectedTopic.value = matchingTopic;
      }
    }

    // ← بارگذاری پیام‌ها با chatId واقعی
    loadChatMessages(chat.chatId.toString(), refresh: true);
  }

  // ─── بازگشت از پیام‌ها به لیست چت‌ها ─── (NEW)
  void goBackToChatList() {
    selectedChat.value = null;
    selectedTopic.value = null;
    replyToMessage.value = null;
    chatMessages.clear();
    messageController.clear();
    messagePage = 1;
    hasMoreMessages.value = true;
  }

  // ─── Select account for new chat ───
  void selectAccount(AccountModel account) {
    chatMessages.clear();
    chatList.clear();
    selectedChatAccount.value = null;
    selectedChat.value = null;    // ← NEW
    selectedAccount.value = account;
    loadTopics();
  }

  // ─── Select topic ─── (MODIFIED)
  void selectTopic(TopicModel topic) {
    selectedTopic.value = topic;
    // فقط اگر چت انتخاب شده باشد پیام‌ها را بارگذاری کن
    if (selectedChat.value != null) {
      loadChatMessages(selectedChat.value!.chatId.toString(), refresh: true);
    }
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
    if (query.isEmpty) {
      filteredChatAccountList.assignAll(chatAccountList);
    } else {
      final filtered = chatAccountList
          .where((chatAccount) =>
      chatAccount.accountName?.toLowerCase().contains(query.toLowerCase()) ??
          false)
          .toList();
      filteredChatAccountList.assignAll(filtered);
    }
  }

  // ─── Clear selections ─── (MODIFIED)
  void clearSelections() {
    selectedChatAccount.value = null;
    selectedAccount.value = null;
    selectedChat.value = null;     // ← NEW
    selectedTopic.value = null;
    replyToMessage.value = null;
    chatMessages.clear();
    chatList.clear();              // ← NEW
    messageController.clear();
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
    clearSelections();
    selectedChatTab.value = 0;
    isLoadingChatAccounts.value = false;
    isLoadingChats.value = false;   // ← NEW
    isLoadingMessages.value = false;
    isLoadingAccounts.value = false;
    isLoadingTopics.value = false;
    isSendingMessage.value = false;
  }

  void setReplyMessage(ChatMessageModel message) {
    replyToMessage.value = message;
  }

  void cancelReply() {
    replyToMessage.value = null;
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
      await loadChatAccountList();
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
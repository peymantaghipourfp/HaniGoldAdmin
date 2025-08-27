import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/config/repository/chat.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/home/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/home/model/chat_user.model.dart';
import 'package:hanigold_admin/src/domain/home/model/topic.model.dart';
import 'package:hanigold_admin/src/domain/home/model/user.model.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository = ChatRepository();
  final AccountRepository accountRepository = AccountRepository();
  final box = GetStorage();

  // Observable variables
  RxList<ChatUserModel> chatUserList = <ChatUserModel>[].obs;
  RxList<ChatMessageModel> chatMessages = <ChatMessageModel>[].obs;
  RxList<AccountModel> accountList = <AccountModel>[].obs;
  RxList<TopicModel> topicList = <TopicModel>[].obs;
  RxList<AccountModel> filteredAccountList = <AccountModel>[].obs;

  // Selected items
  Rxn<ChatUserModel> selectedChatUser = Rxn<ChatUserModel>();
  Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  Rxn<TopicModel> selectedTopic = Rxn<TopicModel>();
  Rxn<ChatMessageModel> replyToMessage = Rxn<ChatMessageModel>();

  // Controllers
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  // State variables
  RxBool isLoadingChats = false.obs;
  RxBool isLoadingMessages = false.obs;
  RxBool isLoadingAccounts = false.obs;
  RxBool isLoadingTopics = false.obs;
  RxBool isSendingMessage = false.obs;
  // Pagination variables
  RxBool isLoadingMoreChats = false.obs;
  RxBool isLoadingMoreMessages = false.obs;
  RxBool hasMoreChats = true.obs;
  RxBool hasMoreMessages = true.obs;
  int chatPage = 1;
  int messagePage = 1;
  final int pageSize = 10;

  // Current user ID
  String get currentUserId => box.read('id').toString() ?? '1001';
  String get currentUserName => box.read('userName') ?? 'کاربر';

  @override
  void onInit() {
    super.onInit();
    loadChatUserList(refresh: true);
    loadAccountList();
  }

  @override
  void onClose() {
    //messageController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Load chat user list
  Future<void> loadChatUserList({bool refresh = false}) async {
    try {
      if (refresh) {
        chatPage = 1;
        hasMoreChats.value = true;
        chatUserList.clear();
      }
      if (!hasMoreChats.value || isLoadingMoreChats.value) return;
      if (refresh) {
      isLoadingChats.value = true;
      } else {
        isLoadingMoreChats.value = true;
      }
      print("currentUserId:::${currentUserId}");
      print("Loading chat page: $chatPage");

      final startIndex = (chatPage - 1) * pageSize + 1;
      final toIndex = chatPage * pageSize;

      final chats = await chatRepository.getUserChatList(
        currentUserId,
        startIndex: startIndex,
        toIndex: toIndex,
      );

      if (refresh) {
        chatUserList.assignAll(chats);
      } else {
        chatUserList.addAll(chats);
      }

      // Check if we have more data
      hasMoreChats.value = chats.length == pageSize;
      if (hasMoreChats.value) {
        chatPage++;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری لیست چت‌ها: $e');
      print('خطا در بارگذاری لیست چت‌ها: $e');
    } finally {
      isLoadingChats.value = false;
      isLoadingMoreChats.value = false;
    }
  }

  // Load account list for user selection
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

  // Load topics for selected user
  Future<void> loadTopics(String userId) async {
    try {
      isLoadingTopics.value = true;
      final topics = await chatRepository.getTopics(userId);
      topicList.assignAll(topics);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری موضوعات: $e');
    } finally {
      isLoadingTopics.value = false;
    }
  }

  // Load chat messages between current user and selected user
  Future<void> loadChatMessages(String otherUserId, {bool refresh = false}) async {
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
      print("Loading messages between user $currentUserId and user $otherUserId");

      print("Loading message page: $messagePage");

      final startIndex = (messagePage - 1) * pageSize + 1;
      final toIndex = messagePage * pageSize;

      final messages = await chatRepository.getChatMessages(
        currentUserId,
        otherUserId,
        startIndex: startIndex,
        toIndex: toIndex,
      );
      print("Loaded ${messages.length} messages");
      if (refresh) {
        chatMessages.assignAll(messages);
      } else {
        chatMessages.addAll(messages);
      }

      // Check if we have more data
      hasMoreMessages.value = messages.length == pageSize;
      if (hasMoreMessages.value) {
        messagePage++;
      }

      // Mark messages as seen when entering the chat (only on refresh)
      if (refresh) {
        await markMessagesAsSeen(messages);
      }
      // If this is an existing chat and we have messages, get the topic from the latest message
      if (refresh && messages.isNotEmpty && selectedTopic.value == null) {
        final latestMessage = messages.first; // Messages are ordered by ID desc, so first is latest
        if (latestMessage.topic != null && latestMessage.topic!.isNotEmpty) {
          // Find the topic object that matches the topic string
          TopicModel? topicObj;
          try {
            topicObj = topicList.firstWhere((t) => t.topic == latestMessage.topic);
          } catch (e) {
            topicObj = null;
          }

          if (topicObj != null) {
            selectedTopic.value = topicObj;
            print("Auto-selected topic from existing chat: ${topicObj.topic}");
          } else {
            // Create a temporary topic object if not found in list
            selectedTopic.value = TopicModel(
                user: null,
                topic: latestMessage.topic,
                code: '',
                id: 0,
                infos: []
            );
            print("Created temporary topic: ${latestMessage.topic}");
          }
        } else {
          // No topic in latest message, show topic selection dialog
          print("No topic found in existing messages, user may need to select topic");
        }
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری پیام‌ها: $e');
      print("Error loading messages: $e");
    } finally {
      isLoadingMessages.value = false;
      isLoadingMoreMessages.value = false;
    }
  }

  // Mark messages as seen when entering a chat
  Future<void> markMessagesAsSeen(List<ChatMessageModel> messages) async {
    try {
      // Find messages sent to current user that are not seen
      final unseenMessages = messages.where((message) =>
      message.toUser?.id.toString() == currentUserId &&
          message.seen == false
      ).toList();

      // Mark each unseen message as seen
      for (final message in unseenMessages) {
        if (message.id != null) {
          await chatRepository.updateSeen(message.id.toString());
          print("Marked message ${message.id} as seen");
        }
      }

      // Update the seen status in the local messages list
      for (int i = 0; i < chatMessages.length; i++) {
        if (chatMessages[i].toUser?.id.toString() == currentUserId &&
            chatMessages[i].seen == false) {
          // Create a new message object with seen = true
          final updatedMessage = ChatMessageModel(
            replyMessage: chatMessages[i].replyMessage,
            fromUser: chatMessages[i].fromUser,
            toUser: chatMessages[i].toUser,
            date: chatMessages[i].date,
            topic: chatMessages[i].topic,
            messageContent: chatMessages[i].messageContent,
            type: chatMessages[i].type,
            seen: true, // Mark as seen
            delivered: chatMessages[i].delivered,
            rowNum: chatMessages[i].rowNum,
            id: chatMessages[i].id,
            replyId: chatMessages[i].replyId,
            infos: chatMessages[i].infos,
            recordType: chatMessages[i].recordType,
          );
          chatMessages[i] = updatedMessage;
        }
      }

      // Refresh chat list to update unseen counts
      await loadChatUserList(refresh: true);
    } catch (e) {
      print("Error marking messages as seen: $e");
    }
  }

  // Update a single message's seen status
  void updateMessageSeenStatus(int messageId, bool seen) {
    final messageIndex = chatMessages.indexWhere((message) => message.id == messageId);
    if (messageIndex != -1) {
      final message = chatMessages[messageIndex];
      final updatedMessage = ChatMessageModel(
        replyMessage: message.replyMessage,
        fromUser: message.fromUser,
        toUser: message.toUser,
        date: message.date,
        topic: message.topic,
        messageContent: message.messageContent,
        type: message.type,
        seen: seen,
        delivered: message.delivered,
        rowNum: message.rowNum,
        id: message.id,
        replyId: message.replyId,
        infos: message.infos,
        recordType: message.recordType,
      );
      chatMessages[messageIndex] = updatedMessage;
    }
  }


  // Send message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    // For existing chats, we need either selectedAccount or selectedChatUser
    if (selectedAccount.value == null && selectedChatUser.value == null) {
      Get.snackbar('خطا', 'کاربر انتخاب نشده است');
      return;
    }
    // Ensure topic is selected
    if (selectedTopic.value == null) {
      Get.snackbar('خطا', 'لطفا ابتدا موضوع گفتگو را انتخاب کنید');

      // If this is an existing chat, offer to show topic selection
      if (selectedChatUser.value != null && selectedAccount.value != null) {
        Get.snackbar(
            'راهنمایی',
            'برای ادامه گفتگو، لطفا موضوع جدید انتخاب کنید',
            duration: Duration(seconds: 4)
        );
      }
      return;
    }

    try {
      isSendingMessage.value = true;

      // Determine the recipient
      final recipientId = selectedAccount.value?.id ?? selectedChatUser.value?.chatUserId ?? 0;
      final recipientName = selectedAccount.value?.name ?? selectedChatUser.value?.chatUserName ?? '';

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
        "topic": selectedTopic.value?.topic,
        "messageContent": messageController.text.trim(),
        "type": 0,
        "seen": false,
        "delivered": true,
        "rowNum": 1,
        "id": DateTime.now().millisecondsSinceEpoch,
        "replyId": replyToMessage.value?.id,
        "replyMessage": replyToMessage.value != null ? {
          "fromUser": replyToMessage.value!.fromUser?.toJson(),
          "toUser": replyToMessage.value!.toUser?.toJson(),
          "messageContent": replyToMessage.value!.messageContent,
          "id": replyToMessage.value!.id,
          "infos": replyToMessage.value!.infos,
        } : null,
        "infos": []
      };

      final success = await chatRepository.sendMessage(sendData);
      if (success) {
        messageController.clear();
        // Clear reply after sending
        replyToMessage.value = null;
        // add it to the chat user list
        if (selectedAccount.value != null && selectedChatUser.value == null) {
          await addNewChatUser(selectedAccount.value!);
        }
        // Reload messages to show the new message
        await loadChatMessages(recipientId.toString(), refresh: true);
        // Reload chat list to update last message
        await loadChatUserList(refresh: true);
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ارسال پیام: $e');
    } finally {
      isSendingMessage.value = false;
    }
  }

  // Select chat user
  void selectChatUser(ChatUserModel chatUser) {
    selectedChatUser.value = chatUser;
    loadChatMessages(chatUser.chatUserId.toString(), refresh: true);
  }

  // Select account for new chat
  void selectAccount(AccountModel account) {
    print("Selecting account for new chat: ${account.name} (ID: ${account.id})");
    // Clear previous selections and messages
    chatMessages.clear();
    selectedChatUser.value = null;
    selectedAccount.value = account;
    loadTopics(currentUserId.toString());
  }

  // Select topic
  void selectTopic(TopicModel topic) {
    selectedTopic.value = topic;
    // If we have a selected account, load messages with them
    if (selectedAccount.value != null) {
      print("Loading messages for new chat with topic: ${topic.topic}");
      loadChatMessages(selectedAccount.value!.id.toString(), refresh: true);
    }
  }

  // Filter accounts based on search
  void filterAccounts(String query) {
    if (query.isEmpty) {
      filteredAccountList.assignAll(accountList);
    } else {
      final filtered = accountList.where((account) =>
      account.name?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
      filteredAccountList.assignAll(filtered);
    }
  }

  // Clear selections
  void clearSelections() {
    selectedChatUser.value = null;
    selectedAccount.value = null;
    selectedTopic.value = null;
    replyToMessage.value = null;
    chatMessages.clear();
    messageController.clear();
  }

  // Check if user exists in chat list
  bool isUserInChatList(int userId) {
    return chatUserList.any((chat) => chat.chatUserId == userId);
  }

  // Find account by ID
  AccountModel? findAccountById(int accountId) {
    try {
      return accountList.firstWhere((account) => account.id == accountId);
    } catch (e) {
      return null;
    }
  }

  // Select chat user and set account for existing chat
  void selectChatUserForExistingChat(ChatUserModel chatUser) {
    print("Selecting chat with user: ${chatUser.chatUserName} (ID: ${chatUser.chatUserId})");
    // Clear previous selections and messages
    chatMessages.clear();
    selectedTopic.value = null;
    selectedChatUser.value = chatUser;
    // Try to find the account for this chat user
    final account = findAccountById(chatUser.chatUserId ?? 0);
    if (account != null) {
      selectedAccount.value = account;
      // Load topics for this user so we can match topics from messages
      loadTopics(currentUserId.toString());
    }
    loadChatMessages(chatUser.chatUserId.toString(), refresh: true);
  }

  // Add new chat user to the list after sending first message
  Future<void> addNewChatUser(AccountModel account) async {
    try {
      // Check if user is already in chat list
      if (!isUserInChatList(account.id ?? 0)) {
        final newChatUser = ChatUserModel(
          chatUserId: account.id,
          chatUserName: account.name,
          lastMessageDate: DateTime.now(),
          unseenCount: 0,
        );

        // Add to the beginning of the list
        chatUserList.insert(0, newChatUser);

        // Set this as the selected chat user
        selectedChatUser.value = newChatUser;
      }
    } catch (e) {
      print('Error adding new chat user: $e');
    }
  }

  // Clear selections and reset state
  void resetChatState() {
    print("Resetting chat state");
    clearSelections();
    chatMessages.clear();
    isLoadingChats.value = false;
    isLoadingMessages.value = false;
    isLoadingAccounts.value = false;
    isLoadingTopics.value = false;
    isSendingMessage.value = false;
  }

  // Set reply message
  void setReplyMessage(ChatMessageModel message) {
    replyToMessage.value = message;
  }

  // Cancel reply
  void cancelReply() {
    replyToMessage.value = null;
  }
  // Get current conversation identifier for debugging
  String getCurrentConversationId() {
    final currentUser = currentUserId;
    final otherUser = selectedAccount.value?.id?.toString() ??
        selectedChatUser.value?.chatUserId?.toString() ??
        'unknown';
    return "$currentUser-$otherUser";
  }
  // Load more chat users when scrolling
  Future<void> loadMoreChats() async {
    if (hasMoreChats.value && !isLoadingMoreChats.value) {
      await loadChatUserList();
    }
  }

  // Load more messages when scrolling
  Future<void> loadMoreMessages(String otherUserId) async {
    if (hasMoreMessages.value && !isLoadingMoreMessages.value) {
      await loadChatMessages(otherUserId);
    }
  }
  // Check if topic is required and prompt user if missing
  Future<bool> ensureTopicSelected() async {
    if (selectedTopic.value != null) {
      return true;
    }

    // If we have an account selected, load topics
    if (selectedAccount.value != null) {
      await loadTopics(currentUserId.toString());

      // If topics are loaded but none selected, show error
      if (topicList.isNotEmpty && selectedTopic.value == null) {
        Get.snackbar(
            'انتخاب موضوع',
            'لطفا موضوع گفتگو را انتخاب کنید.\nبرای انتخاب موضوع، از منوی "+" استفاده کنید.',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.orange.withOpacity(0.8)
        );
        return false;
      }
    }

    return selectedTopic.value != null;
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/home/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/home/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/home/model/chat_user.model.dart';
import 'package:hanigold_admin/src/domain/home/model/topic.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ChatDialog extends StatelessWidget {
  const ChatDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController(), permanent: false);

    return Dialog(
      backgroundColor: AppColor.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: Get.width * 0.8,
        height: Get.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Text(
                  'گفتگوها',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    controller.loadChatUserList(refresh: true);
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: AppColor.primaryColor,
                  ),
                  tooltip: 'تازه‌سازی لیست',
                ),
                IconButton(
                  onPressed: () => _showAddUserDialog(context, controller),
                  icon: Icon(
                    Icons.add,
                    color: AppColor.primaryColor,
                  ),
                  tooltip: 'افزودن کاربر جدید',
                ),
                IconButton(
                  onPressed: () {
                    controller.resetChatState();
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Chat List
            Expanded(
              child: Obx(() {
                if (controller.isLoadingChats.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.chatUserList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: AppColor.textColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'هیچ گفتگویی یافت نشد',
                          style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _showAddUserDialog(context, controller),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'شروع گفتگوی جدید',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.chatUserList.length + (controller.hasMoreChats.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end when loading more
                    if (index == controller.chatUserList.length) {
                      if (controller.isLoadingMoreChats.value) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (controller.hasMoreChats.value) {
                        // Trigger loading more when reaching the end
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.loadMoreChats();
                        });
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    final chatUser = controller.chatUserList[index];
                    return _buildChatItem(context, controller, chatUser);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, ChatController controller, ChatUserModel chatUser) {
    return Obx((){
    final isSelected = controller.selectedChatUser.value?.chatUserId == chatUser.chatUserId;
    return Container(
      margin: const EdgeInsets.only(bottom: 8,left: 10,right: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColor.primaryColor : AppColor.textColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        onTap: () {
          controller.selectChatUserForExistingChat(chatUser);
          _showExistingChatPage(context, controller, chatUser);
        },
        leading: CircleAvatar(
          backgroundColor: AppColor.primaryColor,
          child: Text(
            chatUser.chatUserName?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          chatUser.chatUserName ?? 'کاربر ناشناس',
          style: AppTextStyle.bodyText.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatUser.lastMessageDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '',
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 12,
                color: AppColor.textColor.withOpacity(0.7),
              ),
            ),
            // Show current topic for this chat if selected and topic exists
            if (isSelected && controller.selectedTopic.value?.topic != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.topic,
                      size: 12,
                      color: AppColor.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        controller.selectedTopic.value!.topic!,
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 10,
                          color: AppColor.primaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: chatUser.unseenCount != null && chatUser.unseenCount! > 0
            ? Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            chatUser.unseenCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : null,
      ),
    );
    });
    /*return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColor.primaryColor : AppColor.textColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        onTap: () {
          controller.selectChatUserForExistingChat(chatUser);
          _showExistingChatPage(context, controller, chatUser);
        },
        leading: CircleAvatar(
          backgroundColor: AppColor.primaryColor,
          child: Text(
            chatUser.chatUserName?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          chatUser.chatUserName ?? 'کاربر ناشناس',
          style: AppTextStyle.bodyText.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
        ),
        subtitle: Text(
          chatUser.lastMessageDate ?? '',
          style: AppTextStyle.bodyText.copyWith(
            fontSize: 12,
            color: AppColor.textColor.withOpacity(0.7),
          ),
        ),
        trailing: chatUser.unseenCount != null && chatUser.unseenCount! > 0
            ? Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            chatUser.unseenCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : null,
      ),
    );*/
  }

  void _showAddUserDialog(BuildContext context, ChatController controller) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.6,
          height: Get.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'انتخاب کاربر',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.searchController.clear();
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColor.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search field
              TextField(
                controller: controller.searchController,
                onChanged: controller.filterAccounts,
                style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
                decoration: InputDecoration(
                  hintText: 'جستجوی کاربر...',
                  hintStyle: TextStyle(color: AppColor.textColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.search, color: AppColor.textColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.textColor.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Account list
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingAccounts.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredAccountList.isEmpty) {
                    return Center(
                      child: Text(
                        'هیچ کاربری یافت نشد',
                        style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.textColor.withOpacity(0.7),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredAccountList.length,
                    itemBuilder: (context, index) {
                      final account = controller.filteredAccountList[index];
                      final isInChatList = controller.isUserInChatList(account.id ?? 0);

                      return GestureDetector(
                        onTap: () {
                          _selectUserForChat(context, controller, account);
                        },
                        child: ListTile(
                          onTap: isInChatList ? null : () => _selectUserForChat(context, controller, account),
                          leading: CircleAvatar(
                            backgroundColor: AppColor.primaryColor,
                            child: Text(
                              account.name?.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            account.name ?? 'کاربر ناشناس',
                            style: AppTextStyle.bodyText.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isInChatList ? AppColor.textColor.withOpacity(0.5) : AppColor.textColor,
                            ),
                          ),
                          trailing: isInChatList
                              ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.textColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'در گفتگو',
                              style: AppTextStyle.bodyText.copyWith(
                                fontSize: 10,
                                color: AppColor.textColor.withOpacity(0.7),
                              ),
                            ),
                          )
                              : Icon(
                            Icons.arrow_forward_ios,
                            color: AppColor.primaryColor,
                            size: 16,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectUserForChat(BuildContext context, ChatController controller, AccountModel account) {
    controller.selectAccount(account);
    controller.clearSelections(); // Clear previous selections
    controller.selectedAccount.value = account; //
    Get.back(); // Close user selection dialog

    // Show topic selection dialog
    _showTopicSelectionDialog(context, controller, account);
  }

  void _showTopicSelectionDialog(BuildContext context, ChatController controller, AccountModel account) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.5,
          height: Get.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'انتخاب موضوع برای ${account.name}',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColor.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Topic list
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingTopics.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.topicList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.topic_outlined,
                            size: 64,
                            color: AppColor.textColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'هیچ موضوعی یافت نشد',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.topicList.length,
                    itemBuilder: (context, index) {
                      final topic = controller.topicList[index];
                      return ListTile(
                        onTap: () {
                          controller.selectTopic(topic);
                          Get.back(); // Close topic selection dialog
                          //Get.back(); // Close main chat dialog
                          _showChatPage(context, controller, account, topic);
                        },
                        leading: Icon(
                          Icons.topic,
                          color: AppColor.primaryColor,
                        ),
                        title: Text(
                          topic.topic ?? 'موضوع ناشناس',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        subtitle: Text(
                          topic.code ?? '',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColor.primaryColor,
                          size: 16,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExistingChatPage(BuildContext context, ChatController controller, ChatUserModel chatUser) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.8,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.textColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    child: Text(
                      chatUser.chatUserName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatUser.chatUserName ?? 'کاربر ناشناس',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        Text(
                          chatUser.lastMessageDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                        // Show current topic for existing chats
                        /*Obx(() {
                          final selectedTopic = controller.selectedTopic.value;
                          if (controller.selectedChatUser.value?.chatUserId == chatUser.chatUserId &&
                              selectedTopic != null && selectedTopic.topic != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.topic,
                                    size: 12,
                                    color: AppColor.primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      selectedTopic.topic!,
                                      style: AppTextStyle.bodyText.copyWith(
                                        fontSize: 10,
                                        color: AppColor.primaryColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        }),*/
                      ],
                    ),
                  ),
                  // Topic selection button for existing chats
                    IconButton(
                      onPressed: () {
                        if (controller.selectedAccount.value != null) {
                          _showTopicSelectionDialog(context, controller, controller.selectedAccount.value!);
                        }
                      },
                      icon: Icon(
                        Icons.topic,
                        color: AppColor.primaryColor,
                      ),
                      tooltip: 'انتخاب/تغییر موضوع',
                    ),

                ],
              ),
              // Show current topic
              SizedBox(height: 10,),
              Obx(() {
                final topic = controller.selectedTopic.value;
                if (topic != null && topic.topic != null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.topic,
                          size: 16,
                          color: AppColor.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'موضوع: ${topic.topic}',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
              const SizedBox(height: 12),

              // Messages
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingMessages.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.chatMessages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: AppColor.textColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'هیچ پیامی در این گفتگو وجود ندارد',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: controller.chatMessages.length + (controller.hasMoreMessages.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the top when loading more (since list is reversed)
                      if (index == controller.chatMessages.length) {
                        if (controller.isLoadingMoreMessages.value) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (controller.hasMoreMessages.value) {
                          // Trigger loading more when reaching the top
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final otherUserId = controller.selectedChatUser.value?.chatUserId.toString() ??
                                controller.selectedAccount.value?.id.toString() ?? '';
                            if (otherUserId.isNotEmpty) {
                              controller.loadMoreMessages(otherUserId);
                            }
                          });
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      final message = controller.chatMessages[index];
                      final isFromCurrentUser = message.fromUser?.id.toString() == controller.currentUserId;

                      return _buildMessageItem(message, isFromCurrentUser);
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Reply preview
              _buildReplyPreview(controller),
              // Message input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
                      decoration: InputDecoration(
                        hintText: controller.replyToMessage.value != null
                            ? 'پاسخ خود را بنویسید...'
                            : 'پیام خود را بنویسید...',
                        hintStyle: TextStyle(color: AppColor.textColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColor.textColor.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColor.textColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => IconButton(
                    onPressed: controller.isSendingMessage.value ? null : controller.sendMessage,
                    icon: controller.isSendingMessage.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Icon(
                      Icons.send,
                      color: AppColor.primaryColor,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChatPage(BuildContext context, ChatController controller, AccountModel account, TopicModel topic) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.8,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.textColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    child: Text(
                      account.name?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name ?? 'کاربر ناشناس',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.topic,
                                size: 12,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                topic.topic ?? 'موضوع ناشناس',
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 12,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Messages
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingMessages.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.chatMessages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: AppColor.textColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'هیچ پیامی در این گفتگو وجود ندارد',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: controller.chatMessages.length + (controller.hasMoreMessages.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the top when loading more (since list is reversed)
                      if (index == controller.chatMessages.length) {
                        if (controller.isLoadingMoreMessages.value) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (controller.hasMoreMessages.value) {
                          // Trigger loading more when reaching the top
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final otherUserId = controller.selectedChatUser.value?.chatUserId.toString() ??
                                controller.selectedAccount.value?.id.toString() ?? '';
                            if (otherUserId.isNotEmpty) {
                              controller.loadMoreMessages(otherUserId);
                            }
                          });
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      final message = controller.chatMessages[index];
                      final isFromCurrentUser = message.fromUser?.id.toString() == controller.currentUserId;

                      return _buildMessageItem(message, isFromCurrentUser);
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Reply preview
              _buildReplyPreview(controller),
              // Message input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
                      decoration: InputDecoration(
                        hintText: controller.replyToMessage.value != null
                            ? 'پاسخ خود را بنویسید...'
                            : 'پیام خود را بنویسید...',
                        hintStyle: TextStyle(color: AppColor.textColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColor.textColor.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColor.textColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => IconButton(
                    onPressed: controller.isSendingMessage.value ? null : controller.sendMessage,
                    icon: controller.isSendingMessage.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Icon(
                      Icons.send,
                      color: AppColor.primaryColor,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessageModel message, bool isFromCurrentUser) {
    final ChatController controller = Get.find<ChatController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 8,left: 20,right: 10),
      child: Row(
        mainAxisAlignment: isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColor.textColor.withOpacity(0.1),
              child: Text(
                message.fromUser?.name?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: !isFromCurrentUser ? () {
                controller.setReplyMessage(message);
                //_showReplyOptions(message);
              } : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isFromCurrentUser ? Color(0xFF506E98) : AppColor.textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show reply preview if this message is a reply
                    if (message.replyMessage != null) ...[
                      Container(
                        //width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration:
                          message.replyMessage?.id != null ?
                        BoxDecoration(
                          color: isFromCurrentUser
                              ? Colors.white.withOpacity(0.1)
                              : AppColor.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isFromCurrentUser
                                ? Colors.white.withOpacity(0.3)
                                : AppColor.primaryColor.withOpacity(0.3),
                          ),
                        ): BoxDecoration(),
                        child: SizedBox(
                          width: Get.width*0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isFromCurrentUser) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.reply,
                                    size: 12,
                                    color: isFromCurrentUser
                                        ? Colors.white.withOpacity(0.8)
                                        : AppColor.primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                    Text(
                                      'پاسخ به ${message.replyMessage!.fromUser?.name ?? 'کاربر'}',
                                      style: AppTextStyle.bodyText.copyWith(
                                        fontSize: 10,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                ],
                              ),
                              ],
                              const SizedBox(height: 2),
                              Text(
                                message.replyMessage!.messageContent ?? '',
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 11,
                                  color: isFromCurrentUser
                                      ? Colors.white.withOpacity(0.9)
                                      : AppColor.textColor.withOpacity(0.9),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Text(
                      message.messageContent ?? '',
                      style: AppTextStyle.bodyText.copyWith(
                        color: isFromCurrentUser ? Colors.white : AppColor.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.date?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 10,
                            color: isFromCurrentUser ? Colors.white.withOpacity(0.8) : AppColor.textColor.withOpacity(0.6),
                          ),
                        ),
                        // Show check marks for messages sent by the other person
                        if (isFromCurrentUser) ...[
                          const SizedBox(width: 4),
                          _buildMessageStatus(message),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF506E98),
              child: Text(
                message.fromUser?.name?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildMessageStatus(ChatMessageModel message) {
    // Show check marks based on message status
    if (message.seen == true) {
      // Two check marks for seen messages
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.done_all,
            size: 14,
            color: Colors.white.withOpacity(0.8)
          ),
        ],
      );
    } else if (message.delivered == true) {
      // One check mark for delivered but not seen messages
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.done,
            size: 14,
              color: Colors.white.withOpacity(0.8)
          ),
        ],
      );
    } else {
      // No check mark for pending messages
      return const SizedBox.shrink();
    }
  }

  /*void _showReplyOptions(ChatMessageModel message) {
    final ChatController controller = Get.find<ChatController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.textColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.reply,
                color: AppColor.primaryColor,
              ),
              title: Text(
                'پاسخ',
                style: AppTextStyle.bodyText.copyWith(
                  color: AppColor.textColor,
                ),
              ),
              onTap: () {
                controller.setReplyMessage(message);
                Get.back();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }*/

  Widget _buildReplyPreview(ChatController controller) {
    return Obx(() {
      final replyMessage = controller.replyToMessage.value;
      if (replyMessage != null) {
        return Container(
          //width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.primaryColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.reply,
                    size: 16,
                    color: AppColor.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'پاسخ به ${replyMessage.fromUser?.name ?? 'کاربر'}',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: controller.cancelReply,
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColor.textColor.withOpacity(0.7),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                replyMessage.messageContent ?? '',
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 12,
                  color: AppColor.textColor.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}

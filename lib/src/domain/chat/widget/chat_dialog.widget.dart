import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_account.model.dart';
import 'package:hanigold_admin/src/domain/chat/widget/swipe_toReply.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../controller/chat.controller.dart';
import '../model/chat_message.model.dart';
import '../model/topic.model.dart';

class ChatDialog extends StatelessWidget {
  const ChatDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController(), permanent: false);
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Dialog(
      backgroundColor: AppColor.secondary50Color,
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
                  onPressed: () => controller.loadChatAccountList(refresh: true),
                  icon: Icon(Icons.refresh, color: AppColor.buttonColor),
                  tooltip: 'تازه‌سازی لیست',
                ),
                IconButton(
                  onPressed: () => _showAddUserDialog(context, controller),
                  icon: Icon(Icons.add, color: AppColor.buttonColor),
                  tooltip: 'افزودن کاربر جدید',
                ),
                IconButton(
                  onPressed: () {
                    controller.resetChatState();
                    Get.back();
                  },
                  icon: Icon(Icons.close, color: AppColor.textColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Body
            isDesktop
                ? Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── سمت راست: تب + لیست اکانت ───
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        _buildVerticalChatTabs(controller),
                        Expanded(
                          child: _buildChatListContent(context, controller),
                        ),
                      ],
                    ),
                  ),
                  // ─── سمت چپ: پنل اصلی ─── (MODIFIED)
                  Expanded(
                    flex: 2,
                    child: Obx(() {
                      // ۱) چت انتخاب شده → پیام‌ها
                      if (controller.selectedChat.value != null) {
                        return _buildConversationPanel(context, controller);
                      }
                      // ۲) اکانت انتخاب شده → لیست چت‌ها
                      if (controller.selectedChatAccount.value != null) {
                        return _buildChatListPanel(context, controller);
                      }
                      // ۳) کاربر جدید + موضوع → پیام‌ها
                      if (controller.selectedAccount.value != null &&
                          controller.selectedTopic.value != null) {
                        return _buildConversationPanel(context, controller);
                      }
                      // ۴) خالی
                      return _buildEmptySidePanel(context);
                    }),
                  ),
                ],
              ),
            )
                : Expanded(
              child: Column(
                children: [
                  _buildHorizontalChatTabs(controller),
                  Expanded(
                    child: _buildChatListContent(context, controller),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  (NEW) پنل لیست چت‌ها برای اکانت انتخاب‌شده
  // ═══════════════════════════════════════════════════════
  Widget _buildChatListPanel(BuildContext context, ChatController controller) {
    final chatAccount = controller.selectedChatAccount.value!;

    return Container(
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: AppColor.secondary100Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.textColor.withAlpha(40), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.secondary50Color,
              border: Border(
                bottom: BorderSide(color: AppColor.textColor.withAlpha(40)),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chatAccount.accountName ?? 'کاربر ناشناس',
                        style: AppTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColor.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'لیست گفتگوها',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 12,
                          color: AppColor.textColor.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.clearSelections,
                  icon: Icon(Icons.close,
                      color: AppColor.textColor.withAlpha(200), size: 22),
                  tooltip: 'بستن',
                ),
              ],
            ),
          ),

          // Chat list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingChats.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.buttonColor),
                );
              }

              if (controller.chatList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forum_outlined,
                          size: 48, color: AppColor.textColor.withAlpha(130)),
                      const SizedBox(height: 12),
                      Text(
                        'هیچ گفتگویی برای این کاربر وجود ندارد',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 13,
                          color: AppColor.textColor.withAlpha(175),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.chatList.length +
                    (controller.hasMoreChats.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.chatList.length) {
                    if (controller.isLoadingMoreChats.value) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    if (controller.hasMoreChats.value) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.loadMoreChatItems();
                      });
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  return _buildChatItem(
                      context, controller, controller.chatList[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  (NEW) آیتم تکی چت در لیست
  // ═══════════════════════════════════════════════════════
  Widget _buildChatItem(
      BuildContext context, ChatController controller, ChatModel chat) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final bool isClosed = chat.status == 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isClosed
            ? AppColor.textColor.withAlpha(20)
            : AppColor.secondary50Color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isClosed
              ? AppColor.errorColor.withAlpha(60)
              : AppColor.textColor.withAlpha(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          controller.selectChat(chat);
          if (!isDesktop) {
            // در موبایل: باز کردن دیالوگ پیام‌ها
            _showMessageDialog(context, controller);
          }
        },
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        title: Row(
          children: [
            Icon(Icons.topic, size: 16, color: AppColor.primaryColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                chat.topicTitle ?? 'بدون موضوع',
                style: AppTextStyle.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColor.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ─── بج وضعیت ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isClosed
                    ? AppColor.errorColor.withAlpha(30)
                    : Colors.green.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isClosed
                      ? AppColor.errorColor.withAlpha(100)
                      : Colors.green.withAlpha(100),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isClosed ? Icons.lock_rounded : Icons.lock_open_rounded,
                    size: 12,
                    color: isClosed ? AppColor.errorColor : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isClosed ? 'بسته' : 'باز',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isClosed ? AppColor.errorColor : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chat.lastMessagePreview != null &&
                chat.lastMessagePreview!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                chat.lastMessagePreview!,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 12,
                  color: isClosed
                      ? AppColor.textColor.withAlpha(120)
                      : AppColor.textColor.withAlpha(175),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              chat.lastMessageOn?.toPersianDate(
                  twoDigits: true,
                  showTime: true,
                  timeSeprator: '-') ??
                  '',
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                color: isClosed
                    ? AppColor.textColor.withAlpha(100)
                    : AppColor.textColor.withAlpha(130),
              ),
            ),
          ],
        ),
        trailing:isClosed
            ? null
            :Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColor.buttonColor.withAlpha(180),
            ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  (NEW) دیالوگ لیست چت‌ها (موبایل)
  // ═══════════════════════════════════════════════════════
  void _showChatListDialog(BuildContext context, ChatController controller,
      ChatAccountModel chatAccount) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.secondary100Color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, color: AppColor.textColor),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatAccount.accountName ?? 'کاربر ناشناس',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        Text(
                          'لیست گفتگوها',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.textColor.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Chat list
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingChats.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.chatList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.forum_outlined,
                              size: 48,
                              color: AppColor.textColor.withAlpha(130)),
                          const SizedBox(height: 12),
                          Text(
                            'هیچ گفتگویی وجود ندارد',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withAlpha(175),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.chatList.length +
                        (controller.hasMoreChats.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.chatList.length) {
                        if (controller.isLoadingMoreChats.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (controller.hasMoreChats.value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.loadMoreChatItems();
                          });
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      return _buildChatItem(
                          context, controller, controller.chatList[index]);
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

  // ═══════════════════════════════════════════════════════
  //  (NEW) دیالوگ پیام‌ها (موبایل) - بعد از انتخاب چت
  // ═══════════════════════════════════════════════════════
  void _showMessageDialog(BuildContext context, ChatController controller) {
    final chatAccount = controller.selectedChatAccount.value;
    final chat = controller.selectedChat.value;

    Get.dialog(
      Dialog(
        backgroundColor: AppColor.secondary100Color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.goBackToChatList();
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, color: AppColor.textColor),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatAccount?.accountName ?? 'کاربر ناشناس',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        if (chat?.topicTitle != null)
                          Row(
                            children: [
                              Icon(Icons.topic, size: 12,
                                  color: AppColor.primaryColor),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  chat!.topicTitle!,
                                  style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 11,
                                    color: AppColor.primaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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
                          Icon(Icons.chat_bubble_outline,
                              size: 64,
                              color: AppColor.textColor.withAlpha(130)),
                          const SizedBox(height: 16),
                          Text(
                            'هیچ پیامی وجود ندارد',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withAlpha(175),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: controller.chatMessages.length +
                        (controller.hasMoreMessages.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.chatMessages.length) {
                        if (controller.isLoadingMoreMessages.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child:
                            Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (controller.hasMoreMessages.value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.loadMoreMessages();
                          });
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child:
                            Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      final message = controller.chatMessages[index];
                      final isFromCurrentUser = message.senderType == 1;
                      return _buildMessageItem(message, isFromCurrentUser);
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              _buildReplyPreview(controller),
              // Input
              chat?.status==0 ?
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor),
                      decoration: InputDecoration(
                        hintText: 'پیام خود را بنویسید...',
                        hintStyle: TextStyle(
                            color: AppColor.textColor.withAlpha(175)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: AppColor.textColor.withAlpha(75)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: AppColor.textColor.withAlpha(75)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                          BorderSide(color: AppColor.buttonColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => IconButton(
                    onPressed: controller.isSendingMessage.value
                        ? null
                        : controller.sendMessage,
                    icon: controller.isSendingMessage.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2),
                    )
                        : Icon(Icons.send,
                        color: AppColor.secondary3Color),
                  )),
                ],
              ) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  آیتم اکانت چت
  // ═══════════════════════════════════════════════════════
  Widget _buildChatAccount(BuildContext context, ChatController controller,
      ChatAccountModel chatAccount) {
    return Obx(() {
      final isSelected = controller.selectedChatAccount.value?.accountId ==
          chatAccount.accountId;
      final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

      return Container(
        margin: const EdgeInsets.only(bottom: 4, left: 10, right: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.buttonColor.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColor.buttonColor
                : AppColor.textColor.withAlpha(50),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          onTap: () {
            controller.selectChatUserForExistingChat(chatAccount);
            // ← MODIFIED: موبایل → دیالوگ لیست چت‌ها
            if (!isDesktop) {
              _showChatListDialog(context, controller, chatAccount);
            }
          },
          title: Text(
            chatAccount.accountName ?? 'کاربر ناشناس',
            style: AppTextStyle.bodyText.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatAccount.lastMessageOn?.toPersianDate(
                    twoDigits: true,
                    showTime: true,
                    timeSeprator: '-') ??
                    '',
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 12,
                  color: AppColor.textColor.withAlpha(175),
                ),
              ),
            ],
          ),
          trailing: chatAccount.unreadChatCount != null &&
              chatAccount.unreadChatCount! > 0
              ? Container(
            width:
            (chatAccount.unreadChatCount ?? 0) > 99 ? 36 : 28,
            height:
            (chatAccount.unreadChatCount ?? 0) > 99 ? 36 : 28,
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: AppColor.errorColor,
              child: Text(
                (chatAccount.unreadChatCount ?? 0) > 99
                    ? "+99"
                    : chatAccount.unreadChatCount.toString(),
                style: AppTextStyle.bodyText
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          )
              : null,
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════
  //  پنل مکالمه (پیام‌ها)
  // ═══════════════════════════════════════════════════════
  Widget _buildConversationPanel(
      BuildContext context, ChatController controller) {
    final chatAccount = controller.selectedChatAccount.value;
    final account = controller.selectedAccount.value;
    final chat = controller.selectedChat.value;

    final displayName =
        chatAccount?.accountName ?? account?.name ?? 'کاربر ناشناس';
    final topicName =
        chat?.topicTitle ?? controller.selectedTopic.value?.title;

    return Container(
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: AppColor.secondary100Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.textColor.withAlpha(40), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.secondary50Color,
              border: Border(
                  bottom: BorderSide(color: AppColor.textColor.withAlpha(40))),
            ),
            child: Row(
              children: [
                // ← NEW: دکمه بازگشت به لیست چت‌ها
                if (controller.selectedChat.value != null)
                  IconButton(
                    onPressed: controller.goBackToChatList,
                    icon: Icon(Icons.arrow_back,
                        color: AppColor.textColor.withAlpha(200), size: 22),
                    tooltip: 'بازگشت به لیست گفتگوها',
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: AppTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColor.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // ← نمایش موضوع
                      if (topicName != null)
                        Row(
                          children: [
                            Icon(Icons.topic,
                                size: 12, color: AppColor.primaryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                topicName,
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 11,
                                  color: AppColor.primaryColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.clearSelections,
                  icon: Icon(Icons.close,
                      color: AppColor.textColor.withAlpha(200), size: 22),
                  tooltip: 'بستن گفتگو',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Messages
          Expanded(
            child: Obx(() {
              if (controller.isLoadingMessages.value) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColor.buttonColor));
              }
              if (controller.chatMessages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 48,
                          color: AppColor.textColor.withAlpha(130)),
                      const SizedBox(height: 12),
                      Text(
                        'هیچ پیامی در این گفتگو وجود ندارد',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 13,
                          color: AppColor.textColor.withAlpha(175),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: controller.chatMessages.length +
                    (controller.hasMoreMessages.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.chatMessages.length) {
                    if (controller.isLoadingMoreMessages.value) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child:
                            CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    if (controller.hasMoreMessages.value) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.loadMoreMessages(); // ← بدون پارامتر
                      });
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child:
                            CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  final message = controller.chatMessages[index];
                  final isFromCurrentUser = message.senderType == 1;
                  return _buildMessageItem(message, isFromCurrentUser);
                },
              );
            }),
          ),
          _buildReplyPreview(controller),

          // Input
          chat?.status==0 ?
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    focusNode: controller.messageFocusNode,
                    maxLines: null,
                    style: AppTextStyle.bodyText
                        .copyWith(color: AppColor.textColor),
                    decoration: InputDecoration(
                      hintText: controller.replyToMessage.value != null
                          ? 'پاسخ خود را بنویسید...'
                          : 'پیام خود را بنویسید...',
                      hintStyle:
                      TextStyle(color: AppColor.textColor.withAlpha(175)),
                      filled: true,
                      fillColor: AppColor.backGroundColor2.withAlpha(180),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                            color: AppColor.textColor.withAlpha(50)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                            color: AppColor.buttonColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() => IconButton(
                  onPressed: controller.isSendingMessage.value
                      ? null
                      : controller.sendMessage,
                  icon: controller.isSendingMessage.value
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.buttonColor),
                  )
                      : Icon(Icons.send_rounded,
                      color: AppColor.secondary3Color, size: 26),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColor.buttonColor.withAlpha(40),
                  ),
                )),
              ],
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  Empty state
  // ═══════════════════════════════════════════════════════
  Widget _buildEmptySidePanel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.textColor.withAlpha(40), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.buttonColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 56,
                color: AppColor.buttonColor.withAlpha(180),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'یک گفتگو را انتخاب کنید',
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'از لیست سمت راست یک کاربر انتخاب کنید یا با دکمه + گفتگوی جدید شروع کنید.',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 13,
                  color: AppColor.textColor.withAlpha(175),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  دیالوگ‌ها (بدون تغییر ساختاری عمده)
  // ═══════════════════════════════════════════════════════

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
                    icon: Icon(Icons.close, color: AppColor.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.searchController,
                onChanged: controller.filterAccounts,
                style:
                AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
                decoration: InputDecoration(
                  hintText: 'جستجوی کاربر...',
                  hintStyle:
                  TextStyle(color: AppColor.textColor.withAlpha(175)),
                  prefixIcon: Icon(Icons.search, color: AppColor.textColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: AppColor.textColor.withAlpha(80)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: AppColor.textColor.withAlpha(80)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.buttonColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                          color: AppColor.textColor.withAlpha(175),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.filteredAccountList.length,
                    itemBuilder: (context, index) {
                      final account =
                      controller.filteredAccountList[index];
                      final isInChatList =
                      controller.isAccountInChatList(account.id ?? 0);
                      return ListTile(
                        minTileHeight: 40,
                        onTap: isInChatList
                            ? null
                            :
                            () => _selectUserForChat(
                            context, controller, account),
                        /*leading: CircleAvatar(
                          backgroundColor: AppColor.buttonColor,
                          child: Text(
                            account.name?.substring(0, 1).toUpperCase() ??
                                'U',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),*/
                        title: Text(
                          account.name ?? 'کاربر ناشناس',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isInChatList
                                ? AppColor.textColor.withAlpha(130)
                                : AppColor.textColor,
                          ),
                        ),
                        trailing: isInChatList
                            ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.textColor.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'در گفتگو',
                            style: AppTextStyle.bodyText.copyWith(
                              fontSize: 10,
                              color:
                              AppColor.textColor.withAlpha(175),
                            ),
                          ),
                        )
                            : Icon(Icons.arrow_forward_ios,
                            color: AppColor.buttonColor, size: 16),
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

  void _selectUserForChat(BuildContext context, ChatController controller,
      AccountModel account) {
    controller.clearSelections();
    controller.selectAccount(account);
    Get.back();

    _showTopicSelectionDialog(
      context,
      controller,
      chatAccount: ChatAccountModel(
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
      ),
      account: account,
    );
  }

  void _showTopicSelectionDialog(
      BuildContext context,
      ChatController controller, {
        required ChatAccountModel chatAccount,
        AccountModel? account,
      }) {
    final topicOwnerId = chatAccount.accountId;
    if (topicOwnerId != null) {
      controller.loadTopics();
    }
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
              Row(
                children: [
                  Text(
                    'انتخاب موضوع',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: AppColor.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                          Icon(Icons.topic_outlined,
                              size: 64,
                              color: AppColor.textColor.withAlpha(130)),
                          const SizedBox(height: 16),
                          Text(
                            'هیچ موضوعی یافت نشد',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withAlpha(175),
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
                      final isDesktop = ResponsiveBreakpoints.of(context)
                          .largerThan(TABLET);
                      return ListTile(
                        onTap: () {
                          controller.selectTopic(topic);
                          Get.back();
                          if (!isDesktop && account != null) {
                            _showChatPage(
                                context, controller, account, topic);
                          }
                        },
                        leading:
                        Icon(Icons.topic, color: AppColor.buttonColor),
                        title: Text(
                          topic.title ?? 'موضوع ناشناس',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        subtitle: Text(
                          topic.code ?? '',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: 12,
                            color: AppColor.textColor.withAlpha(175),
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: AppColor.buttonColor, size: 16),
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

  void _showChatPage(BuildContext context, ChatController controller,
      AccountModel account, TopicModel topic) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, color: AppColor.textColor),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColor.buttonColor,
                    child: Text(
                      account.name?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.buttonColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.topic,
                                  size: 12, color: AppColor.buttonColor),
                              const SizedBox(width: 4),
                              Text(
                                topic.title ?? 'موضوع ناشناس',
                                style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 12,
                                  color: AppColor.buttonColor,
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
                          Icon(Icons.chat_bubble_outline,
                              size: 64,
                              color: AppColor.textColor.withAlpha(130)),
                          const SizedBox(height: 16),
                          Text(
                            'هیچ پیامی وجود ندارد',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withAlpha(175),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: controller.chatMessages.length +
                        (controller.hasMoreMessages.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.chatMessages.length) {
                        if (controller.isLoadingMoreMessages.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        if (controller.hasMoreMessages.value) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) {
                            controller.loadMoreMessages();
                          });
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      final message = controller.chatMessages[index];
                      final isFromCurrentUser = message.senderType == 1;
                      return _buildMessageItem(
                          message, isFromCurrentUser);
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              _buildReplyPreview(controller),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor),
                      decoration: InputDecoration(
                        hintText: 'پیام خود را بنویسید...',
                        hintStyle: TextStyle(
                            color: AppColor.textColor.withAlpha(175)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: AppColor.textColor.withAlpha(75)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: AppColor.textColor.withAlpha(75)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                          BorderSide(color: AppColor.buttonColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => IconButton(
                    onPressed: controller.isSendingMessage.value
                        ? null
                        : controller.sendMessage,
                    icon: controller.isSendingMessage.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2),
                    )
                        : Icon(Icons.send,
                        color: AppColor.secondary3Color),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  Message item (بدون تغییر)
  // ═══════════════════════════════════════════════════════
  Widget _buildMessageItem(ChatMessageModel message, bool isFromCurrentUser) {
    final ChatController controller = Get.find<ChatController>();

    Widget messageContent = Align(
      alignment: isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 6,
          left: isFromCurrentUser ? 60 : 12,
          right: isFromCurrentUser ? 12 : 60,
        ),
        child: Column(
          crossAxisAlignment:
          isFromCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // ─── حباب پیام ───
            Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.55),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isFromCurrentUser
                    ? const Color(0xFF2B5278)   // آبی تیره (پیام من)
                    : const Color(0xFF182533),  // خاکستری تیره (پیام طرف مقابل)
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isFromCurrentUser ? 16 : 4),
                  bottomRight: Radius.circular(isFromCurrentUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── نام فرستنده (فقط برای طرف مقابل) ───
                  if (!isFromCurrentUser && message.senderAccountName != null) ...[
                    Text(
                      message.senderAccountName!,
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        //color: const Color(0xFF6AB3F3), // آبی روشن
                        color: const Color(0xFFF3B36A),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],

                  // ─── ریپلای ───
                  if (message.replyToSeq != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          right: BorderSide(
                            color: isFromCurrentUser
                                ? const Color(0xFF6AB3F3)
                                : const Color(0xFF8774E1),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'پاسخ به پیام #${message.replyToSeq}',
                            style: AppTextStyle.bodyText.copyWith(
                              fontSize: 11,
                              color: isFromCurrentUser
                                  ? const Color(0xFF6AB3F3)
                                  : const Color(0xFF8774E1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ─── متن پیام ───
                  Text(
                    message.text ?? '',
                    style: AppTextStyle.bodyText.copyWith(
                      color: Colors.white.withAlpha(230),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ─── زمان + تیک ───
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.createdOnUtc?.toPersianDate(
                            twoDigits: true,
                            showTime: true,
                            timeSeprator: ':') ??
                            '',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: 10,
                          color: Colors.white.withAlpha(120),
                        ),
                      ),
                      // ─── تیک تحویل (فقط پیام من) ───
                      if (isFromCurrentUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.deliveredOnUtc != null
                              ? Icons.done_all
                              : Icons.done,
                          size: 14,
                          color: message.deliveredOnUtc != null
                              ? const Color(0xFF6AB3F3) // تیک آبی
                              : Colors.white.withAlpha(120),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // ─── Swipe to reply (فقط پیام طرف مقابل) ───
    return SwipeToReply(
      enabled: !isFromCurrentUser,
      onSwipe: () => controller.setReplyMessage(message),
      child: messageContent,
    );
  }
  // ═
  // ═══════════════════════════════════════════════════════
  //  Reply preview (بدون تغییر)
  // ═══════════════════════════════════════════════════════
  Widget _buildReplyPreview(ChatController controller) {
    return Obx(() {
      final replyMessage = controller.replyToMessage.value;
      if (replyMessage != null) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColor.buttonColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border:
            Border.all(color: AppColor.buttonColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.reply, size: 16, color: AppColor.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'پاسخ به کاربر',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 12,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: controller.cancelReply,
                    icon: Icon(Icons.close,
                        size: 16,
                        color: AppColor.textColor.withOpacity(0.7)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'replyMessage.messageContent',
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

  // ═══════════════════════════════════════════════════════
  //  تب‌ها و لیست (بدون تغییر ساختاری)
  // ═══════════════════════════════════════════════════════

  Widget _buildVerticalChatTabs(ChatController controller) {
    return Obx(() {
      final openCount =
          controller.chatAccountList.where((a) => a.chatStatus == 0).length;
      final closedCount =
          controller.chatAccountList.where((a) => a.chatStatus == 1).length;

      return Container(
        width: 60,
        child: Column(
          children: [
            _buildVerticalTabItem(
                controller, 0, 'باز', Icons.lock_open_rounded, openCount),
            const SizedBox(height: 4),
            _buildVerticalTabItem(
                controller, 1, 'بسته', Icons.lock_rounded, closedCount),
            const Spacer(),
          ],
        ),
      );
    });
  }

  Widget _buildVerticalTabItem(ChatController controller, int index,
      String title, IconData icon, int count) {
    final isSelected = controller.selectedChatTab.value == index;

    return GestureDetector(
      onTap: () => controller.selectedChatTab.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 52,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColor.buttonColor.withAlpha(70),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : AppColor.textColor.withAlpha(160)),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : AppColor.textColor.withAlpha(160),
              ),
            ),
            if (count > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.errorColor.withAlpha(100)
                      : AppColor.textColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : AppColor.textColor.withAlpha(150),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ← MODIFIED: loadMoreChats → loadMoreChatAccounts
  Widget _buildChatListContent(
      BuildContext context, ChatController controller) {
    return Column(
      children: [
        _buildChatSearchField(controller),
        /*TextField(
          controller: controller.chatAccountsSearchController,
          onChanged: (value) => controller.filterChatAccounts(value),
          style:
          AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
          decoration: InputDecoration(
            hintText: 'جستجوی گفتگو...',
            hintStyle:
            TextStyle(color: AppColor.textColor.withAlpha(175)),
            prefixIcon: Icon(Icons.search, color: AppColor.textColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              BorderSide(color: AppColor.textColor.withAlpha(80)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              BorderSide(color: AppColor.textColor.withAlpha(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.buttonColor),
            ),
          ),
        ),*/
        Expanded(
          child: Obx(() {
            if (controller.isLoadingChatAccounts.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final filteredList = controller.filteredChatAccountsByStatus;

            if (controller.chatAccountList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 64, color: AppColor.textColor.withAlpha(130)),
                    const SizedBox(height: 16),
                    Text('هیچ گفتگویی یافت نشد',
                        style: AppTextStyle.bodyText
                            .copyWith(color: AppColor.textColor.withAlpha(175))),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showAddUserDialog(context, controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('شروع گفتگوی جدید',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            if (filteredList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 48, color: AppColor.textColor.withAlpha(130)),
                    const SizedBox(height: 12),
                    Text(
                      controller.selectedChatTab.value == 0
                          ? 'هیچ گفتگوی بازی یافت نشد'
                          : 'هیچ گفتگوی بسته‌ای یافت نشد',
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor.withAlpha(175)),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredList.length +
                  (controller.hasMoreChatAccounts.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredList.length) {
                  if (controller.isLoadingMoreChatAccounts.value) {
                    return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()));
                  } else if (controller.hasMoreChatAccounts.value) {
                    WidgetsBinding.instance.addPostFrameCallback(
                            (_) => controller.loadMoreChatAccounts()); // ← RENAMED
                    return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()));
                  }
                  return const SizedBox.shrink();
                }
                return _buildChatAccount(
                    context, controller, filteredList[index]);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHorizontalChatTabs(ChatController controller) {
    return Obx(() {
      final openCount =
          controller.chatAccountList.where((a) => a.chatStatus == 0).length;
      final closedCount =
          controller.chatAccountList.where((a) => a.chatStatus == 1).length;

      return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColor.backGroundColor2.withAlpha(120),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildHorizontalTabItem(controller, 0, 'باز', openCount),
            const SizedBox(width: 4),
            _buildHorizontalTabItem(controller, 1, 'بسته', closedCount),
          ],
        ),
      );
    });
  }

  Widget _buildHorizontalTabItem(
      ChatController controller, int index, String title, int count) {
    final isSelected = controller.selectedChatTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedChatTab.value = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.buttonColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: AppTextStyle.bodyText.copyWith(
                    color: isSelected ? Colors.white : AppColor.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.errorColor.withAlpha(100)
                        : AppColor.textColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(count.toString(),
                      style: AppTextStyle.bodyText.copyWith(
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white
                            : AppColor.textColor.withAlpha(175),
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatSearchField(ChatController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5,left: 7,right: 7),
      child: TextField(
        controller: controller.chatAccountsSearchController,
        onChanged: (value) => controller.filterChatAccounts(value),
        style: AppTextStyle.bodyText,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'جستجوی گفتگو...',
          hintStyle: AppTextStyle.bodyText.copyWith(
            color: AppColor.textColor.withAlpha(130),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColor.textColor.withAlpha(160),
          ),
          suffixIcon:
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: AppColor.textColor.withAlpha(160),
                ),
                onPressed: () {
                  controller.chatAccountsSearchController.clear();
                  controller.filterChatAccounts('');
                },
              ),
          filled: true,
          fillColor: AppColor.backGroundColor2.withAlpha(120),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

}
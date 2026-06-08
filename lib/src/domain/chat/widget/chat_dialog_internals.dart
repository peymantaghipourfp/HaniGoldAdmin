import 'package:flutter/material.dart';

import '../controller/chat.controller.dart';

/// Legacy bubble palette — prefer [ChatThemeData.of] in widgets.
@Deprecated('Use context.chatTheme from chat_theme.dart')
const Color kBubbleOutgoing = Color(0xFF2B5278);
@Deprecated('Use context.chatTheme from chat_theme.dart')
const Color kBubbleIncoming = Color(0xFF182533);
@Deprecated('Use context.chatTheme from chat_theme.dart')
const Color kBubbleSystem = Color(0xFF4A4230);
@Deprecated('Use context.chatTheme from chat_theme.dart')
const Color kBubbleReplyAccent = Color(0xFF04C2BB);

/// Shared tab metadata for the chat-account list (vertical + horizontal layouts).
class ChatAccountTabUiSpec {
  const ChatAccountTabUiSpec({
    required this.index,
    required this.label,
    required this.icon,
  });

  final int index;
  final String label;
  final IconData icon;
}

const kChatAccountTabSpecs = <ChatAccountTabUiSpec>[
  ChatAccountTabUiSpec(
    index: ChatAccountListTabs.unpicked,
    label: 'در انتظار',
    icon: Icons.remove_circle_outline,
  ),
  ChatAccountTabUiSpec(
    index: ChatAccountListTabs.all,
    label: 'همه',
    icon: Icons.list_alt_rounded,
  ),
  ChatAccountTabUiSpec(
    index: ChatAccountListTabs.open,
    label: 'باز',
    icon: Icons.lock_open_rounded,
  ),
  ChatAccountTabUiSpec(
    index: ChatAccountListTabs.closed,
    label: 'بسته',
    icon: Icons.lock_rounded,
  ),
];

const kAvatarPalette = <Color>[
  Color(0xFF2B5278),
  Color(0xFF4A4230),
  Color(0xFF3A6B3A),
  Color(0xFF6B3A3A),
  Color(0xFF3A3A6B),
  Color(0xFF6B553A),
  Color(0xFF3A6B6B),
];

const kAttachmentTypeIcons = <String, IconData>{
  'image': Icons.image_outlined,
  'video': Icons.videocam_outlined,
  'audio': Icons.audiotrack_outlined,
  'pdf': Icons.picture_as_pdf_outlined,
  'archive': Icons.folder_zip_outlined,
  'document': Icons.insert_drive_file_outlined,
};

const kAttachmentTypeLabels = <String, String>{
  'image': 'تصویر',
  'video': 'ویدئو',
  'audio': 'صدا',
  'pdf': 'PDF',
  'archive': 'آرشیو',
  'document': 'سند',
};

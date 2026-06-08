import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

/// List row for chat picker dialogs — [ListTile] needs a [Material] ancestor for ink.
class ChatDialogListTile extends StatelessWidget {
  const ChatDialogListTile({
    super.key,
    required this.theme,
    required this.onTap,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.minTileHeight,
  });

  final ChatThemeData theme;
  final VoidCallback onTap;
  final Widget title;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final double? minTileHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          minTileHeight: minTileHeight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: theme.onSurface.withAlpha(14),
          hoverColor: theme.accent.withAlpha(28),
          splashColor: theme.accent.withAlpha(40),
          onTap: onTap,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../utils/chat_composer_text_editing.dart';

/// Inserts [emoji] into [textController] at the current selection (or appends).
void insertEmojiAtComposerSelection(
    TextEditingController textController,
    String emoji,
    ) {
  if (emoji.isEmpty) return;
  final normalized = normalizeComposerTextEditingValue(textController.value);
  final text = normalized.text;
  final (start, end) = expandComposerSelectionToGraphemes(
    text,
    normalized.selection,
  );
  final newText = text.replaceRange(start, end, emoji);
  final offset = (start + emoji.length).clamp(0, newText.length);
  applyComposerTextEditingValue(
    textController,
    TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset),
    ),
  );
}

/// Removes the current selection, or the grapheme cluster before the caret.
void deleteLastGraphemeBeforeCursorInComposer(TextEditingController textController) {
  final normalized = normalizeComposerTextEditingValue(textController.value);
  final text = normalized.text;
  final sel = normalized.selection;
  if (!sel.isValid) return;

  if (!sel.isCollapsed) {
    final (start, end) = expandComposerSelectionToGraphemes(text, sel);
    final newText = text.replaceRange(start, end, '');
    applyComposerTextEditingValue(
      textController,
      TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: start.clamp(0, newText.length),
        ),
      ),
    );
    return;
  }
  final caret = snapCollapsedComposerOffset(
    text,
    sel.baseOffset.clamp(0, text.length),
  );
  if (caret <= 0) return;
  final deleteEnd = caret;
  final deleteStart = composerGraphemeStartBefore(text, deleteEnd);
  if (deleteStart >= deleteEnd) return;
  final newText = text.replaceRange(deleteStart, deleteEnd, '');
  applyComposerTextEditingValue(
    textController,
    TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: deleteStart.clamp(0, newText.length),
      ),
    ),
  );
}

class _EmojiCategory {
  const _EmojiCategory(this.label, this.icon, this.emojis);
  final String label;
  final IconData icon;
  final List<String> emojis;
}

/// Curated high-signal sets (Unicode strings; no extra font dependency).
const List<_EmojiCategory> _kEmojiCategories = [
  _EmojiCategory('احساسات', Icons.sentiment_satisfied_alt_outlined, [
    '😀', '😃', '😄', '😁', '😅', '😂', '🤣', '😊', '😇', '🙂', '😉', '😌',
    '😍', '🥰', '😘', '😗', '😙', '😚', '😋', '😛', '😜', '🤪', '😝', '🤑',
    '🤗', '🤭', '🤫', '🤔', '🤐', '🤨', '😐', '😑', '😶', '😏', '😒', '🙄',
    '😬', '🤥', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢', '🤮', '🤧',
    '🥵', '🥶', '🥴', '😵', '🤯', '🤠', '🥳', '😎', '🤓', '🧐', '😈', '👿',
    '💀', '☠️', '💩', '🤡', '👹', '👺', '👻', '👽', '👾', '🤖',
  ]),
  _EmojiCategory('اشاره', Icons.pan_tool_alt_outlined, [
    '👍', '👎', '👌', '✌️', '🤞', '🤟', '🤘', '🤙', '👈', '👉', '👆', '👇',
    '☝️', '✋', '🤚', '🖐️', '🖖', '👋', '🤝', '💪', '🙏', '✍️', '👏', '🙌',
    '👐', '🤲', '🤜', '🤛',
  ]),
  _EmojiCategory('قلب و عشق', Icons.favorite_border_rounded, [
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔', '❣️', '💕',
    '💞', '💓', '💗', '💖', '💘', '💝', '💟', '♥️', '🌹', '🥀', '🌷', '🌸',
  ]),
  _EmojiCategory('سایر', Icons.auto_awesome_outlined, [
    '✨', '🔥', '💯', '⭐', '🌟', '💫', '⚡', '☀️', '🌙', '☁️', '🌈', '☂️',
    '🎉', '🎊', '🎁', '🏆', '🥇', '🥈', '🥉', '⚽', '🏀', '🎵', '🎶', '📌',
    '✅', '❌', '❓', '❗', '💬', '🗯️', '💭', '📎', '📷', '📱', '⏰', '⌛',
  ]),
];

enum _MediaTab { emoji, sticker, gif }

/// Inline emoji surface (Telegram-like layout, dark theme): docked above the composer.
class ChatEmojiPickerPanel extends StatefulWidget {
  const ChatEmojiPickerPanel({
    super.key,
    required this.textController,
    required this.onClose,
    this.onRestoreComposerFocus,
  });

  final TextEditingController textController;
  final VoidCallback onClose;
  final VoidCallback? onRestoreComposerFocus;

  @override
  State<ChatEmojiPickerPanel> createState() => _ChatEmojiPickerPanelState();
}

class _ChatEmojiPickerPanelState extends State<ChatEmojiPickerPanel> {
  int _categoryIndex = 0;
  _MediaTab _mediaTab = _MediaTab.emoji;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onEmojiTap(String emoji) {
    insertEmojiAtComposerSelection(widget.textController, emoji);
    widget.onRestoreComposerFocus?.call();
  }

  void _onBackspace() {
    deleteLastGraphemeBeforeCursorInComposer(widget.textController);
    widget.onRestoreComposerFocus?.call();
  }

  List<String> _filteredEmojis(_EmojiCategory cat) {
    final q = _searchController.text.trim();
    if (q.isEmpty) return cat.emojis;
    return cat.emojis.where((e) => e.contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final cat = _kEmojiCategories[_categoryIndex];
    final filtered = _filteredEmojis(cat);
    final chatTheme = context.chatTheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: chatTheme.emojiPanelSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: chatTheme.emojiPanelBorder),
          boxShadow: [
            BoxShadow(
              color: chatTheme.panelShadow.withAlpha(120),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _kEmojiCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 4),
                        itemBuilder: (context, i) {
                          final selected = i == _categoryIndex;
                          final icon = _kEmojiCategories[i].icon;
                          return InkWell(
                            onTap: () => setState(() => _categoryIndex = i),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    icon,
                                    size: 22,
                                    color: selected
                                        ? chatTheme.accent
                                        : chatTheme.onSurfaceMuted,
                                  ),
                                  const SizedBox(height: 4),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 160),
                                    curve: Curves.easeOutCubic,
                                    height: 2,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? chatTheme.accent
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  tooltip: 'بستن',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: chatTheme.onSurfaceVariant,
                    size: 26,
                  ),
                ),
              ],
            ),
            /*Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 13,
                  color: ChatAppColors.textPrimary,
                ),
                cursorColor: ChatAppColors.secondary,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'جستجو',
                  hintStyle: AppTextStyle.bodyText.copyWith(
                    fontSize: 13,
                    color: chatTheme.onSurfaceMuted,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: chatTheme.onSurfaceMuted,
                  ),
                  filled: true,
                  fillColor: ChatAppColors.searchBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color: ChatAppColors.border.withAlpha(160),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color: ChatAppColors.border.withAlpha(120),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color: ChatAppColors.secondary.withAlpha(200),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  cat.label,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: chatTheme.onSurface,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _mediaTab == _MediaTab.emoji
                  ? filtered.isEmpty
                  ? Center(
                child: Text(
                  'ایموجی‌ای یافت نشد',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    color: chatTheme.onSurfaceMuted,
                  ),
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                physics: const ClampingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 12 : 7,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 1,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final e = filtered[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onEmojiTap(e),
                      borderRadius: BorderRadius.circular(10),
                      splashColor:
                      chatTheme.accent.withAlpha(50),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: chatTheme.panelGradientStart.withAlpha(90),
                        ),
                        child: Center(
                          child: Text(
                            e,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 23,
                              height: 1.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'به‌زودی',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 13,
                    color: chatTheme.onSurfaceMuted,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: chatTheme.emojiPanelBorder,
                  ),
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBackspace,
                      tooltip: 'پاک کردن',
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.backspace_outlined,
                        size: 22,
                        color: chatTheme.onSurfaceVariant,
                      ),
                    ),
                    /*const Spacer(),
                    _footerTab('ایموجی', _MediaTab.emoji),
                    const SizedBox(width: 12),
                    _footerTab('استیکر', _MediaTab.sticker),
                    const SizedBox(width: 12),
                    _footerTab('گیف', _MediaTab.gif),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

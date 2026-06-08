import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/chat_app_colors.dart';

/// Material 3 semantic palette for chat (conversation + management shell).
@immutable
class ChatThemeData {
  const ChatThemeData({
    required this.bubbleOutgoing,
    required this.bubbleOutgoingGradientEnd,
    required this.bubbleIncoming,
    required this.bubbleSystem,
    required this.bubbleReplyAccent,
    required this.bubbleReplyQuoteIncoming,
    required this.bubbleReplyQuoteSystem,
    required this.bubbleSenderNameAccent,
    required this.onBubble,
    required this.onBubbleMuted,
    required this.composerSurface,
    required this.composerBorder,
    required this.composerHint,
    required this.menuSurface,
    required this.menuIconAccent,
    required this.swipeReplyIcon,
    required this.swipeReplyIconActive,
    required this.swipeReplyBackground,
    required this.swipeReplyBackgroundActive,
    required this.emojiPanelSurface,
    required this.emojiPanelBorder,
    required this.sendButtonBackground,
    required this.sendIcon,
    required this.shellBackground,
    required this.panelGradientStart,
    required this.panelGradientEnd,
    required this.panelBorder,
    required this.panelHeader,
    required this.panelShadow,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onSurfaceMuted,
    required this.divider,
    required this.accent,
    required this.accentContainer,
    required this.onAccent,
    required this.tabSelected,
    required this.tabTrack,
    required this.tabBadge,
    required this.listItemSelectedFill,
    required this.listItemSelectedBorder,
    required this.listItemSelectedGlow,
    required this.searchFill,
    required this.searchOutline,
    required this.threadOpenGradientStart,
    required this.threadOpenGradientEnd,
    required this.threadClosedGradientStart,
    required this.threadClosedGradientEnd,
    required this.threadViewGradientStart,
    required this.threadViewGradientEnd,
    required this.statusClosed,
    required this.statusView,
    required this.statusOpen,
    required this.unreadBadge,
    required this.topicAccent,
    required this.emptyStateIcon,
    required this.progress,
  });

  // —— Conversation ——
  final Color bubbleOutgoing;
  final Color bubbleOutgoingGradientEnd;
  final Color bubbleIncoming;
  final Color bubbleSystem;
  final Color bubbleReplyAccent;
  final Color bubbleReplyQuoteIncoming;
  final Color bubbleReplyQuoteSystem;
  final Color bubbleSenderNameAccent;
  final Color onBubble;
  final Color onBubbleMuted;
  final Color composerSurface;
  final Color composerBorder;
  final Color composerHint;
  final Color menuSurface;
  final Color menuIconAccent;
  final Color swipeReplyIcon;
  final Color swipeReplyIconActive;
  final Color swipeReplyBackground;
  final Color swipeReplyBackgroundActive;
  final Color emojiPanelSurface;
  final Color emojiPanelBorder;
  final Color sendButtonBackground;
  final Color sendIcon;

  // —— Management shell ——
  final Color shellBackground;
  final Color panelGradientStart;
  final Color panelGradientEnd;
  final Color panelBorder;
  final Color panelHeader;
  final Color panelShadow;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onSurfaceMuted;
  final Color divider;
  final Color accent;
  final Color accentContainer;
  final Color onAccent;
  final Color tabSelected;
  final Color tabTrack;
  final Color tabBadge;
  final Color listItemSelectedFill;
  final Color listItemSelectedBorder;
  final Color listItemSelectedGlow;
  final Color searchFill;
  final Color searchOutline;
  final Color threadOpenGradientStart;
  final Color threadOpenGradientEnd;
  final Color threadClosedGradientStart;
  final Color threadClosedGradientEnd;
  final Color threadViewGradientStart;
  final Color threadViewGradientEnd;
  final Color statusClosed;
  final Color statusView;
  final Color statusOpen;
  final Color unreadBadge;
  final Color topicAccent;
  final Color emptyStateIcon;
  final Color progress;

  Gradient? get bubbleOutgoingGradient {
    if (bubbleOutgoing == bubbleOutgoingGradientEnd) return null;
    return LinearGradient(
      colors: [bubbleOutgoing, bubbleOutgoingGradientEnd],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
  }

  LinearGradient get panelGradient => LinearGradient(
        colors: [panelGradientStart, panelGradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  BoxDecoration dialogDecoration({double radius = 20}) => BoxDecoration(
        color: shellBackground,
        gradient: panelGradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: panelBorder),
      );

  BoxDecoration panelDecoration({double radius = 16}) => BoxDecoration(
        gradient: panelGradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: panelBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: panelShadow.withAlpha(100),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      );

  BoxDecoration threadCardDecoration({
    required bool isClosed,
    required bool isView,
  }) {
    final (start, end, border) = isClosed
        ? (threadClosedGradientStart, threadClosedGradientEnd, statusClosed)
        : isView
            ? (threadViewGradientStart, threadViewGradientEnd, statusView)
            : (threadOpenGradientStart, threadOpenGradientEnd, panelBorder);
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [start, end],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border.withAlpha(200)),
      boxShadow: [
        BoxShadow(
          color: panelShadow.withAlpha(50),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Canonical M3 dark [ColorScheme] for the chat module (independent of app theme).
  static const ColorScheme chatDarkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF22D3EE),
    onPrimary: Color(0xFF020617),
    primaryContainer: Color(0xFF164E63),
    onPrimaryContainer: Color(0xFFA5F3FC),
    secondary: Color(0xFF22C55E),
    onSecondary: Color(0xFF020617),
    secondaryContainer: Color(0xFF14532D),
    onSecondaryContainer: Color(0xFFBBF7D0),
    tertiary: Color(0xFF9B8CFF),
    onTertiary: Color(0xFF020617),
    error: Color(0xFFFB7185),
    onError: Color(0xFF020617),
    surface: Color(0xFF0F172A),
    onSurface: Color(0xFFF8FAFC),
    surfaceContainerHighest: Color(0xFF29374B),
    surfaceContainerHigh: Color(0xFF1E293B),
    surfaceContainer: Color(0xFF1E293B),
    surfaceContainerLow: Color(0xFF0F172A),
    surfaceContainerLowest: Color(0xFF020617),
    onSurfaceVariant: Color(0xFFCBD5E1),
    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF475569),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: Color(0xFF0891B2),
  );

  /// Dark tokens used everywhere in chat (admin app [MaterialApp] defaults to light brightness).
  static final ChatThemeData dark = ChatThemeData.forDarkColorScheme(chatDarkColorScheme);

  static ChatThemeData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<ChatThemeInherited>();
    if (inherited != null) return inherited.themeData;
    return ChatThemeData.dark;
  }

  /// Wraps chat UI so [Theme] brightness and [chatTheme] are always dark.
  static ThemeData materialTheme() {
    final tokens = ChatThemeData.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: chatDarkColorScheme,
      fontFamily: 'IranSansR',
    );
    return base.copyWith(
      scaffoldBackgroundColor: tokens.shellBackground,
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.shellBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(color: tokens.divider, thickness: 1),
      iconTheme: IconThemeData(color: tokens.onSurfaceVariant),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: tokens.progress),
      textTheme: base.textTheme.apply(
        bodyColor: tokens.onSurface,
        displayColor: tokens.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.searchFill,
        hintStyle: TextStyle(color: tokens.onSurfaceMuted),
        labelStyle: TextStyle(color: tokens.onSurfaceVariant),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.searchOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.accent, width: 1.2),
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: tokens.onSurface,
        iconColor: tokens.onSurfaceVariant,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: tokens.menuSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.accent,
          foregroundColor: tokens.onAccent,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: tokens.accent),
      ),
    );
  }

  /// M3 dark — OLED-friendly slate base, cyan accent, green status.
  factory ChatThemeData.forDarkColorScheme(ColorScheme scheme) {
    const shell = Color(0xFF020617);
    const surfaceLow = Color(0xFF0F172A);
    const surface = Color(0xFF1E293B);
    const surfaceHigh = Color(0xFF29374B);
    const outline = Color(0xFF334155);
    const accentCyan = Color(0xFF22D3EE);
    const accentGreen = Color(0xFF22C55E);

    return ChatThemeData(
      bubbleOutgoing: const Color(0xFF2B5278),
      bubbleOutgoingGradientEnd: ChatAppColors.disabled,
      bubbleIncoming: const Color(0xFF182533),
      bubbleSystem: const Color(0xFF4A4230),
      bubbleReplyAccent: accentCyan,
      bubbleReplyQuoteIncoming: ChatAppColors.tertiary,
      bubbleReplyQuoteSystem: const Color(0xFFF36A93),
      bubbleSenderNameAccent: const Color(0xFFF3B36A),
      onBubble: const Color(0xFFF8FAFC),
      onBubbleMuted: const Color(0xFFCBD5E1).withAlpha(140),
      composerSurface: surfaceLow.withAlpha(245),
      composerBorder: outline,
      composerHint: const Color(0xFF94A3B8),
      menuSurface: surfaceLow,
      menuIconAccent: accentCyan,
      swipeReplyIcon: const Color(0xFF94A3B8),
      swipeReplyIconActive: accentCyan,
      swipeReplyBackground: surfaceHigh.withAlpha(90),
      swipeReplyBackgroundActive: accentCyan.withAlpha(72),
      emojiPanelSurface: surfaceLow,
      emojiPanelBorder: outline,
      sendButtonBackground: accentCyan.withAlpha(56),
      sendIcon: accentCyan,
      shellBackground: shell,
      panelGradientStart: surfaceHigh,
      panelGradientEnd: surfaceLow,
      panelBorder: outline.withAlpha(180),
      panelHeader: surfaceLow,
      panelShadow: Colors.black,
      onSurface: const Color(0xFFF8FAFC),
      onSurfaceVariant: const Color(0xFFCBD5E1),
      onSurfaceMuted: const Color(0xFF94A3B8),
      divider: outline,
      accent: accentCyan,
      accentContainer: accentCyan.withAlpha(40),
      onAccent: shell,
      tabSelected: ChatAppColors.tertiarySelect,
      tabTrack: surfaceLow.withAlpha(200),
      tabBadge: const Color(0xFFEF4444),
      listItemSelectedFill: const Color(0xFF1D4ED8).withAlpha(40),
      listItemSelectedBorder: accentCyan.withAlpha(200),
      listItemSelectedGlow: ChatAppColors.tertiarySelect.withAlpha(90),
      searchFill: surface,
      searchOutline: outline.withAlpha(120),
      threadOpenGradientStart: const Color(0xFF061D2D),
      threadOpenGradientEnd: ChatAppColors.tertiarySelect1,
      threadClosedGradientStart: surfaceLow,
      threadClosedGradientEnd: ChatAppColors.errorG,
      threadViewGradientStart: surfaceLow,
      threadViewGradientEnd: ChatAppColors.warningG,
      statusClosed: ChatAppColors.error,
      statusView: ChatAppColors.warning,
      statusOpen: accentGreen,
      unreadBadge: ChatAppColors.unreadBadge,
      topicAccent: accentGreen,
      emptyStateIcon: const Color(0xFF64748B),
      progress: accentCyan,
    );
  }

  factory ChatThemeData.light(ColorScheme scheme) {
    return ChatThemeData(
      bubbleOutgoing: scheme.primary,
      bubbleOutgoingGradientEnd: scheme.primaryContainer,
      bubbleIncoming: scheme.surfaceContainerHighest,
      bubbleSystem: scheme.tertiaryContainer,
      bubbleReplyAccent: scheme.secondary,
      bubbleReplyQuoteIncoming: scheme.tertiary,
      bubbleReplyQuoteSystem: scheme.error,
      bubbleSenderNameAccent: const Color(0xFFB45309),
      onBubble: scheme.onSurface,
      onBubbleMuted: scheme.onSurfaceVariant,
      composerSurface: scheme.surfaceContainerLow,
      composerBorder: scheme.outlineVariant,
      composerHint: scheme.onSurfaceVariant,
      menuSurface: scheme.surfaceContainerHigh,
      menuIconAccent: scheme.primary,
      swipeReplyIcon: scheme.onSurfaceVariant,
      swipeReplyIconActive: scheme.secondary,
      swipeReplyBackground: scheme.surfaceContainerHighest,
      swipeReplyBackgroundActive: scheme.secondaryContainer,
      emojiPanelSurface: scheme.surfaceContainerLow,
      emojiPanelBorder: scheme.outlineVariant,
      sendButtonBackground: scheme.primaryContainer,
      sendIcon: scheme.onPrimaryContainer,
      shellBackground: scheme.surface,
      panelGradientStart: scheme.surfaceContainerHigh,
      panelGradientEnd: scheme.surfaceContainerLow,
      panelBorder: scheme.outlineVariant,
      panelHeader: scheme.surfaceContainerLow,
      panelShadow: scheme.shadow,
      onSurface: scheme.onSurface,
      onSurfaceVariant: scheme.onSurfaceVariant,
      onSurfaceMuted: scheme.outline,
      divider: scheme.outlineVariant,
      accent: scheme.primary,
      accentContainer: scheme.primaryContainer,
      onAccent: scheme.onPrimary,
      tabSelected: scheme.primary,
      tabTrack: scheme.surfaceContainerHighest,
      tabBadge: scheme.error,
      listItemSelectedFill: scheme.primaryContainer.withAlpha(120),
      listItemSelectedBorder: scheme.primary,
      listItemSelectedGlow: scheme.primary.withAlpha(60),
      searchFill: scheme.surfaceContainerHighest,
      searchOutline: scheme.outlineVariant,
      threadOpenGradientStart: scheme.surfaceContainerLow,
      threadOpenGradientEnd: scheme.surfaceContainer,
      threadClosedGradientStart: scheme.surfaceContainerLow,
      threadClosedGradientEnd: scheme.errorContainer,
      threadViewGradientStart: scheme.surfaceContainerLow,
      threadViewGradientEnd: scheme.tertiaryContainer,
      statusClosed: scheme.error,
      statusView: scheme.tertiary,
      statusOpen: scheme.primary,
      unreadBadge: scheme.error,
      topicAccent: scheme.tertiary,
      emptyStateIcon: scheme.onSurfaceVariant,
      progress: scheme.primary,
    );
  }
}

extension ChatThemeContext on BuildContext {
  ChatThemeData get chatTheme => ChatThemeData.of(this);
}

/// Forces M3 dark [Theme] + [ChatThemeData] for an entire chat subtree.
class ChatThemeScope extends StatelessWidget {
  const ChatThemeScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChatThemeInherited(
      themeData: ChatThemeData.dark,
      child: Theme(
        data: ChatThemeData.materialTheme(),
        child: child,
      ),
    );
  }
}

class ChatThemeInherited extends InheritedWidget {
  const ChatThemeInherited({
    super.key,
    required this.themeData,
    required super.child,
  });

  final ChatThemeData themeData;

  @override
  bool updateShouldNotify(ChatThemeInherited oldWidget) =>
      themeData != oldWidget.themeData;
}

/// Use for [Get.dialog] / [showDialog] opened from chat so overlays stay dark.
Widget chatThemedDialog(Widget dialog) => ChatThemeScope(child: dialog);

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

void main() {
  group('ChatThemeData', () {
    test('dark and light palettes differ on bubble incoming', () {
      final dark = ChatThemeData.forDarkColorScheme(ChatThemeData.chatDarkColorScheme);
      final light = ChatThemeData.light(const ColorScheme.light());
      expect(dark.bubbleIncoming, isNot(equals(light.bubbleIncoming)));
      expect(dark.bubbleReplyAccent, isNot(equals(light.bubbleReplyAccent)));
    });

    test('outgoing gradient is set for dark theme', () {
      final dark = ChatThemeData.dark;
      expect(dark.bubbleOutgoingGradient, isNotNull);
      expect(dark.bubbleOutgoingGradient!.colors.length, 2);
    });

    test('dark management shell uses M3 slate base', () {
      expect(ChatThemeData.dark.shellBackground, const Color(0xFF020617));
      expect(ChatThemeData.dark.accent, const Color(0xFF22D3EE));
      expect(ChatThemeData.dark.panelGradient.colors.length, 2);
    });

    testWidgets('of(context) stays dark when app ThemeData is light', (tester) async {
      late ChatThemeData captured;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: Builder(
            builder: (context) {
              captured = ChatThemeData.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(captured.shellBackground, ChatThemeData.dark.shellBackground);
      expect(captured.onSurface, const Color(0xFFF8FAFC));
    });

    testWidgets('ChatThemeScope forces dark Material brightness', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: const ChatThemeScope(
            child: SizedBox(key: Key('scoped')),
          ),
        ),
      );

      final scopeContext = tester.element(find.byKey(const Key('scoped')));
      expect(Theme.of(scopeContext).brightness, Brightness.dark);
      expect(Theme.of(scopeContext).colorScheme.brightness, Brightness.dark);
    });
  });
}

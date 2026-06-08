import 'package:characters/characters.dart';
import 'package:flutter/painting.dart';

/// True when [g] is treated as an emoji cluster for bubble typography (not linguistic text).
///
/// Uses Unicode ranges for pictographs, symbols, flags, and common supplemental emoji.
/// Joiners (ZWJ) and variation selectors are allowed inside [g] when a base pictograph exists.
bool isEmojiGraphemeCluster(String g) {
  if (g.isEmpty) return false;
  var sawEmojiBase = false;
  for (final r in g.runes) {
    if (r == 0x200D || r == 0xFE0F || r == 0xFE0E) continue;
    if (r >= 0x1F3FB && r <= 0x1F3FF) {
      sawEmojiBase = true;
      continue;
    }
    if (_isEmojiBaseRune(r)) {
      sawEmojiBase = true;
    }
  }
  return sawEmojiBase;
}

bool _isEmojiBaseRune(int r) {
  return (r >= 0x1F300 && r <= 0x1FAFF) ||
      (r >= 0x2600 && r <= 0x26FF) ||
      (r >= 0x2700 && r <= 0x27BF) ||
      (r >= 0x1F600 && r <= 0x1F64F) ||
      (r >= 0x1F680 && r <= 0x1F6FF) ||
      (r >= 0x1F900 && r <= 0x1F9FF) ||
      (r >= 0x1F1E6 && r <= 0x1F1FF) ||
      (r >= 0x231A && r <= 0x23FF) ||
      (r == 0x24C2) ||
      (r == 0x25AA || r == 0x25AB) ||
      (r == 0x25B6 || r == 0x25C0) ||
      (r >= 0x25FB && r <= 0x25FE) ||
      (r == 0x2614 || r == 0x2615) ||
      (r == 0x2648) ||
      (r >= 0x2649 && r <= 0x2653) ||
      (r == 0x267F) ||
      (r == 0x2693) ||
      (r >= 0x26A1 && r <= 0x26A1) ||
      (r == 0x26AA || r == 0x26AB) ||
      (r == 0x26BD || r == 0x26BE) ||
      (r == 0x26C4 || r == 0x26C5) ||
      (r == 0x26CE) ||
      (r == 0x26D4) ||
      (r == 0x26EA) ||
      (r == 0x26F2 || r == 0x26F3) ||
      (r == 0x26F5) ||
      (r >= 0x26FA && r <= 0x26FA) ||
      (r == 0x26FD) ||
      (r == 0x2702) ||
      (r == 0x2705) ||
      (r >= 0x2708 && r <= 0x270D) ||
      (r == 0x270F) ||
      (r == 0x2712) ||
      (r == 0x2714 || r == 0x2716) ||
      (r == 0x271D) ||
      (r == 0x2721) ||
      (r == 0x2728) ||
      (r == 0x2733 || r == 0x2734) ||
      (r == 0x2744) ||
      (r == 0x2747) ||
      (r == 0x274C || r == 0x274E) ||
      (r >= 0x2753 && r <= 0x2755) ||
      (r == 0x2757) ||
      (r == 0x2763 || r == 0x2764) ||
      (r >= 0x2795 && r <= 0x2797) ||
      (r == 0x27A1) ||
      (r == 0x27B0) ||
      (r == 0x27BF) ||
      (r == 0x00A9 || r == 0x00AE) ||
      (r == 0x203C || r == 0x2049) ||
      (r == 0x2122 || r == 0x2139) ||
      (r == 0x2194 ||
          r == 0x2195 ||
          r == 0x2196 ||
          r == 0x2197 ||
          r == 0x2198 ||
          r == 0x2199) ||
      (r == 0x21A9 || r == 0x21AA) ||
      (r == 0x2328) ||
      (r == 0x23CF) ||
      (r == 0x23ED || r == 0x23EE || r == 0x23EF) ||
      (r == 0x23F1 || r == 0x23F2) ||
      (r == 0x23F8 || r == 0x23F9 || r == 0x23FA) ||
      (r == 0x2B50 || r == 0x2B55) ||
      (r == 0x3030 || r == 0x303D) ||
      (r == 0x3297 || r == 0x3299);
}

/// Builds [TextSpan] list: emoji graphemes use [emojiStyle], other text uses [baseStyle].
List<InlineSpan> buildEmojiAwareTextSpans(
    String input,
    TextStyle baseStyle,
    TextStyle emojiStyle,
    ) {
  if (input.isEmpty) return const [];
  final spans = <InlineSpan>[];
  final buf = StringBuffer();
  bool? bufIsEmoji;
  for (final g in input.characters) {
    final nextIsEmoji = isEmojiGraphemeCluster(g);
    if (buf.isNotEmpty && bufIsEmoji != null && nextIsEmoji != bufIsEmoji) {
      final flushEmoji = bufIsEmoji == true;
      spans.add(
        TextSpan(
          text: buf.toString(),
          style: flushEmoji ? emojiStyle : baseStyle,
        ),
      );
      buf.clear();
    }
    buf.write(g);
    bufIsEmoji = nextIsEmoji;
  }
  if (buf.isNotEmpty) {
    spans.add(
      TextSpan(
        text: buf.toString(),
        style: (bufIsEmoji ?? false) ? emojiStyle : baseStyle,
      ),
    );
  }
  return spans;
}

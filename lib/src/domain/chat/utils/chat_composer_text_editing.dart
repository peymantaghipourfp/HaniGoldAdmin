import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Drops unpaired UTF-16 surrogates (they break Flutter text selection on emoji).
String sanitizeComposerText(String text) {
  if (text.isEmpty) return text;
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final unit = text.codeUnitAt(i);
    if (_isHighSurrogate(unit)) {
      if (i + 1 < text.length && _isLowSurrogate(text.codeUnitAt(i + 1))) {
        buffer.writeCharCode(unit);
        buffer.writeCharCode(text.codeUnitAt(i + 1));
        i++;
      }
    } else if (!_isLowSurrogate(unit)) {
      buffer.writeCharCode(unit);
    }
  }
  return buffer.toString();
}

bool _isHighSurrogate(int unit) => unit >= 0xD800 && unit <= 0xDBFF;

bool _isLowSurrogate(int unit) => unit >= 0xDC00 && unit <= 0xDFFF;

/// Start code-unit offset of the grapheme cluster at or before [offset].
int composerGraphemeStartBefore(String text, int offset) {
  if (text.isEmpty || offset <= 0) return 0;
  final target = offset.clamp(0, text.length);
  var codeUnits = 0;
  for (final g in text.characters) {
    final next = codeUnits + g.length;
    if (next > target) return codeUnits;
    if (next == target) {
      return target == text.length ? codeUnits : target;
    }
    codeUnits = next;
  }
  return codeUnits;
}

/// End code-unit offset of the grapheme cluster at or after [offset].
int composerGraphemeEndAfter(String text, int offset) {
  if (text.isEmpty) return 0;
  final target = offset.clamp(0, text.length);
  var codeUnits = 0;
  for (final g in text.characters) {
    final next = codeUnits + g.length;
    if (next >= target) return next;
    codeUnits = next;
  }
  return text.length;
}

/// Snaps a collapsed caret out of the middle of a surrogate / ZWJ cluster.
int snapCollapsedComposerOffset(String text, int offset) {
  final clamped = offset.clamp(0, text.length);
  final start = composerGraphemeStartBefore(text, clamped);
  final end = composerGraphemeEndAfter(text, clamped);
  if (clamped > start && clamped < end) return end;
  return clamped;
}

/// Expands a selection to full grapheme boundaries (required before replace/delete).
(int start, int end) expandComposerSelectionToGraphemes(
    String text,
    TextSelection selection,
    ) {
  final len = text.length;
  if (!selection.isValid) return (len, len);

  if (selection.isCollapsed) {
    final at = snapCollapsedComposerOffset(text, selection.baseOffset);
    return (at, at);
  }

  var start = selection.start.clamp(0, len);
  var end = selection.end.clamp(0, len);
  if (start > end) {
    final swap = start;
    start = end;
    end = swap;
  }
  start = composerGraphemeStartBefore(text, start);
  end = composerGraphemeEndAfter(text, end);
  return (start, end);
}

/// Ensures valid UTF-16 text and a selection that does not split grapheme clusters.
TextEditingValue normalizeComposerTextEditingValue(TextEditingValue value) {
  final sanitized = sanitizeComposerText(value.text);
  final len = sanitized.length;

  if (sanitized != value.text) {
    return TextEditingValue(
      text: sanitized,
      selection: TextSelection.collapsed(offset: len),
      composing: TextRange.empty,
    );
  }

  if (!value.selection.isValid) {
    return TextEditingValue(
      text: sanitized,
      selection: TextSelection.collapsed(offset: len),
      composing: TextRange.empty,
    );
  }

  final (start, end) = expandComposerSelectionToGraphemes(sanitized, value.selection);
  final safeStart = start.clamp(0, len);
  final safeEnd = end.clamp(safeStart, len);
  final selection = value.selection.isCollapsed
      ? TextSelection.collapsed(offset: safeStart)
      : TextSelection(baseOffset: safeStart, extentOffset: safeEnd);

  return TextEditingValue(
    text: sanitized,
    selection: selection,
    composing: value.composing.isValid ? value.composing : TextRange.empty,
  );
}

void applyComposerTextEditingValue(
    TextEditingController controller,
    TextEditingValue value,
    ) {
  controller.value = normalizeComposerTextEditingValue(value);
}

/// Snaps edits to grapheme boundaries so emoji are not split (avoids selection crashes).
class ComposerGraphemeTextInputFormatter extends TextInputFormatter {
  const ComposerGraphemeTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.composing.isValid) return newValue;
    return normalizeComposerTextEditingValue(newValue);
  }
}

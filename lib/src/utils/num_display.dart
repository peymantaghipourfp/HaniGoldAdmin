/// Global number-to-string formatting for display and calculations.
///
/// On Windows, [num.toString()] can produce "10.0" for whole numbers, which
/// breaks display and string-based parsing (e.g. [replaceAll] for digits).
/// Use [toDisplayString] for consistent, compact output: whole numbers
/// without ".0", decimals unchanged.
library;

/// Extension on [num] for platform-consistent display string.
extension NumDisplay on num {
  /// Returns a string suitable for display and string-based calculations.
  /// Whole numbers are returned without ".0" (e.g. 10, not 10.0).
  /// Use [fractionDigits] to force decimal places when needed.
  String toDisplayString({int? fractionDigits}) {
    if (fractionDigits != null) {
      return toStringAsFixed(fractionDigits);
    }
    if (this == roundToDouble()) {
      return toInt().toString();
    }
    return toString();
  }
}
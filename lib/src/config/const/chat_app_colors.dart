
import 'package:flutter/material.dart';


class ChatAppColors {
  ChatAppColors._();
  // =========================
  // Core Background Colors
  // =========================
  static const Color background = Color(0xFF002231); // Deep navy
  static const Color surface = Color(0xFF012439); // Card/background
  static const Color surfaceSecondary = Color(0xFF29374B); // Elevated surfaces
  static const Color border = Color(0xFF02456D); // Dividers and borders
  static const Color backgroundCard = Color(0xFF061D2D);

  // =========================
  // Brand Colors
  // =========================
  static const Color primary = Color(0xFF6D8FFF); // Bright blue
  static const Color primaryHover = Color(0xFF86A3FF);
  static const Color secondary = Color(0xFF22D3EE); // Cyan
  static const Color secondary1 = Color(0xFF0FC485);
  static const Color tertiary = Color(0xFF9B8CFF); // Purple
  static const Color tertiarySelect = Color(0xFF443D71);
  static const Color tertiarySelect1 = Color(0xFF3B3561);

  // =========================
  // Text Colors
  // =========================
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color hint = Color(0xFF94A3B8);
  static const Color disabled = Color(0xFF64748B);
  static const Color onPrimary = Colors.white;

  // =========================
  // Chat Bubble Colors
  // =========================
  static const Color myMessage = primary;
  static const Color myMessageGradientEnd = Color(0xFF8AA6FF);
  static const Color otherMessage = Color(0xFF1E293B);

  // =========================
  // Status Colors
  // =========================
  static const Color online = Color(0xFF22C55E);
  static const Color typing = Color(0xFF06B6D4);
  static const Color unreadBadge = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningG = Color(0xFF76592E);
  static const Color error = Color(0xFFFB7185);
  static const Color errorG = Color(0xFF5C3238);

  // =========================
  // Input & Search
  // =========================
  static const Color searchBackground = Color(0xFF1E293B);
  static const Color inputBackground = Color(0xFF111827);
  static const Color selectedItem = Color(0xFF1D4ED8);
  static const Color hover = Color(0xFF1E3A8A);

  // =========================
  // Shadows
  // =========================
  static const Color shadow = Color(0x66000000); // 40% black opacity

  // =========================
  // Gradients
  // =========================
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [
      surfaceSecondary,
      surface,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [
      backgroundCard,
      tertiarySelect1,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient freshGradient = LinearGradient(
    colors: [
      secondary,
      primary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient closeGradient = LinearGradient(
    colors: [
      inputBackground,
      errorG,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient viewGradient = LinearGradient(
    colors: [
      inputBackground,
      warningG,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
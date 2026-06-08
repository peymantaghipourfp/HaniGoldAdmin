import 'package:flutter/material.dart';

import 'chat_dialog_internals.dart';

class InitialAvatar extends StatelessWidget {
  const InitialAvatar({super.key, this.name, this.seed, this.size = 36});

  final String? name;
  final int? seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final effectiveSeed = seed ?? name.hashCode;
    final color = kAvatarPalette[effectiveSeed.abs() % kAvatarPalette.length];
    final initial = _extractInitial(name);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(30), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.42,
          fontWeight: FontWeight.bold,
          color: Colors.white.withAlpha(230),
        ),
      ),
    );
  }

  static String _extractInitial(String? name) {
    if (name == null || name.trim().isEmpty) return '؟';
    final trimmed = name.trim();
    for (final rune in trimmed.runes) {
      final char = String.fromCharCode(rune);
      if (char.trim().isNotEmpty) return char.toUpperCase();
    }
    return '؟';
  }
}

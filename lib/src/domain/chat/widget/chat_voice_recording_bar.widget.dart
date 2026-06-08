import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/utils/chat_attachment_utils.dart';

/// Inline recording strip shown in the composer while the user holds the mic.
class ChatVoiceRecordingBar extends StatelessWidget {
  const ChatVoiceRecordingBar({
    super.key,
    required this.elapsedListenable,
    required this.cancelArmed,
  });

  final ValueListenable<Duration> elapsedListenable;
  final bool cancelArmed;

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;

    return RepaintBoundary(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: theme.statusClosed,
              shape: BoxShape.circle,
              boxShadow: cancelArmed
                  ? null
                  : [
                BoxShadow(
                  color: theme.statusClosed.withAlpha(120),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ValueListenableBuilder<Duration>(
            valueListenable: elapsedListenable,
            builder: (context, elapsed, _) {
              return Text(
                formatChatAudioDuration(elapsed),
                style: AppTextStyle.bodyText.copyWith(
                  color:
                  cancelArmed ? theme.statusClosed : theme.onBubble,
                  fontSize: 15,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              );
            },
          ),
          const Spacer(),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: AppTextStyle.bodyText.copyWith(
              color:
              cancelArmed ? theme.statusClosed : theme.onBubbleMuted,
              fontSize: 13,
              fontWeight:
              cancelArmed ? FontWeight.w600 : FontWeight.normal,
            ),
            child: Text(
              cancelArmed
                  ? 'رها کنید تا لغو شود'
                  : '← برای لغو بکشید',
            ),
          ),
        ],
      ),
    );
  }
}

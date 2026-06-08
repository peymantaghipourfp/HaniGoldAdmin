import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/const/toast.service.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';
import 'package:hanigold_admin/src/domain/chat/utils/chat_composer_text_editing.dart';
import 'package:hanigold_admin/src/domain/chat/utils/chat_voice_recording.dart';
import 'package:hanigold_admin/src/domain/chat/widget/chat_voice_recording_bar.widget.dart';
import 'package:record/record.dart';

import '../../../config/const/chat_app_colors.dart';

/// Text field + mic/send trailing control with shared hold-to-record state.
class ChatComposerInputTrailing extends StatefulWidget {
  const ChatComposerInputTrailing({
    super.key,
    required this.controller,
    required this.isDesktop,
    required this.isBusy,
    required this.isEmpty,
    required this.hasAttachments,
    required this.canSendWithoutText,
    required this.composerHint,
    required this.customerTyping,
    required this.onVoiceRecordingChanged,
  });

  final ChatController controller;
  final bool isDesktop;
  final bool isBusy;
  final bool isEmpty;
  final bool hasAttachments;
  /// Reply or forward: send is allowed (and shown) without composer text.
  final bool canSendWithoutText;
  final String composerHint;
  final bool customerTyping;
  final ValueChanged<bool> onVoiceRecordingChanged;

  @override
  State<ChatComposerInputTrailing> createState() =>
      _ChatComposerInputTrailingState();
}

class _ChatComposerInputTrailingState extends State<ChatComposerInputTrailing>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  final Stopwatch _recordingStopwatch = Stopwatch();
  final ValueNotifier<Duration> _recordingElapsed =
  ValueNotifier<Duration>(Duration.zero);

  OverlayEntry? _overlayEntry;
  Ticker? _elapsedTicker;
  StreamSubscription<RecordState>? _recordStateSub;
  Offset? _pointerDownGlobal;
  bool _cancelArmed = false;
  bool _recording = false;
  bool _finishing = false;
  bool _captureActive = false;
  String _recordingExtension = 'm4a';
  RecordConfig? _recordConfig;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _recordConfig = kChatVoiceWebRecordConfig;
      _recordingExtension = kChatVoiceWebFormatCandidates.first.extension;
    }
    unawaited(_prepareRecordFormat());
    _recordStateSub = _recorder.onStateChanged().listen(_onRecorderState);
  }

  Future<void> _prepareRecordFormat() async {
    try {
      final format = await resolveChatVoiceRecordFormat(_recorder);
      if (!mounted) return;
      setState(() {
        _recordConfig = format.config;
        _recordingExtension = format.extension;
      });
    } catch (_) {
      if (!mounted || !kIsWeb) return;
      setState(() {
        _recordConfig = kChatVoiceWebRecordConfig;
        _recordingExtension = kChatVoiceWebFormatCandidates.first.extension;
      });
    }
  }

  bool get _showVoiceButton =>
      _recording ||
          (widget.isEmpty &&
              !widget.hasAttachments &&
              !widget.isBusy &&
              !widget.canSendWithoutText);

  bool get _sendEnabled =>
      !widget.isBusy &&
          (!widget.isEmpty || widget.canSendWithoutText || widget.hasAttachments);

  @override
  void dispose() {
    _stopElapsedTicker(resetStopwatch: true);
    _recordStateSub?.cancel();
    _recordingElapsed.dispose();
    _removeOverlay();
    unawaited(_recorder.dispose());
    super.dispose();
  }

  void _onRecorderState(RecordState state) {
    switch (state) {
      case RecordState.record:
        if (_recording && !_captureActive) {
          _captureActive = true;
          _startElapsedTicker(reset: true);
        }
      case RecordState.pause:
        if (_captureActive) {
          _stopElapsedTicker(resetStopwatch: false);
        }
      case RecordState.stop:
        _captureActive = false;
    }
  }

  void _setRecording(bool value) {
    if (_recording == value) return;
    _recording = value;
    widget.onVoiceRecordingChanged(value);
  }

  void _startElapsedTicker({required bool reset}) {
    _elapsedTicker?.stop();
    if (reset) {
      _recordingStopwatch
        ..reset()
        ..start();
      _recordingElapsed.value = Duration.zero;
    } else if (!_recordingStopwatch.isRunning) {
      _recordingStopwatch.start();
    }

    _elapsedTicker ??= createTicker(_onElapsedTick);
    if (!_elapsedTicker!.isActive) {
      _elapsedTicker!.start();
    }
    _onElapsedTick(Duration.zero);
  }

  void _stopElapsedTicker({required bool resetStopwatch}) {
    _elapsedTicker?.stop();
    if (_recordingStopwatch.isRunning) {
      _recordingStopwatch.stop();
    }
    if (resetStopwatch) {
      _recordingStopwatch.reset();
      _recordingElapsed.value = Duration.zero;
    }
  }

  void _onElapsedTick(Duration _) {
    if (!_recordingStopwatch.isRunning) return;

    final next = voiceRecordingDisplayElapsed(
      _recordingElapsed.value,
      _recordingStopwatch.elapsed,
    );
    if (next != _recordingElapsed.value) {
      _recordingElapsed.value = next;
    }
  }

  Future<void> _onPointerDown(PointerDownEvent event) async {
    if (widget.isBusy || _recording || _finishing) return;

    var config = _recordConfig;
    if (config == null) {
      final format = await resolveChatVoiceRecordFormat(_recorder);
      config = format.config;
      _recordingExtension = format.extension;
      _recordConfig = config;
    }

    if (chatVoiceRecordingPreflightsPermission) {
      final permitted = await ensureChatVoiceMicrophonePermission(
        recorder: _recorder,
      );
      if (!permitted) {
        ToastService().error('دسترسی به میکروفون داده نشد');
        return;
      }
    }

    final path = kIsWeb
        ? 'voice.web'
        : await chatVoiceRecordingOutputPath(_recordingExtension);

    _captureActive = false;
    _pointerDownGlobal = event.position;
    _cancelArmed = false;
    _setRecording(true);
    _recordingElapsed.value = Duration.zero;

    try {
      await _recorder.start(config, path: path);
      if (kIsWeb && !await _recorder.isRecording()) {
        throw StateError('voice recording did not start');
      }
      if (!_captureActive) {
        _captureActive = true;
        _startElapsedTicker(reset: true);
      }
    } catch (e) {
      _setRecording(false);
      _captureActive = false;
      _stopElapsedTicker(resetStopwatch: true);
      ToastService().error('دسترسی به میکروفون داده نشد');
      return;
    }

    HapticFeedback.mediumImpact();
    _insertOverlay();
    if (mounted) setState(() {});
  }

  void _insertOverlay() {
    _removeOverlay();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerCancel,
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final origin = _pointerDownGlobal;
    if (origin == null || !_recording) return;

    final armed =
        event.position.dx - origin.dx >= kChatVoiceCancelDragThreshold;
    if (armed != _cancelArmed) {
      setState(() => _cancelArmed = armed);
      if (armed) HapticFeedback.lightImpact();
    }
  }

  Future<void> _onPointerUp(PointerUpEvent event) async {
    await _finishRecording(send: !_cancelArmed);
  }

  Future<void> _onPointerCancel(PointerCancelEvent event) async {
    await _finishRecording(send: false);
  }

  Future<void> _finishRecording({required bool send}) async {
    if (!_recording || _finishing) return;
    _finishing = true;
    _removeOverlay();
    _stopElapsedTicker(resetStopwatch: false);

    final duration = _recordingStopwatch.elapsed;

    String? path;
    try {
      if (send) {
        path = await _recorder.stop();
      } else {
        await _recorder.cancel();
      }
    } catch (_) {
      await _recorder.cancel();
    }

    _captureActive = false;
    _setRecording(false);
    _pointerDownGlobal = null;
    _cancelArmed = false;
    _stopElapsedTicker(resetStopwatch: true);

    if (mounted) setState(() {});

    if (send) {
      if (duration < kChatVoiceMinDuration) {
        ToastService().info('مدت ضبط خیلی کوتاه بود');
        await deleteChatVoiceRecordingFile(path);
      } else {
        final bytes = await readChatVoiceRecordingBytes(path);
        await deleteChatVoiceRecordingFile(path);
        if (bytes == null || bytes.isEmpty) {
          ToastService().error('خواندن فایل صوتی ناموفق بود');
        } else {
          final fileName = chatVoiceRecordingFileName(_recordingExtension);
          await widget.controller.sendVoiceMessage(bytes, fileName);
        }
      }
    }

    _finishing = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.chatTheme;
    final buttonSize = widget.isDesktop ? 44.0 : 34.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _recording
              ? ChatVoiceRecordingBar(
            key: const ValueKey('chat-voice-recording-bar'),
            elapsedListenable: _recordingElapsed,
            cancelArmed: _cancelArmed,
          )
              : TextField(
            controller: widget.controller.messageController,
            focusNode: widget.controller.messageFocusNode,
            inputFormatters: const [ComposerGraphemeTextInputFormatter()],
            maxLines: 5,
            minLines: 1,
            style: AppTextStyle.bodyText.copyWith(
              color: theme.onBubble,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: widget.composerHint,
              hintStyle: AppTextStyle.bodyText.copyWith(
                color: widget.customerTyping
                    ? ChatAppColors.typing
                    : theme.composerHint,
                fontSize: 14,
                fontStyle: widget.customerTyping
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 12,
              ),
            ),
          ),
        ),
        SizedBox(width: widget.isDesktop ? 4 : 1),
        if (_showVoiceButton)
          Tooltip(
            message: 'نگه دارید و صحبت کنید',
            child: Listener(
              onPointerDown: widget.isBusy ? null : _onPointerDown,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  color: _recording
                      ? theme.statusClosed.withAlpha(72)
                      : theme.sendButtonBackground,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  _recording ? Icons.mic_rounded : Icons.mic_none_rounded,
                  size: 22,
                  color: _recording ? theme.statusClosed : theme.sendIcon,
                ),
              ),
            ),
          )
        else
          FilledButton(
            onPressed: _sendEnabled ? widget.controller.sendMessage : null,
            style: FilledButton.styleFrom(
              backgroundColor: theme.sendButtonBackground,
              foregroundColor: theme.sendIcon,
              disabledBackgroundColor:
              theme.sendButtonBackground.withAlpha(80),
              minimumSize: Size(buttonSize, buttonSize),
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: widget.isBusy
                ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.sendIcon,
              ),
            )
                : Icon(
              Icons.send_rounded,
              size: 22,
              color: _sendEnabled ? theme.sendIcon : theme.onBubbleMuted,
            ),
          ),
      ],
    );
  }
}

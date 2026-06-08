import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

import '../controller/chat.controller.dart';
import '../utils/chat_attachment_utils.dart';

/// Which [ChatAudioPlayerState] currently owns playback (others must pause).
class ActiveChatAudio {
  static final ValueNotifier<ChatAudioPlayerState?> current =
      ValueNotifier<ChatAudioPlayerState?>(null);
}

class ChatAudioPlayer extends StatefulWidget {
  const ChatAudioPlayer({
    super.key,
    required this.controller,
    required this.recordId,
    this.cached,
  });

  final ChatController controller;
  final String recordId;
  final ChatPendingAttachment? cached;

  @override
  State<ChatAudioPlayer> createState() => ChatAudioPlayerState();
}

class ChatAudioPlayerState extends State<ChatAudioPlayer> {
  late final AudioPlayer _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<void>? _completeSub;

  Uint8List? _bytes;
  bool _sourceLoaded = false;
  bool _loading = false;
  bool _failed = false;
  bool _playing = false;
  bool _downloading = false;
  bool _scrubbing = false;
  Duration _position = Duration.zero;
  Duration _scrubPosition = Duration.zero;
  Duration _duration = Duration.zero;

  void _onCoordinatorChanged() {
    if (!mounted) return;
    final active = ActiveChatAudio.current.value;
    if (active != this && _playing) {
      unawaited(_player.pause());
      setState(() => _playing = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    unawaited(_player.setReleaseMode(ReleaseMode.stop));
    ActiveChatAudio.current.addListener(_onCoordinatorChanged);
    _positionSub = _player.onPositionChanged.listen((d) {
      if (!mounted || _scrubbing) return;
      setState(() => _position = d);
    });
    _durationSub = _player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });
    _completeSub = _player.onPlayerComplete.listen((_) async {
      if (ActiveChatAudio.current.value == this) {
        ActiveChatAudio.current.value = null;
      }
      try {
        await _player.seek(Duration.zero);
      } catch (_) {}
      if (mounted) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    ActiveChatAudio.current.removeListener(_onCoordinatorChanged);
    if (ActiveChatAudio.current.value == this) {
      ActiveChatAudio.current.value = null;
    }
    _positionSub?.cancel();
    _durationSub?.cancel();
    _completeSub?.cancel();
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_loading) return;
    if (_playing) {
      await _player.pause();
      if (ActiveChatAudio.current.value == this) {
        ActiveChatAudio.current.value = null;
      }
      if (mounted) setState(() => _playing = false);
      return;
    }

    if (!_sourceLoaded) {
      setState(() {
        _loading = true;
        _failed = false;
      });
      try {
        final bytes = widget.cached?.bytes ??
            await widget.controller.fetchChatAttachmentBytes(widget.recordId);
        if (!mounted) return;
        if (bytes == null) {
          setState(() {
            _loading = false;
            _failed = true;
          });
          return;
        }
        _bytes = bytes;
        ActiveChatAudio.current.value = this;
        await _player.setSource(BytesSource(bytes));
        _sourceLoaded = true;
        await _player.resume();
        if (!mounted) return;
        setState(() {
          _loading = false;
          _playing = true;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _failed = true;
        });
        Get.snackbar(
          'خطا',
          'پخش ناموفق: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    ActiveChatAudio.current.value = this;
    try {
      await _player.resume();
      if (mounted) setState(() => _playing = true);
    } catch (e) {
      if (mounted) {
        setState(() => _failed = true);
        Get.snackbar(
          'خطا',
          'پخش ناموفق: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _onDownload() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      final bytes = _bytes ??
          await widget.controller.fetchChatAttachmentBytes(widget.recordId);
      if (!mounted) return;
      if (bytes == null) {
        Get.snackbar(
          'خطا',
          'دانلود ناموفق',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      _bytes ??= bytes;
      await saveChatAttachmentBytesToDisk(
        bytes: bytes,
        recordId: widget.recordId,
        fileType: 'audio',
        cached: widget.cached,
      );
      if (!mounted) return;
      Get.snackbar(
        'ذخیره',
        'فایل ذخیره شد',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        'خطا',
        'دانلود ناموفق: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxMs = _duration.inMilliseconds;
    final posForSlider = (_scrubbing ? _scrubPosition : _position)
        .inMilliseconds
        .clamp(0, maxMs > 0 ? maxMs : 0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(18),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _failed
                  ? Colors.redAccent.withAlpha(160)
                  : Colors.white.withAlpha(35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: _togglePlay,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: Colors.white54,
                            ),
                          )
                        : Icon(
                            _playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white.withAlpha(230),
                            size: 22,
                          ),
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 1.5,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 4,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 8,
                          ),
                        ),
                        child: Slider(
                          value: maxMs > 0 ? posForSlider.toDouble() : 0,
                          max: maxMs > 0 ? maxMs.toDouble() : 1,
                          onChanged: maxMs > 0 && _sourceLoaded
                              ? (v) {
                                  setState(() {
                                    _scrubbing = true;
                                    _scrubPosition =
                                        Duration(milliseconds: v.round());
                                  });
                                }
                              : null,
                          onChangeEnd: maxMs > 0 && _sourceLoaded
                              ? (v) async {
                                  final to = Duration(
                                    milliseconds: v.round().clamp(0, maxMs),
                                  );
                                  try {
                                    await _player.seek(to);
                                  } catch (_) {}
                                  if (mounted) {
                                    setState(() {
                                      _scrubbing = false;
                                      _position = to;
                                    });
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: _downloading ? null : _onDownload,
                    icon: _downloading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: Colors.white54,
                            ),
                          )
                        : Icon(
                            Icons.download_outlined,
                            color: Colors.white.withAlpha(200),
                            size: 18,
                          ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 2, end: 2),
                child: Text(
                  '${formatChatAudioDuration(_scrubbing ? _scrubPosition : _position)} / ${formatChatAudioDuration(_duration)}',
                  textAlign: TextAlign.end,
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 10,
                    color: Colors.white.withAlpha(140),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

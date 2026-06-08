import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'chat_voice_recording_io.dart'
if (dart.library.html) 'chat_voice_recording_stub.dart';

/// Minimum hold duration before a voice clip is sent.
const Duration kChatVoiceMinDuration = Duration(milliseconds: 500);

/// Horizontal drag distance (logical px) toward the text field that cancels.
const double kChatVoiceCancelDragThreshold = 80;

/// AAC-LC via MediaRecorder — matches server-accepted `.m4a` voice uploads.
const RecordConfig kChatVoiceAacRecordConfig = RecordConfig(
  encoder: AudioEncoder.aacLc,
  bitRate: 128000,
  sampleRate: 44100,
);

/// Opus-in-WebM fallback (e.g. Firefox); use `.webm` extension, not `.opus`.
const RecordConfig kChatVoiceOpusRecordConfig = RecordConfig(
  encoder: AudioEncoder.opus,
  bitRate: 64000,
  sampleRate: 48000,
);

/// Sync fallback for web before [resolveChatVoiceRecordFormat] completes.
const RecordConfig kChatVoiceWebRecordConfig = kChatVoiceAacRecordConfig;

/// Preferred web encoders (first supported wins). AAC → Opus/WebM; no WAV on web.
const List<({RecordConfig config, String extension})>
kChatVoiceWebFormatCandidates = [
  (config: kChatVoiceAacRecordConfig, extension: 'm4a'),
  (config: kChatVoiceOpusRecordConfig, extension: 'webm'),
];

/// Multipart MIME for chat voice uploads (server validates type + extension).
String? chatVoiceRecordingUploadMimeType(String extension) {
  switch (extension.trim().toLowerCase().replaceFirst('.', '')) {
    case 'm4a':
      return 'audio/mp4';
    case 'webm':
    case 'opus':
      return 'audio/webm';
    case 'wav':
      return 'audio/wav';
    default:
      return null;
  }
}

/// On web, microphone access must be requested via [AudioRecorder.start] inside
/// the pointer-down chain — a separate [AudioRecorder.hasPermission] call loses
/// Chrome's transient user activation.
bool get chatVoiceRecordingPreflightsPermission => !kIsWeb;

/// Platform-aware encoder + file extension for chat voice messages.
Future<({RecordConfig config, String extension})> resolveChatVoiceRecordFormat(
    AudioRecorder recorder,
    ) async {
  if (kIsWeb) {
    for (final candidate in kChatVoiceWebFormatCandidates) {
      if (await recorder.isEncoderSupported(candidate.config.encoder)) {
        return candidate;
      }
    }
    throw StateError(
      'No compressed audio encoder supported in this browser',
    );
  }

  if (await recorder.isEncoderSupported(AudioEncoder.aacLc)) {
    return (
    config: const RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    ),
    extension: 'm4a',
    );
  }

  return (
  config: const RecordConfig(
    encoder: AudioEncoder.wav,
    sampleRate: 44100,
  ),
  extension: 'wav',
  );
}

String chatVoiceRecordingFileName(String extension) {
  final ext = extension.trim().toLowerCase().replaceFirst('.', '');
  final stamp = DateTime.now().millisecondsSinceEpoch;
  return 'voice_$stamp.$ext';
}

/// Advances the displayed elapsed time by at most one whole second per call.
///
/// Prevents UI jumps (e.g. 00:02 → 00:12) when frame/timer delivery is delayed
/// but the underlying [Stopwatch] kept running.
Duration voiceRecordingDisplayElapsed(
    Duration displayed,
    Duration stopwatchElapsed,
    ) {
  final targetSeconds = stopwatchElapsed.inSeconds;
  final shownSeconds = displayed.inSeconds;
  if (targetSeconds <= shownSeconds) return displayed;
  return Duration(seconds: shownSeconds + 1);
}

/// Requests microphone access before recording on native/desktop.
///
/// Web callers must skip this and invoke [AudioRecorder.start] directly so
/// `getUserMedia` runs while the pointer-down user activation is still valid.
Future<bool> ensureChatVoiceMicrophonePermission({
  AudioRecorder? recorder,
}) async {
  if (kIsWeb) return true;

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  final r = recorder ?? AudioRecorder();
  try {
    return await r.hasPermission(request: true);
  } finally {
    if (recorder == null) {
      await r.dispose();
    }
  }
}

Future<String> chatVoiceRecordingOutputPath(String extension) async {
  if (kIsWeb) return 'voice.web';
  final dir = await getTemporaryDirectory();
  return p.join(
    dir.path,
    chatVoiceRecordingFileName(extension),
  );
}

Future<Uint8List?> readChatVoiceRecordingBytes(String? path) async {
  if (path == null || path.trim().isEmpty) return null;
  if (kIsWeb) {
    return XFile(path).readAsBytes();
  }
  return readVoiceRecordingFileBytes(path);
}

Future<void> deleteChatVoiceRecordingFile(String? path) async {
  if (path == null || kIsWeb) return;
  await deleteVoiceRecordingFile(path);
}

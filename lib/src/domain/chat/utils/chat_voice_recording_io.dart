import 'dart:io';
import 'dart:typed_data';

Future<Uint8List?> readVoiceRecordingFileBytes(String path) async {
  final file = File(path);
  if (!await file.exists()) return null;
  return file.readAsBytes();
}

Future<void> deleteVoiceRecordingFile(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  } catch (_) {}
}

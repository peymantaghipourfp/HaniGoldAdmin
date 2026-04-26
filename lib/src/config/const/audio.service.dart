import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Use lazy initialization to avoid crash on Windows
  // AudioPlayer is only created when first accessed
  AudioPlayer? _audioPlayer;
  bool _isInitialized = false;

  // Define all available sound files
  static const Map<String, String> _soundFiles = {
    'notification': 'sounds/notification.mp3',
    'notificationCoin': 'sounds/notificationCoin.mp3',
    'notificationAll': 'sounds/notificationAll.mp3',
    // 'error': 'sounds/error.mp3',
    // 'warning': 'sounds/warning.mp3',
  };

  /// Lazily create AudioPlayer only when needed
  AudioPlayer _getPlayer() {
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set audio mode for better web compatibility
      await _getPlayer().setReleaseMode(ReleaseMode.stop);
      _isInitialized = true;
    } catch (e) {
      Get.log('Error initializing audio service: $e');
    }
  }

  /// Get the correct source for the current platform
  Source _getAudioSource(String soundPath) {
    if (kIsWeb) {
      // For web builds, use UrlSource with the correct path
      return UrlSource('assets/$soundPath');
    } else {
      // For mobile/desktop, use AssetSource
      return AssetSource(soundPath);
    }
  }

  /// Play a specific sound by name
  Future<void> playSound(String soundName) async {
    try {
      await initialize();

      final soundPath = _soundFiles[soundName];
      if (soundPath == null) {
        Get.log('Sound not found: $soundName');
        return;
      }

      final audioSource = _getAudioSource(soundPath);
      Get.log('Playing sound: $soundName with source: $audioSource');

      if (kIsWeb) {
        // Web-specific handling with proper source
        await _getPlayer().setSource(audioSource);
        await _getPlayer().resume();
      } else {
        // Mobile/desktop handling
        await _getPlayer().play(audioSource);
      }

      Get.log('Playing sound: $soundName');
    } catch (e) {
      Get.log('Error playing sound $soundName: $e');

      // Fallback method with AssetSource
      try {
        final soundPath = _soundFiles[soundName];
        if (soundPath != null) {
          Get.log('Trying fallback with AssetSource: $soundPath');
          await _getPlayer().play(AssetSource(soundPath));
        }
      } catch (fallbackError) {
        Get.log('Fallback error playing sound $soundName: $fallbackError');
      }
    }
  }

  /// Play notification sound (backward compatibility)
  Future<void> playNotificationSound() async {
    await playSound('notification');
  }
  Future<void> playNotificationSoundCoin() async {
    await playSound('notificationCoin');
  }
  Future<void> playNotificationSoundAll() async {
    await playSound('notificationAll');
  }

  /// Get list of available sound names
  List<String> get availableSounds => _soundFiles.keys.toList();

  /// Check if a sound exists
  bool hasSound(String soundName) => _soundFiles.containsKey(soundName);

  Future<void> dispose() async {
    await _audioPlayer?.dispose();
    _audioPlayer = null;
    _isInitialized = false;
  }
}
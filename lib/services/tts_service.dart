import 'package:flutter_tts/flutter_tts.dart';

/// Service wrapping the flutter_tts plugin for Text-to-Speech.
class TtsService {
  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_isInitialized) return;

    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);

    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);
    _tts.setErrorHandler((msg) => _isSpeaking = false);

    _isInitialized = true;
  }

  /// Speak the given [text] in the specified [locale] (e.g. 'en-US').
  Future<void> speak(String text, {String locale = 'en-US'}) async {
    await init();
    await _tts.setLanguage(locale);
    await _tts.speak(text);
  }

  /// Stop any ongoing speech.
  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  /// Set speech rate: 0.0 (slowest) → 1.0 (fastest). Default 0.5.
  Future<void> setRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Set pitch: 0.5 → 2.0. Default 1.0.
  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  /// Get available languages.
  Future<List<dynamic>> getLanguages() async {
    await init();
    return await _tts.getLanguages;
  }

  void dispose() {
    _tts.stop();
  }
}

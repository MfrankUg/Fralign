import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

/// Service wrapping the speech_to_text plugin for Speech-to-Text.
class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isAvailable = false;
  bool _isListening = false;

  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;

  /// Initialize the speech recognition engine.
  Future<bool> init() async {
    _isAvailable = await _speech.initialize(
      onStatus: (status) {
        _isListening = _speech.isListening;
      },
      onError: (error) {
        _isListening = false;
      },
    );
    return _isAvailable;
  }

  /// Start listening. Calls [onResult] with partial and final results.
  Future<void> startListening({
    required void Function(SpeechRecognitionResult result) onResult,
    String localeId = 'en_US',
  }) async {
    if (!_isAvailable) {
      final available = await init();
      if (!available) return;
    }

    _isListening = true;
    await _speech.listen(
      onResult: onResult,
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        cancelOnError: true,
        partialResults: true,
        localeId: localeId,
      ),
    );
  }

  /// Stop listening.
  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
  }

  /// Cancel the current listening session.
  Future<void> cancel() async {
    await _speech.cancel();
    _isListening = false;
  }

  /// Get available locales on the device.
  Future<List<stt.LocaleName>> getLocales() async {
    if (!_isAvailable) await init();
    return await _speech.locales();
  }
}

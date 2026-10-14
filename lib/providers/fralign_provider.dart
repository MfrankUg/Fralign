import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../models/language_model.dart';
import '../models/dictionary_model.dart';
import '../services/tts_service.dart';
import '../services/stt_service.dart';
import '../services/dictionary_service.dart';

/// Central state management for the Fralign home screen.
class FralignProvider extends ChangeNotifier {
  // ── Services ──
  final TtsService _tts = TtsService();
  final SttService _stt = SttService();
  final DictionaryService _dictionary = DictionaryService();

  // ── Theme ──
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // ── Language ──
  AppLanguage _selectedLanguage = SupportedLanguages.all.first;
  AppLanguage get selectedLanguage => _selectedLanguage;

  // ── Input ──
  final TextEditingController textController = TextEditingController();
  String get currentWord => textController.text.trim();

  // ── TTS State ──
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;
  double _speechRate = 0.5; // 0.0–1.0
  double get speechRate => _speechRate;

  // ── STT State ──
  bool _isListening = false;
  bool get isListening => _isListening;
  String _recognizedText = '';
  String get recognizedText => _recognizedText;

  // ── Dictionary State ──
  DictionaryEntry? _dictionaryEntry;
  DictionaryEntry? get dictionaryEntry => _dictionaryEntry;
  bool _isLoadingDefinition = false;
  bool get isLoadingDefinition => _isLoadingDefinition;

  // ── Dictionary Tab ──
  int _dictionaryTabIndex = 0;
  int get dictionaryTabIndex => _dictionaryTabIndex;

  // ── Favorites ──
  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  FralignProvider() {
    _loadPreferences();
    _tts.init();
  }

  // ── Preferences ──
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    final rate = prefs.getDouble('speechRate') ?? 0.5;
    _speechRate = rate;

    final langCode = prefs.getString('languageCode');
    if (langCode != null) {
      _selectedLanguage = SupportedLanguages.all.firstWhere(
        (l) => l.code == langCode,
        orElse: () => SupportedLanguages.all.first,
      );
    }

    final favs = prefs.getStringList('favorites') ?? [];
    _favorites.addAll(favs);

    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    await prefs.setDouble('speechRate', _speechRate);
    await prefs.setString('languageCode', _selectedLanguage.code);
    await prefs.setStringList('favorites', _favorites.toList());
  }

  // ── Theme ──
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _savePreferences();
    notifyListeners();
  }

  // ── Language ──
  void setLanguage(AppLanguage lang) {
    _selectedLanguage = lang;
    _savePreferences();
    notifyListeners();
  }

  // ── TTS ──
  Future<void> speak() async {
    if (currentWord.isEmpty) return;
    _isSpeaking = true;
    notifyListeners();

    await _tts.setRate(_speechRate);
    await _tts.speak(currentWord, locale: _selectedLanguage.ttsLocale);

    // Wait a tick for the handler to fire
    await Future.delayed(const Duration(milliseconds: 300));
    _isSpeaking = _tts.isSpeaking;
    notifyListeners();

    // Poll until speech completes (lightweight).
    while (_tts.isSpeaking) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    _isSpeaking = false;
    notifyListeners();
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  void setSpeechRate(double rate) {
    _speechRate = rate;
    _savePreferences();
    notifyListeners();
  }

  // ── STT ──
  Future<void> startListening() async {
    _isListening = true;
    _recognizedText = '';
    notifyListeners();

    // Convert locale format: 'en-US' → 'en_US' for speech_to_text.
    final localeId = _selectedLanguage.ttsLocale.replaceAll('-', '_');

    await _stt.startListening(
      onResult: _onSttResult,
      localeId: localeId,
    );
  }

  void _onSttResult(SpeechRecognitionResult result) {
    _recognizedText = result.recognizedWords;
    if (result.finalResult) {
      textController.text = _recognizedText;
      _isListening = false;
      // Auto-lookup dictionary
      lookUpWord();
    }
    notifyListeners();
  }

  Future<void> stopListening() async {
    await _stt.stopListening();
    _isListening = false;
    notifyListeners();
  }

  // ── Dictionary ──
  Future<void> lookUpWord() async {
    if (currentWord.isEmpty) {
      _dictionaryEntry = null;
      notifyListeners();
      return;
    }

    _isLoadingDefinition = true;
    notifyListeners();

    // Extract 2-letter lang code from locale (e.g. 'en-US' → 'en').
    final langCode = _selectedLanguage.code.split('-').first;
    _dictionaryEntry = await _dictionary.lookUp(currentWord, langCode: langCode);

    _isLoadingDefinition = false;
    notifyListeners();
  }

  void setDictionaryTab(int index) {
    _dictionaryTabIndex = index;
    notifyListeners();
  }

  // ── Favorites ──
  bool isFavorite(String word) => _favorites.contains(word.toLowerCase());

  void toggleFavorite(String word) {
    final w = word.toLowerCase();
    if (_favorites.contains(w)) {
      _favorites.remove(w);
    } else {
      _favorites.add(w);
    }
    _savePreferences();
    notifyListeners();
  }

  // ── Clear ──
  void clearInput() {
    textController.clear();
    _dictionaryEntry = null;
    _recognizedText = '';
    notifyListeners();
  }

  /// Letter-by-letter spelling of the current word.
  String get letterSpelling {
    if (currentWord.isEmpty) return '';
    return currentWord.split('').join(' – ').toUpperCase();
  }

  @override
  void dispose() {
    textController.dispose();
    _tts.dispose();
    super.dispose();
  }
}

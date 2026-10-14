/// Supported language model with metadata for the language selector.
class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String ttsLocale;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.ttsLocale,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLanguage &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

/// Pre-defined list of supported languages.
class SupportedLanguages {
  SupportedLanguages._();

  static const List<AppLanguage> all = [
    AppLanguage(
      code: 'en-US',
      name: 'English (US)',
      nativeName: 'English',
      flag: '🇺🇸',
      ttsLocale: 'en-US',
    ),
    AppLanguage(
      code: 'en-GB',
      name: 'English (UK)',
      nativeName: 'English',
      flag: '🇬🇧',
      ttsLocale: 'en-GB',
    ),
    AppLanguage(
      code: 'fr-FR',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
      ttsLocale: 'fr-FR',
    ),
    AppLanguage(
      code: 'es-ES',
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
      ttsLocale: 'es-ES',
    ),
    AppLanguage(
      code: 'de-DE',
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
      ttsLocale: 'de-DE',
    ),
    AppLanguage(
      code: 'it-IT',
      name: 'Italian',
      nativeName: 'Italiano',
      flag: '🇮🇹',
      ttsLocale: 'it-IT',
    ),
    AppLanguage(
      code: 'pt-BR',
      name: 'Portuguese (BR)',
      nativeName: 'Português',
      flag: '🇧🇷',
      ttsLocale: 'pt-BR',
    ),
    AppLanguage(
      code: 'ja-JP',
      name: 'Japanese',
      nativeName: '日本語',
      flag: '🇯🇵',
      ttsLocale: 'ja-JP',
    ),
    AppLanguage(
      code: 'zh-CN',
      name: 'Chinese (Simplified)',
      nativeName: '中文',
      flag: '🇨🇳',
      ttsLocale: 'zh-CN',
    ),
    AppLanguage(
      code: 'ko-KR',
      name: 'Korean',
      nativeName: '한국어',
      flag: '🇰🇷',
      ttsLocale: 'ko-KR',
    ),
    AppLanguage(
      code: 'ar-SA',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
      ttsLocale: 'ar-SA',
    ),
    AppLanguage(
      code: 'hi-IN',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flag: '🇮🇳',
      ttsLocale: 'hi-IN',
    ),
    AppLanguage(
      code: 'ru-RU',
      name: 'Russian',
      nativeName: 'Русский',
      flag: '🇷🇺',
      ttsLocale: 'ru-RU',
    ),
    AppLanguage(
      code: 'sw-KE',
      name: 'Swahili',
      nativeName: 'Kiswahili',
      flag: '🇰🇪',
      ttsLocale: 'sw-KE',
    ),
  ];
}

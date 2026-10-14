import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dictionary_model.dart';

/// Service for querying the Free Dictionary API.
class DictionaryService {
  static const String _baseUrl =
      'https://api.dictionaryapi.dev/api/v2/entries';

  /// Look up a word in a given language.
  /// [langCode] should be a 2-letter ISO code (e.g., 'en', 'fr', 'es').
  Future<DictionaryEntry?> lookUp(String word, {String langCode = 'en'}) async {
    if (word.trim().isEmpty) return null;

    final url = Uri.parse('$_baseUrl/$langCode/${Uri.encodeComponent(word.trim())}');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return DictionaryEntry.fromJson(data.first as Map<String, dynamic>);
        }
      }
    } catch (_) {
      // Network error or timeout — return null gracefully.
    }
    return null;
  }
}

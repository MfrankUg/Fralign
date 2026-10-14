/// Dictionary entry model parsed from Free Dictionary API responses.
class DictionaryEntry {
  final String word;
  final String? phonetic;
  final List<PhoneticEntry> phonetics;
  final List<MeaningEntry> meanings;
  final String? sourceUrl;

  const DictionaryEntry({
    required this.word,
    this.phonetic,
    this.phonetics = const [],
    this.meanings = const [],
    this.sourceUrl,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      word: json['word'] ?? '',
      phonetic: json['phonetic'],
      phonetics: (json['phonetics'] as List<dynamic>?)
              ?.map((p) => PhoneticEntry.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      meanings: (json['meanings'] as List<dynamic>?)
              ?.map((m) => MeaningEntry.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      sourceUrl: (json['sourceUrls'] as List<dynamic>?)?.firstOrNull as String?,
    );
  }

  /// Best phonetic text available.
  String get bestPhonetic {
    if (phonetic != null && phonetic!.isNotEmpty) return phonetic!;
    for (final p in phonetics) {
      if (p.text != null && p.text!.isNotEmpty) return p.text!;
    }
    return '';
  }

  /// First audio URL available.
  String? get audioUrl {
    for (final p in phonetics) {
      if (p.audio != null && p.audio!.isNotEmpty) return p.audio!;
    }
    return null;
  }

  /// All unique synonyms across meanings.
  List<String> get allSynonyms {
    final syns = <String>{};
    for (final m in meanings) {
      syns.addAll(m.synonyms);
      for (final d in m.definitions) {
        syns.addAll(d.synonyms);
      }
    }
    return syns.toList();
  }
}

class PhoneticEntry {
  final String? text;
  final String? audio;
  final String? sourceUrl;

  const PhoneticEntry({this.text, this.audio, this.sourceUrl});

  factory PhoneticEntry.fromJson(Map<String, dynamic> json) {
    return PhoneticEntry(
      text: json['text'],
      audio: json['audio'],
      sourceUrl: json['sourceUrl'],
    );
  }
}

class MeaningEntry {
  final String partOfSpeech;
  final List<DefinitionEntry> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  const MeaningEntry({
    required this.partOfSpeech,
    this.definitions = const [],
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory MeaningEntry.fromJson(Map<String, dynamic> json) {
    return MeaningEntry(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((d) => DefinitionEntry.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
      antonyms: (json['antonyms'] as List<dynamic>?)
              ?.map((a) => a.toString())
              .toList() ??
          [],
    );
  }
}

class DefinitionEntry {
  final String definition;
  final String? example;
  final List<String> synonyms;
  final List<String> antonyms;

  const DefinitionEntry({
    required this.definition,
    this.example,
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory DefinitionEntry.fromJson(Map<String, dynamic> json) {
    return DefinitionEntry(
      definition: json['definition'] ?? '',
      example: json['example'],
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
      antonyms: (json['antonyms'] as List<dynamic>?)
              ?.map((a) => a.toString())
              .toList() ??
          [],
    );
  }
}

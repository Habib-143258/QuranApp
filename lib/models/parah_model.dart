class ParahModel {
  final int id;
  final int juzNumber;
  final String? juzName;
  final String? juzNameSimple;
  final Map<String, String>? verseMapping;
  final int? firstVerseId;
  final int? lastVerseId;
  final int? versesCount;

  ParahModel({
    required this.id,
    required this.juzNumber,
    this.juzName,
    this.juzNameSimple,
    this.verseMapping,
    this.firstVerseId,
    this.lastVerseId,
    this.versesCount,
  });

  factory ParahModel.fromJson(Map<String, dynamic> json) {
    return ParahModel(
      id: json['id'] ?? 0,
      juzNumber: json['juz_number'] ?? 0,
      juzName: json['juz_name'] ?? '',
      juzNameSimple: json['juz_name_simple'] ?? '',
      verseMapping: json['verse_mapping'] != null
          ? Map<String, String>.from(json['verse_mapping'])
          : null,
      firstVerseId: json['first_verse_id'],
      lastVerseId: json['last_verse_id'],
      versesCount: json['verses_count'],
    );
  }
}

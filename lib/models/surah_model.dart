class SurahModel {
  final int id;
  final String nameSimple;
  final String nameComplex;
  final String nameArabic;
  final String revelationPlace;
  final int versesCount;

  SurahModel({
    required this.id,
    required this.nameSimple,
    required this.nameComplex,
    required this.nameArabic,
    required this.revelationPlace,
    required this.versesCount,
  });

  // Getters for compatibility with widget
  int get number => id;
  String get name => nameArabic;
  String get englishName => nameSimple;
  String get englishNameTranslation => nameComplex;
  String get revelationType {
    if (revelationPlace.toLowerCase() == 'makkah') {
      return 'Meccan';
    } else if (revelationPlace.toLowerCase() == 'madinah') {
      return 'Medinan';
    }
    return revelationPlace;
  }

  int get numberOfAyahs => versesCount;

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] ?? 0,
      nameSimple: json['name_simple'] ?? '',
      nameComplex: json['name_complex'] ?? '',
      nameArabic: json['name_arabic'] ?? '',
      revelationPlace: json['revelation_place'] ?? 'makkah',
      versesCount: json['verses_count'] ?? 0,
    );
  }
}

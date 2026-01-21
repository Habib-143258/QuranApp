class SurahModel {
  final int? id;
  final String nameSimple;
  final String nameComplex;
  final String nameArabic;
  final String nameArabicLong;
  final String revelationPlace;
  final int versesCount;

  SurahModel({
    this.id,
    required this.nameSimple,
    required this.nameComplex,
    required this.nameArabic,
    required this.nameArabicLong,
    required this.revelationPlace,
    required this.versesCount,
  });

  // Getters for compatibility with widget
  int get number => id ?? 0;
  String get name => nameArabic;
  String get englishName => nameSimple;
  String get englishNameTranslation => nameComplex;
  String get revelationType {
    if (revelationPlace.toLowerCase().contains('mecca') ||
        revelationPlace.toLowerCase() == 'makkah') {
      return 'Meccan';
    } else if (revelationPlace.toLowerCase().contains('medina') ||
        revelationPlace.toLowerCase() == 'madinah') {
      return 'Medinan';
    }
    return revelationPlace;
  }

  int get numberOfAyahs => versesCount;

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'],
      nameSimple: json['surahName'] ?? '',
      nameComplex: json['surahNameTranslation'] ?? '',
      nameArabic: json['surahNameArabic'] ?? '',
      nameArabicLong: json['surahNameArabicLong'] ?? '',
      revelationPlace: json['revelationPlace'] ?? 'Mecca',
      versesCount: json['totalAyah'] ?? 0,
    );
  }
}

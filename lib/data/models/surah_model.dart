class SurahModel {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final String nameUrdu;
  final int versesCount;

  SurahModel({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameUrdu,
    required this.versesCount,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'],
      nameArabic: json['name_arabic'],
      nameEnglish: json['name_simple'],
      nameUrdu: json['translated_name']?['name'] ?? '',
      versesCount: json['verses_count'],
    );
  }
}

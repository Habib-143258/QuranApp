import 'package:flutter/foundation.dart';

class VerseModel {
  final int verseNumber;
  final String arabic;
  final String urdu;

  VerseModel({
    required this.verseNumber,
    required this.arabic,
    required this.urdu,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      verseNumber: json['verse_number'],
      arabic: json['text_indopak'],
      urdu: json['text_urdu'],
    );
  }
}

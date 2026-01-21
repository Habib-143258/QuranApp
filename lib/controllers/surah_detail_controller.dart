// import 'package:get/get.dart';
// import 'package:quran_app/config/url_config.dart';
// import 'package:quran_app/models/surah_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SurahDetailController extends GetxController {
//   final SurahModel surah;
//   final isLoading = false.obs;
//   final ayahList = <Map<String, dynamic>>[].obs;

//   // Additional data from API
//   final surahMetadata = <String, dynamic>{}.obs;
//   final audioData = <String, dynamic>{}.obs;
//   final availableLanguages = <String>[].obs;
//   final selectedLanguage = 'english'.obs;

//   SurahDetailController({required this.surah});

//   @override
//   void onInit() {
//     super.onInit();
//     fetchAyahs();
//   }

//   Future<void> fetchAyahs() async {
//     try {
//       isLoading(true);
//       final urlConfig = NewUrlClass(languageCode: 'en');
//       final surahId = surah.id ?? 0;
//       final url = urlConfig.getAyatListApi(sectionID: surahId);
//       print('Fetching verses from: $url');

//       final response = await http.get(Uri.parse(url));
//       print('Ayahs Response status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = json.decode(response.body);

//         // Store metadata
//         surahMetadata.value = {
//           'surahName': jsonResponse['surahName'],
//           'surahNameArabic': jsonResponse['surahNameArabic'],
//           'surahNameArabicLong': jsonResponse['surahNameArabicLong'],
//           'surahNameTranslation': jsonResponse['surahNameTranslation'],
//           'revelationPlace': jsonResponse['revelationPlace'],
//           'totalAyah': jsonResponse['totalAyah'],
//           'surahNo': jsonResponse['surahNo'],
//         };

//         // Store audio data
//         audioData.value = jsonResponse['audio'] ?? {};

//         // Extract all language keys
//         final languageKeys = [
//           'english',
//           'urdu',
//           'bengali',
//           'arabic1',
//           'arabic2',
//         ];
//         availableLanguages.value = languageKeys
//             .where((lang) => jsonResponse.containsKey(lang))
//             .toList();

//         // Extract verses with all language translations
//         final arabicData = jsonResponse['arabic1'] as List<dynamic>? ?? [];

//         List<Map<String, dynamic>> verses = [];
//         final totalAyah = jsonResponse['totalAyah'] ?? 0;

//         for (int i = 0; i < totalAyah; i++) {
//           Map<String, dynamic> verseData = {
//             'numberInSurah': i + 1,
//             'arabic1': i < arabicData.length ? arabicData[i] : '',
//           };

//           // Add all available language translations
//           for (String lang in availableLanguages.value) {
//             final langData = jsonResponse[lang] as List<dynamic>? ?? [];
//             verseData[lang] = i < langData.length ? langData[i] : '';
//           }

//           verses.add(verseData);
//         }

//         print(
//           'Parsed ${verses.length} verses with ${availableLanguages.length} languages',
//         );
//         ayahList.value = verses;
//       } else {
//         print('Error status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching Ayahs: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';

class SurahDetailController extends GetxController {
  final SurahModel surah;
  SurahDetailController({required this.surah});

  var isLoading = true.obs;
  var ayahList = <Map<String, dynamic>>[].obs;

  var availableLanguages = <String>['urdu', 'english'].obs;
  var selectedLanguage = 'urdu'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAyahs();
  }

  Future<void> fetchAyahs() async {
    try {
      isLoading.value = true;
      final url = Uri.parse(
        'https://quranapi.pages.dev/api/${surah.number}.json',
      );
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final parsedAyahs = await compute(_parseAyahs, res.body);
        ayahList.assignAll(parsedAyahs);
      } else {
        ayahList.clear();
      }
    } catch (e) {
      ayahList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  static List<Map<String, dynamic>> _parseAyahs(String body) {
    final data = json.decode(body);
    final arabic = List<String>.from(data['arabic1']);
    final urdu = List<String>.from(data['urdu']);
    final english = List<String>.from(data['english']);
    final audioData = data['audio'] as Map<String, dynamic>;

    List<Map<String, dynamic>> ayahs = [];
    for (int i = 0; i < arabic.length; i++) {
      ayahs.add({
        'numberInSurah': i + 1,
        'arabic1': arabic[i],
        'urdu': urdu[i],
        'english': english[i],
        'audio': audioData['${i + 1}'] ?? null,
      });
    }
    return ayahs;
  }
}

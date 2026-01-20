import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quran_app/config/url_config.dart';
import 'package:quran_app/data/models/surah_model.dart';
import 'package:quran_app/data/models/verse_model.dart';

class QuranApiService {
  final NewUrlClass url = NewUrlClass(languageCode: "?language=ur");

  // QuranApiService({required this.url});

  // Future<List<SurahModel>> getSurahList() async {
  //   final response = await http.get(Uri.parse(url.getSurahListApi()));

  //   final decoded = jsonDecode(response.body);
  //   final List list = decoded['data']['chapters'];

  //   return list.map((e) => SurahModel.fromJson(e)).toList();
  // }

  Future<List<SurahModel>> getSurahList() async {
    final response = await http.get(Uri.parse(url.getSurahListApi()));

    if (response.statusCode != 200) {
      throw Exception("Failed to load surahs");
    }

    final decoded = jsonDecode(response.body);

    final List list = decoded['chapters']; // ✅ FIXED

    return list.map((e) => SurahModel.fromJson(e)).toList();
  }

  Future<List<VerseModel>> getVersesBySurah(int surahId) async {
    final response = await http.get(
      Uri.parse(url.getAyatListApi(sectionID: surahId)),
    );
    final data = jsonDecode(response.body);
    final List list = data['verses'];
    return list.map((e) => VerseModel.fromJson(e)).toList();
  }
}

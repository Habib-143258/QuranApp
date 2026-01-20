import 'package:get/get.dart';
import 'package:quran_app/config/url_config.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurahDetailController extends GetxController {
  final SurahModel surah;
  final isLoading = false.obs;
  final ayahList = <Map<String, dynamic>>[].obs;

  SurahDetailController({required this.surah});

  @override
  void onInit() {
    super.onInit();
    fetchAyahs();
  }

  Future<void> fetchAyahs() async {
    try {
      isLoading(true);
      final urlConfig = NewUrlClass(languageCode: 'en');
      final url = urlConfig.getAyatListApi(sectionID: surah.id);
      print('Fetching verses from: $url');

      final response = await http.get(Uri.parse(url));
      print('Ayahs Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> verses = jsonResponse['verses'] ?? [];

        print('Parsed ${verses.length} verses');
        ayahList.value = verses
            .map((verse) => verse as Map<String, dynamic>)
            .toList();
      } else {
        print('Error status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Ayahs: $e');
    } finally {
      isLoading(false);
    }
  }
}

import 'package:get/get.dart';
import 'package:quran_app/config/url_config.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/models/parah_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReadingController extends GetxController {
  final isLoading = false.obs;
  final surahList = <SurahModel>[].obs;
  final parahList = <ParahModel>[].obs;
  final selectedFilter = 'surah'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSurahList();
  }

  Future<void> fetchSurahList() async {
    try {
      isLoading(true);
      final urlConfig = NewUrlClass(languageCode: 'en');
      final url = urlConfig.getSurahListApi();
      print('Fetching Surahs from: $url');

      final response = await http.get(Uri.parse(url));
      print('Surahs Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        print('Parsed ${jsonResponse.length} surahs');
        surahList.value = jsonResponse.asMap().entries.map((entry) {
          final index = entry.key;
          final surah = entry.value as Map<String, dynamic>;
          // Add the ID based on array index (1-indexed)
          surah['id'] = index + 1;
          return SurahModel.fromJson(surah);
        }).toList();
        print('Surah list updated: ${surahList.length}');
      } else {
        print('Error status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Surahs: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchParahList() async {
    try {
      isLoading(true);
      final urlConfig = NewUrlClass(languageCode: 'en');
      final url = urlConfig.getParahListApi();
      print('Fetching Parahs from: $url');

      final response = await http.get(Uri.parse(url));
      print('Parahs Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> parahs = jsonResponse['parahs'] ?? [];

        print('Parsed ${parahs.length} parahs');
        parahList.value = parahs
            .map((parah) => ParahModel.fromJson(parah as Map<String, dynamic>))
            .toList();
        print('Parah list updated: ${parahList.length}');
      } else {
        print('Error status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Parahs: $e');
    } finally {
      isLoading(false);
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    if (filter == 'surah') {
      fetchSurahList();
    } else {
      fetchParahList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<dynamic> getFilteredItems() {
    if (selectedFilter.value == 'surah') {
      return getFilteredSurahs();
    } else {
      return getFilteredParahs();
    }
  }

  List<SurahModel> getFilteredSurahs() {
    if (searchQuery.isEmpty) {
      return surahList.toList();
    }
    return surahList
        .where(
          (surah) =>
              (surah.englishName?.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ??
                  false) ||
              (surah.name?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                  false),
        )
        .toList();
  }

  List<ParahModel> getFilteredParahs() {
    if (searchQuery.isEmpty) {
      return parahList.toList();
    }
    return parahList
        .where(
          (parah) =>
              parah.juzNumber.toString().contains(searchQuery.toLowerCase()) ||
              (parah.juzNameSimple?.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ??
                  false) ||
              (parah.juzName?.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }
}

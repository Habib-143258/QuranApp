import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/data/models/surah_model.dart';
import 'package:quran_app/data/models/verse_model.dart';
import 'package:quran_app/data/services/quran_api_service.dart';

class QuranController extends GetxController {
  final QuranApiService apiService = QuranApiService();

  // QuranController(this.api);

  var surahList = <SurahModel>[].obs;
  var verses = <VerseModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSurahs();
  }

  // Future<void> fetchSurahs() async {
  //   try {
  //     isLoading.value = true;
  //     surahList.value = await api.getSurahList();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchSurahs() async {
    print("Fetching Surahs...");
    try {
      isLoading.value = true;
      // final result = await api.getSurahList();
      surahList.value = await apiService.getSurahList();
      print("Surah Count: ${surahList.length}");
      // surahList.assignAll(result);
    } catch (e) {
      error.value = e.toString();
      debugPrint("ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVerses(int surahId) async {
    try {
      isLoading.value = true;
      verses.value = await apiService.getVersesBySurah(surahId);
    } finally {
      isLoading.value = false;
    }
  }
}

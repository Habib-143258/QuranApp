import 'package:get/get.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/data/services/api_service.dart';
import 'package:quran_app/data/services/hive_service.dart';

class SurahDetailController extends GetxController {
  final SurahModel surah;
  final isLoading = false.obs;
  final ayahList = <Map<String, dynamic>>[].obs;

  // Additional data from API
  final surahMetadata = <String, dynamic>{}.obs;
  final audioData = <String, dynamic>{}.obs;
  final availableLanguages = <String>[].obs;
  final selectedLanguage = 'english'.obs;

  final _apiService = ApiService();
  final _hiveService = HiveService();

  SurahDetailController({required this.surah});

  @override
  void onInit() {
    super.onInit();
    fetchAyahs();
  }

  /// Fetch surah verses: API → compute() → Hive → UI
  Future<void> fetchAyahs() async {
    try {
      isLoading(true);
      final surahId = surah.id ?? 0;

      // Check if data exists in Hive cache
      if (_hiveService.hasSurahDetail(surahId)) {
        print('📱 Loading surah detail from Hive cache');
        final cached = _hiveService.getSurahDetail(surahId);
        if (cached != null) {
          _processAndDisplaySurahData(cached);
          print('✅ Loaded surah detail from cache');
        }
      }

      // Fetch from API with compute() for background parsing
      final response = await _apiService.fetchSurahDetail(surahId);

      if (response.isSuccess && response.data != null) {
        // Save to Hive
        await _hiveService.saveSurahDetail(surahId, response.data!);
        await _hiveService.setCacheTime('surah_$surahId', DateTime.now());

        // Process and display
        _processAndDisplaySurahData(response.data!);
        print('✅ Updated UI with surah verses');
      } else {
        print('❌ Error: ${response.error}');
        if (ayahList.isEmpty) {
          Get.snackbar('Error', 'Failed to load verses');
        }
      }
    } catch (e) {
      print('❌ Exception: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Process and display surah data
  void _processAndDisplaySurahData(Map<String, dynamic> data) {
    // Store metadata
    surahMetadata.value = {
      'surahName': data['surahName'],
      'surahNameArabic': data['surahNameArabic'],
      'surahNameArabicLong': data['surahNameArabicLong'],
      'surahNameTranslation': data['surahNameTranslation'],
      'revelationPlace': data['revelationPlace'],
      'totalAyah': data['totalAyah'],
      'surahNo': data['surahNo'],
    };

    // Store audio data
    audioData.value = data['audio'] ?? {};

    // Extract all language keys
    final languageKeys = ['english', 'urdu', 'bengali', 'arabic1', 'arabic2'];
    availableLanguages.value = languageKeys
        .where((lang) => data.containsKey(lang))
        .toList();

    // Extract verses with all language translations
    final arabicData = data['arabic1'] as List<dynamic>? ?? [];

    List<Map<String, dynamic>> verses = [];
    final totalAyah = data['totalAyah'] ?? 0;

    for (int i = 0; i < totalAyah; i++) {
      Map<String, dynamic> verseData = {
        'numberInSurah': i + 1,
        'arabic1': i < arabicData.length ? arabicData[i] : '',
      };

      // Add all available language translations
      for (String lang in availableLanguages.value) {
        final langData = data[lang] as List<dynamic>? ?? [];
        verseData[lang] = i < langData.length ? langData[i] : '';
      }

      verses.add(verseData);
    }

    ayahList.value = verses;
    print(
      '✅ Processed ${verses.length} verses with ${availableLanguages.length} languages',
    );
  }
}

import 'package:get/get.dart';
import 'package:quran_app/data/services/api_service.dart';
import 'package:quran_app/data/services/hive_service.dart';

class ParahDetailController extends GetxController {
  final juzNumber = 1.obs;
  final juzName = ''.obs;
  final ayahList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedLanguage = 'urdu'.obs;
  final availableLanguages = <String>[].obs;

  final _apiService = ApiService();
  final _hiveService = HiveService();

  /// Fetch Parah detail: API → compute() → Hive → UI
  Future<void> fetchParahDetail(
    int juzNum, {
    String translation = "ur.ahmedali",
  }) async {
    try {
      isLoading(true);
      juzNumber(juzNum);

      // Check if data exists in Hive cache
      if (_hiveService.hasParahData(juzNum)) {
        print('📱 Loading Parah $juzNum from Hive cache');
        final cachedData = _hiveService.getParahData(juzNum);
        if (cachedData != null) {
          _processAndDisplayParahData(cachedData);
          print('✅ Loaded Parah $juzNum from cache');
        }
      }

      // Fetch from API with compute() for background parsing
      final response = await _apiService.fetchParahData(
        juzNum,
        translation: translation,
      );

      if (response.isSuccess && response.data != null) {
        // Save to Hive
        await _hiveService.saveParahData(juzNum, response.data!);

        // Process and display
        _processAndDisplayParahData(response.data!);
        print('✅ Updated UI with Parah $juzNum verses');
      } else {
        print('❌ Error: ${response.error}');
        if (ayahList.isEmpty) {
          Get.snackbar('Error', 'Failed to load parah verses');
        }
      }
    } catch (e) {
      print('❌ Exception: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Process and display Parah data
  void _processAndDisplayParahData(Map<String, dynamic> data) {
    try {
      // Extract metadata
      juzName.value = data['name'] ?? 'Juz ${juzNumber.value}';

      // Extract verses
      final ayahsData = data['ayahs'] as List? ?? [];
      final verses = <Map<String, dynamic>>[];

      for (var ayah in ayahsData) {
        if (ayah is Map) {
          final verse = {
            'numberInSurah': ayah['numberInSurah'] ?? ayah['number'] ?? 0,
            'arabic': ayah['text'] ?? '',
            'urdu': ayah['translation'] ?? ayah['transliteration'] ?? '',
            'english': ayah['englishName'] ?? '',
            'surah': ayah['surah'] ?? {},
          };
          verses.add(verse);
        }
      }

      ayahList.value = verses;

      // Set available languages
      availableLanguages.value = ['Arabic', 'Urdu'];
      selectedLanguage.value = 'urdu';

      print(
        '✅ Processed ${verses.length} verses from Parah ${juzNumber.value}',
      );
    } catch (e) {
      print('❌ Error processing Parah data: $e');
    }
  }

  /// Get display text for verse based on selected language
  String getVerseText(Map<String, dynamic> verse) {
    switch (selectedLanguage.value.toLowerCase()) {
      case 'arabic':
        return verse['arabic'] ?? '';
      case 'urdu':
        return verse['urdu'] ?? '';
      case 'english':
        return verse['english'] ?? '';
      default:
        return verse['urdu'] ?? '';
    }
  }

  /// Change selected language
  void setLanguage(String language) {
    selectedLanguage.value = language;
  }

  /// Navigate to next Parah
  void nextParah() {
    if (juzNumber.value < 30) {
      fetchParahDetail(juzNumber.value + 1);
    } else {
      Get.snackbar('Info', 'This is the last Juz');
    }
  }

  /// Navigate to previous Parah
  void previousParah() {
    if (juzNumber.value > 1) {
      fetchParahDetail(juzNumber.value - 1);
    } else {
      Get.snackbar('Info', 'This is the first Juz');
    }
  }
}

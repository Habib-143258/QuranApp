import 'package:get/get.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/models/parah_model.dart';
import 'package:quran_app/data/services/api_service.dart';
import 'package:quran_app/data/services/hive_service.dart';

class ReadingController extends GetxController {
  final isLoading = false.obs;
  final surahList = <SurahModel>[].obs;
  final parahList = <ParahModel>[].obs;
  final selectedFilter = 'surah'.obs;
  final searchQuery = ''.obs;

  final _apiService = ApiService();
  final _hiveService = HiveService();

  @override
  void onInit() {
    super.onInit();
    fetchSurahList();
  }

  /// Fetch surah list: API → compute() → Hive → UI
  Future<void> fetchSurahList() async {
    try {
      isLoading(true);

      // Check if data exists in Hive cache
      if (_hiveService.hasSurahList()) {
        print('📱 Loading surahs from Hive cache');
        final cachedSurahs = _hiveService.getSurahList();
        surahList.value = cachedSurahs
            .map((surah) => SurahModel.fromJson(surah))
            .toList();
        print('✅ Loaded ${surahList.length} surahs from cache');
      }

      // Fetch from API with compute() for background parsing
      final response = await _apiService.fetchSurahList();

      if (response.isSuccess && response.data != null) {
        // Add IDs and save to Hive
        final surahsWithId = response.data!.asMap().entries.map((entry) {
          final surah = entry.value;
          surah['id'] = entry.key + 1;
          return surah;
        }).toList();

        // Save to Hive
        await _hiveService.saveSurahList(surahsWithId);
        await _hiveService.setCacheTime('surahs', DateTime.now());

        // Update UI
        surahList.value = surahsWithId
            .map((surah) => SurahModel.fromJson(surah))
            .toList();
        print('✅ Updated UI with ${surahList.length} surahs');
      } else {
        print('❌ Error: ${response.error}');
        if (surahList.isEmpty) {
          // Show error only if cache is also empty
          Get.snackbar('Error', 'Failed to load surahs');
        }
      }
    } catch (e) {
      print('❌ Exception: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchParahList() async {
    try {
      isLoading(true);

      // Check if all Parah data is cached and still valid (within 24 hours)
      final parahCacheKey = 'parah_list_cache_time';
      final isCacheValid = _hiveService.isCacheValid(parahCacheKey);

      if (isCacheValid && _hiveService.hasParahData(1)) {
        print('📱 Loading Parahs from Hive cache (cache still valid)');
        final parahList = <ParahModel>[];
        for (int i = 1; i <= 30; i++) {
          final cachedParah = _hiveService.getParahData(i);
          if (cachedParah != null) {
            final transformed = _transformParahResponse(cachedParah, i);
            parahList.add(ParahModel.fromJson(transformed));
          }
        }
        this.parahList.value = parahList;
        print('✅ Loaded ${parahList.length} parahs from cache - NO API CALLS');
        isLoading(false);
        return; // Exit early - don't fetch from API
      }

      // Load from cache first (even if expired) to show immediately
      if (_hiveService.hasParahData(1)) {
        print('📱 Loading expired cache while fetching fresh data...');
        final parahList = <ParahModel>[];
        for (int i = 1; i <= 30; i++) {
          final cachedParah = _hiveService.getParahData(i);
          if (cachedParah != null) {
            final transformed = _transformParahResponse(cachedParah, i);
            parahList.add(ParahModel.fromJson(transformed));
          }
        }
        this.parahList.value = parahList;
        print('✅ Showing stale cache: ${parahList.length} parahs');
      }

      // Fetch fresh data in background (don't block UI)
      print('🌐 Fetching fresh Parah data (30 Juz)...');
      final List<ParahModel> fetchedParahs = [];
      int successCount = 0;

      for (int juzNumber = 1; juzNumber <= 30; juzNumber++) {
        final response = await _apiService.fetchParahData(juzNumber);

        if (response.isSuccess && response.data != null) {
          successCount++;
          await _hiveService.saveParahData(juzNumber, response.data!);
          final transformed = _transformParahResponse(
            response.data!,
            juzNumber,
          );
          fetchedParahs.add(ParahModel.fromJson(transformed));
        } else {
          print('⚠️ Error fetching Parah $juzNumber: ${response.error}');
        }
      }

      // Update cache timestamp only if all were fetched successfully
      if (successCount == 30) {
        await _hiveService.setCacheTime(parahCacheKey, DateTime.now());
        print('✅ All 30 Parahs fetched and cache updated');
      }

      if (fetchedParahs.isNotEmpty) {
        parahList.value = fetchedParahs;
        print('✅ Updated UI with ${fetchedParahs.length} parahs (fresh data)');
      } else if (parahList.isEmpty) {
        Get.snackbar('Error', 'Failed to load parahs');
      }
    } catch (e) {
      print('❌ Exception: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Transform alquran.cloud API response to ParahModel format
  Map<String, dynamic> _transformParahResponse(
    Map<String, dynamic> data,
    int juzNumber,
  ) {
    final ayahs = data['ayahs'] as List? ?? [];
    final versesCount = ayahs.length;

    return {
      'id': juzNumber,
      'juz_number': juzNumber,
      'juz_name': data['name'] ?? 'Juz $juzNumber',
      'juz_name_simple': 'Juz $juzNumber',
      'verses_count': versesCount,
    };
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
              surah.englishName.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              surah.name.toLowerCase().contains(searchQuery.toLowerCase()),
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

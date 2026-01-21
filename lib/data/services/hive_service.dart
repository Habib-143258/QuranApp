import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  static const String surahBoxName = 'surahs';
  static const String surahDetailBoxName = 'surah_details';
  static const String parahBoxName = 'parahs';
  static const String cacheBoxName = 'cache';

  late Box<dynamic> _surahBox;
  late Box<dynamic> _surahDetailBox;
  late Box<dynamic> _parahBox;
  late Box<dynamic> _cacheBox;

  /// Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
    _surahBox = await Hive.openBox(surahBoxName);
    _surahDetailBox = await Hive.openBox(surahDetailBoxName);
    _parahBox = await Hive.openBox(parahBoxName);
    _cacheBox = await Hive.openBox(cacheBoxName);
    print('✅ Hive initialized successfully');
  }

  /// Save surah list to cache
  Future<void> saveSurahList(List<Map<String, dynamic>> surahs) async {
    await _surahBox.clear();
    for (int i = 0; i < surahs.length; i++) {
      surahs[i]['id'] = i + 1; // Add ID based on index
      await _surahBox.put(i + 1, surahs[i]);
    }
    print('💾 Saved ${surahs.length} surahs to Hive');
  }

  /// Get surah list from cache
  List<Map<String, dynamic>> getSurahList() {
    final surahs = <Map<String, dynamic>>[];
    for (var surah in _surahBox.values) {
      surahs.add(Map<String, dynamic>.from(surah as Map));
    }
    return surahs;
  }

  /// Check if surah list exists in cache
  bool hasSurahList() {
    return _surahBox.isNotEmpty;
  }

  /// Save surah detail (verses)
  Future<void> saveSurahDetail(int surahId, Map<String, dynamic> detail) async {
    await _surahDetailBox.put(surahId, detail);
    print('💾 Saved surah detail for ID: $surahId');
  }

  /// Get surah detail from cache
  Map<String, dynamic>? getSurahDetail(int surahId) {
    final detail = _surahDetailBox.get(surahId);
    if (detail != null) {
      return Map<String, dynamic>.from(detail as Map);
    }
    return null;
  }

  /// Check if surah detail exists in cache
  bool hasSurahDetail(int surahId) {
    return _surahDetailBox.containsKey(surahId);
  }

  /// Save Parah/Juz data to cache
  Future<void> saveParahData(
    int juzNumber,
    Map<String, dynamic> parahData,
  ) async {
    await _parahBox.put(juzNumber, parahData);
    print('💾 Saved Parah data for Juz: $juzNumber');
  }

  /// Get Parah/Juz data from cache
  Map<String, dynamic>? getParahData(int juzNumber) {
    final data = _parahBox.get(juzNumber);
    if (data != null) {
      return Map<String, dynamic>.from(data as Map);
    }
    return null;
  }

  /// Check if Parah data exists in cache
  bool hasParahData(int juzNumber) {
    return _parahBox.containsKey(juzNumber);
  }

  /// Clear all caches
  Future<void> clearAll() async {
    await _surahBox.clear();
    await _surahDetailBox.clear();
    await _parahBox.clear();
    await _cacheBox.clear();
    print('🗑️ All Hive data cleared');
  }

  /// Get cache metadata
  Future<void> setCacheTime(String key, DateTime time) async {
    await _cacheBox.put('${key}_time', time.toIso8601String());
  }

  /// Get last cache time
  DateTime? getCacheTime(String key) {
    final timeStr = _cacheBox.get('${key}_time') as String?;
    if (timeStr != null) {
      return DateTime.parse(timeStr);
    }
    return null;
  }

  /// Check if cache is still valid (24 hours)
  bool isCacheValid(String key) {
    final cacheTime = getCacheTime(key);
    if (cacheTime == null) return false;
    final duration = DateTime.now().difference(cacheTime);
    return duration.inHours < 24;
  }
}

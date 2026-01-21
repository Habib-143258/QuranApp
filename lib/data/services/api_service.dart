import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/config/url_config.dart';

/// Model for API response
class ApiResponse<T> {
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({this.data, this.error, required this.statusCode});

  bool get isSuccess => statusCode == 200 && error == null;
}

/// Background computation for JSON parsing
Future<Map<String, dynamic>> _parseSurahJson(String jsonString) async {
  final parsed = json.decode(jsonString);
  return parsed as Map<String, dynamic>;
}

Future<List<Map<String, dynamic>>> _parseSurahListJson(
  String jsonString,
) async {
  final parsed = json.decode(jsonString);
  if (parsed is List) {
    return parsed.cast<Map<String, dynamic>>();
  }
  return [];
}

/// Parse Parah/Juz JSON response from alquran.cloud
Future<Map<String, dynamic>> _parseParahJson(String jsonString) async {
  final parsed = json.decode(jsonString);
  if (parsed is Map && parsed['data'] != null) {
    return parsed['data'] as Map<String, dynamic>;
  }
  return parsed as Map<String, dynamic>;
}

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  final urlConfig = NewUrlClass(languageCode: 'en');

  /// Fetch list of all surahs with background JSON parsing
  Future<ApiResponse<List<Map<String, dynamic>>>> fetchSurahList() async {
    try {
      final url = urlConfig.getSurahListApi();
      print('🌐 Fetching from: $url');

      final response = await http.get(Uri.parse(url));
      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Parse JSON in background using compute()
        final parsedList = await compute(_parseSurahListJson, response.body);
        print('✅ Parsed ${parsedList.length} surahs');

        return ApiResponse(data: parsedList, statusCode: 200);
      } else {
        return ApiResponse(
          error: 'Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error fetching surah list: $e');
      return ApiResponse(error: e.toString(), statusCode: 500);
    }
  }

  /// Fetch surah details with verses
  Future<ApiResponse<Map<String, dynamic>>> fetchSurahDetail(
    int surahId,
  ) async {
    try {
      final url = urlConfig.getAyatListApi(sectionID: surahId);
      print('🌐 Fetching surah detail from: $url');

      final response = await http.get(Uri.parse(url));
      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Parse JSON in background using compute()
        final parsed = await compute(_parseSurahJson, response.body);
        print('✅ Parsed surah detail with ${parsed['totalAyah']} verses');

        return ApiResponse(data: parsed, statusCode: 200);
      } else {
        return ApiResponse(
          error: 'Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error fetching surah detail: $e');
      return ApiResponse(error: e.toString(), statusCode: 500);
    }
  }

  /// Fetch Parah/Juz data with background JSON parsing
  Future<ApiResponse<Map<String, dynamic>>> fetchParahData(
    int juzNumber, {
    String translation = "ur.ahmedali",
  }) async {
    try {
      final url = NewUrlClass.getParahDataApi(
        juzNumber,
        translation: translation,
      );
      print('🌐 Fetching Parah $juzNumber from: $url');

      final response = await http.get(Uri.parse(url));
      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Parse JSON in background using compute()
        final parsed = await compute(_parseParahJson, response.body);
        print(
          '✅ Parsed Parah $juzNumber with ${(parsed['ayahs'] as List?)?.length ?? 0} verses',
        );

        return ApiResponse(data: parsed, statusCode: 200);
      } else {
        return ApiResponse(
          error: 'Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error fetching Parah: $e');
      return ApiResponse(error: e.toString(), statusCode: 500);
    }
  }
}

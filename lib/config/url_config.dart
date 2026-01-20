class UrlClass {
  static String baseurl2 = "https://portal.smpbuh.com";
  static String getAlllanguages = "$baseurl2/language/getalllanguages";
}

class NewUrlClass {
  String languageCode;

  NewUrlClass({this.languageCode = 'en'});

  static String baseurl2 = "https://portal.smpbuh.com";

  String buildUrl(String endpoint) {
    if (languageCode.isEmpty) {
      return "$baseurl2$endpoint";
    }
    return "$baseurl2$endpoint?language=$languageCode";
  }

  String getSurahListApi() {
    return buildUrl("/api/quran/chapters");
  }

  String getAyatListApi({required int sectionID}) {
    return buildUrl("/api/quran/verses?chapter_number=$sectionID");
  }

  String getParahListApi() {
    return buildUrl("/api/quran/parahs");
  }

  String getAllLanguages() {
    return buildUrl("/language/getalllanguages");
  }

  String getQuranAllVersesApi() {
    return buildUrl("/api/quran/verses");
  }
}

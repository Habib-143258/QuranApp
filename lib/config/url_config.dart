// class UrlClass {
//   static String baseurl2 = "https://portal.smpbuh.com";
//   static String getAlllanguages = "$baseurl2/language/getalllanguages";
// }

class NewUrlClass {
  String languageCode;

  NewUrlClass({this.languageCode = 'en'});

  static String baseurl2 = "https://quranapi.pages.dev/api";

  String buildUrl(String endpoint) {
    return "$baseurl2$endpoint";
  }

  String getSurahListApi() {
    return buildUrl("/surah.json");
  }

  String getAyatListApi({required int sectionID}) {
    return buildUrl("/$sectionID.json");
  }

  String getParahListApi() {
    return buildUrl("/juz.json");
  }

  String getParahDetailApi({required int juzNumber}) {
    return buildUrl("/juz/$juzNumber.json");
  }

  String getAllLanguages() {
    return buildUrl("/language/getalllanguages");
  }

  String getQuranAllVersesApi() {
    return buildUrl("/surah.json");
  }
}

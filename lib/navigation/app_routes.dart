import 'package:get/get.dart';
import 'package:quran_app/screens/main_shell.dart';
import 'package:quran_app/screens/home_screen.dart';
import 'package:quran_app/screens/explore_screen.dart';
import 'package:quran_app/screens/search_screen.dart';
import 'package:quran_app/screens/reading_screen.dart';
import 'package:quran_app/screens/settings_screen.dart';
import 'package:quran_app/screens/surah_detail_screen.dart';
import 'package:quran_app/bindings/main_binding.dart';

class AppRoutes {
  static const String main = '/main';
  static const String home = '/home';
  static const String reading = '/reading';
  static const String explore = '/explore';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String surahDetail = '/surah-detail';

  static final pages = [
    GetPage(
      name: main,
      page: () => const MainShell(),
      binding: MainBinding(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: reading,
      page: () => ReadingScreen(),
    ),
    GetPage(
      name: explore,
      page: () => ExploreScreen(),
    ),
    GetPage(
      name: search,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: settings,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: surahDetail,
      page: () {
        final surah = Get.arguments;
        return SurahDetailScreen(surah: surah);
      },
    ),
  ];
}

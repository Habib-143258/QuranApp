import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/main_controller.dart';
import 'package:quran_app/screens/home_screen.dart';
import 'package:quran_app/screens/explore_screen.dart';
import 'package:quran_app/screens/search_screen.dart';
import 'package:quran_app/screens/reading_screen.dart';
import 'package:quran_app/screens/settings_screen.dart';
import 'package:quran_app/widgets/custom_bottom_nav.dart';

class MainShell extends StatelessWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    final List<Widget> screens = [
      ReadingScreen(),
      ExploreScreen(),
      HomeScreen(),
      SearchScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: Obx(() => screens[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changeTab(index),
        ),
      ),
    );
  }
}

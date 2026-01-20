import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/widgets/reading/quran_header_widget.dart';
import 'package:quran_app/widgets/reading/search_surah_widget.dart';
import 'package:quran_app/widgets/reading/surah_filter_widget.dart';
import 'package:quran_app/widgets/reading/surah_list_widget.dart';
import 'package:quran_app/controllers/reading_controller.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(ReadingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const QuranHeaderWidget(),
            const SearchSurahWidget(),
            const SizedBox(height: 12),
            const SurahFilterWidget(),
            const SizedBox(height: 12),
            Expanded(child: const SurahListWidget()),
          ],
        ),
      ),
    );
  }
}

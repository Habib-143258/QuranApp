import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/reading_controller.dart';

class SearchSurahWidget extends StatelessWidget {
  const SearchSurahWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ReadingController controller = Get.find<ReadingController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        onChanged: (value) => controller.updateSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'Search Surah...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
        ),
      ),
    );
  }
}

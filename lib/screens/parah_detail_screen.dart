import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/parah_detail_controller.dart';
import 'package:quran_app/models/parah_model.dart';

class ParahDetailScreen extends StatefulWidget {
  final ParahModel parah;

  const ParahDetailScreen({Key? key, required this.parah}) : super(key: key);

  @override
  State<ParahDetailScreen> createState() => _ParahDetailScreenState();
}

class _ParahDetailScreenState extends State<ParahDetailScreen> {
  late ParahDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ParahDetailController());
    controller.fetchParahDetail(widget.parah.juzNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.juzName.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.ayahList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading verses...'),
              ],
            ),
          );
        }

        if (controller.ayahList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No verses found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchParahDetail(widget.parah.juzNumber);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Language selector
            _LanguageSelectorWidget(controller: controller),
            // Verses list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.ayahList.length,
                itemBuilder: (context, index) {
                  final verse = controller.ayahList[index];
                  return _VerseCardWidget(
                    verse: verse,
                    verseNumber: index + 1,
                    controller: controller,
                  );
                },
              ),
            ),
            // Bottom navigation
            _BottomNavigationWidget(controller: controller),
          ],
        );
      }),
    );
  }
}

/// Language selector widget
class _LanguageSelectorWidget extends StatelessWidget {
  final ParahDetailController controller;

  const _LanguageSelectorWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.availableLanguages.map((language) {
            final isSelected =
                controller.selectedLanguage.value.toLowerCase() ==
                language.toLowerCase();
            return FilterChip(
              label: Text(language),
              selected: isSelected,
              onSelected: (_) => controller.setLanguage(language),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF009688),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Individual verse card widget
class _VerseCardWidget extends StatelessWidget {
  final Map<String, dynamic> verse;
  final int verseNumber;
  final ParahDetailController controller;

  const _VerseCardWidget({
    required this.verse,
    required this.verseNumber,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse number and metadata
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF009688),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Verse $verseNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, size: 20),
                      onPressed: () {
                        Get.snackbar(
                          'Share',
                          'Share functionality coming soon',
                        );
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(0),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, size: 20),
                      onPressed: () {
                        Get.snackbar('Bookmark', 'Added to bookmarks');
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(0),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Arabic text
            if (verse['arabic'] != null &&
                verse['arabic'].toString().isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  verse['arabic'],
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 2,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Translation based on selected language
            Text(
              controller.getVerseText(verse),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom navigation widget for previous/next Parah
class _BottomNavigationWidget extends StatelessWidget {
  final ParahDetailController controller;

  const _BottomNavigationWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.previousParah(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.nextParah(),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009688),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

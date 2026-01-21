import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/surah_model.dart';
import '../controllers/surah_detail_controller.dart';

class SurahDetailScreen extends StatelessWidget {
  final SurahModel surah;

  const SurahDetailScreen({Key? key, required this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SurahDetailController(surah: surah));
    final showTranslation = true.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.ayahList.isEmpty) {
          return const Center(child: Text('No verses available'));
        }

        return Column(
          children: [
            _SurahHeaderWidget(
              surah: surah,
              controller: controller,
              showTranslation: showTranslation,
            ),
            Expanded(
              child: _VersesListWidget(
                controller: controller,
                showTranslation: showTranslation,
              ),
            ),
            _BottomNavigationWidget(surah: surah),
          ],
        );
      }),
    );
  }
}

/// Header widget containing surah info, action buttons, and language selector
class _SurahHeaderWidget extends StatelessWidget {
  final SurahModel surah;
  final SurahDetailController controller;
  final RxBool showTranslation;

  const _SurahHeaderWidget({
    required this.surah,
    required this.controller,
    required this.showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _HeaderTopSection(surah: surah),
          const SizedBox(height: 16),
          _ActionButtonsWidget(showTranslation: showTranslation),
          const SizedBox(height: 16),
          _LanguageSelectorWidget(controller: controller),
        ],
      ),
    );
  }
}

/// Top section of header with title and icons
class _HeaderTopSection extends StatelessWidget {
  final SurahModel surah;

  const _HeaderTopSection({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF009688),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Top icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Row(
                children: const [
                  Icon(Icons.dark_mode, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.settings, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.share, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.bookmark, color: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Surah info
          Text(
            surah.nameArabic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),
          Text(
            surah.englishName,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '${surah.revelationType} • ${surah.numberOfAyahs} verses',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Action buttons (Play Audio and Hide/Show Translation)
class _ActionButtonsWidget extends StatelessWidget {
  final RxBool showTranslation;

  const _ActionButtonsWidget({required this.showTranslation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Play Audio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF009688),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () => showTranslation.value = !showTranslation.value,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009688),
                foregroundColor: Colors.white,
              ),
              child: Obx(
                () => Text(
                  showTranslation.value
                      ? 'Hide Translation'
                      : 'Show Translation',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Language selector chips
class _LanguageSelectorWidget extends StatelessWidget {
  final SurahDetailController controller;

  const _LanguageSelectorWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.availableLanguages.isEmpty) {
        return const SizedBox.shrink();
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(controller.availableLanguages.length, (
            index,
          ) {
            final lang = controller.availableLanguages[index];
            final isSelected = controller.selectedLanguage.value == lang;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(lang.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => controller.selectedLanguage.value = lang,
                backgroundColor: Colors.grey.shade200,
                selectedColor: const Color(0xFF009688),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}

/// Verses list widget
class _VersesListWidget extends StatelessWidget {
  final SurahDetailController controller;
  final RxBool showTranslation;

  const _VersesListWidget({
    required this.controller,
    required this.showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: controller.ayahList.length,
      itemBuilder: (context, index) {
        final ayah = controller.ayahList[index];
        return _VerseCardWidget(
          ayah: ayah,
          controller: controller,
          showTranslation: showTranslation,
        );
      },
    );
  }
}

/// Individual verse card
class _VerseCardWidget extends StatelessWidget {
  final Map<String, dynamic> ayah;
  final SurahDetailController controller;
  final RxBool showTranslation;

  const _VerseCardWidget({
    required this.ayah,
    required this.controller,
    required this.showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    final verseNumber = ayah['numberInSurah'] as int;
    final arabicText = ayah['arabic1'] as String;
    final translation =
        ayah[controller.selectedLanguage.value] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Verse number badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF009688),
              borderRadius: BorderRadius.circular(20),
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
          const SizedBox(height: 12),
          // Arabic text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              arabicText,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 18,
                height: 2.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 12),
          // Translation
          Obx(() {
            if (!showTranslation.value || translation.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Text(
                translation,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          // Action icons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                color: Colors.grey,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                color: Colors.grey,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                color: Colors.grey,
                onPressed: () {},
              ),
            ],
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }
}

/// Bottom navigation widget
class _BottomNavigationWidget extends StatelessWidget {
  final SurahModel surah;

  const _BottomNavigationWidget({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.grey.shade600,
              ),
              child: const Text('Previous Surah'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Center(
              child: Text(
                'Surah ${surah.id} of 114',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009688),
              ),
              child: const Text('Next Surah'),
            ),
          ),
        ],
      ),
    );
  }
}

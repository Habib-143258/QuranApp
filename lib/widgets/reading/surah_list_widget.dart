import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/reading_controller.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/models/parah_model.dart';
import 'package:quran_app/navigation/app_routes.dart';

class SurahListWidget extends StatefulWidget {
  const SurahListWidget({super.key});

  @override
  State<SurahListWidget> createState() => _SurahListWidgetState();
}

class _SurahListWidgetState extends State<SurahListWidget> {
  @override
  Widget build(BuildContext context) {
    final ReadingController controller = Get.find<ReadingController>();

    return Obx(() {
      final items = controller.getFilteredItems();
      final isLoading = controller.isLoading.value;

      // Show loading spinner only on initial load (when no items cached)
      if (isLoading && items.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading surahs...'),
            ],
          ),
        );
      }

      // Show empty state if no items and not loading
      if (items.isEmpty && !isLoading) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No items available'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (controller.selectedFilter.value == 'surah') {
                    controller.fetchSurahList();
                  } else {
                    controller.fetchParahList();
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Show list with refresh indicator
      return RefreshIndicator(
        onRefresh: () async {
          if (controller.selectedFilter.value == 'surah') {
            await controller.fetchSurahList();
          } else {
            await controller.fetchParahList();
          }
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (controller.selectedFilter.value == 'surah') {
              return _SurahItemCard(surah: items[index] as SurahModel);
            } else {
              return _ParahItemCard(parah: items[index] as ParahModel);
            }
          },
        ),
      );
    });
  }
}

/// Individual Surah item card widget
class _SurahItemCard extends StatelessWidget {
  final SurahModel surah;

  const _SurahItemCard({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: _SurahNumberBadge(number: surah.id ?? 0),
          title: Text(
            surah.englishName,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: _SurahSubtitle(surah: surah),
          trailing: _SurahArabicName(surah: surah),
          onTap: () => Get.toNamed(AppRoutes.surahDetail, arguments: surah),
        ),
      ),
    );
  }
}

/// Surah number badge
class _SurahNumberBadge extends StatelessWidget {
  final int number;

  const _SurahNumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFF009688),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// Surah subtitle with translation and revelation type
class _SurahSubtitle extends StatelessWidget {
  final SurahModel surah;

  const _SurahSubtitle({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          surah.englishNameTranslation,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          '${surah.revelationType} • ${surah.numberOfAyahs} verses',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
      ],
    );
  }
}

/// Surah Arabic name with chevron
class _SurahArabicName extends StatelessWidget {
  final SurahModel surah;

  const _SurahArabicName({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          surah.name,
          style: const TextStyle(
            color: Color(0xFF009688),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          textDirection: TextDirection.rtl,
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }
}

/// Individual Parah item card widget
class _ParahItemCard extends StatelessWidget {
  final ParahModel parah;

  const _ParahItemCard({required this.parah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF009688),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                parah.juzNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Text(
            parah.juzNameSimple ?? 'Juz ${parah.juzNumber}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parah.juzName ?? '',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 2),
              Text(
                '${parah.versesCount} verses',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => Get.toNamed(AppRoutes.parahDetail, arguments: parah),
        ),
      ),
    );
  }
}

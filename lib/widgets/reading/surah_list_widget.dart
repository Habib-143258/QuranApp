import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/reading_controller.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/models/parah_model.dart';
import 'package:quran_app/navigation/app_routes.dart';

class SurahListWidget extends StatelessWidget {
  const SurahListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ReadingController controller = Get.find<ReadingController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final items = controller.getFilteredItems();

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (controller.selectedFilter.value == 'surah') {
            return _buildSurahItem(items[index] as SurahModel);
          } else {
            return _buildParahItem(items[index] as ParahModel);
          }
        },
      );
    });
  }

  Widget _buildSurahItem(SurahModel surah) {
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
                (surah.id ?? 0).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Text(
            surah.englishName ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah.englishNameTranslation ?? '',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                '${surah.revelationType ?? 'Unknown'} • ${surah.numberOfAyahs ?? 0} verses',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                surah.name ?? '',
                style: const TextStyle(
                  color: Color(0xFF009688),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          onTap: () => Get.toNamed(AppRoutes.surahDetail, arguments: surah),
        ),
      ),
    );
  }

  Widget _buildParahItem(ParahModel parah) {
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
          onTap: () => Get.snackbar('Info', 'Parah details coming soon'),
        ),
      ),
    );
  }
}

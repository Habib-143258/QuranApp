import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/controllers/surah_detail_controller.dart';

class SurahDetailScreen extends StatelessWidget {
  final SurahModel surah;

  const SurahDetailScreen({Key? key, required this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SurahDetailController(surah: surah));

    return Scaffold(
      appBar: AppBar(
        title: Text(surah.englishName ?? ''),
        backgroundColor: const Color(0xFF009688),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.ayahList.isEmpty) {
          return const Center(child: Text('No verses available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.ayahList.length,
          itemBuilder: (context, index) {
            final ayah = controller.ayahList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verse ${ayah['numberInSurah']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF009688),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ayah['text'] ?? '',
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 16, height: 1.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ayah['translation'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/reading_controller.dart';

class SurahFilterWidget extends StatelessWidget {
  const SurahFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ReadingController controller = Get.find<ReadingController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  side: BorderSide(
                    color: controller.selectedFilter.value == 'surah'
                        ? const Color(0xFF009688)
                        : Colors.grey.shade300,
                    width: controller.selectedFilter.value == 'surah' ? 1.5 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => controller.setFilter('surah'),
                child: Text(
                  'By Surah',
                  style: TextStyle(
                    color: controller.selectedFilter.value == 'surah'
                        ? const Color(0xFF009688)
                        : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  side: BorderSide(
                    color: controller.selectedFilter.value == 'parah'
                        ? const Color(0xFF009688)
                        : Colors.grey.shade300,
                    width: controller.selectedFilter.value == 'parah' ? 1.5 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => controller.setFilter('parah'),
                child: Text(
                  'By Parah',
                  style: TextStyle(
                    color: controller.selectedFilter.value == 'parah'
                        ? const Color(0xFF009688)
                        : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

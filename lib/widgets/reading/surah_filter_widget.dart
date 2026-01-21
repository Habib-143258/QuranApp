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
        () => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setFilter('surah'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.selectedFilter.value == 'surah'
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: controller.selectedFilter.value == 'surah'
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
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
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setFilter('parah'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.selectedFilter.value == 'parah'
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: controller.selectedFilter.value == 'parah'
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

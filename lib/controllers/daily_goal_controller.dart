import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyGoalController extends GetxController {
  late TextEditingController versesGoalController;
  late TextEditingController surahsGoalController;
  late TextEditingController readingTimeGoalController;

  final versesGoal = 50.obs;
  final surahsGoal = 5.obs;
  final readingTimeGoal = 60.obs;

  @override
  void onInit() {
    super.onInit();
    versesGoalController = TextEditingController(text: versesGoal.toString());
    surahsGoalController = TextEditingController(text: surahsGoal.toString());
    readingTimeGoalController = TextEditingController(
      text: readingTimeGoal.toString(),
    );
  }

  void saveGoals() {
    versesGoal.value = int.tryParse(versesGoalController.text) ?? 50;
    surahsGoal.value = int.tryParse(surahsGoalController.text) ?? 5;
    readingTimeGoal.value = int.tryParse(readingTimeGoalController.text) ?? 60;
    Get.snackbar('Success', 'Goals updated successfully');
  }

  @override
  void onClose() {
    versesGoalController.dispose();
    surahsGoalController.dispose();
    readingTimeGoalController.dispose();
    super.onClose();
  }
}

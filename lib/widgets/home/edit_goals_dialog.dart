import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/daily_goal_controller.dart';

class EditGoalsDialog extends StatefulWidget {
  const EditGoalsDialog({super.key});

  @override
  State<EditGoalsDialog> createState() => _EditGoalsDialogState();
}

class _EditGoalsDialogState extends State<EditGoalsDialog> {
  late DailyGoalController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DailyGoalController>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Goals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Set your daily reading targets',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// Verses per Day
            _GoalSliderRow(
              icon: Icons.menu_book_rounded,
              title: 'Verses per Day',
              subtitle: 'Number of verses to read daily',
              color: const Color(0xff0FAF97),
              value: controller.versesGoal.value.toDouble(),
              onChanged: (value) {
                setState(() {
                  controller.versesGoal.value = value.toInt();
                });
              },
              maxValue: 100.0,
            ),

            const SizedBox(height: 20),

            /// Quick Presets
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Presets:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _PresetButton(
                      label: 'Beginner',
                      onTap: () {
                        setState(() {
                          controller.versesGoal.value = 20;
                          controller.surahsGoal.value = 1;
                          controller.readingTimeGoal.value = 15;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    _PresetButton(
                      label: 'Moderate',
                      onTap: () {
                        setState(() {
                          controller.versesGoal.value = 50;
                          controller.surahsGoal.value = 2;
                          controller.readingTimeGoal.value = 30;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    _PresetButton(
                      label: 'Advanced',
                      onTap: () {
                        setState(() {
                          controller.versesGoal.value = 100;
                          controller.surahsGoal.value = 5;
                          controller.readingTimeGoal.value = 60;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0FAF97),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      controller.saveGoals();
                      Get.back();
                    },
                    // icon: const Icon(Icons.check),
                    label: const Text('Save Goals'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalSliderRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final double value;
  final ValueChanged<double> onChanged;
  final double maxValue;

  const _GoalSliderRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.onChanged,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 12,
              elevation: 4,
            ),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: maxValue,
            activeColor: color,
            inactiveColor: Colors.grey.shade300,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

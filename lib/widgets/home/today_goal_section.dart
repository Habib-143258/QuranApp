import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/widgets/home/edit_goals_dialog.dart';

class TodayGoalsSection extends StatelessWidget {
  const TodayGoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Progress",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const EditGoalsDialog(),
                  );
                },
                child: Text(
                  "Edit Goals",
                  style: TextStyle(
                    color: const Color(0xff0FAF97),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Verses Read
          _GoalRow(
            icon: Icons.menu_book_rounded,
            title: "Verses Read",
            value: "7/50",
            progress: 0.14,
            color: const Color(0xff0FAF97),
          ),

          const SizedBox(height: 14),

          /// Surahs Completed
          _GoalRow(
            icon: Icons.grid_view_rounded,
            title: "Surahs Completed",
            value: "0/5",
            progress: 0.0,
            color: const Color(0xff5C6BC0),
          ),

          const SizedBox(height: 14),

          /// Reading Time
          _GoalRow(
            icon: Icons.access_time_rounded,
            title: "Reading Time",
            value: "12/60m",
            progress: 0.2,
            color: const Color(0xff9C27B0),
          ),

          const SizedBox(height: 16),
          const Divider(),

          /// Overall Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.trending_up, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Overall Progress",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                "11%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0FAF97),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final double progress;
  final Color color;

  const _GoalRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
            Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 5,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

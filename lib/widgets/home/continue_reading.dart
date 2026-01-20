import 'package:flutter/material.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF059669), // emerald-600
            Color(0xFF0D9488), // teal-600
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Last Read", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          const Text(
            "Al-Fatihah",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text("Verse 3 of 7", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text("Continue Reading"),
            ),
          ),
        ],
      ),
    );
  }
}

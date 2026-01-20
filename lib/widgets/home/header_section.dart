import 'package:flutter/material.dart';
import 'package:quran_app/screens/home_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "السلام عليكم",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Peace be upon you",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Verse of the Day", style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                Text(
                  "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "In the name of Allah, the Entirely Merciful, the Especially Merciful",
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 4),
                Text("Al-Fatihah 1:1", style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PopularSurahSection extends StatelessWidget {
  const PopularSurahSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Surahs",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _SurahTile(
          number: "1",
          name: "Al-Fatihah",
          verses: "7 verses",
          arabic: "الفاتحة",
        ),
        _SurahTile(
          number: "18",
          name: "Al-Kahf",
          verses: "110 verses",
          arabic: "الكهف",
        ),
        _SurahTile(
          number: "19",
          name: "Maryam",
          verses: "98 verses",
          arabic: "مريم",
        ),
      ],
    );
  }
}

class _SurahTile extends StatelessWidget {
  final String number, name, verses, arabic;

  const _SurahTile({
    required this.number,
    required this.name,
    required this.verses,
    required this.arabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xff0FAF97),
            child: Text(number, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(verses, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(arabic, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

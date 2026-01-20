// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/quran_controller.dart';
// import 'surah_screen.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   final QuranController quranController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Quran"), centerTitle: true),
//       body: Obx(() {
//         if (quranController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (quranController.error.isNotEmpty) {
//           return Center(child: Text("Error: ${quranController.error}"));
//         }

//         if (quranController.surahList.isEmpty) {
//           return const Center(child: Text("No Surahs Found"));
//         }

//         return ListView.builder(
//           itemCount: quranController.surahList.length,
//           itemBuilder: (_, index) {
//             final surah = quranController.surahList[index];

//             return ListTile(
//               leading: CircleAvatar(child: Text(surah.id.toString())),
//               title: Text(surah.nameArabic),
//               subtitle: Text(
//                 "${surah.nameEnglish} • ${surah.versesCount} verses",
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => SurahScreen(surahId: surah.id),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/home/header_section.dart';
import '../widgets/home/continue_reading.dart';
import '../widgets/home/progress_section.dart';
import '../widgets/home/popular_surah_section.dart';
import '../widgets/home/today_goal_section.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderSection(),
              SizedBox(height: 16),
              ContinueReadingCard(),
              SizedBox(height: 20),
              ProgressSection(),
              SizedBox(height: 20),
              PopularSurahSection(),
              SizedBox(height: 20),
              TodayGoalsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_app/data/services/quran_api_service.dart';
import 'package:quran_app/controllers/quran_controller.dart';
import 'package:quran_app/controllers/daily_goal_controller.dart';
import 'package:quran_app/navigation/app_routes.dart';
import 'package:quran_app/config/url_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Local storage (for future progress saving)
  await GetStorage.init();

  /// Language (Urdu by default)
  final url = NewUrlClass(languageCode: "ur");

  /// Dependency Injection
  Get.put<QuranApiService>(QuranApiService(), permanent: true);
  Get.put<QuranController>(QuranController(), permanent: true);
  Get.put<DailyGoalController>(DailyGoalController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran App',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      initialRoute: AppRoutes.main,
      getPages: AppRoutes.pages,
    );
  }
}

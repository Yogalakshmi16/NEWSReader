import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsreader/services/localstorage_database/db_services.dart';
import 'package:newsreader/services/provider/api_services.dart';
import 'package:newsreader/view/screens/splash.dart';
import 'controller/newsarticle_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final dbService = DBService.instance;
  final apiService = NewsArticleProvider();

  Get.put<DBService>(dbService);
  Get.put<NewsArticleProvider>(apiService);
  Get.put<NewsController>(NewsController(apiService: apiService, dbService: dbService),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News Reader App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

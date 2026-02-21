import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbr/app/routes/app_page.dart';
import 'package:imbr/app/routes/app_routes.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('favorites');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LatterCircle",
      initialRoute: Routes.SPLASH,
      getPages: AppPage.routes,
    );
  }
}

import 'package:get/get.dart';
import 'package:imbr/app/modules/favorit/bindings/favorite_binding.dart';
import 'package:imbr/app/modules/favorit/views/favorite_view.dart';
import 'package:imbr/app/modules/home/bindings/home_binding.dart';
import 'package:imbr/app/modules/home/views/home_view.dart';
import 'package:imbr/app/modules/splash/bindings/splash_binding.dart';
import 'package:imbr/app/modules/splash/views/splash_view.dart';
import 'package:imbr/app/routes/app_routes.dart';

class AppPage {
  AppPage._();
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.FAVORITE,
      page: () => const FavoriteView(),
      binding: FavoriteBinding(),
    ),
  ];
}

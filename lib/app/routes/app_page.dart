import 'package:get/get.dart';
import 'package:imbr/app/modules/main_nav/bindings/main_nav_binding.dart';
import 'package:imbr/app/modules/main_nav/views/main_nav_view.dart';
import 'package:imbr/app/modules/profile/bindings/profile_binding.dart';
import 'package:imbr/app/modules/profile/views/profile_view.dart';
import 'package:imbr/app/modules/home/bindings/home_binding.dart';
import 'package:imbr/app/modules/home/views/home_view.dart';
import 'package:imbr/app/modules/rate/bindings/rate_binding.dart';
import 'package:imbr/app/modules/rate/views/rate_view.dart';
import 'package:imbr/app/modules/splash/bindings/splash_binding.dart';
import 'package:imbr/app/modules/splash/views/splash_view.dart';
import 'package:imbr/app/modules/watchlist/bindings/watchlist_binding.dart';
import 'package:imbr/app/modules/watchlist/views/watchlist_view.dart';
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
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.RATE,
      page: () => const RateView(),
      binding: RateBinding(),
    ),
    GetPage(
      name: Routes.WATCHLIST,
      page: () => const WatchlistView(),
      binding: WatchlistBinding(),
    ),
    GetPage(
      name: Routes.MAIN_NAV,
      page: () => const MainNavView(),
      binding: MainNavBinding(),
    ),
  ];
}

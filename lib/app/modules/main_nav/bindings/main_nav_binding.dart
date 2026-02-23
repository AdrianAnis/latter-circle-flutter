import 'package:get/get.dart';
import '../controllers/main_nav_controller.dart';

import '../../home/controllers/home_controller.dart';
import '../../rate/controllers/rate_controller.dart';
import '../../watchlist/controllers/watchlist_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<RateController>(() => RateController());
    Get.lazyPut<WatchlistController>(() => WatchlistController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

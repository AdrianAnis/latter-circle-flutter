import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbr/core/app_colors.dart';
import '../../home/views/home_view.dart';
import '../../rate/views/rate_view.dart';
import '../../watchlist/views/watchlist_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeView(),
            RateView(),
            WatchlistView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: Obx(() {
          return NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AppColors.primary.withOpacity(0.15),

              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(
                  size: 24,
                  color: selected ? AppColors.primary : Colors.grey.shade500,
                );
              }),

              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.primary : Colors.grey.shade500,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: controller.changeIndex,
              height: 70,
              backgroundColor: Colors.white,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.star_outline_rounded),
                  selectedIcon: Icon(Icons.star_rounded),
                  label: "Rate",
                ),
                NavigationDestination(
                  icon: Icon(Icons.bookmark_outline_rounded),
                  selectedIcon: Icon(Icons.bookmark_rounded),
                  label: "Watchlist",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: "Profile",
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

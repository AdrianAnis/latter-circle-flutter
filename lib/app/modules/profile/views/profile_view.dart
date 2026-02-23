import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imbr/core/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final favBox = Hive.box('favorites');
    final watchBox = Hive.box('watchlist');
    final ratedBox = Hive.box('rated');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box('favorites').listenable(),
          builder: (context, Box favBox, _) {
            return ValueListenableBuilder(
              valueListenable: Hive.box('watchlist').listenable(),
              builder: (context, Box watchBox, _) {
                return ValueListenableBuilder(
                  valueListenable: Hive.box('rated').listenable(),
                  builder: (context, Box ratedBox, _) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 8),
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 200,
                                ),
                                SizedBox(height: 8),

                                SizedBox(height: 4),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          _sectionTitle("Favorites"),
                          const SizedBox(height: 16),
                          _horizontalMovieList(favBox),

                          const SizedBox(height: 24),
                          _sectionTitle("Ratings"),
                          const SizedBox(height: 16),
                          _horizontalRatedMovieList(ratedBox),

                          const SizedBox(height: 24),
                          _sectionTitle("Watchlist"),
                          const SizedBox(height: 16),
                          _horizontalMovieList(watchBox),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _horizontalMovieList(Box box) {
    if (box.isEmpty) {
      return const Text(
        "Belum ada data",
        style: TextStyle(color: Colors.white54),
      );
    }

    final movies = box.values.toList().reversed.take(5).toList();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final imageUrl =
              "https://image.tmdb.org/t/p/w500${movie['posterPath']}";

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imageUrl, width: 120, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _horizontalRatedMovieList(Box box) {
    if (box.isEmpty) {
      return const Text(
        "Belum ada data",
        style: TextStyle(color: Colors.white54),
      );
    }

    final movies = box.values.toList().cast<Map>().reversed.take(5).toList();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final imageUrl =
              "https://image.tmdb.org/t/p/w500${movie['posterPath']}";
          final rating = movie['rating'] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(imageUrl, width: 120, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

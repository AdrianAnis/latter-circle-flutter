import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbr/app/data/models/movie_model.dart';
import 'package:imbr/app/modules/home/views/widgets/genre_chip.dart';
import 'package:imbr/app/modules/home/views/widgets/movie_card.dart';
import 'package:imbr/app/modules/home/views/widgets/rating_sheet.dart';
import 'package:imbr/core/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/logo.png', height: 40),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.bgcolor,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                GenreChip(label: "Semua"),
                GenreChip(label: "Action"),
                GenreChip(label: "Comedy"),
                GenreChip(label: "Drama"),
                GenreChip(label: "Horror"),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: controller.movies.length,
                itemBuilder: (context, index) {
                  final movie = controller.movies[index];

                  return MovieCard(movie: movie);
                },
              );
            }),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class RatingSheet extends StatefulWidget {
  final Movie movie;

  const RatingSheet({super.key, required this.movie});

  @override
  State<RatingSheet> createState() => RatingSheetState();
}

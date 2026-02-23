import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbr/app/modules/home/controllers/home_controller.dart';
import 'package:imbr/app/modules/home/views/home_view.dart';
import '../../../../data/models/movie_model.dart';
import 'rating_sheet.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "https://image.tmdb.org/t/p/w500${movie.posterPath}";
    final controller = Get.find<HomeController>();

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: movie.posterPath == null || movie.posterPath!.isEmpty
              ? Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                )
              : Image.network(
                  "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.broken_image)),
                    );
                  },
                ),
        ),

        Positioned(
          bottom: 8,
          left: 8,
          right: 50,
          child: Text(
            movie.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        Positioned(
          right: 8,
          bottom: 8,
          child: GetBuilder<HomeController>(
            builder: (c) => Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      c.isRated(movie.id) ? Icons.star : Icons.star_border,
                      color: c.isRated(movie.id) ? Colors.amber : Colors.white,
                      size: 16,
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        RatingSheet(movie: movie),
                        isScrollControlled: true,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      c.isFavorite(movie.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: c.isFavorite(movie.id) ? Colors.red : Colors.white,
                      size: 16,
                    ),
                    onPressed: () => c.toggleFavorite(movie),
                  ),
                ),

                const SizedBox(height: 8),

                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      c.isWatchlist(movie.id)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: () => c.toggleWatchlist(movie),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

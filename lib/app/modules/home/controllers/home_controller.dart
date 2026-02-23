import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imbr/app/data/services/services/movie_service.dart';
import '../../../data/models/movie_model.dart';

class HomeController extends GetxController {
  var allMovies = <Movie>[].obs;
  var searchQuery = ''.obs;
  var movies = <Movie>[].obs;
  var isLoading = false.obs;
  var selectedGenre = "Semua".obs;

  final genreMap = {"Action": 28, "Comedy": 35, "Drama": 18, "Horror": 27};

  @override
  void onInit() {
    super.onInit();

    
  
    Hive.box('favorites').listenable().addListener(_onHiveChanged);
    Hive.box('rated').listenable().addListener(_onHiveChanged);
    Hive.box('watchlist').listenable().addListener(_onHiveChanged);

    fetchMovies();
  }

  void _onHiveChanged() {
    if (isClosed) return;
    update();
  }

  @override
  void onClose() {
    try {
      Hive.box('favorites').listenable().removeListener(_onHiveChanged);
      Hive.box('rated').listenable().removeListener(_onHiveChanged);
      Hive.box('watchlist').listenable().removeListener(_onHiveChanged);
    } catch (e) {
      print(e);
    }
    super.onClose();
  }

  void fetchMovies({int? genreId}) async {
    try {
      isLoading.value = true;
      final result = await MovieService.fetchMoviesByGenre(genreId);

      allMovies.assignAll(result);
      _applyFilters();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSearchChanged(String value) async {
    searchQuery.value = value;

    if (value.trim().isEmpty) {
     
      final g = selectedGenre.value;
      fetchMovies(genreId: g == "Semua" ? null : genreMap[g]);
      return;
    }

    try {
      isLoading.value = true;
      final result = await MovieService.searchMovies(value);
      movies.assignAll(result);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    final q = searchQuery.value.trim().toLowerCase();

    if (q.isEmpty) {
      movies.assignAll(allMovies);
      return;
    }

    movies.assignAll(
      allMovies.where((m) {
        final title = (m.title).toLowerCase();
        return title.contains(q);
      }).toList(),
    );
  }


  dynamic _findKeyByMovieId(Box box, int movieId) {
    return box.keys.cast<dynamic>().firstWhere((k) {
      final item = box.get(k);
      return item is Map && item['id'] == movieId;
    }, orElse: () => null);
  }


  void _toast({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    IconData? icon,
    Color? bgColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: bgColor ?? Colors.black.withOpacity(0.85),
      colorText: Colors.white,
      margin: const EdgeInsets.all(14),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
      icon: icon == null ? null : Icon(icon, color: Colors.white, size: 20),
      shouldIconPulse: false,
      barBlur: 8, 
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  bool isFavorite(int movieId) {
    final box = Hive.box('favorites');
    return _findKeyByMovieId(box, movieId) != null;
  }

  bool isRated(int movieId) {
    final box = Hive.box('rated');
    return _findKeyByMovieId(box, movieId) != null;
  }

  bool isWatchlist(int movieId) {
    final box = Hive.box('watchlist');
    return _findKeyByMovieId(box, movieId) != null;
  }

  void toggleFavorite(Movie movie) {
    final box = Hive.box('favorites');
    final key = _findKeyByMovieId(box, movie.id);

    if (key == null) {
      box.add({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
      });

      _toast(
        title: "Added",
        message: "${movie.title} added to favorites",
        position: SnackPosition.TOP,
        icon: Icons.favorite,
        bgColor: Colors.redAccent.withOpacity(0.9),
      );
    } else {
      box.delete(key);

      _toast(
        title: "Removed",
        message: "${movie.title} removed from favorites",
        position: SnackPosition.TOP,
        icon: Icons.favorite_border,
        bgColor: Colors.grey.shade900.withOpacity(0.9),
      );
    }

    update();
  }

  void toggleWatchlist(Movie movie) {
    final box = Hive.box('watchlist');
    final key = _findKeyByMovieId(box, movie.id);

    if (key == null) {
      box.add({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
      });

      _toast(
        title: "Added",
        message: "${movie.title} added to watchlist",
        position: SnackPosition.TOP,
        icon: Icons.bookmark,
        bgColor: Colors.blueGrey.withOpacity(0.9),
      );
    } else {
      box.delete(key);

      _toast(
        title: "Removed",
        message: "${movie.title} removed from watchlist",
        position: SnackPosition.TOP,
        icon: Icons.bookmark_border,
        bgColor: Colors.grey.shade900.withOpacity(0.9),
      );
    }

    update();
  }

  void setRating(Movie movie, double rating) {
    final box = Hive.box('rated');

    final data = {
      'id': movie.id,
      'title': movie.title,
      'posterPath': movie.posterPath,
      'rating': rating,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    box.put(movie.id, data);

    _toast(
      title: "Saved",
      message: "Rating set to ${rating.toStringAsFixed(1)} • ${movie.title}",
      position: SnackPosition.TOP,
      icon: Icons.star,
      bgColor: Colors.amber.shade800.withOpacity(0.95),
    );

    update();
  }
}

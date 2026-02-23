import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imbr/app/data/models/movie_model.dart';

class MovieService {
  static const String apiKey = "33cabc89c17332e33d8fd6add0744e5a";

  static Future<List<Movie>> fetchMoviesByGenre(int? genreId) async {
    String url;

    if (genreId == null) {
      url = "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
    } else {
      url =
          "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<List<Movie>> searchMovies(String query) async {
    final url =
        "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=${Uri.encodeQueryComponent(query)}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search movies");
    }
  }
}

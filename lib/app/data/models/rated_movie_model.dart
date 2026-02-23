class RatedMovie {
  final int id;
  final String title;
  final String posterPath;
  final int rating;

  RatedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'rating': rating,
    };
  }

  factory RatedMovie.fromMap(Map map) {
    return RatedMovie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      rating: map['rating'],
    );
  }
}

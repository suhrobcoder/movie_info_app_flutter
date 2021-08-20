import 'genre.dart';

class GenreResponse {
  final List<Genre> genres;
  final String error;

  GenreResponse(this.genres, this.error);

  GenreResponse.fromJson(Map<String, dynamic> json)
      : genres = (json["genres"] as List).map((e) => Genre.fromJson(e)).toList(),
        error = "";

  GenreResponse.withError(this.error) : genres = [];
}

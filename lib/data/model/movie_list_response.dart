import 'package:movie_info_app_flutter/data/model/movie.dart';

class MovieListResponse {
  final int page;
  final List<Movie> results;
  final String error;

  MovieListResponse(this.page, this.results, this.error);

  MovieListResponse.fromJson(Map<String, dynamic> json)
      : page = json["page"],
        results = (json["results"] as List).map((e) => Movie.fromJson(e)).toList(),
        error = "";

  MovieListResponse.withError(this.error)
      : page = -1,
        results = [];
}

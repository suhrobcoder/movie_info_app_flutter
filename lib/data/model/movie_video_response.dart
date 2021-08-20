import 'package:movie_info_app_flutter/data/model/movie_video.dart';

class MovieVideoResponse {
  final int id;
  final List<MovieVideo> results;
  final String error;

  MovieVideoResponse(this.id, this.results, this.error);

  MovieVideoResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        results = (json["results"] as List).map((e) => MovieVideo.fromJson(e)).toList(),
        error = "";

  MovieVideoResponse.withError(this.error)
      : id = 0,
        results = [];
}

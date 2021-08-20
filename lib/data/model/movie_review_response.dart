import 'package:movie_info_app_flutter/data/model/movie_review.dart';

class MovieReviewResponse {
  final int id;
  final int page;
  final List<MovieReview> results;
  final int totalPages;
  final int totalResults;
  final String error;

  MovieReviewResponse(
      this.id, this.page, this.results, this.totalPages, this.totalResults, this.error);

  MovieReviewResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        page = json["page"],
        results = (json["results"] as List).map((e) => MovieReview.fromJson(e)).toList(),
        totalPages = json["total_pages"],
        totalResults = json["total_results"],
        error = "";

  MovieReviewResponse.withError(this.error)
      : id = 0,
        page = 0,
        results = [],
        totalPages = 0,
        totalResults = 0;
}

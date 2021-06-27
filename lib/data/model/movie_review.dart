import 'package:movie_info_app_flutter/data/model/review_author.dart';

class MovieReview {
  final String author;
  final ReviewAuthor authorDetails;
  final String content;
  final String createdAt;

  MovieReview(this.author, this.authorDetails, this.content, this.createdAt);

  MovieReview.fromJson(Map<String, dynamic> json)
      : author = json["author"],
        authorDetails = ReviewAuthor.fromJson(json["author_details"]),
        content = json["content"],
        createdAt = json["created_at"];
}

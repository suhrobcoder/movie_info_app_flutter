import 'genre.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? backdropPath;
  final String? posterPath;
  final List<int>? genreIds;
  final List<Genre>? genres;
  final String? releaseDate;
  final int? runtime;
  final bool video;
  final double? voteAverage;
  final int? voteCount;

  Movie(
      this.id,
      this.title,
      this.overview,
      this.backdropPath,
      this.posterPath,
      this.genreIds,
      this.genres,
      this.releaseDate,
      this.runtime,
      this.video,
      this.voteAverage,
      this.voteCount);

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        overview = json["overview"],
        backdropPath = json["backdrop_path"],
        posterPath = json["poster_path"],
        genreIds = (json["genre_ids"] as List?)?.map((e) => e as int).toList(),
        genres =
            (json["genres"] as List?)?.map((e) => Genre.fromJson(e)).toList(),
        releaseDate = json["release_date"],
        runtime = json["runtime"],
        video = json["video"],
        voteAverage = json["voteAverage"],
        voteCount = json["voteCount"];
}

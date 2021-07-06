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
        voteAverage = json["vote_average"] + 0.0,
        voteCount = json["vote_count"];

  String getPosterUrl() {
    return "https://image.tmdb.org/t/p/w500/$posterPath";
  }

  String getBackdropUrl() {
    return "https://image.tmdb.org/t/p/w500/$backdropPath";
  }

  String getMovieReleaseDate() {
    return releaseDate ?? "";
  }

  String runtimeToString() {
    if (runtime == null) {
      return "";
    } else {
      return "${runtime! ~/ 60}h ${runtime! % 60}min";
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/cast.dart';
import 'package:movie_info_app_flutter/data/model/credits_response.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/model/movie_review.dart';
import 'package:movie_info_app_flutter/data/model/movie_review_response.dart';
import 'package:movie_info_app_flutter/data/model/movie_video.dart';
import 'package:movie_info_app_flutter/data/model/movie_video_response.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final Movie movie;
  final MovieRepository repository;
  final SavedMoviesRepository savedRepository;
  DetailsBloc(this.movie, this.repository, this.savedRepository)
      : super(DetailsInitialState(movie)) {
    on<DetailsLoadEvent>((event, emit) async {
      Movie loadedMovie = movie;
      Movie? movieFromDb = await savedRepository.getMovieById(movie.id);
      if (movieFromDb == null) {
        Movie? movieFromApi = await repository.getMovie(movie.id);
        if (movieFromApi != null) {
          loadedMovie = movieFromApi;
        }
      } else {
        loadedMovie = movieFromDb;
      }
      List result =
          await Future.wait([getCasts(), getReviews(), getMovieVideos()]);
      List<Cast>? casts = result[0];
      List<MovieReview>? reviews = result[1];
      List<MovieVideo>? videos = result[2];
      emit(DetailsLoadedState(loadedMovie, casts, reviews, videos));
    });
  }

  Future<List<Cast>?> getCasts() async {
    CreditsResponse response = await repository.getMovieCredits(movie.id);
    if (response.error.isNotEmpty) {
      return null;
    }
    return response.cast;
  }

  Future<List<MovieReview>?> getReviews() async {
    MovieReviewResponse response =
        await repository.getMovieReviews(movie.id, 1);
    if (response.error.isNotEmpty) {
      return null;
    }
    return response.results;
  }

  Future<List<MovieVideo>?> getMovieVideos() async {
    MovieVideoResponse response = await repository.getMovieVideos(movie.id);
    if (response.error.isNotEmpty) {
      return null;
    }
    return response.results;
  }
}

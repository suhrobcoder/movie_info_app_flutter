import 'package:dio/dio.dart';
import 'package:movie_info_app_flutter/data/model/credits_response.dart';
import 'package:movie_info_app_flutter/data/model/genre_response.dart';
import 'package:movie_info_app_flutter/data/model/guest_session_response.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/model/movie_list_response.dart';
import 'package:movie_info_app_flutter/data/model/movie_review_response.dart';
import 'package:movie_info_app_flutter/data/model/movie_video_response.dart';
import 'package:movie_info_app_flutter/data/model/rate_response.dart';

class ApiClient {
  static String baseUrl = "https://api.themoviedb.org/3/";

  final Dio _dio = Dio();

  ApiClient() {
    _dio.interceptors.add(AuthInterceptors());
    _dio.options.baseUrl = baseUrl;
  }

  Future<GenreResponse> getGenres() async {
    try {
      Response response = await _dio.get("genre/movie/list");
      return GenreResponse.fromJson(response.data);
    } catch (error) {
      return GenreResponse.withError("Someting went wrong");
    }
  }

  Future<MovieListResponse> getPopularMovies(int page, CancelToken cancelToken) async {
    var params = {"page": page};
    try {
      Response response =
          await _dio.get("movie/popular", queryParameters: params, cancelToken: cancelToken);
      return MovieListResponse.fromJson(response.data);
    } catch (error) {
      return MovieListResponse.withError("Someting went wrong");
    }
  }

  Future<MovieListResponse> getTopRatedMovies(int page, CancelToken cancelToken) async {
    var params = {"page": page};
    try {
      Response response =
          await _dio.get("movie/top_rated", queryParameters: params, cancelToken: cancelToken);
      return MovieListResponse.fromJson(response.data);
    } catch (error) {
      return MovieListResponse.withError("Someting went wrong");
    }
  }

  Future<MovieListResponse> getUpcomingMovies(int page, CancelToken cancelToken) async {
    var params = {"page": page};
    try {
      Response response =
          await _dio.get("movie/upcoming", queryParameters: params, cancelToken: cancelToken);
      return MovieListResponse.fromJson(response.data);
    } catch (error) {
      return MovieListResponse.withError("Someting went wrong");
    }
  }

  Future<MovieListResponse> searchMovies(String query, int page) async {
    var params = {"query": query, "page": page};
    try {
      Response response = await _dio.get("search/movie", queryParameters: params);
      return MovieListResponse.fromJson(response.data);
    } catch (error) {
      return MovieListResponse.withError("Someting went wrong");
    }
  }

  Future<Movie?> getMovie(int movieId) async {
    try {
      Response response = await _dio.get("movie/$movieId");
      return Movie.fromJson(response.data);
    } catch (error) {
      return null;
    }
  }

  Future<MovieReviewResponse> getMovieReviews(int movieId, int page) async {
    var params = {"page": page};
    try {
      Response response = await _dio.get("movie/$movieId/reviews", queryParameters: params);
      return MovieReviewResponse.fromJson(response.data);
    } catch (error) {
      return MovieReviewResponse.withError("Someting went wrong");
    }
  }

  Future<MovieVideoResponse> getMovieVideos(int movieId) async {
    try {
      Response response = await _dio.get("movie/$movieId/videos");
      return MovieVideoResponse.fromJson(response.data);
    } catch (error) {
      return MovieVideoResponse.withError("Someting went wrong");
    }
  }

  Future<CreditsResponse> getMovieCredits(int movieId) async {
    try {
      Response response = await _dio.get("movie/$movieId/credits");
      return CreditsResponse.fromJson(response.data);
    } catch (error) {
      return CreditsResponse.withError("Someting went wrong");
    }
  }

  Future<GuestSessionResponse> createGuestSession() async {
    try {
      Response response = await _dio.get("authentication/guest_session/new");
      return GuestSessionResponse.fromJson(response.data);
    } catch (error) {
      return GuestSessionResponse.withError("Someting went wrong");
    }
  }

  Future<RateResponse> rateMovie(int movieId, String guestSessionId, int rating) async {
    var params = {"guest_session_id": guestSessionId};
    try {
      Response response = await _dio
          .post("movie/$movieId/rating", queryParameters: params, data: {"value": rating});
      return RateResponse.fromJson(response.data);
    } catch (error) {
      return RateResponse(-1, "Someting went wrong");
    }
  }
}

class AuthInterceptors extends Interceptor {
  final String apiKey = "7212204084cd53100d0a7c8f3ea1b258";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters["api_key"] = apiKey;
    handler.next(options);
  }
}

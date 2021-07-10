import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:movie_info_app_flutter/bloc/details_bloc/details_bloc.dart';
import 'package:movie_info_app_flutter/bloc/movie_like/movie_like_bloc.dart';
import 'package:movie_info_app_flutter/bloc/rate/rate_cubit.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/screens/details/reviews_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/details/videos_column.dart';
import 'package:movie_info_app_flutter/ui/screens/home/genre_row.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cast_row.dart';

class DetailsScreen extends StatelessWidget {
  final Movie _movie;
  late final MovieLikeBloc movieLikeBloc;
  DetailsScreen(this._movie, {Key? key}) : super(key: key);

  double rating = 5;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    movieLikeBloc =
        MovieLikeBloc(locator.get<SavedMoviesRepository>(), _movie.id);
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailsBloc>(
            create: (_) => DetailsBloc(_movie, locator.get<MovieRepository>(),
                locator.get<SavedMoviesRepository>())
              ..add(DetailsLoadEvent())),
        BlocProvider<RateCubit>(
            create: (_) => RateCubit(locator.get<MovieRepository>(), _movie.id))
      ],
      child: Scaffold(
        body: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            Movie movie = state.movie;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32)),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            fit: BoxFit.fill,
                            imageUrl: movie.getBackdropUrl(),
                            placeholder: (context, str) => Image.asset(
                              "assets/images/backdrop_placeholder.jpg",
                            ),
                            errorWidget: (context, str, _) => Image.asset(
                              "assets/images/backdrop_placeholder.jpg",
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 64,
                        margin: EdgeInsets.only(left: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            bottomLeft: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: "${movie.voteAverage}/",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text: "10",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Text("${movie.voteCount}",
                                    style: Theme.of(context).textTheme.caption),
                              ],
                            )),
                            BlocListener<RateCubit, RateState>(
                              listener: (context, state) {
                                if (state is RateCompleted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)));
                                }
                              },
                              child: Expanded(
                                  child: InkWell(
                                onTap: () {
                                  if (state is! RateRunning) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => _rateDialog(
                                        context,
                                        (_rating) {
                                          RateCubit rateCubit =
                                              BlocProvider.of<RateCubit>(
                                                  context);
                                          rateCubit
                                              .rateMovie((_rating * 2).toInt());
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star),
                                    Text("Rate this"),
                                  ],
                                ),
                              )),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder(
                                  initialData: true,
                                  future: movieLikeBloc.isMovieLiked(),
                                  builder: (_, snapshot) => LikeButton(
                                    isLiked: snapshot.hasData
                                        ? snapshot.data as bool
                                        : false,
                                    size: 48,
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.favorite,
                                        color: isLiked
                                            ? Colors.redAccent
                                            : Colors.grey,
                                        size: 48,
                                      );
                                    },
                                    onTap: (liked) async {
                                      if (!liked) {
                                        return movieLikeBloc.likeMovie(movie);
                                      } else {
                                        return movieLikeBloc.dislikeMovie();
                                      }
                                    },
                                  ),
                                )
                              ],
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 24, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(movie.getMovieReleaseDate()),
                            SizedBox(width: 16),
                            Text(movie.runtimeToString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GenreRow(movie.genres ?? []),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Overview",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          movie.overview,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black.withAlpha(150)),
                        ),
                      ],
                    ),
                  ),
                  state is DetailsLoadedState
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CastRow(state.casts ?? []),
                            VideosColumn(state.videos, _launchUrl),
                            state.reviews != null
                                ? ListTile(
                                    title: Text(
                                      "Reviews",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReviewsScreen(state.reviews!))),
                                  )
                                : Container(),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _launchUrl(String url) async =>
      await canLaunch(url) ? await launch(url) : throw "Could not launch $url";

  AlertDialog _rateDialog(BuildContext context, Function(double) onRate) {
    return AlertDialog(
      title: Text("Rate"),
      content: RatingBar.builder(
        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow),
        onRatingUpdate: (newRating) => rating = newRating,
        initialRating: rating,
        glow: false,
        allowHalfRating: true,
      ),
      actions: [
        OutlinedButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        OutlinedButton(onPressed: () => onRate(rating), child: Text("OK")),
      ],
    );
  }
}

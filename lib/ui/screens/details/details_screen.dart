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
import 'package:movie_info_app_flutter/ui/components/loading_widget.dart';
import 'package:movie_info_app_flutter/ui/screens/details/reviews_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/details/videos_column.dart';
import 'package:movie_info_app_flutter/ui/screens/home/genre_row.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cast_row.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;

  const DetailsScreen(this.movie, {Key? key}) : super(key: key);

  static Widget screen(Movie movie) => MultiBlocProvider(
        providers: [
          BlocProvider<DetailsBloc>(
              create: (_) => DetailsBloc(
                  movie, locator.get<MovieRepository>(), locator.get<SavedMoviesRepository>())),
          BlocProvider<RateCubit>(
              create: (_) => RateCubit(locator.get<MovieRepository>(), movie.id))
        ],
        child: DetailsScreen(movie),
      );

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late DetailsBloc detailsBloc;
  late MovieLikeBloc movieLikeBloc;
  late RateCubit rateCubit;

  double rating = 5;

  @override
  void initState() {
    detailsBloc = BlocProvider.of<DetailsBloc>(context);
    rateCubit = BlocProvider.of<RateCubit>(context);
    movieLikeBloc = MovieLikeBloc(locator.get<SavedMoviesRepository>(), widget.movie.id);
    detailsBloc.add(DetailsLoadEvent());
    super.initState();
  }

  @override
  void dispose() {
    detailsBloc.close();
    rateCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          Movie movie = state.movie;
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32)),
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
                            color: primaryColor,
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
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "10",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor,
                                          ),
                                        ),
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
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(state.message)));
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
                                            rateCubit.rateMovie((_rating * 2).toInt());
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
                                    builder: (_, snapshot) => AbsorbPointer(
                                      absorbing: state is DetailsInitialState,
                                      child: LikeButton(
                                        isLiked: snapshot.hasData ? snapshot.data as bool : false,
                                        size: 48,
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.favorite,
                                            color: isLiked ? Colors.redAccent : Colors.grey,
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
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
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
                                ?.copyWith(color: textColor.withAlpha(200)),
                          ),
                        ],
                      ),
                    ),
                    state is DetailsLoadedState
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state.casts != null && (state.casts?.isNotEmpty ?? false)
                                  ? CastRow(state.casts ?? [])
                                  : SizedBox(),
                              state.videos != null && (state.videos?.isNotEmpty ?? false)
                                  ? VideosColumn(state.videos, _launchUrl)
                                  : SizedBox(),
                              state.reviews != null && (state.reviews?.isNotEmpty ?? false)
                                  ? ListTile(
                                      title: Text(
                                        "Reviews",
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_right),
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ReviewsScreen(state.reviews!))),
                                    )
                                  : SizedBox(),
                            ],
                          )
                        : LoadingWidget(),
                  ],
                ),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: textColor),
            )),
        OutlinedButton(
            onPressed: () => onRate(rating),
            child: Text(
              "OK",
              style: TextStyle(color: textColor),
            )),
      ],
    );
  }
}

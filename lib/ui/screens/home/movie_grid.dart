import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/ui/components/error_widget.dart';
import 'package:movie_info_app_flutter/ui/components/loading_widget.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final Widget Function(Movie) openBuilder;
  final Function? onRefresh;
  final Function? onLoadMore;
  final bool? loading;
  final String? error;
  final Function? retry;
  final Function? onClosed;
  const MovieGrid(
    this.movies,
    this.openBuilder, {
    this.loading,
    this.error,
    Key? key,
    this.retry,
    this.onRefresh,
    this.onLoadMore,
    this.onClosed,
  }) : super(key: key);

  final int maxSize = 200;
  final int spacing = 16;

  @override
  Widget build(BuildContext context) {
    List<List<Movie>> chunked = [];
    Size size = MediaQuery.of(context).size;
    int width = size.width.toInt();
    int rowItemsCount = ((width - spacing) / (maxSize + spacing)).ceil();
    double itemWidth = (width - spacing * (rowItemsCount + 1)) / rowItemsCount;
    for (var i = 0; i < movies.length; i += rowItemsCount) {
      var end = (i + rowItemsCount < movies.length)
          ? i + rowItemsCount
          : movies.length;
      chunked.add(movies.sublist(i, end));
    }
    int rowCount = chunked.length + 1;
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (loading != true &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              movies.isNotEmpty &&
              onLoadMore != null) {
            onLoadMore!();
            return true;
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () {
            return onRefresh == null ? () {} : onRefresh!();
          },
          child: ListView.builder(
            itemCount: rowCount,
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              if (index < rowCount - 1) {
                List<Movie> rowMovies = chunked[index];
                List<Widget> movieCards = rowMovies.map<Widget>((movie) {
                  return Container(
                    width: itemWidth,
                    padding: EdgeInsets.only(bottom: 16),
                    child: MovieItem(
                      movie.title,
                      movie.getPosterUrl(),
                      movie.voteAverage ?? 0,
                      () => openBuilder(movie),
                      onClosed ?? () {},
                    ),
                  );
                }).toList();
                if (movieCards.length < rowItemsCount) {
                  movieCards.addAll(
                    List.generate(
                      rowItemsCount - movieCards.length,
                      (index) => null,
                    ).map((element) {
                      return Container(
                        width: itemWidth,
                        padding: EdgeInsets.only(bottom: 16),
                        child: Container(),
                      );
                    }),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: movieCards,
                );
              } else {
                if (loading ?? false) {
                  return LoadingWidget();
                } else if (error?.isNotEmpty ?? false) {
                  return ErrorVidget(
                      error ?? "Something went wrong", () => retry!());
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  final String title;
  final String posterUrl;
  final double rating;
  final Widget Function() openBuilder;
  final Function onClosed;
  const MovieItem(
      this.title, this.posterUrl, this.rating, this.openBuilder, this.onClosed,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      onClosed: (_) => onClosed(),
      openElevation: 0,
      openBuilder: (_, __) => openBuilder(),
      closedColor: Colors.transparent,
      closedElevation: 0,
      closedBuilder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: CachedNetworkImage(
              imageUrl: posterUrl,
              placeholder: (context, str) => Image.asset(
                "assets/images/poster_placeholder.jpg",
                width: 200,
              ),
              errorWidget: (context, str, _) => Image.asset(
                "assets/images/poster_placeholder.jpg",
                width: 200,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Text(
                rating.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/ui/components/error_widget.dart';
import 'package:movie_info_app_flutter/ui/components/loading_widget.dart';

class MovieGrid extends StatefulWidget {
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

  @override
  State<MovieGrid> createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  final int maxSize = 200;

  final int spacing = 16;

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange &&
          widget.loading != true &&
          widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<List<Movie>> chunked = [];
    Size size = MediaQuery.of(context).size;
    int width = size.width.toInt();
    int rowItemsCount = ((width - spacing) / (maxSize + spacing)).ceil();
    double itemWidth = (width - spacing * (rowItemsCount + 1)) / rowItemsCount;
    for (var i = 0; i < widget.movies.length; i += rowItemsCount) {
      var end = (i + rowItemsCount < widget.movies.length)
          ? i + rowItemsCount
          : widget.movies.length;
      chunked.add(widget.movies.sublist(i, end));
    }
    int rowCount = chunked.length + 1;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          if (widget.onRefresh != null) {
            widget.onRefresh!();
          }
        },
        child: ListView.builder(
          controller: _scrollController,
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
                    () => widget.openBuilder(movie),
                    widget.onClosed ?? () {},
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
              if (widget.loading ?? false) {
                return LoadingWidget();
              } else if (widget.error?.isNotEmpty ?? false) {
                return ErrorVidget(widget.error ?? "Something went wrong",
                    () => widget.retry!());
              }
            }
            return Container();
          },
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

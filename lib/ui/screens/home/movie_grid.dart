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
  final double maxSize = 200;

  final double spacing = 16;

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async {
            if (widget.onRefresh != null) {
              widget.onRefresh!();
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final movie = widget.movies[index];
                    return MovieItem(
                      movie.title,
                      movie.getPosterUrl(),
                      movie.voteAverage ?? 0,
                      () => widget.openBuilder(movie),
                      widget.onClosed ?? () {},
                    );
                  },
                  childCount: widget.movies.length,
                ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxSize,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: 0.555,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 16),
                sliver: SliverToBoxAdapter(
                    child: widget.loading ?? false ? const LoadingWidget() : const SizedBox()),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 16),
                sliver: SliverToBoxAdapter(
                    child: widget.error?.isNotEmpty ?? false
                        ? ErrorVidget(widget.error ?? "Something went wrong", () => widget.retry!())
                        : const SizedBox()),
              ),
            ],
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
  const MovieItem(this.title, this.posterUrl, this.rating, this.openBuilder, this.onClosed,
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
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.yellow),
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

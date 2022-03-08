import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_info_app_flutter/bloc/genre/genre_bloc.dart';
import 'package:movie_info_app_flutter/bloc/movie/movie_bloc.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/components/slide_transition.dart';
import 'package:movie_info_app_flutter/ui/screens/details/details_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/favorites/favorites_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/search/search_screen.dart';
import 'dart:math';

import 'category_row.dart';
import 'genre_row.dart';
import 'movie_grid.dart';

class HomeScreen extends StatefulWidget {
  static Widget screen() => MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
              create: (_) => MovieBloc(locator.get<MovieRepository>())),
          BlocProvider<GenreBloc>(
              create: (_) => GenreBloc(locator.get<MovieRepository>())),
        ],
        child: const HomeScreen(),
      );

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late MovieBloc movieBloc;
  late GenreBloc genreBloc;

  late AnimationController animationController;

  var maxSlide = 300.0;
  final minDragStartEdge = 50;

  bool _canBeDragged = false;

  @override
  void initState() {
    movieBloc = BlocProvider.of<MovieBloc>(context);
    genreBloc = BlocProvider.of<GenreBloc>(context);
    movieBloc.add(LoadMoviesEvent());
    genreBloc.add(LoadGenresEvent());

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  void dispose() {
    movieBloc.close();
    genreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    maxSlide = width * 0.7;
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
            animation: animationController,
            child: HomeContent(
              movieBloc: movieBloc,
              genreBloc: genreBloc,
            ),
            builder: (context, child) {
              double slide = maxSlide * animationController.value;
              return GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragEnd: _onDragEnd,
                onHorizontalDragUpdate: _onDragUpdate,
                onTap: animationController.isCompleted ? () => toggle() : null,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(color: Colors.transparent)),
                    Transform.translate(
                      offset: Offset(slide - maxSlide, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(pi / 2 * (1 - animationController.value)),
                        alignment: Alignment.centerRight,
                        child: HomeDrawer(maxSlide: maxSlide),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(slide, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-pi / 2 * animationController.value),
                        alignment: Alignment.centerLeft,
                        child: child,
                      ),
                    ),
                    Transform.translate(
                      offset:
                          Offset((width - 64) * animationController.value, 0),
                      child: HomeAppBar(onMenuClick: toggle),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void toggle() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
  }

  void open() {
    animationController.animateTo(1);
  }

  void close() {
    animationController.animateTo(0);
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = animationController.isCompleted &&
        details.globalPosition.dx > minDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = (details.primaryDelta ?? 0) / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() > 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}

class HomeAppBar extends StatelessWidget {
  final Function onMenuClick;

  const HomeAppBar({
    required this.onMenuClick,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: AppBar(
        title: const Text("Movie Info App"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => onMenuClick(),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context, MySlideTransition(SearchScreen.screen())),
              icon: const Icon(Icons.search)),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
    required this.movieBloc,
    required this.genreBloc,
  }) : super(key: key);

  final MovieBloc movieBloc;
  final GenreBloc genreBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 56.0),
          BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              return CategoryRow(
                state.category,
                (category) => movieBloc.add(CategorySelectEvent(category)),
              );
            },
          ),
          const SizedBox(height: 8),
          BlocBuilder<GenreBloc, GenreState>(
            builder: (context, state) {
              if (state is GenresLoaded) {
                return GenreRow(
                  state.genres,
                  selectedGenre: state.selectedGenre,
                  onGenreSelected: (genre) {
                    movieBloc.add(GenreSelectedEvent(genre.id));
                    genreBloc.add(SelectGenreEvent(genre));
                  },
                );
              }
              return Container();
            },
          ),
          BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              bool? loading;
              String? error;
              if (state is MovieLoadingState) {
                loading = true;
              } else {
                loading = false;
              }
              if (state is MovieLoadErrorState) {
                error = state.error;
              }
              return MovieGrid(
                movieBloc.getFilteredMovies(),
                (movie) {
                  return DetailsScreen.screen(movie);
                },
                onRefresh: () => movieBloc.add(RefreshEvent()),
                onLoadMore: () => movieBloc.add(LoadMoviesEvent()),
                loading: loading,
                error: error,
                retry: () => movieBloc.add(LoadMoviesEvent()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  final double maxSlide;

  const HomeDrawer({required this.maxSlide, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxSlide,
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/ic_launcher.png",
                  width: 64,
                  height: 64,
                ),
                Text(
                  "Movie Info App",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Search"),
            onTap: () => Navigator.push(
                context, MySlideTransition(SearchScreen.screen())),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Favorites"),
            onTap: () => Navigator.push(
              context,
              MySlideTransition(FavoritesScreen.screen()),
            ),
          )
        ],
      ),
    );
  }
}

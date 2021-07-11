import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_info_app_flutter/bloc/genre/genre_bloc.dart';
import 'package:movie_info_app_flutter/bloc/movie/movie_bloc.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/screens/details/details_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/favorites/favorites_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/search/search_screen.dart';

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
        child: HomeScreen(),
      );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieBloc movieBloc;
  late GenreBloc genreBloc;

  @override
  void initState() {
    movieBloc = BlocProvider.of<MovieBloc>(context);
    genreBloc = BlocProvider.of<GenreBloc>(context);
    movieBloc.add(LoadMoviesEvent());
    genreBloc.add(LoadGenresEvent());
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
    return Container(
      child: Scaffold(
        appBar: buildAppBar(context),
        drawer: Drawer(
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
              )),
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Search"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchScreen.screen()),
                ),
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text("Favorites"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoritesScreen.screen()),
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                var bloc = BlocProvider.of<MovieBloc>(context);
                return CategoryRow(
                  state.category,
                  (category) => bloc.add(CategorySelectEvent(category)),
                );
              },
            ),
            SizedBox(
              height: 8,
            ),
            BlocBuilder<GenreBloc, GenreState>(
              builder: (context, state) {
                var _bloc = BlocProvider.of<GenreBloc>(context);
                if (state is GenresLoaded) {
                  return GenreRow(
                    state.genres,
                    selectedGenre: state.selectedGenre,
                    onGenreSelected: (genre) {
                      movieBloc.add(GenreSelectedEvent(genre.id));
                      _bloc.add(SelectGenreEvent(genre));
                    },
                  );
                }
                return Container();
              },
            ),
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                var bloc = BlocProvider.of<MovieBloc>(context);
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
                  onRefresh: () => bloc.add(RefreshEvent()),
                  onLoadMore: () => bloc.add(LoadMoviesEvent()),
                  loading: loading,
                  error: error,
                  retry: () => bloc.add(LoadMoviesEvent()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Movie Info App"),
      leading: Builder(builder: (context) {
        return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu));
      }),
      actions: [
        IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen.screen())),
            icon: Icon(Icons.search)),
      ],
    );
  }
}

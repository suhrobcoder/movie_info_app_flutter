import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_info_app_flutter/bloc/genre/genre_bloc.dart';
import 'package:movie_info_app_flutter/bloc/movie/movie_bloc.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

import 'category_row.dart';
import 'genre_row.dart';
import 'movie_grid.dart';

class HomeScreen extends StatelessWidget {
  static MovieRepository repository = MovieRepository();
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
            create: (_) => MovieBloc(repository)..add(LoadMoviesEvent())),
        BlocProvider<GenreBloc>(
            create: (_) => GenreBloc(repository)..add(LoadGenresEvent())),
      ],
      child: Container(
        child: Scaffold(
          appBar: buildAppBar(),
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
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text("Favorites"),
                  onTap: () {},
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
                    return GenreRow(state.genres, state.selectedGenre,
                        (genre) => _bloc.add(SelectGenreEvent(genre)));
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
                  }
                  if (state is MovieLoadErrorState) {
                    error = state.error;
                  }
                  return MovieGrid(
                    state.movies,
                    (movie) {},
                    () => bloc.add(RefreshEvent()),
                    () => bloc.add(LoadMoviesEvent()),
                    loading: loading,
                    error: error,
                    retry: () => bloc.add(LoadMoviesEvent()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Movie Info App"),
      leading: Builder(builder: (context) {
        return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu));
      }),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
      ],
    );
  }
}

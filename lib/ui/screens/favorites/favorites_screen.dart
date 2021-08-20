import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_info_app_flutter/bloc/favorites/favorites_bloc.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/components/loading_widget.dart';
import 'package:movie_info_app_flutter/ui/screens/details/details_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/home/movie_grid.dart';

class FavoritesScreen extends StatefulWidget {
  static Widget screen() => BlocProvider(
        create: (context) => FavoritesBloc(locator.get<SavedMoviesRepository>()),
        child: const FavoritesScreen(),
      );

  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoritesBloc favBloc;

  @override
  void initState() {
    favBloc = BlocProvider.of<FavoritesBloc>(context);
    favBloc.add(LoadFavorites());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: Column(
        children: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoading) {
                return const LoadingWidget();
              } else if (state is FavoritesLoaded) {
                return MovieGrid(
                  state.movies,
                  (movie) {
                    return DetailsScreen.screen(movie);
                  },
                  onClosed: () => favBloc.add(LoadFavorites()),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_info_app_flutter/bloc/favorites/favorites_bloc.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';
import 'package:movie_info_app_flutter/ui/components/loading_widget.dart';
import 'package:movie_info_app_flutter/ui/screens/details/details_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/home/movie_grid.dart';

class FavoritesScreen extends StatelessWidget {
  final SavedMoviesRepository savedRepository = SavedMoviesRepository();
  final MovieRepository repository = MovieRepository();
  FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("yes");
    return BlocProvider(
      create: (context) => FavoritesBloc(savedRepository)..add(LoadFavorites()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Favorites"),
        ),
        body: Column(
          children: [
            BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                FavoritesBloc bloc = BlocProvider.of<FavoritesBloc>(context);
                if (state is FavoritesLoading) {
                  return LoadingWidget();
                } else if (state is FavoritesLoaded) {
                  return MovieGrid(
                    state.movies,
                    (movie) {
                      return DetailsScreen(movie, repository, savedRepository);
                    },
                    onClosed: () => bloc.add(LoadFavorites()),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

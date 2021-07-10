import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_info_app_flutter/bloc/search/search_bloc.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/components/error_widget.dart';
import 'package:movie_info_app_flutter/ui/components/loading_widget.dart';
import 'package:movie_info_app_flutter/ui/screens/details/details_screen.dart';

import 'movie_search_item.dart';

class SearchScreen extends StatelessWidget {
  static TextEditingController _controller = TextEditingController();
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(locator.get<MovieRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 18),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controller.text = "";
                    },
                    icon: Icon(Icons.close, color: Colors.white70),
                    splashRadius: 24,
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                onSubmitted: (query) {
                  SearchBloc _bloc = BlocProvider.of<SearchBloc>(context);
                  _bloc.add(SearchExecuteEvent(query));
                },
              );
            },
          ),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            SearchBloc bloc = BlocProvider.of<SearchBloc>(context);
            if (state is SearchLoaded) {
              List<Movie> movies = state.movies;
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  Movie movie = movies[index];
                  return MovieSearchItem(
                    movie.getPosterUrl(),
                    movie.title,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsScreen(movie))),
                  );
                },
              );
            }
            if (state is Searching) {
              return LoadingWidget();
            }
            if (state is SearchError) {
              return ErrorVidget(state.error,
                  () => bloc.add(SearchRetryEvent(_controller.text)));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

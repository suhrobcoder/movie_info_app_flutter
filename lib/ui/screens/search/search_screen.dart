import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_info_app_flutter/bloc/search/search_bloc.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/components/error_widget.dart';
import 'package:movie_info_app_flutter/ui/components/loading_widget.dart';
import 'package:movie_info_app_flutter/ui/screens/details/details_screen.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';

import 'movie_search_item.dart';

class SearchScreen extends StatefulWidget {
  final TextEditingController _controller = TextEditingController();

  static Widget screen() => BlocProvider(
        create: (context) => SearchBloc(locator.get<MovieRepository>()),
        child: SearchScreen(),
      );

  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc searchBloc;

  @override
  void initState() {
    searchBloc = BlocProvider.of<SearchBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return TextField(
              controller: widget._controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.white30, fontSize: 18),
                suffixIcon: IconButton(
                  onPressed: () {
                    widget._controller.text = "";
                  },
                  icon: const Icon(Icons.close, color: Colors.white70),
                  splashRadius: 24,
                ),
              ),
              cursorColor: accentColor,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (query) {
                searchBloc.add(SearchExecuteEvent(query));
              },
            );
          },
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
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
                          builder: (context) => DetailsScreen.screen(movie))),
                );
              },
            );
          }
          if (state is Searching) {
            return const LoadingWidget();
          }
          if (state is SearchError) {
            return ErrorVidget(
              state.error,
              () => searchBloc.add(SearchRetryEvent(widget._controller.text)),
            );
          }
          return Container();
        },
      ),
    );
  }
}

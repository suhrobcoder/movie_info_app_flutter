import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/genre.dart';

class GenreRow extends StatelessWidget {
  final List<Genre> genres;
  final Genre selectedGenre;
  final Function(Genre) onGenreSelected;
  const GenreRow(this.genres, this.selectedGenre, this.onGenreSelected,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return GenreItem(
            genres[index].name,
            selectedGenre == genres[index],
            () => onGenreSelected(genres[index]),
            index == 0
                ? -1
                : (index == genres.length - 1)
                    ? 1
                    : 0,
          );
        },
      ),
    );
  }
}

class GenreItem extends StatelessWidget {
  final String name;
  final bool isSelected;
  final Function onClick;
  final int index;
  const GenreItem(this.name, this.isSelected, this.onClick, this.index,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: index == -1 ? 16 : 8,
        right: index == 1 ? 16 : 8,
        top: 8,
        bottom: 8,
      ),
      child: InkWell(
        onTap: () => onClick(),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
              color:
                  isSelected ? Colors.black.withAlpha(30) : Colors.transparent,
              border: Border.all(
                color: Colors.black.withAlpha(30),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(30)),
          child: Text(
            name,
            style: Theme.of(context).textTheme.button?.copyWith(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

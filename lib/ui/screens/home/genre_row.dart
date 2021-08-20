import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/genre.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';

class GenreRow extends StatelessWidget {
  final List<Genre> genres;
  final Genre? selectedGenre;
  final Function(Genre)? onGenreSelected;
  const GenreRow(
    this.genres, {
    Key? key,
    this.selectedGenre,
    this.onGenreSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return genres.isNotEmpty
        ? SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return GenreItem(
                  genres[index].name,
                  index == 0
                      ? -1
                      : (index == genres.length - 1)
                          ? 1
                          : 0,
                  isSelected: selectedGenre == genres[index],
                  onClick: onGenreSelected != null ? () => onGenreSelected!(genres[index]) : null,
                );
              },
            ),
          )
        : const SizedBox();
  }
}

class GenreItem extends StatelessWidget {
  final String name;
  final bool? isSelected;
  final Function? onClick;
  final int index;
  const GenreItem(this.name, this.index, {Key? key, this.isSelected, this.onClick})
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
        onTap: onClick == null ? null : () => onClick!(),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
              color: isSelected == true ? accentColor.withAlpha(80) : Colors.transparent,
              border: Border.all(
                color: accentColor.withAlpha(60),
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

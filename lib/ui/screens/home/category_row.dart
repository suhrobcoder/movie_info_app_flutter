import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/bloc/movie/movie_bloc.dart';

class CategoryRow extends StatelessWidget {
  final MovieCategory selectedCategory;
  final Function(MovieCategory) onCategorySelected;
  static const Map<MovieCategory, String> categoryTitle = {
    MovieCategory.POPULAR: "Popular",
    MovieCategory.TOP_RATED: "Top Rated",
    MovieCategory.UPCOMING: "Upcoming",
  };
  static const List<MovieCategory> categories = [
    MovieCategory.POPULAR,
    MovieCategory.TOP_RATED,
    MovieCategory.UPCOMING,
  ];
  const CategoryRow(this.selectedCategory, this.onCategorySelected, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 8, left: 6, right: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          return CategoryItem(
            categoryTitle[category]!,
            category == selectedCategory,
            () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onClick;
  const CategoryItem(this.title, this.isSelected, this.onClick, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Container(
              width: 42,
              height: 6,
              decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(3)),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/cast.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';

class CastRow extends StatelessWidget {
  final List<Cast> casts;
  const CastRow(this.casts, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(
              "Cast",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 124,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: casts.length,
              itemBuilder: (context, index) {
                Cast cast = casts[index];
                return Padding(
                  padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 4, right: index == casts.length - 1 ? 16 : 4),
                  child: CastItem(cast.getProfileImageUrl(), cast.name, cast.character),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CastItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String character;
  const CastItem(this.imageUrl, this.name, this.character, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(42),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, str) => Image.asset(
                  "assets/images/profile_placeholder.png",
                ),
                errorWidget: (context, str, _) => Image.asset(
                  "assets/images/profile_placeholder.png",
                ),
              ),
            ),
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.subtitle2,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          Text(
            character,
            maxLines: 2,
            style: Theme.of(context).textTheme.subtitle2?.copyWith(color: textColor.withAlpha(200)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

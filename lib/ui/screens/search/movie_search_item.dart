import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieSearchItem extends StatelessWidget {
  final String posterUrl;
  final String title;
  final Function onClick;
  const MovieSearchItem(this.posterUrl, this.title, this.onClick, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Row(
        children: [
          CachedNetworkImage(
            height: 64,
            imageUrl: posterUrl,
            placeholder: (context, str) => Image.asset(
              "assets/images/poster_placeholder.jpg",
              height: 64,
            ),
            errorWidget: (context, str, _) => Image.asset(
              "assets/images/poster_placeholder.jpg",
              height: 64,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

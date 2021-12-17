import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_info_app_flutter/data/model/movie_review.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';

class ReviewsScreen extends StatelessWidget {
  final List<MovieReview> reviews;
  const ReviewsScreen(this.reviews, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ReviewItem(reviews[index]);
        },
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final MovieReview review;

  const ReviewItem(this.review, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 4)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(42),
                  child: CachedNetworkImage(
                    imageUrl: review.authorDetails.getAvatarUrl(),
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
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  review.author,
                  style: Theme.of(context).textTheme.headline6,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              RatingBarIndicator(
                itemBuilder: (_, __) =>
                    const Icon(Icons.star, color: Colors.yellow),
                rating: (review.authorDetails.rating ?? 0) / 2,
                itemSize: 24,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            review.content,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}

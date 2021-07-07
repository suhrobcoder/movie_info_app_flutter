import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/data/model/movie_review.dart';

class ReviewsScreen extends StatelessWidget {
  final List<MovieReview> reviews;
  const ReviewsScreen(this.reviews, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 4)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
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
              SizedBox(
                width: 8,
              ),
              Text(
                review.author,
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              RatingBar(review.authorDetails.rating ?? 0),
            ],
          ),
          SizedBox(
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

class RatingBar extends StatelessWidget {
  final double rating;
  const RatingBar(this.rating, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) => index).map((e) {
        double x = rating - e * 2;
        return x > 1
            ? Icon(Icons.star, color: Colors.yellow)
            : x == 1
                ? Icon(Icons.star_half, color: Colors.yellow)
                : Icon(Icons.star, color: Colors.transparent);
      }).toList(),
    );
  }
}

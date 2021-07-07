class ReviewAuthor {
  final String name;
  final String username;
  final String avatarPath;
  final double? rating;

  ReviewAuthor(this.name, this.username, this.avatarPath, this.rating);

  ReviewAuthor.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        username = json["username"],
        avatarPath = json["avatar_path"],
        rating = json["rating"];

  String getAvatarUrl() {
    return "https://image.tmdb.org/t/p/w500/$avatarPath";
  }
}

class Cast {
  final int id;
  final String name;
  final String? profilePath;
  final String character;
  final int order;

  Cast(this.id, this.name, this.profilePath, this.character, this.order);

  Cast.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        profilePath = json["profile_path"],
        character = json["character"],
        order = json["order"];

  String getProfileImageUrl() {
    return "https://image.tmdb.org/t/p/w500/$profilePath";
  }
}

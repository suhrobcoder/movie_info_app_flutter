class MovieVideo {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  MovieVideo(this.id, this.key, this.name, this.site, this.type);

  MovieVideo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        key = json["key"],
        name = json["name"],
        site = json["site"],
        type = json["type"];

  String getYoutubeUrl() {
    return "https://youtu.be/$key";
  }
}

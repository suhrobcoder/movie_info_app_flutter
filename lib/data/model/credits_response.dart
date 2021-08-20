import 'package:movie_info_app_flutter/data/model/cast.dart';

class CreditsResponse {
  final int id;
  final List<Cast> cast;
  final String error;

  CreditsResponse(this.id, this.cast, this.error);

  CreditsResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        cast = (json["cast"] as List).map((e) => Cast.fromJson(e)).toList(),
        error = "";

  CreditsResponse.withError(this.error)
      : id = 0,
        cast = [];
}

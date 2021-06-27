class RateResponse {
  final int statusCode;
  final String statusMessage;

  RateResponse(this.statusCode, this.statusMessage);

  RateResponse.fromJson(Map<String, dynamic> json)
      : statusCode = json["status_code"],
        statusMessage = json["status_message"];
}

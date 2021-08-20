class GuestSessionResponse {
  final bool success;
  final String guestSessionId;
  final String expiresAt;
  final String error;

  GuestSessionResponse(this.success, this.guestSessionId, this.expiresAt, this.error);

  GuestSessionResponse.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        guestSessionId = json["guest_session_id"],
        expiresAt = json["expires_at"],
        error = "";

  GuestSessionResponse.withError(this.error)
      : success = false,
        guestSessionId = "",
        expiresAt = "";
}

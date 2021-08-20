import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final String keySessionId = "session_id";
  final String keyExpire = "expires_at";

  static SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future saveGuestSessionId(String guestSessionId, String expiresAt) async {
    SharedPreferences pref = await prefs;
    await pref.setString(keySessionId, guestSessionId);
    await pref.setString(keyExpire, expiresAt);
  }

  Future<String?> getValidSessionIdOrNull() async {
    SharedPreferences pref = await prefs;
    String? expiresAt = pref.getString(keyExpire);
    if (expiresAt == null) {
      return null;
    }
    expiresAt = expiresAt.replaceAll("UTC", "Z");
    var now = DateTime.now();
    var expire = DateTime.parse(expiresAt);
    expire = expire.add(now.timeZoneOffset);
    return now.compareTo(expire) < 0 ? pref.getString(keySessionId) : null;
  }
}

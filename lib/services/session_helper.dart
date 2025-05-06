import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionManager {
  static const String _sessionKey = 'session_id';

  // generate a session if not exists or reset
  static Future<String> generateSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(_sessionKey);

    if (sessionId == null) {
      sessionId = const Uuid().v4(); // generate random UUID
      await prefs.setString(_sessionKey, sessionId);
    }

    return sessionId;
  }

  // reset session
  static Future<void> resetSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

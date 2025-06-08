import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String userIdKey = "user_id";
  static const String userEmailKey = "user_email";
  static const String isLoginKey = "is_login";

  Future<void> saveUserSession(String id, String email, bool isLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userIdKey, id);
    await prefs.setString(userEmailKey, email);
    await prefs.setBool(isLoginKey, isLogin);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoginKey) ?? false;
  }

  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(isLoginKey);
  }
}

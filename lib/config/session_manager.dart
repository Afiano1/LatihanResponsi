import 'package:shared_preferences/shared_preferences.dart';


class SessionManager {
  // untuk SharedPreferences
  static const String _keyRegisteredUsername = 'registered_username';
  static const String _keyRegisteredPassword = 'registered_password';
  static const String _keyIsLogin = 'is_login';
  static const String _keyLoginUsername = 'login_username';

  /// Simpan akun yang terdaftar (username & password)
  Future<void> saveRegisteredUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRegisteredUsername, username);
    await prefs.setString(_keyRegisteredPassword, password);
  }


  Future<String?> getRegisteredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRegisteredUsername);
  }


  Future<String?> getRegisteredPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRegisteredPassword);
  }

  Future<void> saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, true);
    await prefs.setString(_keyLoginUsername, username);
  }


  Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }


  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLoginUsername);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, false);
    await prefs.remove(_keyLoginUsername);
  }
}

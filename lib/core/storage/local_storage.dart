import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences prefs;

  LocalStorage(this.prefs);

  Future<void> saveToken(String token) async {
    await prefs.setString("token", token);
  }

  String? getToken() => prefs.getString("token");

  Future<void> clearToken() async {
    await prefs.remove("token");
  }
}
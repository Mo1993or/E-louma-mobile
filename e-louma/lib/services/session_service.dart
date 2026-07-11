import 'package:E_louma/models/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  SessionService._();
  static const _roleKey = 'user_role';

  static Future<UserRole?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return UserRole.fromStorage(prefs.getString(_roleKey));
  }

  static Future<void> setRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.storageValue);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('savedConnexion') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('savedConnexion', value);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedConnexion');
    await prefs.remove(_roleKey);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class AppStorageService {
  Future<void> save<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else {
      throw UnsupportedError("Unsupported type: ${value.runtimeType}");
    }
  }

  Future<T?> get<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get(key);

    if (value is T) {
      return value;
    }
    return null;
  }

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// External dependencies
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPlugin {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> _getInstance() async {
    if (_preferences != null) return _preferences!;

    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  static Future<bool> writeStringValue({required String key, required String value}) async {
    final prefs = await _getInstance();
    return prefs.setString(key, value);
  }

  static Future<void> writeDoubleValue({required String key, required double value}) async {
    final prefs = await _getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<bool> writeIntValue({required String key, required int value}) async {
    final prefs = await _getInstance();
    return prefs.setInt(key, value);
  }

  static Future<bool> writeBoolValue({required String key, required bool value}) async {
    final prefs = await _getInstance();
    return prefs.setBool(key, value);
  }

  static Future<String> getStringValue({required String key}) async {
    final prefs = await _getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<int> getIntValue({required String key}) async {
    final prefs = await _getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<double> getDoubleValue({required String key}) async {
    final prefs = await _getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  static Future<bool?> getBoolValue({required String key}) async {
    final prefs = await _getInstance();
    return prefs.getBool(key);
  }

  static Future<void> clearAll() async {
    final prefs = await _getInstance();
    await prefs.clear();
  }

  static Future<void> removeValue({required String key}) async {
    final prefs = await _getInstance();
    await prefs.remove(key);
  }
}

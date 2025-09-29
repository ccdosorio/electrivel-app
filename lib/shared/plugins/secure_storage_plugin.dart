// External dependencies
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStoragePlugin {
  static _getInstance() {
    return const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  }

  static Future<void> writeStorage({required String key, required String value}) async {
    final storage = _getInstance();
    await storage.write(key: key, value: value);
  }

  static Future<String?> readStorage({required String key}) async {
    final storage = _getInstance();
    return await storage.read(key: key);
  }

  static Future<void> deleteStorage({required String key}) async {
    final storage = _getInstance();
    await storage.delete(key: key);
  }

  static Future<void> deleteAllStorage() async {
    await _getInstance().deleteAll();
  }
}

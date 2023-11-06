import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() {
    return _instance;
  }
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getString(String key) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      throw Exception(
        "Impossible d'accéder aux variables d'environnement.",
      );
    }
  }

  Future<void> setString(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<bool> exist(String key) async {
    return await storage.containsKey(key: key);
  }

  LocalStorageService._internal();
}

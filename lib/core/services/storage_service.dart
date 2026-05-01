import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Singleton instance
  final _storage = const FlutterSecureStorage();

  // Private constructor to prevent external instantiation
  static const _tokanKey = 'auth_token';

  // save token in storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokanKey, value: token);
  }

  // get the saved token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokanKey);
  }

  // delete the saved token
  Future<void> deleteToken() async {
    return _storage.delete(key: _tokanKey);
  }
}
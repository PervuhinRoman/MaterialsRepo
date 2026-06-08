import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web/web.dart' as web;

abstract interface class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> clearTokens();
}

class WebTokenStorage implements TokenStorage {
  static const _accessKey = 'edu_repo_access_token';
  static const _refreshKey = 'edu_repo_refresh_token';

  @override
  Future<String?> getAccessToken() async =>
      web.window.localStorage.getItem(_accessKey);

  @override
  Future<String?> getRefreshToken() async =>
      web.window.localStorage.getItem(_refreshKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    web.window.localStorage.setItem(_accessKey, accessToken);
    web.window.localStorage.setItem(_refreshKey, refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    web.window.localStorage.removeItem(_accessKey);
    web.window.localStorage.removeItem(_refreshKey);
  }
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage()
    : _storage = const FlutterSecureStorage(
        webOptions: WebOptions(dbName: 'materials_repo_auth'),
      );

  final FlutterSecureStorage _storage;
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  @override
  Future<String?> getAccessToken() => _storage.read(key: _accessKey);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: accessToken),
      _storage.write(key: _refreshKey, value: refreshToken),
    ]);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
    ]);
  }
}

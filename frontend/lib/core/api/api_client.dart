import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Базовый URL переключается через --dart-define=API_URL=...
/// В Docker-окружении запросы идут через nginx proxy на /api/
const String _defaultBaseUrl = kDebugMode
    ? 'http://localhost:8000'
    : '/api';

const String apiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: _defaultBaseUrl,
);

/// Единственная точка создания Dio-клиента.
/// Интерсепторы добавляются снаружи (AuthInterceptor).
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}
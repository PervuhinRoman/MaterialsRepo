import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

part 'dio_providers.g.dart';

@riverpod
TokenStorage tokenStorage(Ref ref) => SecureTokenStorage();

@riverpod
Dio unauthenticatedDio(Ref ref) => createDio();

/// Dio без onUnauthenticated — колбэк подключается в main.dart
@riverpod
Dio authenticatedDio(Ref ref) {
  final dio = createDio();
  final storage = ref.read(tokenStorageProvider);

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: storage,
      onUnauthenticated: () {}, // пустой — переопределяется в main.dart
    ),
  );

  return dio;
}
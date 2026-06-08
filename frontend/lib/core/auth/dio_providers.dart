import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

part 'dio_providers.g.dart';

@riverpod
TokenStorage tokenStorage(Ref ref) =>
    kIsWeb ? WebTokenStorage() : SecureTokenStorage();

@riverpod
Dio unauthenticatedDio(Ref ref) => createDio();

@riverpod
Dio authenticatedDio(Ref ref) {
  final dio = createDio();
  final storage = ref.read(tokenStorageProvider);

  dio.interceptors.add(
    AuthInterceptor(tokenStorage: storage, onUnauthenticated: () {}),
  );

  return dio;
}

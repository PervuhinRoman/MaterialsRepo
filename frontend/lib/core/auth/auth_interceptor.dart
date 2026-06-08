import 'package:dio/dio.dart';

import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.onUnauthenticated,
  });

  final TokenStorage tokenStorage;
  void Function() onUnauthenticated;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Вызываем logout только если токен был — иначе это
      // просто запрос без авторизации, не разрыв сессии
      final token = await tokenStorage.getAccessToken();
      if (token != null) {
        await tokenStorage.clearTokens();
        onUnauthenticated();
      }
    }
    handler.next(err);
  }
}

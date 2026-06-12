import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_state.dart';
import 'dio_providers.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _restoreSession();
    return const AuthState.loading();
  }

  Future<void> _restoreSession() async {
    final storage = ref.read(tokenStorageProvider);
    final token = await storage.getAccessToken();

    if (token == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    try {
      final dio = ref.read(authenticatedDioProvider);
      final response = await dio.get('/auth/me');
      final user = AuthUser(
        id: response.data['id'] as String,
        email: response.data['email'] as String,
        username: response.data['username'] as String,
        role: response.data['role'] as String,
        isActive: response.data['is_active'] as bool,
      );
      state = AuthState.authenticated(user: user);
    } on DioException {
      await ref.read(tokenStorageProvider).clearTokens();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    final dio = ref.read(unauthenticatedDioProvider);
    final response = await dio.post(
      '/auth/login',
      data: {'username': email, 'password': password},
      options: Options(contentType: 'application/x-www-form-urlencoded'),
    );

    final accessToken = response.data['access_token'] as String;
    final refreshToken = response.data['refresh_token'] as String? ?? '';

    await ref
        .read(tokenStorageProvider)
        .saveTokens(accessToken: accessToken, refreshToken: refreshToken);

    // Инвалидируем кэшированный Dio — следующий read создаст новый
    // экземпляр который подхватит токен через AuthInterceptor
    ref.invalidate(authenticatedDioProvider);

    final profileResponse = await ref
        .read(authenticatedDioProvider)
        .get('/auth/me');
    final user = AuthUser(
      id: profileResponse.data['id'] as String,
      email: profileResponse.data['email'] as String,
      username: profileResponse.data['username'] as String,
      role: profileResponse.data['role'] as String,
      isActive: profileResponse.data['is_active'] as bool,
    );

    state = AuthState.authenticated(user: user);
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    // Не меняем state до успешного входа — иначе GoRouter редиректит
    // на /login раньше, чем экран регистрации покажет ошибку
    final dio = ref.read(unauthenticatedDioProvider);
    await dio.post(
      '/auth/register',
      data: {
        'email': email,
        'username': username,
        'password': password,
        'role': role,
      },
    );

    // После регистрации сразу выполняем вход
    await login(email: email, password: password);
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clearTokens();
    state = const AuthState.unauthenticated();
  }
}

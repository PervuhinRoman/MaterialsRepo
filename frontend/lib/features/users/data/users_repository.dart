import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/dio_providers.dart';
import '../domain/app_user.dart';

part 'users_repository.g.dart';

class UsersRepository {
  UsersRepository(this._dio);
  final Dio _dio;

  Future<List<AppUser>> getUsers() async {
    final response = await _dio.get('/auth/users');
    final list = response.data as List<dynamic>;
    return list.map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AppUser> setActive(String userId, {required bool isActive}) async {
    final response = await _dio.patch(
      '/auth/users/$userId',
      data: {'is_active': isActive},
    );
    return AppUser.fromJson(response.data as Map<String, dynamic>);
  }
}

@riverpod
UsersRepository usersRepository(Ref ref) {
  return UsersRepository(ref.watch(authenticatedDioProvider));
}

@riverpod
Future<List<AppUser>> usersList(Ref ref) {
  return ref.watch(usersRepositoryProvider).getUsers();
}

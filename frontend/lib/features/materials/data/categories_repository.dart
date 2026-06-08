import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/dio_providers.dart';
import '../domain/category.dart';

part 'categories_repository.g.dart';

class CategoriesRepository {
  CategoriesRepository(this._dio);
  final Dio _dio;

  Future<List<Category>> getCategories() async {
    final response = await _dio.get('/materials/categories/all');
    final list = response.data as List<dynamic>;
    return list
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

@riverpod
CategoriesRepository categoriesRepository(Ref ref) {
  return CategoriesRepository(ref.watch(authenticatedDioProvider));
}

@riverpod
Future<List<Category>> categoriesList(Ref ref) {
  return ref.watch(categoriesRepositoryProvider).getCategories();
}

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/dio_providers.dart';
import '../domain/material.dart';

part 'materials_repository.g.dart';

class MaterialsRepository {
  MaterialsRepository(this._dio);

  final Dio _dio;

  Future<List<Material>> getMaterials({
    int page = 1,
    int limit = 20,
    String? search,
    int? categoryId,
  }) async {
    final response = await _dio.get(
      '/materials/',
      queryParameters: {
        'skip': (page - 1) * limit,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null) 'category_id': categoryId,
      },
    );

    final list = response.data as List<dynamic>;
    return list
        .map((e) => Material.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> downloadMaterial(String id) async {
    await _dio.get('/materials/$id/download');
  }

  Future<void> deleteMaterial(String id) async {
    await _dio.delete('/materials/$id');
  }

  Future<Material> getMaterial(String id) async {
    final response = await _dio.get('/materials/$id');
    return Material.fromJson(response.data as Map<String, dynamic>);
  }
}

@riverpod
MaterialsRepository materialsRepository(Ref ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return MaterialsRepository(dio);
}

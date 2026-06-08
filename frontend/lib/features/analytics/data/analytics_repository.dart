import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/dio_providers.dart';
import '../domain/analytics.dart';

part 'analytics_repository.g.dart';

class AnalyticsRepository {
  AnalyticsRepository(this._dio);
  final Dio _dio;

  Future<SummaryStats> getSummary() async {
    final response = await _dio.get('/analytics/summary');
    return SummaryStats.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<TopMaterial>> getTopMaterials({int limit = 10}) async {
    final response = await _dio.get(
      '/analytics/top-materials',
      queryParameters: {'limit': limit},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => TopMaterial.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> exportCsv() async {
    final response = await _dio.get(
      '/analytics/export/csv',
      options: Options(responseType: ResponseType.bytes),
    );

    // Web: скачиваем файл через blob
    final bytes = response.data as List<int>;
    _downloadBlob(bytes, 'analytics.csv', 'text/csv');
  }

  void _downloadBlob(List<int> bytes, String filename, String mimeType) {
    // реализуется в экране через web package
  }
}

@riverpod
AnalyticsRepository analyticsRepository(Ref ref) {
  return AnalyticsRepository(ref.watch(authenticatedDioProvider));
}

@riverpod
Future<SummaryStats> analyticsSummary(Ref ref) {
  return ref.watch(analyticsRepositoryProvider).getSummary();
}

@riverpod
Future<List<TopMaterial>> analyticsTopMaterials(Ref ref) {
  return ref.watch(analyticsRepositoryProvider).getTopMaterials();
}

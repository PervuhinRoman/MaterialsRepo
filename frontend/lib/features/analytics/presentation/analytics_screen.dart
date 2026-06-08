import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web/web.dart' as web;

import '../../../core/auth/dio_providers.dart';
import '../data/analytics_repository.dart';
import '../domain/analytics.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(analyticsSummaryProvider);
    final topAsync = ref.watch(analyticsTopMaterialsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок + кнопка экспорта
          Row(
            children: [
              Text(
                'Аналитика',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _exportCsv(context, ref),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Экспорт CSV'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Сводные метрики
          summaryAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorWidget(
              message: 'Ошибка загрузки сводки: $e',
              onRetry: () => ref.invalidate(analyticsSummaryProvider),
            ),
            data: (summary) => _SummaryCards(summary: summary),
          ),
          const SizedBox(height: 32),

          // Топ материалов
          Text(
            'Топ материалов по скачиваниям',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          topAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorWidget(
              message: 'Ошибка загрузки топа: $e',
              onRetry: () => ref.invalidate(analyticsTopMaterialsProvider),
            ),
            data: (top) => _TopMaterialsTable(items: top),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final dio = ref.read(authenticatedDioProvider);
      final response = await dio.get(
        '/analytics/export/csv',
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data as List<int>);
      final blob = web.Blob(
        [bytes.toJS].toJS,
        web.BlobPropertyBag(type: 'text/csv'),
      );
      final url = web.URL.createObjectURL(blob);
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = 'analytics.csv';
      anchor.click();
      web.URL.revokeObjectURL(url);
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка экспорта: ${e.message}')),
        );
      }
    }
  }
}

// ─── Сводные карточки ────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.summary});
  final SummaryStats summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _StatCard(
          label: 'Всего событий',
          value: '${summary.totalEvents}',
          icon: Icons.analytics_outlined,
        ),
        _StatCard(
          label: 'Просмотров',
          value: '${summary.views}',
          icon: Icons.visibility_outlined,
        ),
        _StatCard(
          label: 'Скачиваний',
          value: '${summary.downloads}',
          icon: Icons.download_outlined,
        ),
        _StatCard(
          label: 'Загрузок',
          value: '${summary.uploads}',
          icon: Icons.upload_outlined,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: colorScheme.primary),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Таблица топ материалов ──────────────────────────────────────────────────

class _TopMaterialsTable extends StatelessWidget {
  const _TopMaterialsTable({required this.items});
  final List<TopMaterial> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Данных пока нет'));
    }

    return Card(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('ID материала')),
          DataColumn(label: Text('Скачиваний'), numeric: true),
        ],
        rows: items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return DataRow(
            cells: [
              DataCell(Text('$index')),
              DataCell(Text(item.materialId ?? '—')),
              DataCell(Text('${item.count}')),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Виджет ошибки ───────────────────────────────────────────────────────────

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Повторить')),
        ],
      ),
    );
  }
}

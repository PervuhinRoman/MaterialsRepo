import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as web;

import '../../../core/auth/dio_providers.dart';
import '../../../core/router/app_router.dart';
import '../data/materials_provider.dart';
import '../domain/material.dart' as domain;

class MaterialDetailScreen extends ConsumerWidget {
  const MaterialDetailScreen({required this.materialId, super.key});

  final String materialId;

  String _formatSize(int bytes) {
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} КБ';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} МБ';
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialAsync = ref.watch(materialDetailProvider(materialId));
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      child: materialAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('Ошибка загрузки: $e'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(materialDetailProvider(materialId)),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
        data: (material) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Хлебные крошки
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => context.go(AppRoutes.materials),
                        child: const Text('Материалы'),
                      ),
                      const Icon(Icons.chevron_right, size: 16),
                      Text(
                        material.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Заголовок + кнопка скачать
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка файла
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _iconForMime(material.mimeType),
                          size: 32,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              material.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                material.fileName.split('.').last.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: () => _download(context, ref, material),
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Скачать'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Метаданные
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Информация о файле',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          _MetaRow(
                            label: 'Имя файла',
                            value: material.fileName,
                          ),
                          _MetaRow(
                            label: 'Размер',
                            value: _formatSize(material.fileSize),
                          ),
                          _MetaRow(label: 'Тип', value: material.mimeType),
                          _MetaRow(
                            label: 'Скачиваний',
                            value: '${material.downloadCount}',
                          ),
                          _MetaRow(
                            label: 'Загружен',
                            value: _formatDate(material.createdAt),
                          ),
                          if (material.updatedAt != null)
                            _MetaRow(
                              label: 'Обновлён',
                              value: _formatDate(material.updatedAt!),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Описание
                  if (material.description != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Описание',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              material.description!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _download(
    BuildContext context,
    WidgetRef ref,
    domain.Material material,
  ) async {
    try {
      final dio = ref.read(authenticatedDioProvider);
      final response = await dio.get(
        '/materials/${material.id}/download',
        options: Options(responseType: ResponseType.bytes),
      );

      // Web: создаём blob и программно кликаем ссылку
      final bytes = response.data as List<int>;

      final uint8Array = Uint8List.fromList(bytes);
      final blob = web.Blob(
        [uint8Array.toJS].toJS,
        web.BlobPropertyBag(type: material.mimeType),
      );
      final url = web.URL.createObjectURL(blob);
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = material.fileName;
      anchor.click();
      web.URL.revokeObjectURL(url);

      // Обновляем счётчик скачиваний
      ref.invalidate(materialDetailProvider(material.id));
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.message}')));
      }
    }
  }

  IconData _iconForMime(String mime) => switch (mime) {
    'application/pdf' => Icons.picture_as_pdf_outlined,
    String m when m.contains('word') => Icons.description_outlined,
    String m when m.contains('presentation') => Icons.slideshow_outlined,
    String m when m.contains('sheet') => Icons.table_chart_outlined,
    _ => Icons.insert_drive_file_outlined,
  };
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

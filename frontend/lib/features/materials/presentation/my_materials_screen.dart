import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:materials_repo/core/auth/auth_state.dart';

import '../../../core/auth/auth_notifier.dart';
import '../../../core/router/app_router.dart';
import '../data/materials_provider.dart';
import '../data/materials_repository.dart';
import '../domain/material.dart' as domain;

class MyMaterialsScreen extends ConsumerWidget {
  const MyMaterialsScreen({super.key});

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialsAsync = ref.watch(materialsListProvider);
    final authState = ref.watch(authProvider);

    final currentUserId = authState.when(
      loading: () => '',
      unauthenticated: () => '',
      authenticated: (user) => user.id,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок + кнопка загрузки
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мои материалы',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'Управляйте своими загруженными материалами',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.upload),
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Загрузить материал'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          materialsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Ошибка: $e')),
            data: (materials) {
              // Фильтруем по автору
              final mine = materials
                  .where((m) => m.authorId == currentUserId)
                  .toList();

              if (mine.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      Icon(
                        Icons.folder_open_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      const Text('У вас пока нет загруженных материалов'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context.go(AppRoutes.upload),
                        child: const Text('Загрузить первый материал'),
                      ),
                    ],
                  ),
                );
              }

              return Card(
                child: DataTable(
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(label: Text('Название')),
                    DataColumn(label: Text('Тип')),
                    DataColumn(label: Text('Загружен')),
                    DataColumn(label: Text('Скачиваний'), numeric: true),
                    DataColumn(label: Text('Действия')),
                  ],
                  rows: mine.map((m) => _buildRow(context, ref, m)).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, domain.Material m) {
    final ext = m.fileName.split('.').last.toUpperCase();

    return DataRow(
      cells: [
        // Название
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForMime(m.mimeType),
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Text(m.title, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        // Тип
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              ext,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
        // Дата
        DataCell(Text(_formatDate(m.createdAt))),
        // Скачивания
        DataCell(Text('${m.downloadCount}')),
        // Действия
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                tooltip: 'Редактировать',
                onPressed: () => context.go('/materials/${m.id}/edit'),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.error,
                ),
                tooltip: 'Удалить',
                onPressed: () => _confirmDelete(context, ref, m),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    domain.Material m,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить материал?'),
        content: Text('«${m.title}» будет удалён безвозвратно.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repo = ref.read(materialsRepositoryProvider);
        await repo.deleteMaterial(m.id);
        ref.invalidate(materialsListProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Материал удалён')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Ошибка удаления: $e')));
        }
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

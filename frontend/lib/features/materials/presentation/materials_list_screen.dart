import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:materials_repo/core/auth/auth_state.dart';
import 'package:web/web.dart' as web;

import '../../../core/auth/auth_notifier.dart';
import '../../../core/auth/dio_providers.dart';
import '../data/categories_repository.dart';
import '../data/materials_provider.dart';
import '../data/materials_repository.dart';
import '../domain/category.dart';
import '../domain/material.dart' as domain;

class MaterialsListScreen extends ConsumerStatefulWidget {
  const MaterialsListScreen({
    super.key,
    this.showActions = false, // true — страница «Преподавателям»
    this.filterByCurrentUser = false, // true — только свои материалы
  });

  final bool showActions;
  final bool filterByCurrentUser;

  @override
  ConsumerState<MaterialsListScreen> createState() =>
      _MaterialsListScreenState();
}

class _MaterialsListScreenState extends ConsumerState<MaterialsListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;
  bool _isGridView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materialsAsync = ref.watch(materialsListProvider);
    final categoriesAsync = ref.watch(categoriesListProvider);
    final authState = ref.watch(authProvider);

    final currentUserId = authState.when(
      loading: () => '',
      unauthenticated: () => '',
      authenticated: (user) => user.id,
    );

    final role = authState.when(
      loading: () => '',
      unauthenticated: () => '',
      authenticated: (user) => user.role,
    );

    return Material(
      child: Column(
        children: [
          // Заголовок для страницы преподавателя
          if (widget.showActions)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
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
                    onPressed: () => context.go('/upload'),
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Загрузить материал'),
                  ),
                ],
              ),
            ),

          // Поиск + фильтр + переключение вида
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск материалов...',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              }),
                            )
                          : null,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 12),
                categoriesAsync.when(
                  loading: () => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (categories) => _CategoryFilter(
                    categories: categories,
                    selected: _selectedCategoryId,
                    onChanged: (id) => setState(() => _selectedCategoryId = id),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                  tooltip: _isGridView ? 'Список' : 'Сетка',
                  onPressed: () => setState(() => _isGridView = !_isGridView),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: materialsAsync.when(
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
                      onPressed: () => ref.invalidate(materialsListProvider),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
              data: (materials) {
                var filtered = materials.where((m) {
                  final matchSearch =
                      _searchQuery.isEmpty ||
                      m.title.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );
                  final matchCategory =
                      _selectedCategoryId == null ||
                      m.categoryId == _selectedCategoryId;
                  return matchSearch && matchCategory;
                }).toList();

                // Фильтр по автору для страницы преподавателя
                if (widget.filterByCurrentUser && role != 'admin') {
                  filtered = filtered
                      .where((m) => m.authorId == currentUserId)
                      .toList();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Материалов не найдено'),
                        if (widget.showActions) ...[
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => context.go('/upload'),
                            child: const Text('Загрузить первый материал'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return _isGridView
                    ? _MaterialsGrid(
                        materials: filtered,
                        showActions: widget.showActions,
                        onDelete: (m) => _confirmDelete(context, ref, m),
                        onDownload: _download,
                      )
                    : _MaterialsList(
                        materials: filtered,
                        showActions: widget.showActions,
                        onDelete: (m) => _confirmDelete(context, ref, m),
                        onDownload: _download,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _download(domain.Material m) async {
    try {
      final dio = ref.read(authenticatedDioProvider);
      final response = await dio.get(
        '/materials/${m.id}/download',
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data as List<int>;
      final uint8Array = Uint8List.fromList(bytes);
      final blob = web.Blob(
        [uint8Array.toJS].toJS,
        web.BlobPropertyBag(type: m.mimeType),
      );
      final url = web.URL.createObjectURL(blob);
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = m.fileName;
      anchor.click();
      web.URL.revokeObjectURL(url);
      ref.invalidate(materialsListProvider);
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка скачивания: ${e.message}')),
        );
      }
    }
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
        await ref.read(materialsRepositoryProvider).deleteMaterial(m.id);
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
}

// ─── Фильтр категорий ────────────────────────────────────────────────────────

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  final List<Category> categories;
  final String? selected;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: selected,
      hint: const Text('Все категории'),
      underline: const SizedBox.shrink(),
      items: [
        const DropdownMenuItem(value: null, child: Text('Все категории')),
        ...categories.map(
          (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

// ─── ListView ────────────────────────────────────────────────────────────────

class _MaterialsList extends StatelessWidget {
  const _MaterialsList({
    required this.materials,
    required this.showActions,
    required this.onDelete,
    required this.onDownload,
  });

  final List<domain.Material> materials;
  final bool showActions;
  final void Function(domain.Material) onDelete;
  final void Function(domain.Material) onDownload;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: materials.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => InkWell(
        onTap: () => context.go('/materials/${materials[i].id}'),
        borderRadius: BorderRadius.circular(12),
        child: _MaterialCard(
          material: materials[i],
          showActions: showActions,
          onDelete: () => onDelete(materials[i]),
          onDownload: () => onDownload(materials[i]),
        ),
      ),
    );
  }
}

// ─── GridView ────────────────────────────────────────────────────────────────

class _MaterialsGrid extends StatelessWidget {
  const _MaterialsGrid({
    required this.materials,
    required this.showActions,
    required this.onDelete,
    required this.onDownload,
  });

  final List<domain.Material> materials;
  final bool showActions;
  final void Function(domain.Material) onDelete;
  final void Function(domain.Material) onDownload;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.4,
      ),
      itemCount: materials.length,
      itemBuilder: (_, i) => InkWell(
        onTap: () => context.go('/materials/${materials[i].id}'),
        borderRadius: BorderRadius.circular(12),
        child: _MaterialCard(
          material: materials[i],
          showActions: showActions,
          onDelete: () => onDelete(materials[i]),
          onDownload: () => onDownload(materials[i]),
        ),
      ),
    );
  }
}

// ─── Карточка ────────────────────────────────────────────────────────────────

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({
    required this.material,
    required this.showActions,
    required this.onDelete,
    required this.onDownload,
  });

  final domain.Material material;
  final bool showActions;
  final VoidCallback onDelete;
  final VoidCallback onDownload;

  IconData _iconForMime(String mime) => switch (mime) {
    'application/pdf' => Icons.picture_as_pdf_outlined,
    String m when m.contains('word') => Icons.description_outlined,
    String m when m.contains('presentation') => Icons.slideshow_outlined,
    String m when m.contains('sheet') => Icons.table_chart_outlined,
    _ => Icons.insert_drive_file_outlined,
  };

  String _formatSize(int bytes) {
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} КБ';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} МБ';
  }

  String _ext() => material.fileName.split('.').last.toUpperCase();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconForMime(material.mimeType),
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    material.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (material.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      material.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      _Chip(
                        label: _ext(),
                        color: colorScheme.primaryContainer,
                        textColor: colorScheme.onPrimaryContainer,
                      ),
                      _Chip(
                        label: _formatSize(material.fileSize),
                        color: colorScheme.surfaceContainerHighest,
                        textColor: colorScheme.onSurfaceVariant,
                      ),
                      _Chip(
                        label: '↓ ${material.downloadCount}',
                        color: colorScheme.surfaceContainerHighest,
                        textColor: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Скачать — для всех пользователей
            IconButton(
              icon: const Icon(Icons.download_outlined, size: 20),
              tooltip: 'Скачать',
              onPressed: onDownload,
            ),

            // Кнопки действий
            if (showActions) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                tooltip: 'Редактировать',
                onPressed: () => context.go('/materials/${material.id}/edit'),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outlined,
                  size: 20,
                  color: colorScheme.error,
                ),
                tooltip: 'Удалить',
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: textColor),
      ),
    );
  }
}

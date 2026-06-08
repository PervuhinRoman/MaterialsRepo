import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_notifier.dart';
import '../data/categories_repository.dart';
import '../data/materials_provider.dart';
import '../domain/category.dart';
import '../domain/material.dart' as domain;

class MaterialsListScreen extends ConsumerStatefulWidget {
  const MaterialsListScreen({super.key});

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

    return Material(
      child: Column(
        children: [
          // Поиск + фильтр категорий
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
                // Фильтр по категории
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
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Список / сетка
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
                // Фильтрация на фронте
                final filtered = materials.where((m) {
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

                if (filtered.isEmpty) {
                  return const Center(child: Text('Материалов не найдено'));
                }

                return _isGridView
                    ? _MaterialsGrid(materials: filtered)
                    : _MaterialsList(materials: filtered);
              },
            ),
          ),
        ],
      ),
    );
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
  const _MaterialsList({required this.materials});
  final List<domain.Material> materials;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: materials.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => InkWell(
        onTap: () => context.go('/materials/${materials[i].id}'),
        borderRadius: BorderRadius.circular(12),
        child: _MaterialCard(material: materials[i]),
      ),
    );
  }
}

// ─── GridView ────────────────────────────────────────────────────────────────

class _MaterialsGrid extends StatelessWidget {
  const _MaterialsGrid({required this.materials});
  final List<domain.Material> materials;

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
      itemBuilder: (_, i) => _MaterialCard(material: materials[i]),
    );
  }
}

// ─── Карточка ────────────────────────────────────────────────────────────────

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({required this.material});
  final domain.Material material;

  IconData _iconForMime(String mime) => switch (mime) {
    'application/pdf' => Icons.picture_as_pdf_outlined,
    'application/vnd.openxmlformats-officedocument'
        '.wordprocessingml.document' =>
      Icons.description_outlined,
    'application/vnd.openxmlformats-officedocument'
        '.presentationml.presentation' =>
      Icons.slideshow_outlined,
    'application/vnd.openxmlformats-officedocument'
        '.spreadsheetml.sheet' =>
      Icons.table_chart_outlined,
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
                      // Тип файла
                      _Chip(
                        label: _ext(),
                        color: colorScheme.primaryContainer,
                        textColor: colorScheme.onPrimaryContainer,
                      ),
                      // Размер
                      _Chip(
                        label: _formatSize(material.fileSize),
                        color: colorScheme.surfaceContainerHighest,
                        textColor: colorScheme.onSurfaceVariant,
                      ),
                      // Скачивания
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

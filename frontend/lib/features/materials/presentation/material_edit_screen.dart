import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/dio_providers.dart';
import '../../../core/router/app_router.dart';
import '../data/categories_repository.dart';
import '../data/materials_provider.dart';

class MaterialEditScreen extends ConsumerStatefulWidget {
  const MaterialEditScreen({required this.materialId, super.key});

  final String materialId;

  @override
  ConsumerState<MaterialEditScreen> createState() => _MaterialEditScreenState();
}

class _MaterialEditScreenState extends ConsumerState<MaterialEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategoryId;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initFromMaterial(dynamic material) {
    if (_isInitialized) return;
    _titleController.text = material.title;
    _descriptionController.text = material.description ?? '';
    _selectedCategoryId = material.categoryId;
    _isInitialized = true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = ref.read(authenticatedDioProvider);
      await dio.put(
        '/materials/${widget.materialId}',
        data: {
          'title': _titleController.text.trim(),
          if (_descriptionController.text.trim().isNotEmpty)
            'description': _descriptionController.text.trim(),
          if (_selectedCategoryId != null) 'category_id': _selectedCategoryId,
        },
      );

      ref.invalidate(materialsListProvider);
      ref.invalidate(materialDetailProvider(widget.materialId));

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Материал обновлён')));
        context.go('/materials/${widget.materialId}');
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage = e.response?.data?['detail'] ?? 'Ошибка сохранения';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialAsync = ref.watch(materialDetailProvider(widget.materialId));
    final categoriesAsync = ref.watch(categoriesListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return materialAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (material) {
        _initFromMaterial(material);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Хлебные крошки
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => context.go(AppRoutes.myMaterials),
                          child: const Text('Мои материалы'),
                        ),
                        const Icon(Icons.chevron_right, size: 16),
                        const Text('Редактирование'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Редактировать материал',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      material.fileName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Название
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Название материала *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Введите название'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Описание
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Описание',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Категория
                    categoriesAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (categories) => Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              value: _selectedCategoryId,
                              decoration: const InputDecoration(
                                labelText: 'Категория',
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Без категории'),
                                ),
                                ...categories.map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _selectedCategoryId = v),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Кнопки
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => context.go(AppRoutes.myMaterials),
                          child: const Text('Отмена'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: _isLoading ? null : _submit,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: const Text('Сохранить'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

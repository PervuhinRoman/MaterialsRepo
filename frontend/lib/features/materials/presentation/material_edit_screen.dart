import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as web;

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
  String? _selectedFileName;
  Uint8List? _selectedFileBytes;
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

  Future<void> _pickFile() async {
    final input = web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'file';
    input.accept = '.pdf,.docx,.doc,.pptx,.ppt,.xlsx,.xls,.zip';

    final completer = Completer<void>();
    input.addEventListener(
      'change',
      (web.Event event) {
        final files = input.files;
        if (files != null && files.length > 0) {
          final file = files.item(0)!;
          final reader = web.FileReader();
          reader.addEventListener(
            'load',
            (web.Event _) {
              final bytes = Uint8List.fromList(
                (reader.result as JSArrayBuffer).toDart.asUint8List(),
              );
              setState(() {
                _selectedFileName = file.name;
                _selectedFileBytes = bytes;
              });
              completer.complete();
            }.toJS,
          );
          reader.readAsArrayBuffer(file);
        } else {
          completer.complete();
        }
      }.toJS,
    );
    input.click();
    await completer.future;
  }

  Future<void> _showCreateCategoryDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Новая категория'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final dio = ref.read(authenticatedDioProvider);
                final response = await dio.post(
                  '/materials/categories',
                  data: {
                    'name': nameController.text.trim(),
                    if (descController.text.trim().isNotEmpty)
                      'description': descController.text.trim(),
                  },
                );
                setState(() {
                  _selectedCategoryId = response.data['id'] as String;
                });
                ref.invalidate(categoriesListProvider);
                if (ctx.mounted) Navigator.of(ctx).pop(true);
              } on DioException catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.response?.data?['detail'] ?? 'Ошибка создания',
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );

    nameController.dispose();
    descController.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = ref.read(authenticatedDioProvider);

      // Обновляем метаданные
      await dio.put(
        '/materials/${widget.materialId}',
        data: {
          'title': _titleController.text.trim(),
          if (_descriptionController.text.trim().isNotEmpty)
            'description': _descriptionController.text.trim(),
          if (_selectedCategoryId != null) 'category_id': _selectedCategoryId,
        },
      );

      // Заменяем файл, если выбран новый
      if (_selectedFileBytes != null && _selectedFileName != null) {
        final formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            _selectedFileBytes!,
            filename: _selectedFileName!,
          ),
        });
        await dio.patch('/materials/${widget.materialId}/file', data: formData);
      }

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

                    // Категория + кнопка создать
                    categoriesAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (categories) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              initialValue: _selectedCategoryId,
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
                          const SizedBox(width: 8),
                          Tooltip(
                            message: 'Создать категорию',
                            child: OutlinedButton(
                              onPressed: _showCreateCategoryDialog,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                minimumSize: const Size(52, 52),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Зона замены файла
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedFileName != null
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: _selectedFileName != null
                              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                              : colorScheme.surfaceContainerLowest,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectedFileName != null
                                  ? Icons.check_circle_outline
                                  : Icons.upload_file_outlined,
                              size: 36,
                              color: _selectedFileName != null
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            if (_selectedFileName != null) ...[
                              Text(
                                _selectedFileName!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              TextButton(
                                onPressed: _pickFile,
                                child: const Text('Выбрать другой файл'),
                              ),
                            ] else ...[
                              Text(
                                'Текущий файл: ${material.fileName}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Нажмите, чтобы заменить файл',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
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

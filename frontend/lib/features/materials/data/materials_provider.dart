import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/material.dart';
import 'materials_repository.dart';

part 'materials_provider.g.dart';

@riverpod
Future<List<Material>> materialsList(Ref ref) {
  final repo = ref.watch(materialsRepositoryProvider);
  return repo.getMaterials();
}

@riverpod
Future<Material> materialDetail(Ref ref, String id) {
  return ref.watch(materialsRepositoryProvider).getMaterial(id);
}

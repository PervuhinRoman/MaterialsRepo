// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(materialsRepository)
final materialsRepositoryProvider = MaterialsRepositoryProvider._();

final class MaterialsRepositoryProvider
    extends
        $FunctionalProvider<
          MaterialsRepository,
          MaterialsRepository,
          MaterialsRepository
        >
    with $Provider<MaterialsRepository> {
  MaterialsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'materialsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$materialsRepositoryHash();

  @$internal
  @override
  $ProviderElement<MaterialsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MaterialsRepository create(Ref ref) {
    return materialsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaterialsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaterialsRepository>(value),
    );
  }
}

String _$materialsRepositoryHash() =>
    r'0f6424097d43d856b6b9824576ac8e0440cf9234';

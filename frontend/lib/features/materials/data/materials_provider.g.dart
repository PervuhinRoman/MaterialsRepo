// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(materialsList)
final materialsListProvider = MaterialsListProvider._();

final class MaterialsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Material>>,
          List<Material>,
          FutureOr<List<Material>>
        >
    with $FutureModifier<List<Material>>, $FutureProvider<List<Material>> {
  MaterialsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'materialsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$materialsListHash();

  @$internal
  @override
  $FutureProviderElement<List<Material>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Material>> create(Ref ref) {
    return materialsList(ref);
  }
}

String _$materialsListHash() => r'b6d8cde986839e057fc032db8627ccfc63964d66';

@ProviderFor(materialDetail)
final materialDetailProvider = MaterialDetailFamily._();

final class MaterialDetailProvider
    extends
        $FunctionalProvider<AsyncValue<Material>, Material, FutureOr<Material>>
    with $FutureModifier<Material>, $FutureProvider<Material> {
  MaterialDetailProvider._({
    required MaterialDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'materialDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$materialDetailHash();

  @override
  String toString() {
    return r'materialDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Material> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Material> create(Ref ref) {
    final argument = this.argument as String;
    return materialDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MaterialDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$materialDetailHash() => r'9be34fb9fb56ab579dc5011d7eeebc2166e54871';

final class MaterialDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Material>, String> {
  MaterialDetailFamily._()
    : super(
        retry: null,
        name: r'materialDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MaterialDetailProvider call(String id) =>
      MaterialDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'materialDetailProvider';
}

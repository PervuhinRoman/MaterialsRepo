// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider = AnalyticsRepositoryProvider._();

final class AnalyticsRepositoryProvider
    extends
        $FunctionalProvider<
          AnalyticsRepository,
          AnalyticsRepository,
          AnalyticsRepository
        >
    with $Provider<AnalyticsRepository> {
  AnalyticsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnalyticsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsRepository create(Ref ref) {
    return analyticsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsRepository>(value),
    );
  }
}

String _$analyticsRepositoryHash() =>
    r'84f984ef8046206dc31a3298da1685ec1a2201ed';

@ProviderFor(analyticsSummary)
final analyticsSummaryProvider = AnalyticsSummaryProvider._();

final class AnalyticsSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SummaryStats>,
          SummaryStats,
          FutureOr<SummaryStats>
        >
    with $FutureModifier<SummaryStats>, $FutureProvider<SummaryStats> {
  AnalyticsSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsSummaryHash();

  @$internal
  @override
  $FutureProviderElement<SummaryStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SummaryStats> create(Ref ref) {
    return analyticsSummary(ref);
  }
}

String _$analyticsSummaryHash() => r'22fab09a946eab63ca7b737393bbbaa809c87a6e';

@ProviderFor(analyticsTopMaterials)
final analyticsTopMaterialsProvider = AnalyticsTopMaterialsProvider._();

final class AnalyticsTopMaterialsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TopMaterial>>,
          List<TopMaterial>,
          FutureOr<List<TopMaterial>>
        >
    with
        $FutureModifier<List<TopMaterial>>,
        $FutureProvider<List<TopMaterial>> {
  AnalyticsTopMaterialsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsTopMaterialsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsTopMaterialsHash();

  @$internal
  @override
  $FutureProviderElement<List<TopMaterial>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TopMaterial>> create(Ref ref) {
    return analyticsTopMaterials(ref);
  }
}

String _$analyticsTopMaterialsHash() =>
    r'3772cb6d0d2a4d7d0a32374f2e81be02409617c8';

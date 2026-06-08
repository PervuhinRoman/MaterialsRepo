// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStorage create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage>(value),
    );
  }
}

String _$tokenStorageHash() => r'685c5e3ecbe57f43cb7d757fc51e85d8590845e3';

@ProviderFor(unauthenticatedDio)
final unauthenticatedDioProvider = UnauthenticatedDioProvider._();

final class UnauthenticatedDioProvider
    extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  UnauthenticatedDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unauthenticatedDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unauthenticatedDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return unauthenticatedDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$unauthenticatedDioHash() =>
    r'7827abc1687d8e691ec16d66c774d725b108a299';

/// Dio без onUnauthenticated — колбэк подключается в main.dart

@ProviderFor(authenticatedDio)
final authenticatedDioProvider = AuthenticatedDioProvider._();

/// Dio без onUnauthenticated — колбэк подключается в main.dart

final class AuthenticatedDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio без onUnauthenticated — колбэк подключается в main.dart
  AuthenticatedDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticatedDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticatedDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return authenticatedDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$authenticatedDioHash() => r'91c5de6ee67eb536d9d0919ec13cbdbac3b98c70';

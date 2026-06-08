import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id, // UUID
    required String email,
    required String username,
    required String role,
    required bool isActive,
  }) = _AuthUser;
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated({required AuthUser user}) =
      _Authenticated;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:materials_repo/core/auth/auth_state.dart';

import '../../features/materials/presentation/my_materials_screen.dart';
import '../../features/materials/presentation/material_edit_screen.dart';
import '../../features/materials/presentation/material_detail_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/materials/presentation/materials_list_screen.dart';
import '../../features/materials/presentation/upload_screen.dart';
import '../../shared/widgets/app_shell.dart';
import '../../shared/widgets/not_found_screen.dart';
import '../auth/auth_notifier.dart';

import '../../shared/widgets/loading_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const loading = '/loading';
  static const materials = '/materials';
  static const materialDetail = '/materials/:id';
  static const materialEdit = '/materials/:id/edit';
  static const myMaterials = '/my-materials';
  static const upload = '/upload';
  static const analytics = '/analytics';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.loading,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (context, state) {
      final location = state.matchedLocation;

      return authState.when(
        // Идёт проверка токена — держим на loading
        loading: () => location == AppRoutes.loading ? null : AppRoutes.loading,
        // Не авторизован — на логин (регистрация тоже доступна)
        unauthenticated: () =>
            location == AppRoutes.login || location == AppRoutes.register
                ? null
                : AppRoutes.login,
        // Авторизован — с loading/login на материалы
        authenticated: (_) =>
            location == AppRoutes.login || location == AppRoutes.loading
            ? AppRoutes.materials
            : null,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.materials,
            name: 'materials',
            builder: (context, state) => const MaterialsListScreen(),
          ),
          GoRoute(
            path: AppRoutes.materialDetail,
            name: 'materialDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MaterialDetailScreen(materialId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.myMaterials,
            name: 'myMaterials',
            builder: (context, state) => const MyMaterialsScreen(),
          ),
          GoRoute(
            path: AppRoutes.materialEdit,
            name: 'materialEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MaterialEditScreen(materialId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.upload,
            name: 'upload',
            builder: (context, state) => const UploadScreen(),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            name: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
        ],
      ),
    ],
  );
});

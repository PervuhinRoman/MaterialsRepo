import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/auth/auth_interceptor.dart';
import 'core/auth/auth_notifier.dart';      // ← authNotifierProvider
import 'core/auth/dio_providers.dart';      // ← authenticatedDioProvider
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MaterialsRepoApp(),
    ),
  );
}

class MaterialsRepoApp extends ConsumerStatefulWidget {
  const MaterialsRepoApp({super.key});

  @override
  ConsumerState<MaterialsRepoApp> createState() => _MaterialsRepoAppState();
}

class _MaterialsRepoAppState extends ConsumerState<MaterialsRepoApp> {
  @override
  void initState() {
    super.initState();
    // После инициализации виджета подменяем пустой колбэк реальным логаутом
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dio = ref.read(authenticatedDioProvider);
      // Находим наш AuthInterceptor и обновляем колбэк
      for (final interceptor in dio.interceptors) {
        if (interceptor is AuthInterceptor) {
          interceptor.onUnauthenticated = () {
            ref.read(authProvider.notifier).logout();
          };
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Репозиторий учебных материалов',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
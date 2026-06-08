import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_notifier.dart';
import '../../core/auth/auth_state.dart';
import '../../core/router/app_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final location = GoRouterState.of(context).matchedLocation;

    final username = authState.when(
      loading: () => '',
      unauthenticated: () => '',
      authenticated: (user) => user.username,
    );

    final role = authState.when(
      loading: () => '',
      unauthenticated: () => '',
      authenticated: (user) => user.role,
    );

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // Постоянный sidebar
          Container(
            width: 240,
            color: colorScheme.surfaceContainerLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Логотип
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.school_rounded,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'EduRepo',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Пользователь
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          username.isNotEmpty ? username[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _roleLabel(role),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Навигационные пункты
                _NavItem(
                  icon: Icons.folder_outlined,
                  selectedIcon: Icons.folder,
                  label: 'Материалы',
                  selected: location.startsWith(AppRoutes.materials),
                  onTap: () => context.go(AppRoutes.materials),
                ),

                if (role == 'teacher' || role == 'admin')
                  _NavItem(
                    icon: Icons.upload_file_outlined,
                    selectedIcon: Icons.upload_file,
                    label: 'Загрузить',
                    selected: location.startsWith(AppRoutes.upload),
                    onTap: () => context.go(AppRoutes.upload),
                  ),

                if (role == 'admin')
                  _NavItem(
                    icon: Icons.bar_chart_outlined,
                    selectedIcon: Icons.bar_chart,
                    label: 'Аналитика',
                    selected: location.startsWith(AppRoutes.analytics),
                    onTap: () => context.go(AppRoutes.analytics),
                  ),

                const Spacer(),
                const Divider(),

                // Выйти
                _NavItem(
                  icon: Icons.logout_outlined,
                  selectedIcon: Icons.logout,
                  label: 'Выйти',
                  selected: false,
                  onTap: () => ref.read(authProvider.notifier).logout(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Вертикальный разделитель
          VerticalDivider(width: 1, color: colorScheme.outlineVariant),

          // Контент
          Expanded(child: child),
        ],
      ),
    );
  }

  String _roleLabel(String role) => switch (role) {
    'admin' => 'Администратор',
    'teacher' => 'Преподаватель',
    'student' => 'Студент',
    _ => role,
  };
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colorScheme.secondaryContainer : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selected ? selectedIcon : icon,
              color: selected
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

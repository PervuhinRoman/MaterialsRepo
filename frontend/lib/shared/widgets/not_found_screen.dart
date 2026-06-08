import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            const Text('Страница не найдена'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.goNamed('materials'),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  }
}
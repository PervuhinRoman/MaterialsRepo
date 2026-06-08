import 'package:flutter/material.dart';
import 'materials_list_screen.dart';

class MyMaterialsScreen extends StatelessWidget {
  const MyMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialsListScreen(
      showActions: true,
      filterByCurrentUser: true,
    );
  }
}

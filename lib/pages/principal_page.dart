// lib/pages/principal_page.dart
import 'package:flutter/material.dart';
import 'package:project_e_commerce/widgets/home_page/fronsheet_home.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key}); // Aseguramos que se pase en el constructor

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FrontSheetHome(),
    );
  }
}

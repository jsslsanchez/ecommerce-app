// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:project_e_commerce/pages/favorite_page.dart';
import 'package:project_e_commerce/pages/principal_page.dart';
import 'package:project_e_commerce/pages/user_profile_page.dart';
import 'package:project_e_commerce/providers/ui_provider.dart';
import 'package:project_e_commerce/widgets/home_page/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      body: _HomePage(), // No es necesario pasar `productManager` aquí
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final currentIndex = uiProvider.bnbIndex;

    // Lista de páginas, accedemos al ProductManager globalmente en PrincipalPage
    List<Widget> pages = [
      const PrincipalPage(), // No pasamos `ProductManager` aquí, lo obtenemos con `Provider`
      const FavoritePage(), // No es necesario `ProductManager` en esta página
      const UserProfilePage(), // Lo mismo para UserProfilePage
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce Shop"),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: pages[currentIndex],
    );
  }
}

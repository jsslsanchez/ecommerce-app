import 'package:flutter/material.dart';
import 'package:project_e_commerce/presentation/widgets/widgets.dart';
import 'package:project_e_commerce/presentation/screens/permissions/permissions_screen.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores'),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Ícono de configuración
            onPressed: () {
              // Navegar a la pantalla de permisos
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PermissionsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Lista de Sensores'),
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            const MainMenu(),
          ],
        ),
      ),
    );
  }
}

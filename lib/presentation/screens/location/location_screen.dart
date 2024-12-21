import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_e_commerce/presentation/providers/location/user_location_provider.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocationAsync = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación'),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ubicación Actual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            userLocationAsync.when(
              data: (data) => Text(
                'Latitud: ${data.$1}, Longitud: ${data.$2}',
                style: const TextStyle(fontSize: 16),
              ),
              error: (error, stackTrace) => Text(
                'Error al obtener la ubicación: $error',
                style: const TextStyle(color: Colors.red),
              ),
              loading: () => const CircularProgressIndicator(),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Seguimiento de Ubicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

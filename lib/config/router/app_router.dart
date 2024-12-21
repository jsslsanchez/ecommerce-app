// lib/config/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:project_e_commerce/pages/home_page.dart';
import 'package:project_e_commerce/presentation/screens/screens.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/', // Ruta raíz
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/permissions',
    builder: (context, state) => const PermissionsScreen(),
  ),

  // Sensores
  GoRoute(
    path: '/gyroscope',
    builder: (context, state) => const GyroscopeScreen(),
  ),
  GoRoute(
    path: '/accelerometer',
    builder: (context, state) => const AccelerometerScreen(),
  ),
  GoRoute(
    path: '/magnetometer',
    builder: (context, state) => const MagnetometerScreen(),
  ),
  GoRoute(
    path: '/gyroscope-ball',
    builder: (context, state) => const GyroscopeBallScreen(),
  ),
  GoRoute(
    path: '/compass',
    builder: (context, state) => const CompassScreen(),
  ),
  GoRoute(
    path: '/location',
    builder: (context, state) => const LocationScreen(),
  ),
  GoRoute(
    path: '/maps',
    builder: (context, state) => const MapScreen(),
  ),
  GoRoute(
    path: '/controlled-map',
    builder: (context, state) => const ControlledMapScreen(),
  ),
]);

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem(this.title, this.icon, this.route);
}

const IconData gyroscopeIcon = Icons.downloading;
const IconData accelerometerIcon = Icons.speed;
const IconData magnetometerIcon = Icons.explore_outlined;
const IconData gyroscopeBallIcon = Icons.sports_baseball_outlined;
const IconData compassIcon = Icons.explore;
const IconData locationIcon = Icons.pin_drop;
const IconData mapsIcon = Icons.map_outlined;
const IconData controllIcon = Icons.gamepad_outlined;


final menuItems = <MenuItem>[
  MenuItem('Giróscopio', gyroscopeIcon, '/gyroscope'),
  MenuItem('Acelerómetro', accelerometerIcon, '/accelerometer'),
  MenuItem('Magnetometro', magnetometerIcon, '/magnetometer'),
  MenuItem('Giróscopio Ball', gyroscopeBallIcon, '/gyroscope-ball'),
  MenuItem('Brújula', compassIcon, '/compass'),
  MenuItem('Ubicación', locationIcon, '/location'),
  MenuItem('Mapas', mapsIcon, '/maps'),
  MenuItem('Control', controllIcon, '/controlled-map'),

];

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: menuItems
          .map((item) => HomeMenuItem(
              title: item.title, route: item.route, icon: item.icon))
          .toList(),
    );
  }
}

class HomeMenuItem extends StatelessWidget {
  final String title;
  final String route;
  final IconData icon;
  final List<Color> bgColors;

  const HomeMenuItem(
      {super.key,
      required this.title,
      required this.route,
      required this.icon,
      this.bgColors = const [
        Color.fromARGB(255, 149, 217, 169),
        Color.fromARGB(255, 39, 91, 9)
      ]});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: bgColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

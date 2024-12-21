import 'package:flutter/material.dart';
import 'package:project_e_commerce/providers/ui_provider.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    return BottomNavigationBar(
      currentIndex: uiProvider.bnbIndex,
      onTap: (int i) => uiProvider.bnbIndex = i,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            label: 'Favorite', icon: Icon(Icons.favorite_rounded)),
        BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
      ],
      showUnselectedLabels: false,
      showSelectedLabels: false,
    );
  }
}

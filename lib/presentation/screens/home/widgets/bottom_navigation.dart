// lib/presentation/screens/home/widgets/bottom_navigation.dart
import 'package:flutter/material.dart';

class HomeNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const HomeNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Historique',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
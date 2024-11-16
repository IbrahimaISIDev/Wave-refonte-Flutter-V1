// lib/presentation/screens/home/widgets/tab_with_badge.dart
import 'package:flutter/material.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class TabWithBadge extends StatelessWidget {
  final String title;
  final IconData icon;
  final int badgeCount;

  const TabWithBadge({
    required this.title,
    required this.icon,
    required this.badgeCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Stack(
        children: [
          Icon(icon, size: HomeScreenStyles.iconSize),
          if (badgeCount > 0)
            Positioned(
              top: -5,
              right: -5,
              child: Badge(
                // La propriété label attend un Widget pour afficher le contenu
                label: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Personnalisation optionnelle du badge
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(4),
                isLabelVisible: true,
              ),
            ),
        ],
      ),
      text: title,
    );
  }
}
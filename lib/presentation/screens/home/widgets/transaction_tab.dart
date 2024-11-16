// lib/presentation/screens/home/widgets/transaction_tab.dart
import 'package:flutter/material.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class TransactionTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final int badgeCount;

  const TransactionTab({
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
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: HomeScreenStyles.badgeDecoration,
                constraints: const BoxConstraints(
                  minWidth: HomeScreenStyles.badgeSize,
                  minHeight: HomeScreenStyles.badgeSize,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      text: title,
    );
  }
}

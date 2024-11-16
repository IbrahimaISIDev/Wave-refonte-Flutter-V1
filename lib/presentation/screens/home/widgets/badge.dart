// lib/presentation/screens/home/widgets/badge.dart
import 'package:flutter/material.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class Badge extends StatelessWidget {
  final int count;

  const Badge({
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: HomeScreenStyles.badgeDecoration,
      constraints: const BoxConstraints(
        minWidth: HomeScreenStyles.badgeSize,
        minHeight: HomeScreenStyles.badgeSize,
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
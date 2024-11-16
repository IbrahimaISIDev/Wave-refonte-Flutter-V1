// lib/presentation/screens/home/models/quick_action_item.dart
import 'package:flutter/material.dart';

class QuickActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
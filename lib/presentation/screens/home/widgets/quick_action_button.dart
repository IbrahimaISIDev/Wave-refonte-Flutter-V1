// lib/presentation/screens/home/widgets/quick_action_button.dart
import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/home/models/quick_action_item.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class QuickActionButton extends StatelessWidget {
  final QuickActionItem item;

  const QuickActionButton({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: HomeScreenStyles.getQuickActionDecoration(item.color),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: item.color, size: HomeScreenStyles.iconSize),
            const SizedBox(height: HomeScreenStyles.smallSpacing),
            Text(
              item.label,
              style: HomeScreenStyles.quickActionLabelStyle.copyWith(
                color: item.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
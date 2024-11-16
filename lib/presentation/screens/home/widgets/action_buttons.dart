// lib/presentation/screens/home/widgets/action_buttons.dart
import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/home/widgets/action_button.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onQRCodeTap;
  final VoidCallback onScannerTap;

  const ActionButtons({
    required this.onQRCodeTap,
    required this.onScannerTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(HomeScreenStyles.defaultSpacing),
        child: Row(
          children: [
            Expanded(
              child: ActionButton(
                icon: Icons.qr_code,
                label: 'Mon QR Code',
                onTap: onQRCodeTap,
              ),
            ),
            const SizedBox(width: HomeScreenStyles.smallSpacing),
            Expanded(
              child: ActionButton(
                icon: Icons.qr_code_scanner,
                label: 'Scanner',
                onTap: onScannerTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
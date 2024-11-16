// lib/presentation/screens/home/widgets/user_balance.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class UserBalance extends StatelessWidget {
  final double balance;
  final bool isVisible;
  final VoidCallback onTap;

  const UserBalance({
    required this.balance,
    required this.isVisible,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'FCFA',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isVisible
                  ? currencyFormat.format(balance)
                  : '• • • • • • • • • • • •',
              style: HomeScreenStyles.balanceTextStyle,
            ),
            const SizedBox(width: HomeScreenStyles.smallSpacing),
            Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
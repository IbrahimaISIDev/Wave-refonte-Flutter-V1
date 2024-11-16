// lib/presentation/screens/home/widgets/quick_actions.dart
import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/home/models/quick_action_item.dart';
import 'package:wave_app/presentation/screens/home/widgets/quick_action_button.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_screen.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QuickActionItem> actions = [
      QuickActionItem(
        icon: Icons.send,
        label: 'Transfert',
        color: Theme.of(context).primaryColor,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TransferScreen()),
        ),
      ),
      QuickActionItem(
        icon: Icons.account_balance_wallet,
        label: 'Recharger',
        color: Colors.green,
        onTap: () {},
      ),
      QuickActionItem(
        icon: Icons.receipt_long,
        label: 'Factures',
        color: Colors.orange,
        onTap: () {},
      ),
      QuickActionItem(
        icon: Icons.more_horiz,
        label: 'Plus',
        color: Colors.purple,
        onTap: () {},
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: HomeScreenStyles.defaultSpacing,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions.map((action) => QuickActionButton(
            item: action,
          )).toList(),
        ),
      ),
    );
  }
}

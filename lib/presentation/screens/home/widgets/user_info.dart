// lib/presentation/screens/home/widgets/user_info.dart
import 'package:flutter/material.dart';
import 'package:wave_app/data/models/user_model.dart';
import 'package:wave_app/presentation/screens/home/widgets/profile_avatar.dart';
import 'package:wave_app/presentation/screens/home/widgets/user_balance.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class HomeUserInfo extends StatelessWidget {
  final UserModel user;
  final bool isBalanceVisible;
  final VoidCallback onBalanceTap;
  final VoidCallback onProfileTap;

  const HomeUserInfo({
    required this.user,
    required this.isBalanceVisible,
    required this.onBalanceTap,
    required this.onProfileTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: HomeScreenStyles.largeSpacing),
            Text(
              'Bonjour, ${user.prenom}',
              style: HomeScreenStyles.greetingTextStyle,
            ),
            const SizedBox(height: HomeScreenStyles.smallSpacing),
            UserBalance(
              balance: user.solde,
              isVisible: isBalanceVisible,
              onTap: onBalanceTap,
            ),
          ],
        ),
        ProfileAvatar(
          photoUrl: user.photo,
          onTap: onProfileTap,
        ),
      ],
    );
  }
}
// lib/presentation/screens/home/widgets/home_app_bar.dart
import 'package:flutter/material.dart';
import 'package:wave_app/data/models/user_model.dart';
import 'package:wave_app/presentation/screens/home/widgets/user_info.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class HomeAppBar extends StatefulWidget {
  final UserModel user;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    required this.user,
    required this.onProfileTap,
    super.key,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: HomeScreenStyles.getHeaderGradient(context),
          child: SafeArea(
            child: Padding(
              padding: HomeScreenStyles.defaultScreenPadding,
              child: HomeUserInfo(
                user: widget.user,
                isBalanceVisible: _isBalanceVisible,
                onBalanceTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                onProfileTap: widget.onProfileTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
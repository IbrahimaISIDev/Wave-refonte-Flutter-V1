// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/bloc/transaction/transaction_bloc.dart';
import 'package:wave_app/bloc/transaction/transaction_event.dart';
import 'package:wave_app/presentation/screens/home/models/qr_code_modal.dart';
import 'package:wave_app/presentation/screens/home/models/qr_scanner_modal.dart';
import 'package:wave_app/presentation/screens/home/widgets/bottom_navigation.dart';
import 'package:wave_app/presentation/screens/profile/profile_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_history_screen.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/action_buttons.dart';
import 'widgets/quick_actions.dart';
import 'widgets/transaction_tabs.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: HomeScreenStyles.navigationBarTheme,
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeScreenContent(),
            const TransferHistoryScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: HomeNavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }

  Widget _buildHomeScreenContent() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return CustomScrollView(
            slivers: [
              HomeAppBar(
                user: state.user,
                onProfileTap: () => setState(() => _selectedIndex = 2),
              ),
              ActionButtons(
                onQRCodeTap: () => _showQRCode(context, state.user.numeroCompte),
                onScannerTap: () => _showScannerModal(context),
              ),
              const QuickActions(),
              const TransactionTabs(),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showQRCode(BuildContext context, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QRCodeModal(phoneNumber: phoneNumber),
    );
  }

  void _showScannerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QRScannerModal(),
    );
  }
}
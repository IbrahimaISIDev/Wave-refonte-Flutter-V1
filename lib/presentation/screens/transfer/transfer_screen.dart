// transfer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'package:wave_app/presentation/widgets/balance_card.dart';
import 'package:wave_app/presentation/widgets/multiple_transfer_form.dart';
import 'package:wave_app/presentation/widgets/scheduled_transfer_form.dart';
import 'package:wave_app/presentation/widgets/transfer_form.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, String? recipientId});

  @override
  // ignore: library_private_types_in_public_api
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _currentIndex = 0;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<String> _titles = [
    'Transfert Simple',
    'Transferts Multiples',
    'Transferts Planifiés'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferBloc(
        context.read<TransferRepository>(),
        context.read<AuthBloc>(),
      ),
      child: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state is TransferFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                _titles[_currentIndex],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Column(
              children: [
                const BalanceCard(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    children: const [
                      TransferForm(),
                      MultipleTransferForm(),
                      ScheduledTransferForm(),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.send),
                  label: 'Simple',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz),
                  label: 'Multiple',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: 'Planifié',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
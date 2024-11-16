// lib/presentation/screens/home/widgets/lists/transactions_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transaction/transaction_bloc.dart';
import 'package:wave_app/bloc/transaction/transaction_state.dart';
import 'package:wave_app/presentation/screens/home/widgets/transaction_item.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TransactionError) {
          return Center(child: Text('Erreur: ${state.message}'));
        }

        if (state is TransactionLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text('Aucune transaction récente'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: HomeScreenStyles.defaultSpacing,
            ),
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return TransactionItem(transaction: transaction);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
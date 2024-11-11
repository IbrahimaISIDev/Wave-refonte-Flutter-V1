// lib/bloc/transaction/transaction_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transaction/transaction_event.dart';
import 'package:wave_app/bloc/transaction/transaction_state.dart';
import 'package:wave_app/data/models/transaction.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // Vous pouvez ajouter un repository ici plus tard
  TransactionBloc(read) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
  }

  List<Transaction> _transactions = [];

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(TransactionLoading());
      // Simuler un délai de chargement
      await Future.delayed(const Duration(seconds: 1));
      
      // Plus tard, vous pourrez charger les données depuis une API ou une base de données
      emit(TransactionLoaded(_transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is TransactionLoaded) {
        _transactions = List.from(currentState.transactions)
          ..add(event.transaction);
        emit(TransactionLoaded(_transactions));
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
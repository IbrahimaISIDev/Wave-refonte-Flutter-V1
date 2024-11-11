// lib/bloc/transaction/transaction_event.dart
import 'package:equatable/equatable.dart';
import 'package:wave_app/data/models/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}
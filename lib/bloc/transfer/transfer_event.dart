// lib/bloc/transfer/transfer_event.dart
import 'package:equatable/equatable.dart';

abstract class TransferEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateTransferEvent extends TransferEvent {
  final String recipientId;
  final double amount;

  CreateTransferEvent({required this.recipientId, required this.amount});

  @override
  List<Object> get props => [recipientId, amount];
}

class CreateMultipleTransferEvent extends TransferEvent {
  final List<Map<String, dynamic>> transfers; // Removed the nullable (?) operator

  CreateMultipleTransferEvent({
    required this.transfers, required List<String> recipients, required double amount, // Made transfers required
  });
}

class GetTransferHistoryEvent extends TransferEvent {}
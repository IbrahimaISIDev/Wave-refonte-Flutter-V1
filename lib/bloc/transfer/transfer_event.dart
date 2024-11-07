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
}


class GetTransferHistoryEvent extends TransferEvent {}

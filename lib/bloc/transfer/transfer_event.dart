// lib/bloc/transfer/transfer_event.dart

abstract class TransferEvent {}

class CreateTransferEvent extends TransferEvent {
  final String recipientId;
  final double amount;

  // Utilisation de paramètres nommés
  CreateTransferEvent({required this.recipientId, required this.amount});
}

class GetTransferHistoryEvent extends TransferEvent {}

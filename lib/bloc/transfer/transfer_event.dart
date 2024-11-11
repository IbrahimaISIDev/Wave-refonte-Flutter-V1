// Gardez une seule classe d'événement qui hérite de TransferEvent
import 'package:wave_app/data/models/transfer_model.dart';

abstract class TransferEvent {}

class PerformTransferEvent extends TransferEvent {
  final String recipient;
  final double amount;

  PerformTransferEvent(this.recipient, this.amount);
}

class PerformMultipleTransferEvent extends TransferEvent {
  final List<String> recipients;
  final double amount;

  PerformMultipleTransferEvent(this.recipients, this.amount);
}

class ScheduleTransferEvent extends TransferEvent {
  final String recipient;
  final double amount;
  final TransferSchedule schedule;

  ScheduleTransferEvent(this.recipient, this.amount, this.schedule);
}

class CancelTransferEvent extends TransferEvent {
  final int transactionId;
  final String reason;

  CancelTransferEvent(this.transactionId, this.reason);
}

// Modification ici : Assurez-vous que la classe LoadTransferHistoryEvent hérite de TransferEvent
class LoadTransferHistoryEvent extends TransferEvent {
  final int page;
  final int limit;

  LoadTransferHistoryEvent({this.page = 1, this.limit = 10});
}

// Si vous n'avez pas besoin de GetTransferHistoryEvent, supprimez-la
// class GetTransferHistoryEvent {
//   final int page;
//   final int limit;
//
//   GetTransferHistoryEvent({this.page = 1, this.limit = 10});
// }


// // lib/bloc/transfer/transfer_event.dart
// import 'package:equatable/equatable.dart';

// abstract class TransferEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class CreateTransferEvent extends TransferEvent {
//   final String recipientId;
//   final double amount;

//   CreateTransferEvent({required this.recipientId, required this.amount});

//   @override
//   List<Object> get props => [recipientId, amount];
// }

// class CreateMultipleTransferEvent extends TransferEvent {
//   final List<Map<String, dynamic>> transfers; // Removed the nullable (?) operator

//   CreateMultipleTransferEvent({
//     required this.transfers, required List<String> recipients, required double amount, // Made transfers required
//   });
// }

// class GetTransferHistoryEvent extends TransferEvent {}
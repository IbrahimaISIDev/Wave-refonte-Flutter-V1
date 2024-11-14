// transfer_event.dart
import 'package:equatable/equatable.dart';

abstract class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object> get props => [];
}

class LoadTransferHistoryEvent extends TransferEvent {}

class PerformTransferEvent extends TransferEvent {
  final String recipientPhone;
  final double amount;

  const PerformTransferEvent({
    required this.recipientPhone,
    required this.amount,
  });

  @override
  List<Object> get props => [recipientPhone, amount];
}

class PerformMultipleTransfersEvent extends TransferEvent {
  final List<String> recipientPhones;
  final double amount;

  const PerformMultipleTransfersEvent({
    required this.recipientPhones,
    required this.amount,
  });

  @override
  List<Object> get props => [recipientPhones, amount];
}

class ScheduleTransferEvent extends TransferEvent {
  final String recipientPhone;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String frequency;
  final String executionTime;

  const ScheduleTransferEvent({
    required this.recipientPhone,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    required this.executionTime,
  });

  @override
  List<Object> get props => [recipientPhone, amount, startDate, endDate, frequency, executionTime];
}

class CancelTransferEvent extends TransferEvent {
  final int transactionId;
  final String reason;

  const CancelTransferEvent(this.transactionId, this.reason);

  @override
  List<Object> get props => [transactionId, reason];
}
// abstract class TransferState {
//   final bool isLoading;
  
//   const TransferState({this.isLoading = false});

//   get transfers => null;
// }

// class TransferInitial extends TransferState {
//   const TransferInitial() : super(isLoading: false);
// }

// class TransferLoading extends TransferState {
//   const TransferLoading() : super(isLoading: true);
// }

// class TransferSuccess extends TransferState {
//   final String message;
//   final String transactionId;
//   final Map<String, dynamic> details;
//   final bool isScheduled;

//   const TransferSuccess({
//     required this.message,
//     required this.transactionId,
//     required this.details,
//     this.isScheduled = false,
//   }) : super(isLoading: false);
// }

// class TransferFailure extends TransferState {
//   final String error;
//   final Map<String, dynamic>? details;

//   const TransferFailure({
//     required this.error,
//     this.details,
//   }) : super(isLoading: false);

//   get message => null;
// }

// class TransferHistoryLoaded extends TransferState {
//   final List<Map<String, dynamic>> transfers;

//   const TransferHistoryLoaded({required this.transfers}) : super(isLoading: false);
// }

// 

// lib/bloc/transfer/transfer_state.dart
import 'package:equatable/equatable.dart';
import 'package:wave_app/data/models/transfer_model.dart';

abstract class TransferState extends Equatable {
  final bool isLoading;
  
  const TransferState({this.isLoading = false});
  
  @override
  List<Object?> get props => [isLoading];
}

class TransferInitial extends TransferState {
  const TransferInitial() : super(isLoading: false);
}

class TransferLoading extends TransferState {
  const TransferLoading() : super(isLoading: true);
}

class TransferSuccess extends TransferState {
  final String message;
  final String transactionId;
  final Map<String, dynamic> details;
  final bool isScheduled;

  const TransferSuccess({
    required this.message,
    required this.transactionId,
    required this.details,
    this.isScheduled = false,
  }) : super(isLoading: false);

  @override
  List<Object?> get props => [message, transactionId, details, isScheduled];
}

class TransferFailure extends TransferState {
  final String error;
  final Map<String, dynamic>? details;

  const TransferFailure({
    required this.error,
    this.details,
  }) : super(isLoading: false);

  @override
  List<Object?> get props => [error, details];
}

class TransferHistoryLoaded extends TransferState {
  final List<Transaction> transfers;

  const TransferHistoryLoaded({required this.transfers}) : super(isLoading: false);

  @override
  List<Object> get props => [transfers];
}

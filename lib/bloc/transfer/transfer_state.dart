import 'package:wave_app/data/models/transfer_model.dart';

abstract class TransferState {
  String? get message => null;
}

class TransferInitial extends TransferState {}

class TransferSuccess extends TransferState {
  final TransferResult result;

  TransferSuccess(this.result);
}

class MultipleTransferSuccess extends TransferState {
  final MultipleTransferResult result;

  MultipleTransferSuccess(this.result);
}

class TransferCancellationSuccess extends TransferState {
  final CancelTransferResult result;

  TransferCancellationSuccess(this.result);
}

class TransferHistoryLoaded extends TransferState {
  final List<TransferHistory> history;

  TransferHistoryLoaded(this.history);

  get transfers => null;
}

class TransferFailure extends TransferState {
  final String error;

  TransferFailure(this.error);
}

class TransferError{
  final String error;
  TransferError(this.error);
}

class TransferLoading{
  TransferLoading();
}



// // lib/bloc/transfer/transfer_state.dart
// import 'package:equatable/equatable.dart';
// import 'package:wave_app/data/models/transfer_model.dart';

// abstract class TransferState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class TransferInitial extends TransferState {}

// class TransferLoading extends TransferState {}

// class TransferSuccess extends TransferState {
//   final TransferModel transfer;

//   TransferSuccess(this.transfer);

//   @override
//   List<Object> get props => [transfer];
// }

// class MultipleTransferSuccess extends TransferState {
//   final List<TransferModel> transfers;
//   final int successCount;
//   final int totalCount;

//   MultipleTransferSuccess({
//     required this.transfers,
//     required this.successCount,
//     required this.totalCount,
//   });

//   @override
//   List<Object> get props => [transfers, successCount, totalCount];
// }

// class TransferError extends TransferState {
//   final String message;
//   final List<TransferModel>? partialTransfers;

//   TransferError(this.message, {this.partialTransfers});

//   @override
//   List<Object> get props => [message, partialTransfers ?? []];
// }

// class TransferHistoryLoaded extends TransferState {
//   final List<TransferModel> transferHistory;

//   TransferHistoryLoaded(this.transferHistory);

//   @override
//   List<Object> get props => [transferHistory];

//   get transfers => null;
// }



// abstract class TransferState {}

// class TransferInitial extends TransferState {}

// class TransferLoading extends TransferState {}

// class TransferSuccess extends TransferState {
//   final TransferModel transfer;

//   TransferSuccess(this.transfer);
// }

// class TransferHistoryLoaded extends TransferState {
//   final List<TransferModel> transferHistory;

//   TransferHistoryLoaded(this.transferHistory);
// }

// class TransferError extends TransferState {
//   final String message;

//   TransferError(this.message);
// }

// class TransferLoaded extends TransferState {
//   final List<TransferModel> transfers;

//   TransferLoaded(this.transfers);
// }

// class TransferModel {
//   final int id;
//   final String name;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String description;
//   final String type;
//   final String currency;
//   final double amount;
//   final String recipientName;
//   final String recipientAccountNumber;
//   final String recipientBankName;
//   final String recipientBranchCode;
//   final String recipientSwiftCode;
//   final String recipientAddress;
//   TransferModel(this.id, this.name, this.status, this.createdAt, this.updatedAt,
//       this.description, this.type, this.currency, this.amount, this.recipientName,
//       this.recipientAccountNumber, this.recipientBankName, this.recipientBranchCode,
//       this.recipientSwiftCode, this.recipientAddress);
// }

// class TransferCreated extends TransferState {
//   final TransferModel transfer;

//   TransferCreated(this.transfer);
// }

// class TransferError extends TransferState {
//   final String message;

//   TransferError(this.message);
// }
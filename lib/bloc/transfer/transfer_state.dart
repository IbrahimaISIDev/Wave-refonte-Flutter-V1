// lib/bloc/transfer/transfer_state.dart
// transfer_state.dart
import 'package:wave_app/data/models/transfer_model.dart';

abstract class TransferState {}

class TransferInitial extends TransferState {}

class TransferLoading extends TransferState {}

class TransferSuccess extends TransferState {
  final TransferModel transfer;
  TransferSuccess(this.transfer);
}

class TransferHistoryLoaded extends TransferState {
  final List<TransferModel> transferHistory;
  TransferHistoryLoaded(this.transferHistory);

  get transfers => null;
}

class TransferError extends TransferState {
  final String message;
  TransferError(this.message);
}


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
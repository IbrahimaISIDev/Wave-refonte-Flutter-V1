import 'package:wave_app/data/models/transfer_model.dart';

abstract class TransferState {
  const TransferState();
}

class TransferInitial extends TransferState {}

class TransferLoading extends TransferState {}

class TransferSuccess extends TransferState {
  final TransferResult transferResult;

  const TransferSuccess(this.transferResult);
}

class MultipleTransferSuccess extends TransferState {
  final MultipleTransferResult multipleTransferResult;

  const MultipleTransferSuccess(this.multipleTransferResult);
}

class TransferFailure extends TransferState {
  final String error;

  const TransferFailure(this.error);
}

class TransferScheduled extends TransferState {
  final dynamic data;

  const TransferScheduled(this.data);
}

class TransferHistoryLoaded extends TransferState {
  final List<TransferResult> transfers;

  const TransferHistoryLoaded(this.transfers);
}

class TransferError extends TransferState {
  final String? message;

  const TransferError([this.message]);
}

class TransferCancelled extends TransferState {}
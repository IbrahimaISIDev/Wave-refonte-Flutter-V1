import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepository _transferRepository;
  final AuthBloc _authBloc;

  TransferBloc(this._transferRepository, this._authBloc)
      : super(TransferInitial()) {
    on<PerformTransferEvent>(_performTransfer);
    on<PerformMultipleTransfersEvent>(_performMultipleTransfers);
    on<ScheduleTransferEvent>(_scheduleTransfer);
  }

  Future<void> _performTransfer(
    PerformTransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      emit(TransferLoading());
      final result = await _transferRepository.performTransfer(
        recipientPhone: event.recipientPhone,
        amount: event.amount,
      );
      emit(TransferSuccess(result));
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }

  Future<void> _performMultipleTransfers(
    PerformMultipleTransfersEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      emit(TransferLoading());
      final result = await _transferRepository.performMultipleTransfers(
        recipientPhones: event.recipientPhones,
        amount: event.amount,
      );
      emit(MultipleTransferSuccess(result));
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }

  Future<void> _scheduleTransfer(
    ScheduleTransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      emit(TransferLoading());
      final result = await _transferRepository.scheduleTransfer(
        recipientPhone: event.recipientPhone,
        amount: event.amount,
        scheduleDate: event.startDate,
        scheduleTime: event.executionTime,
      );
      emit(TransferScheduled(result));
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }
}
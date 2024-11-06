// lib/bloc/transfer/transfer_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/data/models/transfer_model.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepository _transferRepository;
  final AuthBloc _authBloc;

  TransferBloc(this._transferRepository, this._authBloc) : super(TransferInitial()) {
    on<CreateTransferEvent>(_handleCreateTransfer);
    on<GetTransferHistoryEvent>(_handleGetTransferHistory);
  }

  Future<void> _handleCreateTransfer(CreateTransferEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading());
    try {
      if (_authBloc.state is AuthAuthenticated) {
        final currentUser = (_authBloc.state as AuthAuthenticated).user;
        final transfer = await _transferRepository.createTransfer(
          currentUser.id,
          event.recipientId,
          event.amount,
        );
        emit(TransferSuccess(transfer));
      } else {
        emit(TransferError('Utilisateur non authentifié'));
      }
    } catch (e) {
      emit(TransferError(e.toString()));
    }
  }

  Future<void> _handleGetTransferHistory(GetTransferHistoryEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading());
    try {
      final transferHistory = await _transferRepository.getTransferHistory();
      emit(TransferHistoryLoaded(transferHistory));
    } catch (e) {
      emit(TransferError(e.toString()));
    }
  }
}
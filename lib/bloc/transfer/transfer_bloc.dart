// lib/bloc/transfer/transfer_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepository _transferRepository;
  final AuthBloc _authBloc;

  TransferBloc(this._transferRepository, this._authBloc) : super(TransferInitial()) {
    on<CreateTransferEvent>(_handleCreateTransfer);
    on<CreateMultipleTransferEvent>(_handleCreateMultipleTransfer);
    on<GetTransferHistoryEvent>(_handleGetTransferHistory);
  }

  Future<void> _handleCreateTransfer(CreateTransferEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading());
    try {
      if (_authBloc.state is AuthAuthenticated) {
        final currentUser = (_authBloc.state as AuthAuthenticated).user;
        final transfer = await _transferRepository.createTransfer(
          currentUser.id as String,
          event.recipientId,
          event.amount,
        );
        emit(TransferSuccess(transfer));
      } else {
        emit(TransferError('Utilisateur non authentifié'));
      }
    } catch (e) {
      emit(TransferError('Erreur lors de la création du transfert : ${e.toString()}'));
    }
  }

  Future<void> _handleCreateMultipleTransfer(
    CreateMultipleTransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(TransferLoading());
    try {
      if (_authBloc.state is! AuthAuthenticated) {
        emit(TransferError('Utilisateur non authentifié'));
        return;
      }

      final currentUser = (_authBloc.state as AuthAuthenticated).user;
      
      // Calculer le montant total
      final totalAmount = event.transfers.fold<double>(
        0,
        (sum, transfer) => sum + (transfer['amount'] as double),
      );

      // Vérifier le solde
      if (!await _transferRepository.checkBalance(totalAmount)) {
        emit(TransferError('Solde insuffisant pour effectuer tous les transferts'));
        return;
      }

      // Effectuer les transferts
      final transfers = await _transferRepository.createMultipleTransfers(
        currentUser.id as String,
        event.transfers,
      );

      emit(MultipleTransferSuccess(
        transfers: transfers,
        successCount: transfers.length,
        totalCount: event.transfers.length,
      ));
    } catch (e) {
      emit(TransferError(
        'Erreur lors des transferts multiples : ${e.toString()}',
      ));
    }
  }

  Future<void> _handleGetTransferHistory(
    GetTransferHistoryEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(TransferLoading());
    try {
      if (_authBloc.state is AuthAuthenticated) {
        final transferHistory = await _transferRepository.getTransferHistory();
        emit(TransferHistoryLoaded(transferHistory));
      } else {
        emit(TransferError('Utilisateur non authentifié'));
      }
    } catch (e) {
      emit(TransferError('Erreur lors du chargement de l\'historique : ${e.toString()}'));
    }
  }
}
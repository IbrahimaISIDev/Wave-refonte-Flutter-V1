import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/data/models/transfer_model.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepository _transferRepository;
  final AuthBloc _authBloc;

  TransferBloc(this._transferRepository, this._authBloc)
      : super(TransferInitial()) {
    on<PerformTransferEvent>(_onPerformTransfer);
    on<PerformMultipleTransferEvent>(_onPerformMultipleTransfer);
    on<ScheduleTransferEvent>(_onScheduleTransfer);
    on<CancelTransferEvent>(_onCancelTransfer);
    on<LoadTransferHistoryEvent>(_onLoadTransferHistory);
  }

  // Traitement d'un transfert unique
  Future<void> _onPerformTransfer(
      PerformTransferEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading() as TransferState); // Removed unnecessary cast
    try {
      final result = await _transferRepository.transfer(
        _authBloc.state.user,
        event.recipient,
        event.amount,
      );
      emit(TransferSuccess(result));
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }

  // Traitement des transferts multiples
  Future<void> _onPerformMultipleTransfer(
      PerformMultipleTransferEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading() as TransferState); // Removed unnecessary cast
    try {
      final result = await _transferRepository.multipleTransfer(
        _authBloc.state.user,
        event.recipients,
        event.amount,
      );
      emit(MultipleTransferSuccess(result));
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }

  // Planification d'un transfert
  Future<void> _onScheduleTransfer(
      ScheduleTransferEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading() as TransferState); // Removed unnecessary cast
    try {
      final result = await _transferRepository.scheduleTransfer(
        _authBloc.state.user,
        event.recipient,
        event.amount,
        event.schedule as DateTime, // Removed unnecessary cast
      );
      emit(TransferSuccess(result));
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }

  // Annulation d'un transfert
  Future<void> _onCancelTransfer(
      CancelTransferEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading() as TransferState); // Removed unnecessary cast
    try {
      final result = await _transferRepository.cancelTransfer(
        _authBloc.state.user.id,
        event.transactionId as String, // Removed unnecessary cast
        event.reason,
      );
      emit(TransferCancellationSuccess(result));
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }

  // Chargement de l'historique des transferts
// Bloc pour gérer l'événement LoadTransferHistoryEvent
  Future<void> _onLoadTransferHistory(
      LoadTransferHistoryEvent event, Emitter<TransferState> emit) async {
    emit(TransferLoading() as TransferState);
    try {
      final history = await _transferRepository.getTransferHistory(
        _authBloc.state.user.id,
        event.page,
        event.limit,
      );
      emit(TransferHistoryLoaded(history.cast<
          TransferHistory>())); // Assurez-vous que le résultat est bien un TransferHistory
    } catch (e) {
      emit(TransferFailure(e.toString()));
    }
  }
}



// // lib/bloc/transfer/transfer_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wave_app/bloc/auth/auth_bloc.dart';
// import 'package:wave_app/bloc/auth/auth_state.dart';
// import 'package:wave_app/data/repositories/transfer_repository.dart';
// import 'transfer_event.dart';
// import 'transfer_state.dart';

// class TransferBloc extends Bloc<TransferEvent, TransferState> {
//   final TransferRepository _transferRepository;
//   final AuthBloc _authBloc;

//   TransferBloc(this._transferRepository, this._authBloc) : super(TransferInitial()) {
//     on<CreateTransferEvent>(_handleCreateTransfer);
//     on<CreateMultipleTransferEvent>(_handleCreateMultipleTransfer);
//     on<GetTransferHistoryEvent>(_handleGetTransferHistory);
//   }

//   Future<void> _handleCreateTransfer(CreateTransferEvent event, Emitter<TransferState> emit) async {
//     emit(TransferLoading());
//     try {
//       if (_authBloc.state is AuthAuthenticated) {
//         final currentUser = (_authBloc.state as AuthAuthenticated).user;
//         final transfer = await _transferRepository.createTransfer(
//           currentUser.id as String,
//           event.recipientId,
//           event.amount,
//         );
//         emit(TransferSuccess(transfer));
//       } else {
//         emit(TransferError('Utilisateur non authentifié'));
//       }
//     } catch (e) {
//       emit(TransferError('Erreur lors de la création du transfert : ${e.toString()}'));
//     }
//   }

//   Future<void> _handleCreateMultipleTransfer(
//     CreateMultipleTransferEvent event,
//     Emitter<TransferState> emit,
//   ) async {
//     emit(TransferLoading());
//     try {
//       if (_authBloc.state is! AuthAuthenticated) {
//         emit(TransferError('Utilisateur non authentifié'));
//         return;
//       }

//       final currentUser = (_authBloc.state as AuthAuthenticated).user;
      
//       // Calculer le montant total
//       final totalAmount = event.transfers.fold<double>(
//         0,
//         (sum, transfer) => sum + (transfer['amount'] as double),
//       );

//       // Vérifier le solde
//       if (!await _transferRepository.checkBalance(totalAmount)) {
//         emit(TransferError('Solde insuffisant pour effectuer tous les transferts'));
//         return;
//       }

//       // Effectuer les transferts
//       final transfers = await _transferRepository.createMultipleTransfers(
//         currentUser.id as String,
//         event.transfers,
//       );

//       emit(MultipleTransferSuccess(
//         transfers: transfers,
//         successCount: transfers.length,
//         totalCount: event.transfers.length,
//       ));
//     } catch (e) {
//       emit(TransferError(
//         'Erreur lors des transferts multiples : ${e.toString()}',
//       ));
//     }
//   }

//   Future<void> _handleGetTransferHistory(
//     GetTransferHistoryEvent event,
//     Emitter<TransferState> emit,
//   ) async {
//     emit(TransferLoading());
//     try {
//       if (_authBloc.state is AuthAuthenticated) {
//         final transferHistory = await _transferRepository.getTransferHistory();
//         emit(TransferHistoryLoaded(transferHistory));
//       } else {
//         emit(TransferError('Utilisateur non authentifié'));
//       }
//     } catch (e) {
//       emit(TransferError('Erreur lors du chargement de l\'historique : ${e.toString()}'));
//     }
//   }
// }
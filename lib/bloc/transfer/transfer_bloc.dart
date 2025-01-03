// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wave_app/bloc/auth/auth_bloc.dart';
// import 'package:wave_app/bloc/transfer/transfer_event.dart';
// import 'package:wave_app/bloc/transfer/transfer_state.dart';
// import 'package:wave_app/data/repositories/transfer_repository.dart';

// class TransferBloc extends Bloc<TransferEvent, TransferState> {
//   final TransferRepository _transferRepository;
//   final AuthBloc _authBloc;

//   TransferBloc(this._transferRepository, this._authBloc)
//       : super(const TransferInitial()) {
//     on<PerformTransferEvent>(_performTransfer);
//     on<PerformMultipleTransfersEvent>(_performMultipleTransfers);
//     on<ScheduleTransferEvent>(_scheduleTransfer);
//     on<LoadTransferHistoryEvent>(
//         _loadTransferHistory); // Ajoutez cette ligne pour enregistrer le gestionnaire
//   }

//   String _formatError(dynamic error) {
//     if (error is DioException) {
//       // Gestion des erreurs Dio spécifiques
//       switch (error.type) {
//         case DioExceptionType.connectionTimeout:
//           return 'Délai de connexion dépassé. Veuillez réessayer.';
//         case DioExceptionType.sendTimeout:
//           return 'Échec de l\'envoi. Veuillez vérifier votre connexion.';
//         case DioExceptionType.receiveTimeout:
//           return 'Délai de réception dépassé. Veuillez réessayer.';
//         case DioExceptionType.badResponse:
//           // Gestion des codes d'erreur HTTP
//           final statusCode = error.response?.statusCode;
//           switch (statusCode) {
//             case 400:
//               return 'Données invalides. Veuillez vérifier vos informations.';
//             case 401:
//               return 'Session expirée. Veuillez vous reconnecter.';
//             case 403:
//               return 'Accès refusé. Veuillez vérifier vos droits.';
//             case 404:
//               return 'Service indisponible. Veuillez réessayer plus tard.';
//             case 422:
//               return 'Solde insuffisant ou données invalides.';
//             case 500:
//               return 'Erreur serveur. Veuillez réessayer plus tard.';
//             default:
//               return 'Une erreur est survenue. Veuillez réessayer.';
//           }
//         case DioExceptionType.cancel:
//           return 'Opération annulée.';
//         default:
//           return 'Erreur de connexion. Veuillez vérifier votre connexion internet.';
//       }
//     }
//     return error.toString();
//   }

//   // TransferBloc(this._transferRepository) : super(const TransferInitial()) {
//   //   on<LoadTransferHistoryEvent>(_loadTransferHistory);
//   // }

//   Future<void> _loadTransferHistory(
//     LoadTransferHistoryEvent event,
//     Emitter<TransferState> emit,
//   ) async {
//     try {
//       emit(const TransferLoading());

//       // Fetching transfer history as a List<TransferHistory>
//       final transferHistory = await _transferRepository.getTransferHistory();

//       // Explicitly typing the list as List<Map<String, dynamic>>
//       final List<Map<String, dynamic>> transferHistoryMapList = transferHistory
//           .map<Map<String, dynamic>>((history) => history.toMap())
//           .toList();

//       // Emit the TransferHistoryLoaded with the mapped data
//       emit(TransferHistoryLoaded(transfers: transferHistoryMapList));
//     } catch (e) {
//       emit(const TransferFailure(
//         error: 'Erreur lors du chargement de l\'historique des transferts',
//       ));
//     }
//   }

//   Future<void> _performTransfer(
//     PerformTransferEvent event,
//     Emitter<TransferState> emit,
//   ) async {
//     try {
//       emit(const TransferLoading());
//       final result = await _transferRepository.performTransfer(
//         recipientPhone: event.recipientPhone,
//         amount: event.amount,
//       );

//       emit(TransferSuccess(
//         message:
//             'Transfert de ${event.amount} FCFA effectué avec succès vers ${event.recipientPhone}',
//         transactionId: result.transactionId.toString(),
//         details: {
//           'transaction_id': result.transactionId,
//           'amount': result.amount,
//           'recipient': {
//             'firstName': result.recipient.firstName,
//             'lastName': result.recipient.lastName,
//             'phone': result.recipient.phone,
//           },
//           'balance': result.balance,
//           'status': result.status,
//           'created_at': result.createdAt?.toIso8601String(),
//         },
//       ));
//     } catch (e) {
//       emit(TransferFailure(
//         error: _formatError(e),
//         details: e is DioException ? e.response?.data : null,
//       ));
//     }
//   }

//   Future<void> _performMultipleTransfers(
//     PerformMultipleTransfersEvent event,
//     Emitter<TransferState> emit,
//   ) async {
//     try {
//       emit(const TransferLoading());
//       final result = await _transferRepository.performMultipleTransfers(
//         recipientPhones: event.recipientPhones,
//         amount: event.amount,
//       );

//       final totalAmount = event.amount * event.recipientPhones.length;
//       emit(TransferSuccess(
//         message:
//             'Transfert multiple de ${event.amount} FCFA effectué avec succès vers ${event.recipientPhones.length} bénéficiaires (Total: $totalAmount FCFA)',
//         transactionId: 'batch_${DateTime.now().millisecondsSinceEpoch}',
//         details: {
//           'successful_transfers': result.successfulTransfers
//               .map((transfer) => {
//                     'transaction_id': transfer.transactionId,
//                     'amount': transfer.amount,
//                     'recipient': {
//                       'firstName': transfer.recipient.firstName,
//                       'lastName': transfer.recipient.lastName,
//                       'phone': transfer.recipient.phone,
//                     },
//                   })
//               .toList(),
//           'failed_transfers': result.failedTransfers
//               .map((failed) => {
//                     'recipient': failed.recipient,
//                     'reason': failed.reason,
//                   })
//               .toList(),
//           'total_transferred': result.totalTransferred,
//           'remaining_balance': result.remainingBalance,
//           'transfers_completed': result.transfersCompleted,
//           'transfers_failed': result.transfersFailed,
//         },
//       ));
//     } catch (e) {
//       emit(TransferFailure(
//         error: _formatError(e),
//         details: e is DioException ? e.response?.data : null,
//       ));
//     }
//   }

//   Future<void> _scheduleTransfer(
//     ScheduleTransferEvent event,
//     Emitter<TransferState> emit,
//   ) async {
//     try {
//       emit(const TransferLoading());
//       final result = await _transferRepository.scheduleTransfer(
//         recipientPhone: event.recipientPhone,
//         amount: event.amount,
//         scheduleDate: event.startDate,
//         scheduleTime: event.executionTime,
//         frequency: event.frequency, // Add this line
//       );

//       final formattedDate = event.startDate.toString().split(' ')[0];
//       emit(TransferSuccess(
//         message:
//             'Transfert programmé de ${event.amount} FCFA vers ${event.recipientPhone} pour le $formattedDate à ${event.executionTime}',
//         transactionId: result.transactionId.toString(),
//         details: {
//           'transaction_id': result.transactionId,
//           'amount': result.amount,
//           'recipient': {
//             'firstName': result.recipient.firstName,
//             'lastName': result.recipient.lastName,
//             'phone': result.recipient.phone,
//           },
//           'schedule_date': event.startDate.toIso8601String(),
//           'execution_time': event.executionTime,
//           'frequency': event.frequency, // Add this line
//         },
//         isScheduled: true,
//       ));
//     } catch (e) {
//       emit(TransferFailure(
//         error: _formatError(e),
//         details: e is DioException ? e.response?.data : null,
//       ));
//     }
//   }
// }

import 'package:dio/dio.dart';
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
      : super(const TransferInitial()) {
    on<PerformTransferEvent>(_performTransfer);
    on<PerformMultipleTransfersEvent>(_performMultipleTransfers);
    on<ScheduleTransferEvent>(_scheduleTransfer);
    on<LoadTransferHistoryEvent>(_loadTransferHistory);
  }

  String _formatError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Délai de connexion dépassé. Veuillez réessayer.';
        case DioExceptionType.sendTimeout:
          return 'Échec de l\'envoi. Veuillez vérifier votre connexion.';
        case DioExceptionType.receiveTimeout:
          return 'Délai de réception dépassé. Veuillez réessayer.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 400:
              return 'Données invalides. Veuillez vérifier vos informations.';
            case 401:
              return 'Session expirée. Veuillez vous reconnecter.';
            case 403:
              return 'Accès refusé. Veuillez vérifier vos droits.';
            case 404:
              return 'Service indisponible. Veuillez réessayer plus tard.';
            case 422:
              return 'Solde insuffisant ou données invalides.';
            case 500:
              return 'Erreur serveur. Veuillez réessayer plus tard.';
            default:
              return 'Une erreur est survenue. Veuillez réessayer.';
          }
        case DioExceptionType.cancel:
          return 'Opération annulée.';
        default:
          return 'Erreur de connexion. Veuillez vérifier votre connexion internet.';
      }
    }
    return error.toString();
  }

  Future<void> _loadTransferHistory(
    LoadTransferHistoryEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      emit(const TransferLoading());

      // Récupérer l'historique sous forme de List<Map<String, dynamic>>
      final List<Map<String, dynamic>> transferHistory =
          (await _transferRepository.getTransferHistory())
              .cast<Map<String, dynamic>>();

      // Convertir chaque Map en Transaction
      final List<Transaction> transferHistoryList = transferHistory
          .map<Transaction>((map) => Transaction.fromJson(map))
          .toList();

      emit(TransferHistoryLoaded(transfers: transferHistoryList));
    } catch (e) {
      emit(const TransferFailure(
        error: 'Erreur lors du chargement de l\'historique des transferts',
      ));
    }
  }

  Future<void> _performTransfer(
    PerformTransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      emit(const TransferLoading());
      final result = await _transferRepository.performTransfer(
        recipientPhone: event.recipientPhone,
        amount: event.amount,
      );

      emit(TransferSuccess(
        message:
            'Transfert de ${event.amount} FCFA effectué avec succès vers ${event.recipientPhone}',
        transactionId: result.transactionId.toString(),
        details: {
          'transaction_id': result.transactionId,
          'amount': result.amount,
          'recipient': {
            'firstName': result.recipient.firstName,
            'lastName': result.recipient.lastName,
            'phone': result.recipient.phone,
          },
          'balance': result.balance,
          'status': result.status,
          'created_at': result.createdAt?.toIso8601String(),
        },
      ));
    } catch (e) {
      emit(TransferFailure(
        error: _formatError(e),
        details: e is DioException ? e.response?.data : null,
      ));
    }
  }

  Future<void> _performMultipleTransfers(
    PerformMultipleTransfersEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      emit(const TransferLoading());
      final result = await _transferRepository.performMultipleTransfers(
        recipientPhones: event.recipientPhones,
        amount: event.amount,
      );

      final totalAmount = event.amount * event.recipientPhones.length;
      emit(TransferSuccess(
        message:
            'Transfert multiple de ${event.amount} FCFA effectué avec succès vers ${event.recipientPhones.length} bénéficiaires (Total: $totalAmount FCFA)',
        transactionId: 'batch_${DateTime.now().millisecondsSinceEpoch}',
        details: {
          'successful_transfers': result.successfulTransfers
              .map((transfer) => {
                    'transaction_id': transfer.transactionId,
                    'amount': transfer.amount,
                    'recipient': {
                      'firstName': transfer.recipient.firstName,
                      'lastName': transfer.recipient.lastName,
                      'phone': transfer.recipient.phone,
                    },
                  })
              .toList(),
          'failed_transfers': result.failedTransfers
              .map((failed) => {
                    'recipient': failed.recipient,
                    'reason': failed.reason,
                  })
              .toList(),
          'total_transferred': result.totalTransferred,
          'remaining_balance': result.remainingBalance,
          'transfers_completed': result.transfersCompleted,
          'transfers_failed': result.transfersFailed,
        },
      ));
    } catch (e) {
      emit(TransferFailure(
        error: _formatError(e),
        details: e is DioException ? e.response?.data : null,
      ));
    }
  }

  Future<void> _scheduleTransfer(
    ScheduleTransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      emit(const TransferLoading());
      final result = await _transferRepository.scheduleTransfer(
        recipientPhone: event.recipientPhone,
        amount: event.amount,
        scheduleDate: event.startDate,
        scheduleTime: event.executionTime,
        frequency: event.frequency,
      );

      final formattedDate = event.startDate.toString().split(' ')[0];
      emit(TransferSuccess(
        message:
            'Transfert programmé de ${event.amount} FCFA vers ${event.recipientPhone} pour le $formattedDate à ${event.executionTime}',
        transactionId: result.transactionId.toString(),
        details: {
          'transaction_id': result.transactionId,
          'amount': result.amount,
          'recipient': {
            'firstName': result.recipient.firstName,
            'lastName': result.recipient.lastName,
            'phone': result.recipient.phone,
          },
          'schedule_date': event.startDate.toIso8601String(),
          'execution_time': event.executionTime,
          'frequency': event.frequency,
        },
        isScheduled: true,
      ));
    } catch (e) {
      emit(TransferFailure(
        error: _formatError(e),
        details: e is DioException ? e.response?.data : null,
      ));
    }
  }
}

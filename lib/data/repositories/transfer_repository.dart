import 'package:dio/dio.dart';
import 'package:wave_app/data/models/transfer_model.dart';
import 'package:wave_app/services/dio_service.dart';

class TransferRepository {
  late final Dio _dio;

  TransferRepository() {
    _dio = DioService.instance.getDio();
  }

  // Effectuer un transfert unique
  Future<TransferResult> performTransfer({
    required String recipientPhone,
    required double amount,
  }) async {
    try {
      final response = await _dio.post(
        '/transfer',
        data: {
          'telephone': recipientPhone,
          'montant': amount,
        },
      );

      if (response.statusCode == 200) {
        return TransferResult.fromJson(response.data['data']);
      } else {
        throw _createApiException(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Erreur inattendue lors du transfert: $e');
    }
  }

  // Effectuer des transferts multiples
  Future<MultipleTransferResult> performMultipleTransfers({
    required List<String> recipientPhones,
    required double amount,
  }) async {
    try {
      final response = await _dio.post(
        '/transfer/multiple',
        data: {
          'telephones': recipientPhones,
          'montant': amount,
        },
      );

      if (response.statusCode == 200) {
        return MultipleTransferResult.fromJson(response.data['data']);
      } else {
        throw _createApiException(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Erreur inattendue lors des transferts multiples: $e');
    }
  }

  // Annuler un transfert
  Future<CancelTransferResult> cancelTransfer({
    required String transactionId,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '/transfer/cancel',
        data: {
          'transaction_id': transactionId,
          'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        return CancelTransferResult.fromJson(response.data['data']);
      } else {
        throw _createApiException(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Erreur inattendue lors de l\'annulation du transfert: $e');
    }
  }

  // Planifier un transfert
  Future<TransferResult> scheduleTransfer({
    required String recipientPhone,
    required double amount,
    required DateTime scheduleDate,
    required String scheduleTime, required String frequency,
  }) async {
    try {
      final response = await _dio.post(
        '/transfer/schedule',
        data: {
          'telephone': recipientPhone,
          'montant': amount,
          'frequence': frequency,
          'date_debut': scheduleDate.toIso8601String(),
          'heure_execution': scheduleTime,
        },
      );

      if (response.statusCode == 200) {
        return TransferResult.fromJson(response.data['data']);
      } else {
        throw _createApiException(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Erreur inattendue lors de la planification du transfert: $e');
    }
  }

  // Récupérer l'historique des transferts
  Future<List<TransferHistory>> getTransferHistory() async {
    try {
      final response = await _dio.get('/transactions/history');

      if (response.statusCode == 200) {
        final List<dynamic> transfersJson = response.data['transfers'] ?? [];
        return transfersJson
            .map((transferJson) => TransferHistory.fromJson(transferJson))
            .toList();
      } else {
        throw _createApiException(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération de l\'historique: $e');
    }
  }

  // Récupérer les détails d'un transfert spécifique
  Future<TransferResult> getTransferDetails(String transactionId) async {
    try {
      final response = await _dio.get('/transfer/$transactionId');

      if (response.statusCode == 200) {
        return TransferResult.fromJson(response.data['data']);
      } else {
        throw _createApiException(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Erreur inattendue lors de la récupération des détails du transfert: $e');
    }
  }

  // Gérer les exceptions de l'API
  Exception _createApiException(Response response) {
    String message;
    try {
      message = response.data?['message'] ?? 'Erreur inconnue';
    } catch (e) {
      message = 'Erreur de format de réponse';
    }
    return Exception('Erreur API (${response.statusCode}): $message');
  }

  // Gérer les exceptions Dio
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Délai d\'attente dépassé. Vérifiez votre connexion internet.',
        );

      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return Exception('Session expirée. Veuillez vous reconnecter.');
        }
        final statusCode = e.response?.statusCode;
        String message;
        try {
          message = e.response?.data?['message'] ?? 'Erreur inconnue';
        } catch (_) {
          message = 'Erreur de format de réponse';
        }
        return Exception('Erreur $statusCode: $message');

      case DioExceptionType.connectionError:
        return Exception(
          'Impossible de se connecter au serveur. Vérifiez votre connexion.',
        );

      case DioExceptionType.badCertificate:
        return Exception(
          'Erreur de certificat SSL. Connexion non sécurisée.',
        );

      case DioExceptionType.cancel:
        return Exception('La requête a été annulée.');

      default:
        return Exception(
          'Une erreur est survenue: ${e.message ?? 'Erreur inconnue'}',
        );
    }
  }
}
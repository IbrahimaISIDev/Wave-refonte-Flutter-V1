import 'package:dio/dio.dart';
import 'package:wave_app/data/models/transfer_model.dart';

class TransferRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://votre_api_url.com/api',
    contentType: 'application/json',
  ));

  // Effectuer un transfert simple
  Future<TransferResult> transfer(user, String recipientId, double amount) async {
    try {
      final response = await _dio.post('/transfers', data: {
        'sender_id': user.id,
        'recipient_id': recipientId,
        'amount': amount,
      });
      return TransferResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Effectuer des transferts multiples
  Future<MultipleTransferResult> multipleTransfer(user, List<String> recipients, double amount) async {
    try {
      final transfers = recipients.map((recipient) => {
        'recipient_id': recipient,
        'amount': amount,
      }).toList();

      final response = await _dio.post('/transfers/bulk', data: {
        'sender_id': user.id,
        'transfers': transfers,
      });
      
      return MultipleTransferResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Planifier un transfert
  Future<TransferResult> scheduleTransfer(user, String recipientId, double amount, DateTime scheduleDate) async {
    try {
      final response = await _dio.post('/transfers/schedule', data: {
        'sender_id': user.id,
        'recipient_id': recipientId,
        'amount': amount,
        'schedule_date': scheduleDate.toIso8601String(),
      });
      return TransferResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Annuler un transfert
  Future<CancelTransferResult> cancelTransfer(String userId, String transactionId, String reason) async {
    try {
      final response = await _dio.post('/transfers/cancel', data: {
        'user_id': userId,
        'transaction_id': transactionId,
        'reason': reason,
      });
      return CancelTransferResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Récupérer l'historique des transferts
  Future<List> getTransferHistory(String userId, int page, int limit) async {
    try {
      final response = await _dio.get('/transfers/history', queryParameters: {
        'user_id': userId,
        'page': page,
        'limit': limit,
      });
      return (response.data as List)
          .map((item) => TransferHistory.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response?.data['message'];
    }
    return 'Une erreur est survenue. Veuillez réessayer.';
  }
}
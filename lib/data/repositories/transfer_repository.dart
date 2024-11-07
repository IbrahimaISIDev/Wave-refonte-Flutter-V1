// lib/data/repositories/transfer_repository.dart
import 'package:dio/dio.dart';
import 'package:wave_app/data/models/transfer_model.dart';

class TransferRepository {
  // Remplacez 'YOUR_API_URL' par l'URL de votre API réelle.
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://votre_api_url.com', // Remplacez ici avec l'URL de l'API
    contentType: 'application/json',
  ));

  // Créer un transfert
  Future<TransferModel> createTransfer(String senderId, String recipientId, double amount) async {
    try {
      final response = await _dio.post('/transfers', data: {
        'sender_id': senderId,
        'recipient_id': recipientId,
        'amount': amount,
      });
      return TransferModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Récupérer l'historique des transferts
  Future<List<TransferModel>> getTransferHistory() async {
    try {
      final response = await _dio.get('/transfers/history');
      return (response.data as List)
          .map((item) => TransferModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Gérer les erreurs
  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response?.data['message'];
    }
    return 'Une erreur est survenue. Veuillez réessayer.';
  }
}

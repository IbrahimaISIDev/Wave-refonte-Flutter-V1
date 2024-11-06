// lib/data/repositories/transfer_repository.dart
import 'package:dio/dio.dart';
import 'package:wave_app/data/models/transfer_model.dart';

class TransferRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'YOUR_API_URL',
    contentType: 'application/json',
  ));

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

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response?.data['message'];
    }
    return 'Une erreur est survenue. Veuillez réessayer.';
  }
}


// class TransferRepository {
//   Future<TransferModel> createTransfer(int recipientId, double amount, String userId) async {
//     // Simuler une création de transfert
//     return TransferModel(
//       id: 1,
//       name: "Transfer to $recipientId",
//       status: "completed",
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       description: "Transfer of $amount",
//       type: "send",
//       currency: "FCFA",
//       amount: amount,
//       recipientName: "Recipient $recipientId",
//     );
//   }

//   Future<List<TransferModel>> getTransferHistory() async {
//     // Simuler la récupération de l'historique
//     return [];
//   }
// }
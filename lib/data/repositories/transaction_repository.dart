import 'package:wave_app/data/models/transaction.dart';
import 'package:wave_app/data/models/transfer_model.dart';
import 'package:wave_app/data/models/user_model.dart';

class TransactionStats {
  final String totalEnvoye;
  final String totalRecu;
  final int nombreEnvois;
  final int nombreReceptions;

  TransactionStats({
    required this.totalEnvoye,
    required this.totalRecu,
    required this.nombreEnvois,
    required this.nombreReceptions,
  });

  factory TransactionStats.fromJson(Map<String, dynamic> json) {
    return TransactionStats(
      totalEnvoye: json['total_envoye'] as String,
      totalRecu: json['total_recu'] as String,
      nombreEnvois: json['nombre_envois'] as int,
      nombreReceptions: json['nombre_receptions'] as int,
    );
  }
}

class TransactionPagination {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  TransactionPagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory TransactionPagination.fromJson(Map<String, dynamic> json) {
    return TransactionPagination(
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
    );
  }
}

class TransactionHistoryResponse {
  final List<Transaction> transactions;
  final TransactionStats stats;
  final TransactionPagination pagination;

  TransactionHistoryResponse({
    required this.transactions,
    required this.stats,
    required this.pagination,
  });
}

class TransactionRepository {
  Future<TransactionHistoryResponse> getTransactionHistory(
    int userId, {
    int page = 1,
    int perPage = 15,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Simulation de la réponse pour l'exemple
      final Map<String, dynamic> response = {
        'status': true,
        'data': {
          'transactions': [
            {
              'id': 1,
              'type': {'id': 1, 'libelle': 'TRANSFERT'},
              'montant': 5000.0,
              'date': '2024-03-11 10:30:00',
              'status': 'completed',
              'is_expediteur': true,
              'autre_partie': {
                'id': 2,
                'nom': 'Doe',
                'prenom': 'John',
                'telephone': '0612345678'
              },
              'cancelled_at': null,
              'cancel_reason': null
            }
          ],
          'stats': {
            'total_envoye': '50 000 FCFA',
            'total_recu': '30 000 FCFA',
            'nombre_envois': 5,
            'nombre_receptions': 3
          },
          'pagination': {
            'total': 100,
            'per_page': 15,
            'current_page': 1,
            'last_page': 7
          }
        }
      };

      final data = response['data'] as Map<String, dynamic>;
      final transactionsJson = data['transactions'] as List<dynamic>;
      
      // Conversion explicite en List<Transaction>
      final List<Transaction> transactions = List<Transaction>.from(
        transactionsJson.map((json) => Transaction.fromJson(json as Map<String, dynamic>))
      );
          
      final stats = TransactionStats.fromJson(data['stats'] as Map<String, dynamic>);
      final pagination = TransactionPagination.fromJson(data['pagination'] as Map<String, dynamic>);

      return TransactionHistoryResponse(
        transactions: transactions,
        stats: stats,
        pagination: pagination,
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'historique: $e');
    }
  }

  Future<double> checkBalance(int userId) async {
    try {
      // Simulation de la réponse
      final Map<String, dynamic> response = {
        'status': true,
        'balance': 25000.0
      };

      return response['balance'] as double;
    } catch (e) {
      throw Exception('Erreur lors de la vérification du solde: $e');
    }
  }

  Future<Transaction?> verifyQrCode(String qrCodeData) async {
    try {
      // Simulation de la réponse
      final Map<String, dynamic> response = {
        'status': true,
        'transaction': {
          'id': 1,
          'type': {'id': 1, 'libelle': 'TRANSFERT'},
          'montant': 5000.0,
          'date': '2024-03-11 10:30:00',
          'status': 'pending',
        }
      };

      if (response['status'] == true && response['transaction'] != null) {
        return Transaction.fromJson(response['transaction'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la vérification du QR code: $e');
    }
  }

  Future<bool> cancelTransaction(int transactionId, String reason) async {
    try {
      // Simuler l'appel API
      return true;
    } catch (e) {
      throw Exception('Erreur lors de l\'annulation de la transaction: $e');
    }
  }
}


// import 'package:wave_app/data/models/transaction.dart';
// import 'package:wave_app/data/models/transfer_model.dart';
// import 'package:wave_app/data/models/user_model.dart';

// class TransactionStats {
//   final String totalEnvoye;
//   final String totalRecu;
//   final int nombreEnvois;
//   final int nombreReceptions;

//   TransactionStats({
//     required this.totalEnvoye,
//     required this.totalRecu,
//     required this.nombreEnvois,
//     required this.nombreReceptions,
//   });

//   factory TransactionStats.fromJson(Map<String, dynamic> json) {
//     return TransactionStats(
//       totalEnvoye: json['total_envoye'],
//       totalRecu: json['total_recu'],
//       nombreEnvois: json['nombre_envois'],
//       nombreReceptions: json['nombre_receptions'],
//     );
//   }
// }

// class TransactionPagination {
//   final int total;
//   final int perPage;
//   final int currentPage;
//   final int lastPage;

//   TransactionPagination({
//     required this.total,
//     required this.perPage,
//     required this.currentPage,
//     required this.lastPage,
//   });

//   factory TransactionPagination.fromJson(Map<String, dynamic> json) {
//     return TransactionPagination(
//       total: json['total'],
//       perPage: json['per_page'],
//       currentPage: json['current_page'],
//       lastPage: json['last_page'],
//     );
//   }
// }

// class TransactionHistoryResponse {
//   final List<Transaction> transactions;
//   final TransactionStats stats;
//   final TransactionPagination pagination;

//   TransactionHistoryResponse({
//     required this.transactions,
//     required this.stats,
//     required this.pagination,
//   });
// }

// class TransactionRepository {
//   Future<TransactionHistoryResponse> getTransactionHistory(
//     int userId, {
//     int page = 1,
//     int perPage = 15,
//     Map<String, dynamic>? filters,
//   }) async {
//     try {
//       // Ici, vous ferez l'appel API réel
//       // Response response = await dio.get('/transactions/history', queryParameters: {...});
      
//       // Simulation de la réponse pour l'exemple
//       final response = {
//         'status': true,
//         'data': {
//           'transactions': [
//             {
//               'id': 1,
//               'type': {'id': 1, 'libelle': 'TRANSFERT'},
//               'montant': 5000.0,
//               'date': '2024-03-11 10:30:00',
//               'status': 'completed',
//               'is_expediteur': true,
//               'autre_partie': {
//                 'id': 2,
//                 'nom': 'Doe',
//                 'prenom': 'John',
//                 'telephone': '0612345678'
//               },
//               'cancelled_at': null,
//               'cancel_reason': null
//             }
//           ],
//           'stats': {
//             'total_envoye': '50 000 FCFA',
//             'total_recu': '30 000 FCFA',
//             'nombre_envois': 5,
//             'nombre_receptions': 3
//           },
//           'pagination': {
//             'total': 100,
//             'per_page': 15,
//             'current_page': 1,
//             'last_page': 7
//           }
//         }
//       };

//       final transactions = (response['data']?['transactions'] as List)
//           .map((t) => Transaction.fromJson(t))
//           .toList();
          
//       final stats = TransactionStats.fromJson(response['data']?['stats']);
//       final pagination = TransactionPagination.fromJson(response['data']?['pagination']);

//       return TransactionHistoryResponse(
//         transactions: transactions,
//         stats: stats,
//         pagination: pagination,
//       );
//     } catch (e) {
//       throw Exception('Erreur lors de la récupération de l\'historique: $e');
//     }
//   }

//   Future<Object?> checkBalance(int userId) async {
//     try {
//       // Ici, vous ferez l'appel API réel
//       // final response = await dio.get('/transactions/balance');
      
//       // Simulation de la réponse
//       final response = {
//         'status': true,
//         'balance': 25000.0
//       };

//       return response['balance'];
//     } catch (e) {
//       throw Exception('Erreur lors de la vérification du solde: $e');
//     }
//   }

//   Future<Transaction?> verifyQrCode(String qrCodeData) async {
//     try {
//       // Ici, vous ferez l'appel API réel
//       // final response = await dio.post('/transactions/verify-qr', data: {'qr_code_data': qrCodeData});
      
//       // Simulation de la réponse
//       final response = {
//         'status': true,
//         'transaction': {
//           'id': 1,
//           'type': {'id': 1, 'libelle': 'TRANSFERT'},
//           'montant': 5000.0,
//           'date': '2024-03-11 10:30:00',
//           'status': 'pending',
//         }
//       };

//       return response['status'] != null ? Transaction.fromJson(response['transaction']) : null;
//     } catch (e) {
//       throw Exception('Erreur lors de la vérification du QR code: $e');
//     }
//   }

//   Future<bool> cancelTransaction(int transactionId, String reason) async {
//     try {
//       // Ici, vous ferez l'appel API réel
//       // final response = await dio.post('/transactions/$transactionId/cancel', data: {'reason': reason});
      
//       return true;
//     } catch (e) {
//       throw Exception('Erreur lors de l\'annulation de la transaction: $e');
//     }
//   }
// }
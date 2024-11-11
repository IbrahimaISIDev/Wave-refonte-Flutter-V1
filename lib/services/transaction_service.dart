// lib/services/transaction_service.dart
import 'package:dio/dio.dart';
import 'package:wave_app/data/models/transaction.dart';

class TransactionService {
  final Dio _dio;
  
 TransactionService() : _dio = Dio() {
    _dio.options.baseUrl = 'http://192.168.6.82:3000/api';
    // Ajoutez ici la configuration de votre intercepteur pour le token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Replace this with actual token retrieval logic
        final token = await getTokenFromStorage(); // Example function
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  Future<TransactionHistoryResponse> getTransactionHistory({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _dio.get(
        '/history',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200 && response.data['status']) {
        return TransactionHistoryResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Une erreur est survenue');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'historique: ${e.toString()}');
    }
  }
  
  getTokenFromStorage() {
    // Assuming you're using a storage library like shared_preferences
    // Replace this with actual token retrieval logic
    return Future.value('YOUR_TOKEN_HERE'); // Example token
  }
}

class TransactionHistoryResponse {
  final List<Transaction> transactions;
  final TransactionStats stats;
  final PaginationInfo pagination;

  TransactionHistoryResponse({
    required this.transactions,
    required this.stats,
    required this.pagination,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      transactions: (json['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
      stats: TransactionStats.fromJson(json['stats']),
      pagination: PaginationInfo.fromJson(json['pagination']),
    );
  }
}

class TransactionStats {
  final String totalSent;
  final String totalReceived;
  final int sentCount;
  final int receivedCount;

  TransactionStats({
    required this.totalSent,
    required this.totalReceived,
    required this.sentCount,
    required this.receivedCount,
  });

  factory TransactionStats.fromJson(Map<String, dynamic> json) {
    return TransactionStats(
      totalSent: json['total_envoye'],
      totalReceived: json['total_recu'],
      sentCount: json['nombre_envois'],
      receivedCount: json['nombre_receptions'],
    );
  }
}

class PaginationInfo {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  PaginationInfo({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}
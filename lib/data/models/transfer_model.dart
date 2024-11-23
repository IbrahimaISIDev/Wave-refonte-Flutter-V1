// Définition de l'énumération TransferType
enum TransferType { single, multiple }

// Définition de la classe Recipient
class Recipient {
  final String firstName;
  final String lastName;
  final String phone;
  final bool isFavorite;

  Recipient({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.isFavorite = false,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      firstName: json['prenom'] ?? '',
      lastName: json['nom'] ?? '',  
      phone: json['telephone'] ?? '',
      isFavorite: json['is_favori'] ?? false,
    );
  }
}

// Définition de la classe FailedTransfer
class FailedTransfer {
  final String recipient;
  final String reason;

  FailedTransfer({
    required this.recipient,
    required this.reason,
  });

  factory FailedTransfer.fromJson(Map<String, dynamic> json) {
    return FailedTransfer(
      recipient: json['recipient'] ?? '',
      reason: json['reason'] ?? 'Raison inconnue',
    );
  }
}

// Classe principale TransferResult
class TransferResult {
  final int transactionId;
  final double amount;
  final Recipient recipient;
  final DateTime? createdAt;
  final double? balance;
  final String? status;

  TransferResult({
    required this.transactionId,
    required this.amount,
    required this.recipient,
    this.createdAt,
    this.balance,
    this.status,
  });

  factory TransferResult.fromJson(Map<String, dynamic> data) {
    return TransferResult(
      transactionId: data['transaction_id'] ?? 0,
      amount: _safeParseDouble(data['amount']),
      recipient: Recipient.fromJson(data['recipient'] ?? {}),
      createdAt: data['date'] != null ? DateTime.parse(data['date']) : null,
      balance: _safeParseDouble(data['balance']),
      status: data['status'],
    );
  }

  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value.replaceAll(",", "."));
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }
}

class MultipleTransferResult {
  final List<TransferResult> successfulTransfers;
  final List<FailedTransfer> failedTransfers;
  final double totalTransferred;
  final double remainingBalance;
  final int transfersCompleted;
  final int transfersFailed;

  MultipleTransferResult({
    required this.successfulTransfers,
    required this.failedTransfers,
    required this.totalTransferred,
    required this.remainingBalance,
    required this.transfersCompleted,
    required this.transfersFailed,
  });

  factory MultipleTransferResult.fromJson(Map<String, dynamic> json) {
    return MultipleTransferResult(
      successfulTransfers: (json['successful_transfers'] as List?)
          ?.map((data) => TransferResult.fromJson(data))
          .toList() ?? [],
      failedTransfers: (json['failed_transfers'] as List?)
          ?.map((data) => FailedTransfer.fromJson(data))
          .toList() ?? [],
      totalTransferred: _safeParseDouble(json['total_transferred']),
      remainingBalance: _safeParseDouble(json['remaining_balance']),
      transfersCompleted: json['transfers_completed'] ?? 0,
      transfersFailed: json['transfers_failed'] ?? 0,
    );
  }

  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value.replaceAll(",", "."));
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }
}

class CancelTransferResult {
  final int transactionId;
  final double refundAmount;
  final double newBalance;
  final DateTime cancelDate;

  CancelTransferResult({
    required this.transactionId,
    required this.refundAmount,
    required this.newBalance,
    required this.cancelDate,
  });

  factory CancelTransferResult.fromJson(Map<String, dynamic> json) {
    return CancelTransferResult(
      transactionId: json['transaction_id'] ?? 0,
      refundAmount: _safeParseDouble(json['refund_amount']),
      newBalance: _safeParseDouble(json['new_balance']),
      cancelDate: DateTime.parse(json['cancel_date'] ?? DateTime.now().toIso8601String()),
    );
  }

  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value.replaceAll(",", "."));
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }
}

class TransferHistory {
  final int id;
  final double amount;
  final Recipient recipient;
  final DateTime date;
  final TransferType type;

  TransferHistory({
    required this.id,
    required this.amount,
    required this.recipient,
    required this.date,
    required this.type,
  });

  factory TransferHistory.fromJson(Map<String, dynamic> item) {
    return TransferHistory(
      id: item['id'] ?? 0,
      amount: _safeParseDouble(item['amount']),
      recipient: Recipient.fromJson(item['recipient'] ?? {}),
      date: DateTime.parse(item['date'] ?? DateTime.now().toIso8601String()),
      type: TransferType.single,
    );
  }

  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value.replaceAll(",", "."));
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }
  toMap() {}
}

class Transfer {
  final double amount;
  final String date;
  final String status;

  Transfer({required this.amount, required this.date, required this.status});

  // Factory constructor to create a Transfer from a map
  factory Transfer.fromMap(Map<String, dynamic> map) {
    return Transfer(
      amount: map['amount'] ?? 0.0,
      date: map['date'] ?? '',
      status: map['status'] ?? 'unknown',
    );
  }
}


enum TransactionType { sent, received, transfer }

enum TransactionStatus { completed, pending, failed, cancelled }

class Transaction {
  final TransactionType type;
  final double amount;
  final String recipient;
  final DateTime date;
  final TransactionStatus status;

  const Transaction({
    required this.type,
    required this.amount,
    required this.recipient,
    required this.date,
    required this.status,
  });

  get montant => null;

  get autreParte => null;

  get typeOperation => null;

  get typeLibelle => null;

  get cancelledAt => null;

  get cancelReason => null;

  static fromJson(t) {}

  static fromMap(map) {}
}
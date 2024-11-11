// lib/data/models/transfer_model.dart
import 'dart:async';

class TransferResult {
  final int transactionId;
  final double amount;
  final Recipient recipient;
  final DateTime date;
  final double balance;

  TransferResult({
    required this.transactionId,
    required this.amount,
    required this.recipient,
    required this.date,
    required this.balance,
  });

  static Future<TransferResult> fromJson(data) {
    // Implementation of parsing JSON data
    return Future.value(TransferResult(
      transactionId: data['transaction_id'],
      amount: data['amount'],
      recipient: Recipient.fromJson(data['recipient']),
      date: DateTime.parse(data['date']),
      balance: data['balance'],
    ));
  }
}

class MultipleTransferResult {
  final List<TransferResult> successfulTransfers;
  final List<FailedTransfer> failedTransfers;
  final double totalTransferred;
  final double remainingBalance;

  MultipleTransferResult({
    required this.successfulTransfers,
    required this.failedTransfers,
    required this.totalTransferred,
    required this.remainingBalance,
  });

  static Future<MultipleTransferResult> fromJson(data) {
    // Implementation of parsing JSON data
    return Future.value(MultipleTransferResult(
      successfulTransfers: data['successful_transfers'].map((data) => TransferResult.fromJson(data)).toList(),
      failedTransfers: data['failed_transfers'].map((data) => FailedTransfer.fromJson(data)).toList(),
      totalTransferred: data['total_transferred'],
      remainingBalance: data['remaining_balance'],
    ));
  }
}

class FailedTransfer {
  final String recipient;
  final String reason;

  FailedTransfer({
    required this.recipient,
    required this.reason,
  });
  
  static fromJson(data) {
    // Implementation of parsing JSON data
    return FailedTransfer(
      recipient: data['recipient'],
      reason: data['reason'],
    );
  }
}

class CancelTransferResult {
  final int transactionId;
  final double refundAmount;
  final double newBalance;

  CancelTransferResult({
    required this.transactionId,
    required this.refundAmount,
    required this.newBalance,
  });

  static Future<CancelTransferResult> fromJson(data) {
    // Implementation of parsing JSON data
    return Future.value(CancelTransferResult(
      transactionId: data['transaction_id'],
      refundAmount: data['refund_amount'],
      newBalance: data['new_balance'],
    ));
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

  static fromJson(item) {
    // Implementation of parsing JSON data
    return TransferHistory(
      id: item['id'],
      amount: item['amount'],
      recipient: Recipient.fromJson(item['recipient']),
      date: DateTime.parse(item['date']),
      type: TransferType.single, // Assuming single transfer type for simplicity
    );
  }
}

class TransferSchedule {
  final DateTime nextTransferDate;
  final Duration frequency;

  TransferSchedule({
    required this.nextTransferDate,
    required this.frequency,
  });
}

class Recipient {
  final String name;
  final String phone;

  Recipient({
    required this.name,
    required this.phone,
  });
  
  static fromJson(data) {
    // Implementation of parsing JSON data
    return Recipient(
      name: data['name'],
      phone: data['phone'],
    );
  }
}

enum TransferType { single, multiple }

class TransferModel {
  final int id;
  final int senderId;
  final int recipientId;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String status;
  final String description;
  final String type;
  final String currency;
  final String recipientName;
  final String recipientPhone;

  TransferModel({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.status,
    required this.description,
    required this.type,
    required this.currency,
    required this.recipientName,
    required this.recipientPhone,
  });

  // Méthode fromJson pour convertir des données JSON en une instance TransferModel
  static Future<TransferModel> fromJson(Map<String, dynamic> data) async {
    return TransferModel(
      id: data['id'] as int,
      senderId: data['sender_id'] as int,
      recipientId: data['recipient_id'] as int,
      amount: (data['amount'] as num).toDouble(),
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
      name: data['name'] as String,
      status: data['status'] as String,
      description: data['description'] as String,
      type: data['type'] as String,
      currency: data['currency'] as String,
      recipientName: data['recipient_name'] as String,
      recipientPhone: data['recipient_phone'] as String,
    );
  }
}


// // lib/data/models/transfer_model.dart

// class TransferModel {
//   final int id;
//   final int senderId;
//   final int recipientId;
//   final double amount;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String name;
//   final String status;
//   final String description;
//   final String type;
//   final String currency;
//   final String recipientName;

//   TransferModel({
//     required this.id,
//     required this.senderId,
//     required this.recipientId,
//     required this.amount,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.name,
//     required this.status,
//     required this.description,
//     required this.type,
//     required this.currency,
//     required this.recipientName,
//   });

//   factory TransferModel.fromJson(Map<String, dynamic> json) {
//     return TransferModel(
//       id: json['id'],
//       senderId: json['sender_id'],
//       recipientId: json['recipient_id'],
//       amount: json['amount'].toDouble(),
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       name: json['name'],
//       status: json['status'],
//       description: json['description'],
//       type: json['type'],
//       currency: json['currency'],
//       recipientName: json['recipient_name'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'sender_id': senderId,
//       'recipient_id': recipientId,
//       'amount': amount,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//       'name': name,
//       'status': status,
//       'description': description,
//       'type': type,
//       'currency': currency,
//       'recipient_name': recipientName,
//     };
//   }
// }

// // Optional: Extension for string parsing, not strictly necessary here.
// extension DateTimeParsing on String {
//   String toIso8601String() {
//     return DateTime.parse(this).toUtc().toIso8601String();
//   }
// }
// lib/data/models/transfer_model.dart
class TransferModel {
  final String id;
  final String senderId;
  final String recipientId;
  final double amount;
  final String status;
  final DateTime createdAt;

  TransferModel({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'],
      senderId: json['sender_id'],
      recipientId: json['recipient_id'],
      amount: double.parse(json['amount'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'recipient_id': recipientId,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
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
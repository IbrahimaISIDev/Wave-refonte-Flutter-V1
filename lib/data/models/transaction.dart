// Définition du type de transaction
enum TransactionType {
  sent,
  received, transfer,
}

// Définition du statut de transaction
enum TransactionStatus {
  completed,
  pending,
}

// Classe Transaction
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

  static fromJson(t) {}
}

// lib/data/models/transaction.dart
// import 'package:equatable/equatable.dart';

// enum TransactionType { send, receive }

// class Transaction extends Equatable {
//   final String id;
//   final double amount;
//   final TransactionType type;
//   final DateTime date;
//   final String recipient;

//   const Transaction({
//     required this.id,
//     required this.amount,
//     required this.type,
//     required this.date,
//     required this.recipient,
//   });

//   @override
//   List<Object> get props => [id, amount, type, date, recipient];
// }
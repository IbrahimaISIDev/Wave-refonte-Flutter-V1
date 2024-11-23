// lib/models/transaction.dart
import 'package:equatable/equatable.dart';

enum TransactionType {
  sent,
  received,
  transfer,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
  cancelled
}

class Transaction extends Equatable {
  final int id;
  final TransactionType type;
  final String typeLibelle;
  final String typeOperation;
  final double montant;
  final DateTime date;
  final TransactionStatus status;
  final bool isExpediteur;
  final TransactionParty autreParte;
  final DateTime? cancelledAt;
  final String? cancelReason;

  const Transaction({
    required this.id,
    required this.type,
    required this.typeLibelle,
    required this.typeOperation,
    required this.montant,
    required this.date,
    required this.status,
    required this.isExpediteur,
    required this.autreParte,
    this.cancelledAt,
    this.cancelReason,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: _getTransactionType(json['type_operation']),
      typeLibelle: json['type']['libelle'],
      typeOperation: json['type_operation'],
      montant: json['montant'].toDouble(),
      date: DateTime.parse(json['date']),
      status: _getTransactionStatus(json['status']),
      isExpediteur: json['is_expediteur'],
      autreParte: TransactionParty.fromJson(json['autre_partie']),
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at']) : null,
      cancelReason: json['cancel_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': {
        'libelle': typeLibelle,
      },
      'type_operation': typeOperation,
      'montant': montant,
      'date': date.toIso8601String(),
      'status': _statusToString(status),
      'is_expediteur': isExpediteur,
      'autre_partie': autreParte.toJson(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancel_reason': cancelReason,
    };
  }

  static TransactionType _getTransactionType(String typeOperation) {
    switch (typeOperation.toLowerCase()) {
      case 'envoi':
        return TransactionType.sent;
      case 'reception':
        return TransactionType.received;
      default:
        return TransactionType.transfer;
    }
  }

  static TransactionStatus _getTransactionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return TransactionStatus.completed;
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
  }

  static String _statusToString(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'completed';
      case TransactionStatus.pending:
        return 'pending';
      case TransactionStatus.failed:
        return 'failed';
      case TransactionStatus.cancelled:
        return 'cancelled';
    }
  }

  @override
  List<Object?> get props => [
        id,
        type,
        typeLibelle,
        typeOperation,
        montant,
        date,
        status,
        isExpediteur,
        autreParte,
        cancelledAt,
        cancelReason,
      ];
}

class TransactionParty extends Equatable {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;

  const TransactionParty({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
  });

  factory TransactionParty.fromJson(Map<String, dynamic> json) {
    return TransactionParty(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
    };
  }

  @override
  List<Object> get props => [id, nom, prenom, telephone];
}
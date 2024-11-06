// Définition du type de transaction
enum TransactionType {
  sent,
  received,
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
}
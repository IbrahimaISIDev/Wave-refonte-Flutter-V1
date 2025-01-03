// lib/presentation/screens/home/widgets/lists/transaction_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave_app/data/models/transaction.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
  );

  TransactionItem({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Créer une chaîne pour le nom complet du destinataire
    String recipientName = '${transaction.autreParte.prenom} ${transaction.autreParte.nom}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: HomeScreenStyles.defaultSpacing),
      decoration: HomeScreenStyles.transactionItemDecoration,
      child: ListTile(
        leading: Icon(
          transaction.type == TransactionType.sent
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: transaction.type == TransactionType.sent
              ? HomeScreenStyles.sentColor
              : HomeScreenStyles.receivedColor,
        ),
        title: Text(
          recipientName, // Utiliser le nom complet créé
          style: HomeScreenStyles.transactionTitleStyle,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: HomeScreenStyles.transactionSubtitleStyle,
        ),
        trailing: Text(
          currencyFormat.format(transaction.montant), // Utiliser montant au lieu de amount
          style: HomeScreenStyles.getTransactionAmountStyle(
              transaction.isExpediteur), // Utiliser isExpediteur comme booléen
        ),
      ),
    );
  }
}
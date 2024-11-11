import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Card(
            elevation: 8, // Ombre plus marquée pour un effet de profondeur
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Coins arrondis
            ),
            color: Colors.blue.shade50, // Fond léger et moderne
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre "Solde disponible" avec une couleur subtile
                  const Text(
                    'Solde disponible',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 12), // Espacement plus large entre les éléments
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Montant du solde avec une taille de police importante
                      Text(
                        '${state.user.balance.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 30, // Plus grand pour attirer l'attention
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent, // Contraste avec le fond
                        ),
                      ),
                      // Icône stylisée avec une légère animation ou survol
                      Icon(
                        Icons.account_balance_wallet,
                        size: 28,
                        color: Colors.blue.shade800, // Icône colorée et moderne
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Espacement inférieur
                  // Ajout d'un effet visuel supplémentaire, comme une ligne de séparation
                  Divider(
                    color: Colors.blue.shade200,
                    thickness: 1.5,
                  ),
                  const SizedBox(height: 8),
                  // Optionnel : Vous pouvez ajouter une petite note sous le solde
                  const Text(
                    'Assurez-vous que votre solde soit suffisant pour effectuer la transaction.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}


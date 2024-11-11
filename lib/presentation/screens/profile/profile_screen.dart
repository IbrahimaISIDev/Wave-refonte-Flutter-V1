import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_event.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/data/models/user_model.dart';
import 'package:wave_app/presentation/screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Mon Profil',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // Redirection vers la page de connexion après déconnexion
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen(phone: '',)),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return _buildProfileDetails(context, state.user);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user.photo != null ? NetworkImage(user.photo!) : null,
            backgroundColor: Colors.blue,
            child: user.photo == null
                ? Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Informations Personnelles',
            [
              _buildInfoRow(Icons.person, 'Nom', user.nom),
              _buildInfoRow(Icons.phone, 'Téléphone', user.telephone),
              _buildInfoRow(Icons.email, 'Email', user.email),
              _buildInfoRow(Icons.location_on, 'Adresse', user.adresse ?? 'Non renseigné'),
              _buildInfoRow(Icons.cake, 'Date de naissance', user.dateNaissance ?? 'Non renseigné'),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoCard(
            'Solde & Promotions',
            [
              _buildInfoRow(Icons.account_balance_wallet, 'Solde', '${user.solde} FCFA'),
              _buildInfoRow(Icons.local_offer, 'Promo', '${user.promo} %'),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Déconnexion',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}




          // _buildInfoCard(
          //   'Carte de Fidélité',
          //   [
          //     _buildInfoRow(Icons.credit_card, 'Numéro de carte', user.carte ?? 'Non renseigné'),
          //     _buildInfoRow(
          //         Icons.check_circle,
          //         'Statut de la carte',
          //         user.etatcarte ? 'Active' : 'Inactive',
          //     ),
          //   ],
          // ),
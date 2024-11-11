// ignore: file_names
import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/auth/register_screen.dart';

// ignore: unused_element
class _RegisterScreenState extends State<RegisterScreen> {
  // Liste des rôles disponibles
  final List<Map<String, String>> roles = [
    {'id': '1', 'name': 'admin', 'description': 'Administrateur'},
    {'id': '2', 'name': 'user', 'description': 'Utilisateur standard'},
    {'id': '3', 'name': 'merchant', 'description': 'Marchand'},
  ];
  
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Autres champs
                const SizedBox(height: 20),
      
                // Champ de sélection du rôle
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Sélectionner un rôle',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.supervisor_account, color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: Theme.of(context).primaryColor.withOpacity(0.8),
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  value: _selectedRole,
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role['id'],
                      child: Text(role['description']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Veuillez sélectionner un rôle' : null,
                ),
                
                const SizedBox(height: 20),
                // Reste du formulaire
              ],
            ),
          ),
        ),
      ),
    );
  }
}

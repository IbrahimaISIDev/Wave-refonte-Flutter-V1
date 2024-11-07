import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: Colors.grey[600]), // Nouvelle couleur de texte
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey), // Nouvelle couleur de hint
        prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor), // Nouvelle couleur d'icône
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[100], // Nouveau fond
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.8)), // Nouvelle bordure
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey[300]!), // Nouvelle bordure inactive
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).primaryColor), // Nouvelle bordure active
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
      ),
      validator: validator,
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white, // Fond blanc
              Colors.grey[100]!, // Fond gris clair
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // En-tête avec logo et retour
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, 
                          color: Theme.of(context).primaryColor), // Nouvelle couleur de l'icône
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Logo
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/samaxaalis.jpeg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Titre
                  Text(
                    'Ravi de vous revoir !',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600], // Nouvelle couleur de texte
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Formulaire
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Champ téléphone
                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Numéro de téléphone',
                          prefixIcon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre numéro de téléphone';
                            }
                            if (!RegExp(r'^\d{9,}$').hasMatch(value)) {
                              return 'Numéro de téléphone invalide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Champ mot de passe
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Mot de passe',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).primaryColor, // Nouvelle couleur d'icône
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            return null;
                          },
                        ),
                        
                        // Mot de passe oublié
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigation vers la page de récupération
                            },
                            child: Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor, // Nouvelle couleur du lien
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Bouton de connexion
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor, // Nouvelle couleur de fond
                              foregroundColor: Colors.white, // Nouvelle couleur de texte
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                              shadowColor: Colors.black.withOpacity(0.1), // Nouvelle couleur d'ombre
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Se connecter',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
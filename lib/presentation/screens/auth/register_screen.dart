import 'package:flutter/material.dart';
import 'dart:io'; // Pour la manipulation des fichiers
import 'package:image_picker/image_picker.dart'; // Pour sélectionner des images
import 'package:provider/provider.dart';
import 'package:wave_app/data/models/user_model.dart';
import 'package:wave_app/providers/auth_provider.dart';
import 'package:wave_app/utils/validators.dart';
import 'package:path_provider/path_provider.dart'; // Pour gérer les chemins de fichiers
import 'package:path/path.dart' as path; // Pour les opérations sur les chemins

class RegisterScreen extends StatefulWidget {
  const RegisterScreen(
      {super.key,
      required String name,
      required String phone,
      required String email});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _secretCodeController = TextEditingController();
  final _confirmSecretCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdateController = TextEditingController();

  File? _profileImage; // Stocke l'image de profil sélectionnée
  final _picker = ImagePicker(); // Instance d'ImagePicker pour sélectionner des images
  DateTime? _selectedDate;
  String _selectedGender = 'Non spécifié';

  bool _isLoading = false;
  bool _acceptTerms = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000, // Limite la largeur maximale
        maxHeight: 1000, // Limite la hauteur maximale
        imageQuality: 85, // Définit la qualité de l'image (85%)
      );

      if (pickedFile != null) {
        // Création du dossier temporaire
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        File imageFile = File(pickedFile.path);

        // Génération d'un nom unique pour l'image
        String uniqueFileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';

        // Copie de l'image dans le dossier temporaire
        final File localImage =
            await imageFile.copy('$tempPath/$uniqueFileName');

        setState(() {
          _profileImage = localImage;
        });
      }
    } catch (e) {
      // Gestion des erreurs
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Erreur lors de la sélection de l\'image: ${e.toString()}')));
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 ans
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format de date en français avec padding pour les jours et mois
        final year = picked.year.toString();
        final month = picked.month.toString().padLeft(2, '0');
        final day = picked.day.toString().padLeft(2, '0');
        _birthdateController.text = '$year-$month-$day';
      });
    }
  }

  // void _showImageSourceDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
  //         title: const Text('Choisir une photo de profil',
  //             style: TextStyle(color: Colors.white)),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.camera_alt, color: Colors.white),
  //               title: const Text('Prendre une photo',
  //                   style: TextStyle(color: Colors.white)),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _pickImage(ImageSource.camera);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.photo_library, color: Colors.white),
  //               title: const Text('Choisir depuis la galerie',
  //                   style: TextStyle(color: Colors.white)),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _pickImage(ImageSource.gallery);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showImageSourceDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // ... Configuration du dialogue
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Option Camera
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            // Option Galerie
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      );
    },
  );
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
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Créer un compte',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Rejoignez Wave pour des transferts d\'argent simples et sécurisés',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Photo de profil
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? const Icon(Icons.person,
                                  size: 60, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              onPressed: _showImageSourceDialog,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'Nom',
                          prefixIcon: Icons.person_outline,
                          validator: FormValidators.validateName,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _surnameController,
                          hintText: 'Prénom',
                          prefixIcon: Icons.person_outline,
                          validator: FormValidators.validateSurname,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _birthdateController,
                          hintText: 'Date de naissance',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: _selectDate,
                          validator: FormValidators.validateBirthdate,
                        ),
                        const SizedBox(height: 20),

                        // Sélection du genre
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedGender,
                              dropdownColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                              style: const TextStyle(color: Colors.white),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                              items: ['Non spécifié', 'Homme', 'Femme']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedGender = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _addressController,
                          hintText: 'Adresse',
                          prefixIcon: Icons.location_on_outlined,
                          validator: FormValidators.validateAddress,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Numéro de téléphone',
                          prefixIcon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                          validator: FormValidators.validatePhone,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: FormValidators.validateEmail,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              fillColor: WidgetStateProperty.resolveWith(
                                (states) => Colors.white,
                              ),
                              checkColor: Theme.of(context).primaryColor,
                            ),
                            Expanded(
                              child: Text(
                                'J\'accepte les conditions d\'utilisation et la politique de confidentialité',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: (!_acceptTerms || _isLoading)
                                ? null
                                : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Créer un compte',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Déjà un compte ? ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(prefixIcon, color: Colors.white70),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        errorStyle: const TextStyle(color: Colors.white),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
      ),
      validator: validator,
    );
  }

// Mise à jour de la fonction _handleRegister()
  void _handleRegister() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      setState(() => _isLoading = true);

      try {
        // Convertir le genre sélectionné au format attendu
        String sexe = _selectedGender == 'Homme' ? 'homme' : 'femme';

        // Formater la date au format attendu par le backend (si nécessaire)
        String formattedDate = _birthdateController.text;

        // Vérifier si l'image est valide (format image)
        // if (_profileImage != null) {
        //   final mimeType = lookupMimeType(_profileImage!.path);
        //   if (mimeType == null || !mimeType.startsWith('image/')) {
        //     // Afficher une erreur si ce n'est pas une image valide
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content:
        //             Text('Le fichier sélectionné n\'est pas une image valide.'),
        //         backgroundColor: Colors.red,
        //       ),
        //     );
        //     setState(() => _isLoading = false);
        //     return;
        //   }
        // }
        if (_profileImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez sélectionner une photo de profil'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final user = UserModel.forRegistration(
          nom: _nameController.text.trim(),
          prenom: _surnameController.text.trim(),
          telephone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          adresse: _addressController.text.trim(),
          dateNaissance: formattedDate,
          sexe: sexe,
          photo: _profileImage?.path, // Ajouter le chemin de l'image
        );
        // Suppression de l'image temporaire après l'inscription réussie
        //await _profileImage!.delete();

        // Envoi de l'image avec la requête d'inscription
        final success = await Provider.of<AuthProvider>(context, listen: false)
            .register(user, _profileImage);

        if (success && mounted) {
          Navigator.pushNamed(
            context,
            '/otp-verification',
            arguments: _phoneController.text,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'inscription: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _secretCodeController.dispose();
    _confirmSecretCodeController.dispose();
    super.dispose();
  }
}

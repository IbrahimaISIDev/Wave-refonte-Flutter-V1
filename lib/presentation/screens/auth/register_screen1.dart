// import 'package:flutter/material.dart';
// import 'package:wave_app/utils/validators.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen(
//       {super.key,
//       required String name,
//       required String phone,
//       required String email});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _surnameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _secretCodeController = TextEditingController();
//   final _confirmSecretCodeController = TextEditingController();
//   final _addressController = TextEditingController();

//   DateTime? _selectedDate;
//   String _selectedGender = 'Non spécifié';

//   bool _isLoading = false;
//   bool _acceptTerms = false;

//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate:
//           DateTime.now().subtract(const Duration(days: 6570)), // 18 ans
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       locale: const Locale('fr', 'FR'),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Theme.of(context).primaryColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//             dialogBackgroundColor: Colors.white,
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Theme.of(context).primaryColor,
//               Theme.of(context).primaryColor.withOpacity(0.8),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const SizedBox(height: 20),

//                   Text(
//                     'Créer un compte',
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 10),

//                   Text(
//                     'Rejoignez Wave pour des transferts d\'argent simples et sécurisés',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         _buildTextField(
//                           controller: _nameController,
//                           hintText: 'Nom',
//                           prefixIcon: Icons.person_outline,
//                           validator: FormValidators.validateName,
//                         ),
//                         const SizedBox(height: 20),

//                         _buildTextField(
//                           controller: _surnameController,
//                           hintText: 'Prénom',
//                           prefixIcon: Icons.person_outline,
//                           validator: FormValidators.validateSurname,
//                         ),
//                         const SizedBox(height: 20),
//                         // Sélection du genre
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 24, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<String>(
//                               isExpanded: true,
//                               value: _selectedGender,
//                               dropdownColor: Theme.of(context)
//                                   .primaryColor
//                                   .withOpacity(0.8),
//                               style: const TextStyle(color: Colors.white),
//                               icon: const Icon(Icons.arrow_drop_down,
//                                   color: Colors.white),
//                               items: ['Non spécifié', 'Homme', 'Femme']
//                                   .map((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(value),
//                                 );
//                               }).toList(),
//                               onChanged: (newValue) {
//                                 setState(() {
//                                   _selectedGender = newValue!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         _buildTextField(
//                           controller: _addressController,
//                           hintText: 'Adresse',
//                           prefixIcon: Icons.location_on_outlined,
//                           validator: FormValidators.validateAddress,
//                         ),
//                         const SizedBox(height: 20),

//                         _buildTextField(
//                           controller: _phoneController,
//                           hintText: 'Numéro de téléphone',
//                           prefixIcon: Icons.phone_android,
//                           keyboardType: TextInputType.phone,
//                           validator: FormValidators.validatePhone,
//                         ),
//                         const SizedBox(height: 20),

//                         _buildTextField(
//                           controller: _emailController,
//                           hintText: 'Email',
//                           prefixIcon: Icons.email_outlined,
//                           keyboardType: TextInputType.emailAddress,
//                           validator: FormValidators.validateEmail,
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: _acceptTerms,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _acceptTerms = value ?? false;
//                                 });
//                               },
//                               fillColor: WidgetStateProperty.resolveWith(
//                                 (states) => Colors.white,
//                               ),
//                               checkColor: Theme.of(context).primaryColor,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 'J\'accepte les conditions d\'utilisation et la politique de confidentialité',
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.9),
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 30),

//                         SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             onPressed: (!_acceptTerms || _isLoading)
//                                 ? null
//                                 : _handleRegister,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               foregroundColor: Theme.of(context).primaryColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: _isLoading
//                                 ? SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                   )
//                                 : const Text(
//                                     'Créer un compte',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Déjà un compte ? ',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontSize: 16,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pushReplacementNamed(
//                                     context, '/login');
//                               },
//                               child: const Text(
//                                 'Se connecter',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData prefixIcon,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     bool readOnly = false,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//     VoidCallback? onTap,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       readOnly: readOnly,
//       onTap: onTap,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
//         prefixIcon: Icon(prefixIcon, color: Colors.white70),
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.1),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: const BorderSide(color: Colors.white, width: 1),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide(color: Colors.red.shade300, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide(color: Colors.red.shade300, width: 1),
//         ),
//         errorStyle: const TextStyle(color: Colors.white),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 24,
//           vertical: 20,
//         ),
//       ),
//       validator: validator,
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _secretCodeController.dispose();
//     _confirmSecretCodeController.dispose();
//     super.dispose();
//   }
// }

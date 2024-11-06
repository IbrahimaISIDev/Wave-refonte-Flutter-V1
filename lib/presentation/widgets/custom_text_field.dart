import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;  // Added validator parameter


  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,  // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }
}

// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final TextInputType keyboardType;
//   final IconData prefixIcon;
//   final String? Function(String?)? validator;  // Added validator parameter

//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.label,
//     required this.keyboardType,
//     required this.prefixIcon,
//     this.validator,  // Added to constructor
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,  // Use the validator
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(prefixIcon),
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
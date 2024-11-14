import 'package:flutter/material.dart';

class LoginScreenStyles {
  // Style du container principal
  static BoxDecoration mainContainerDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white,
        Colors.grey[100]!,
      ],
    ),
  );

  // Style du texte de titre
  static TextStyle getTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ) ?? const TextStyle();
  }

  // Style des champs de texte
  static InputDecoration getInputDecoration({
    required BuildContext context,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
    );
  }

  // Style du bouton de connexion
  static ButtonStyle getLoginButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 2,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
    );
  }

  // Style du texte des liens
  static TextStyle getLinkTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w500,
    );
  }

  // Style du texte des champs
  static TextStyle getTextFieldStyle() {
    return TextStyle(color: Colors.grey[600]);
  }

  // Dimensions communes
  static const double defaultPadding = 24.0;
  static const double buttonHeight = 55.0;
  static const double logoSize = 100.0;
  static const double borderRadius = 30.0;
}
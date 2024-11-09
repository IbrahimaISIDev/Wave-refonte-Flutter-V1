class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    final phoneRegex = RegExp(r'^\d{9,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  static String? validateSecretCode(String? value) {
    // Ici, on vérifie que le code secret a une longueur minimale de 5 chiffres
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un code secret';
    }
    final secretCodeRegex =
        RegExp(r'^\d{5}$'); // Code secret composé de 5 chiffres
    if (!secretCodeRegex.hasMatch(value)) {
      return 'Le code secret doit être composé de 5 chiffres';
    }
    return null;
  }

  static String? Function(String?) validateConfirmSecretCode(
      String secretCode) {
    return (String? value) {
      if (value != secretCode) {
        return 'Les codes secrets ne correspondent pas';
      }
      return null;
    };
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre nom';
    }
    return null;
  }

  static String? validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre prénom';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre adresse';
    }
    return null;
  }

  static String? validateBirthdate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre date de naissance';
    }
    return null;
  }
}

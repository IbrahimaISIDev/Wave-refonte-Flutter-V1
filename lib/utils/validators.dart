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
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre code secret';
    }
    if (value.length != 4) {
      return 'Le code secret doit contenir 4 chiffres';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Le code secret doit contenir uniquement des chiffres';
    }
    return null;
  }

  static String? validateConfirmSecretCode(String? value, String originalCode) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre code secret';
    }
    if (value != originalCode) {
      return 'Les codes ne correspondent pas';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre nom';
    }
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
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


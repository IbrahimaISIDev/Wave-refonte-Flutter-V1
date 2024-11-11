import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wave_app/data/models/user_model.dart';
import 'package:wave_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final ServiceAuth _authService;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _userData;
  String? _verificationPhone;

  AuthProvider({ServiceAuth? authService})
      : _authService = authService ?? ServiceAuth();

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get userData => _userData;

  // Fonction d'inscription
  Future<bool> inscription({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String adresse,
    required String dateNaissance,
    required String sexe,
    String? photo,
  }) async {
    _setLoading(true);
    _setError(null);

    print(
        'Tentative d\'inscription avec : nom=$nom, prenom=$prenom, telephone=$telephone');

    try {
      final response = await _authService.inscription(
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        email: email,
        adresse: adresse,
        dateNaissance: dateNaissance,
        sexe: sexe,
        photo: photo,
      );

      _userData = response;
      _verificationPhone = telephone;
      print('Inscription réussie');
      return true;
    } catch (e) {
      _setError(e.toString());
      print('Erreur d\'inscription : $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Vérification OTP
  Future<bool> verifyOtp({required String code}) async {
    if (_verificationPhone == null) {
      _setError('Numéro de téléphone non disponible');
      print('Erreur : Numéro de téléphone non disponible');
      return false;
    }

    _setLoading(true);
    _setError(null);

    print(
        'Vérification OTP pour le téléphone $_verificationPhone avec le code $code');

    try {
      final response = await _authService.verifyOtp(
        phone: _verificationPhone!,
        code: code,
      );

      _userData?.addAll(response);
      print('OTP vérifié avec succès');
      return true;
    } catch (e) {
      _setError(e.toString());
      print('Erreur de vérification OTP : $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Configuration du code secret
  Future<bool> setupSecretCode(String secretCode) async {
    if (_verificationPhone == null) {
      _setError('Numéro de téléphone non disponible');
      print('Erreur : Numéro de téléphone non disponible');
      return false;
    }

    _setLoading(true);
    _setError(null);

    print('Configuration du code secret pour le téléphone $_verificationPhone');

    try {
      final response = await _authService.setupSecretCode(
        phone: _verificationPhone!,
        secretCode: secretCode,
      );

      _userData?.addAll(response);
      print('Code secret configuré avec succès');
      return true;
    } catch (e) {
      _setError(e.toString());
      print('Erreur de configuration du code secret : $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Renvoi OTP
  Future<bool> resendOtp() async {
    if (_verificationPhone == null) {
      _setError('Numéro de téléphone non disponible');
      print('Erreur : Numéro de téléphone non disponible');
      return false;
    }

    _setLoading(true);
    _setError(null);

    print('Renvoi du code OTP pour le téléphone $_verificationPhone');

    try {
      await _authService.resendOtp(phone: _verificationPhone!);
      print('Code OTP renvoyé avec succès');
      return true;
    } catch (e) {
      _setError(e.toString());
      print('Erreur lors du renvoi du code OTP : $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Méthodes utilitaires pour gérer les états de chargement et d'erreur
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Fonction pour inscrire un utilisateur avec une image de profil (non implémentée ici)
  // Update the register method to return a bool indicating success
// Mise à jour de la fonction register()
  Future<bool> register(UserModel user, File? profileImage) async {
    _setLoading(true);
    _setError(null);

    try {
      // Gérer le chemin de l'image de profil
      String? photoPath = profileImage?.path;

      final response = await _authService.inscription(
        nom: user.nom,
        prenom: user.prenom,
        telephone: user.telephone,
        email: user.email,
        adresse: user.adresse,
        dateNaissance: user.dateNaissance,
        sexe: user.sexe,
        photo: photoPath,
      );

      _userData = response;
      _verificationPhone = user.telephone;

      print('Registration successful');
      return true;
    } catch (e) {
      _setError(e.toString());
      print('Registration failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}

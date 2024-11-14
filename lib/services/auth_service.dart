import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAuth {
  static const String urlBase = 'http://192.168.6.82:3000/api';
  //static const String urlBase = 'https://flutter-laravel-wave-app.onrender.com/api';

  final http.Client client;

  static var instance;

  ServiceAuth({http.Client? client}) : client = client ?? http.Client();

  // Fonction d'inscription
Future<Map<String, dynamic>> inscription({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String adresse,
    required String dateNaissance,
    required String sexe,
    String? photo,
  }) async {
    print('Envoi de la requête d\'inscription');
    try {
      final Map<String, dynamic> body = {
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'email': email,
        'adresse': adresse,
        'date_naissance': dateNaissance,
        'sexe': sexe.toLowerCase(),
        'roleId': 2,
        'solde': 0,
        'promo': 0,
        'etatcarte': true,
        'secret': '2024', // Ajout de la valeur par défaut pour le secret
        if (photo != null) 'photo': photo,
      };

      print('Données envoyées : $body'); // Pour debug

      final response = await client.post(
        Uri.parse('$urlBase/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['access_token'] != null) {
          await _saveAuthToken(responseData['access_token']);
        }
        print('Inscription réussie');
        return responseData;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      print('Erreur d\'inscription : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Vérification OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    print('Vérification OTP pour $phone');
    try {
      final response = await client.post(
        Uri.parse('$urlBase/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telephone': phone,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        print('OTP vérifié');
        return jsonDecode(response.body);
      } else {
        throw Exception('Code OTP invalide');
      }
    } catch (e) {
      print('Erreur de vérification OTP : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Configuration du code secret
  Future<Map<String, dynamic>> setupSecretCode({
    required String phone,
    required String secretCode,
  }) async {
    print('Configuration du code secret pour $phone');
    try {
      final response = await client.post(
        Uri.parse('$urlBase/set-secret-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telephone': phone,
          'code_secret': secretCode,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _saveAuthToken(data['token']);
        }
        print('Code secret configuré');
        return data;
      } else {
        throw Exception('Erreur lors de la configuration du code secret');
      }
    } catch (e) {
      print('Erreur de configuration du code secret : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Renvoi OTP
  Future<void> resendOtp({required String phone}) async {
    print('Demande de renvoi du code OTP pour $phone');
    try {
      final response = await client.post(
        Uri.parse('$urlBase/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'telephone': phone}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de l\'envoi du nouveau code');
      }
      print('Code OTP renvoyé');
    } catch (e) {
      print('Erreur lors du renvoi du code OTP : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Sauvegarde du token d'authentification
  Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token d\'authentification sauvegardé');
  }
}

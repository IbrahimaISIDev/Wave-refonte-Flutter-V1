import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAuth {
  static const String urlBase = 'https://flutter-laravel-wave-app.onrender.com/api';
  final http.Client client;

  ServiceAuth({http.Client? client}) : client = client ?? http.Client();

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
        'secret': '2024',
        if (photo != null) 'photo': photo,
      };

      print('Données envoyées : $body');

      final response = await client.post(
        Uri.parse('$urlBase/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Si le statut est 200 ou 201, on considère que l'inscription est réussie
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // Essayer de décoder la réponse JSON
          final responseData = jsonDecode(response.body);
          print('Réponse serveur JSON : $responseData');
          return {
            'success': true,
            'telephone': telephone,
            'message': 'Inscription réussie',
            ...responseData
          };
        } catch (e) {
          // Si le décodage JSON échoue mais que le statut est 200/201,
          // on retourne quand même un succès avec les informations minimales
          print('Réponse non-JSON reçue mais inscription probablement réussie');
          return {
            'success': true,
            'telephone': telephone,
            'message': 'Inscription réussie'
          };
        }
      } else {
        final responseData = _tryDecodeResponse(response);
        throw Exception(responseData['message'] ?? 
            'Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      print('Erreur d\'inscription : $e');
      throw Exception('Une erreur est survenue : $e');
    }
  }

  // Nouvelle méthode utilitaire pour essayer de décoder la réponse
  Map<String, dynamic> _tryDecodeResponse(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Erreur de format de réponse'};
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'telephone': phone,
          'code': code,
        }),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('Erreur de vérification OTP : $e');
      rethrow;
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'telephone': phone,
          'code_secret': secretCode,
        }),
      );

      final responseData = await _handleResponse(response);
      if (responseData['token'] != null) {
        await _saveAuthToken(responseData['token']);
      }
      return responseData;
    } catch (e) {
      print('Erreur de configuration du code secret : $e');
      rethrow;
    }
  }

  // Renvoi OTP
  Future<Map<String, dynamic>> resendOtp({required String phone}) async {
    print('Demande de renvoi du code OTP pour $phone');
    try {
      final response = await client.post(
        Uri.parse('$urlBase/resend-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'telephone': phone}),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('Erreur lors du renvoi du code OTP : $e');
      rethrow;
    }
  }

  // Fonction utilitaire pour gérer les réponses HTTP
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    String? contentType = response.headers['content-type'];
    if (contentType?.toLowerCase().contains('text/html') ?? false) {
      throw Exception(
          'Le serveur a renvoyé une page HTML au lieu de JSON. Statut: ${response.statusCode}');
    }

    try {
      final responseData = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ??
            'Erreur du serveur (${response.statusCode})');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception(
            'Réponse invalide du serveur: ${response.body.substring(0, 100)}...');
      }
      throw Exception('Erreur lors du traitement de la réponse: $e');
    }
  }

  // Sauvegarde du token d'authentification
  Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token d\'authentification sauvegardé');
  }
}

/* import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAuth {
  static const String urlBase = 'https://flutter-laravel-wave-app.onrender.com/api';
  final http.Client client;

  ServiceAuth({http.Client? client}) : client = client ?? http.Client();

// Fonction d'inscription
  Future<void> inscription({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String adresse,
    required String dateNaissance,
    required String sexe,
    String? photo,
  }) async {
    print('Envoi de la requête d\'inscription...');
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
        'secret': '2024',
        if (photo != null) 'photo': photo,
      };

      print('Données envoyées : $body');

      final response = await client.post(
        Uri.parse('$urlBase/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Réponse serveur : $responseData');
        return responseData;
      } else {
        final contentType = response.headers['content-type'];
        if (contentType?.contains('text/html') ?? false) {
          throw Exception('Le serveur a renvoyé une page HTML : ${response.body.substring(0, 100)}');
        }
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      print('Erreur d\'inscription : $e');
      throw Exception('Une erreur est survenue : $e');
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'telephone': phone,
          'code': code,
        }),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('Erreur de vérification OTP : $e');
      rethrow;
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'telephone': phone,
          'code_secret': secretCode,
        }),
      );

      final responseData = await _handleResponse(response);
      if (responseData['token'] != null) {
        await _saveAuthToken(responseData['token']);
      }
      return responseData;
    } catch (e) {
      print('Erreur de configuration du code secret : $e');
      rethrow;
    }
  }

  // Renvoi OTP
  Future<Map<String, dynamic>> resendOtp({required String phone}) async {
    print('Demande de renvoi du code OTP pour $phone');
    try {
      final response = await client.post(
        Uri.parse('$urlBase/resend-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'telephone': phone}),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('Erreur lors du renvoi du code OTP : $e');
      rethrow;
    }
  }

  // Fonction utilitaire pour gérer les réponses HTTP
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    String? contentType = response.headers['content-type'];
    if (contentType?.toLowerCase().contains('text/html') ?? false) {
      throw Exception('Le serveur a renvoyé une page HTML au lieu de JSON. Statut: ${response.statusCode}');
    }

    try {
      final responseData = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Erreur du serveur (${response.statusCode})');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Réponse invalide du serveur: ${response.body.substring(0, 100)}...');
      }
      throw Exception('Erreur lors du traitement de la réponse: $e');
    }
  }

  // Sauvegarde du token d'authentification
  Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token d\'authentification sauvegardé');
  }
} */
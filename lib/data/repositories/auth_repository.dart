import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_app/data/models/user_model.dart';

class AuthRepository {
  final Dio _dio;
  static const String _tokenKey = 'auth_token';
  static const String _baseUrl = 'http://192.168.6.82:3000/api';

  AuthRepository()
      : _dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: const Duration(seconds: 5), // Délai de connexion
            receiveTimeout: const Duration(seconds: 20),  // Augmenter à 20 secondes

            contentType: 'application/json',
            headers: {
              'Accept': 'application/json',
            },
            validateStatus: (status) =>
                true, // Accepter tous les status pour mieux gérer les erreurs
          ),
        );

  // Initialiser le token s'il existe déjà
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<UserModel> login({required String phone, required String code}) async {
  try {
    // Debug: Afficher les informations de la requête
    print('=== Début de la requête de connexion ===');
    print('URL: $_baseUrl/login');
    print('Données envoyées: { telephone: $phone, code: $code }');
    print('Headers: ${_dio.options.headers}');

    // Vérifier d'abord si le serveur est accessible
    try {
      await _dio.get('/health-check');
    } catch (e) {
      print('Erreur de connexion au serveur: $e');
      throw 'Le serveur n\'est pas accessible. Vérifiez l\'URL ou votre connexion internet.';
    }

    // Effectuer la requête de login
    final response = await _dio.post(
      '$_baseUrl/login',
      data: {
        'telephone': phone,
        'code': code,
      },
    );

    // Debug: Afficher la réponse
    print('Status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response data: ${response.data}');

    // Vérification du status code
    if (response.statusCode == null) {
      throw 'Pas de réponse du serveur';
    }

    switch (response.statusCode) {
      case 200:
        try {
          if (response.data == null) {
            throw 'Réponse vide du serveur';
          }

          final data = response.data as Map<String, dynamic>;

          // Vérification des champs requis
          if (!data.containsKey('access_token')) {
            print('Structure de la réponse: $data');
            throw 'Token manquant dans la réponse';
          }

          if (!data.containsKey('user')) {
            print('Structure de la réponse: $data');
            throw 'Données utilisateur manquantes dans la réponse';
          }

          final token = data['access_token'] as String? ?? '';  // Assurer que token n'est pas null
          final userData = data['user'] as Map<String, dynamic>;

          // Sauvegarde du token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);

          // Mise à jour des headers
          _dio.options.headers['Authorization'] = 'Bearer $token';

          return UserModel.fromJson(userData);
        } catch (e) {
          print('Erreur lors du traitement de la réponse: $e');
          throw 'Erreur lors du traitement de la réponse: $e';
        }

      case 400:
        throw response.data?['message'] ?? 'Données invalides';
      case 401:
        throw response.data?['message'] ?? 'Identifiants incorrects';
      case 403:
        throw response.data?['message'] ?? 'Accès refusé';
      case 404:
        throw 'Service non trouvé. URL incorrecte?';
      case 500:
        throw 'Erreur serveur interne';
      default:
        throw 'Erreur ${response.statusCode}: ${response.data?['message'] ?? 'Erreur inconnue'}';
    }
  } on DioException catch (e) {
    print('=== Erreur Dio détectée ===');
    print('Type: ${e.type}');
    print('Message: ${e.message}');
    print('Error: ${e.error}');
    print('Response: ${e.response?.data}');

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw 'Délai de connexion dépassé';
      case DioExceptionType.sendTimeout:
        throw 'Délai d\'envoi dépassé';
      case DioExceptionType.receiveTimeout:
        throw 'Délai de réception dépassé';
      case DioExceptionType.badCertificate:
        throw 'Problème de certificat SSL';
      case DioExceptionType.badResponse:
        final response = e.response;
        if (response != null) {
          print('Bad response data: ${response.data}');
          throw response.data?['message'] ?? 'Erreur de réponse du serveur';
        }
        throw 'Réponse invalide du serveur';
      case DioExceptionType.connectionError:
        throw 'Erreur de connexion. Vérifiez votre connexion internet et l\'URL du serveur';
      case DioExceptionType.cancel:
        throw 'Requête annulée';
      default:
        throw 'Erreur réseau: ${e.message ?? 'Erreur inconnue'}';
    }
  } catch (e) {
    print('=== Erreur générale ===');
    print(e.toString());
    throw 'Erreur inattendue: ${e.toString()}';
  } finally {
    print('=== Fin de la requête de connexion ===');
  }
}


Future<void> logout() async {
  try {
    // Envoyer la requête de déconnexion au serveur
    final response = await _dio.post('/logout');
    if (response.statusCode == 200) {
      print('Déconnexion réussie.');
    } else {
      print('Erreur lors de la déconnexion: ${response.data}');
    }
  } catch (e) {
    print('Erreur lors de la déconnexion: $e');
  } finally {
    // Nettoyage des données locales même en cas d'erreur
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _dio.options.headers.remove('Authorization');
  }
}


  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) {
        return null;
      }

      final response = await _dio.get('/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _handleAuthError(String message) {
    // Ajout de plus de cas spécifiques
    switch (message.toLowerCase()) {
      case 'invalid_credentials':
      case 'identifiants invalides':
        return 'Numéro de téléphone ou code secret incorrect';
      case 'user_not_found':
        return 'Aucun utilisateur trouvé avec ce numéro de téléphone';
      case 'invalid_code':
        return 'Code secret invalide';
      case 'account_locked':
      case 'compte temporairement bloqué':
        return 'Compte temporairement bloqué. Veuillez réessayer dans quelques minutes';
      case 'account_disabled':
      case 'compte désactivé':
        return 'Compte désactivé. Veuillez contacter le support';
      case 'invalid_phone':
        return 'Format du numéro de téléphone invalide';
      default:
        // Log l'erreur non gérée pour analyse future
        print('Erreur non gérée: $message');
        return 'Erreur de connexion: $message';
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Erreur de connexion. Veuillez vérifier votre connexion internet';
      case DioExceptionType.badResponse:
        if (e.response != null) {
          return 'Erreur ${e.response!.statusCode}: ${e.response!.data}';
        }
        return 'Erreur de réponse du serveur';
      case DioExceptionType.connectionError:
        return 'Problème de connexion réseau';
      case DioExceptionType.cancel:
        return 'Requête annulée par l\'utilisateur';
      default:
        return 'Erreur inconnue';
    }
  }

  verifyOtp({required String phone, required String otp}) {}

  setSecretCode({required String phone, required String secretCode}) {}

  register(
      {required String name,
      required String phone,
      required String email,
      required String password}) {}
}

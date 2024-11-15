import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_app/data/models/user_model.dart';
import 'package:wave_app/services/dio_service.dart';

class AuthRepository {
  late final Dio _dio;
  static const String _baseUrl = 'http://192.168.1.95:3000/api';
  //static const String _baseUrl = 'https://flutter-laravel-wave-app.onrender.com/api';


  AuthRepository() {
    _dio = DioService.instance.getDio(addAuthHeader: false);
  }

  // Initialiser le token s'il existe déjà
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(DioService.tokenKey);
    if (token != null) {
      await DioService.instance.setAuthToken(token);
    }
  }

  Future<UserModel> login({required String phone, required String code}) async {
    try {
      print('=== Début de la requête de connexion ===');
      print('URL: $_baseUrl/login');
      print('Données envoyées: { telephone: $phone, code: $code }');

      // Vérifier d'abord si le serveur est accessible
      try {
        await _dio.get('/health-check');
      } catch (e) {
        print('Erreur de connexion au serveur: $e');
        throw 'Le serveur n\'est pas accessible. Vérifiez l\'URL ou votre connexion internet.';
      }

      // Effectuer la requête de login
      final response = await _dio.post(
        '/login',
        data: {
          'telephone': phone,
          'code': code,
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response data: ${response.data}');

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

            if (!data.containsKey('access_token')) {
              print('Structure de la réponse: $data');
              throw 'Token manquant dans la réponse';
            }

            if (!data.containsKey('user')) {
              print('Structure de la réponse: $data');
              throw 'Données utilisateur manquantes dans la réponse';
            }

            final token = data['access_token'] as String;
            final userData = data['user'] as Map<String, dynamic>;

            // Sauvegarder le token via DioService
            await DioService.instance.setAuthToken(token);

            return UserModel.fromJson(userData);
          } catch (e) {
            print('Erreur lors du traitement de la réponse: $e');
            throw 'Erreur lors du traitement de la réponse: $e';
          }

        case 400:
          throw _handleAuthError(response.data?['message'] ?? 'Données invalides');
        case 401:
          throw _handleAuthError(response.data?['message'] ?? 'Identifiants incorrects');
        case 403:
          throw _handleAuthError(response.data?['message'] ?? 'Accès refusé');
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

      throw _handleDioError(e);
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
      final response = await _dio.post('/logout');
      if (response.statusCode == 200) {
        print('Déconnexion réussie.');
      } else {
        print('Erreur lors de la déconnexion: ${response.data}');
      }
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    } finally {
      await DioService.instance.clearAuthToken();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      if (DioService.instance.authToken == null) {
        return null;
      }

      final response = await _dio.get('/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur courant: $e');
      return null;
    }
  }

  String _handleAuthError(String message) {
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
        if (e.response?.data?['message'] != null) {
          return _handleAuthError(e.response!.data['message']);
        }
        return 'Erreur de réponse du serveur';
      case DioExceptionType.connectionError:
        return 'Problème de connexion réseau';
      case DioExceptionType.cancel:
        return 'Requête annulée par l\'utilisateur';
      default:
        return 'Erreur inconnue: ${e.message}';
    }
  }

  Future<UserModel> verifyOtp({required String phone, required String otp}) async {
    try {
      final response = await _dio.post(
        '/verify-otp',
        data: {
          'telephone': phone,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw _handleAuthError(response.data?['message'] ?? 'Erreur de vérification OTP');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> setSecretCode({
    required String phone,
    required String secretCode,
  }) async {
    try {
      final response = await _dio.post(
        '/set-secret-code',
        data: {
          'telephone': phone,
          'code_secret': secretCode,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw _handleAuthError(response.data?['message'] ?? 'Erreur de configuration du code secret');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'nom': name,
          'telephone': phone,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        throw _handleAuthError(response.data?['message'] ?? 'Erreur d\'inscription');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
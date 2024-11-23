import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/auth/login_screen.dart';
import 'package:wave_app/presentation/screens/auth/otp-verification.dart';
import 'package:wave_app/presentation/screens/auth/register_screen.dart';
import 'package:wave_app/presentation/screens/auth/secret_code_setup_screen.dart';
import 'package:wave_app/presentation/screens/auth/welcome_screen.dart';
import 'package:wave_app/presentation/screens/distributor_home_screen.dart';
import 'package:wave_app/presentation/screens/home/home_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_screen.dart';
import 'package:wave_app/presentation/screens/transfer/merchant_scanner_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_history_screen.dart';

class AppRoutes {
  // Routes définies par catégorie
  static const String welcome = '/'; // Peut être retirée si "home" est utilisé
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String transfer = '/transfer';
  static const String transferHistory = '/transfer-history';
  static const String merchantScanner = '/merchant';
  static const String otpVerification = '/otp-verification';
  static const String secretCodeSetup = '/secret-code-setup';
  static const String distributor = '/distributor';

  // Routes simples sans arguments
  static Map<String, WidgetBuilder> getSimpleRoutes() {
    return {
      transfer: (context) => const TransferScreen(),
      transferHistory: (context) => const TransferHistoryScreen(),
      merchantScanner: (context) => const MerchantScannerScreen(),
      distributor: (context) => const DistributorHomeScreen(),
    };
  }

  // On génère les routes en fonction des arguments passés
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Authentification
      case login:
        return _buildLoginRoute(settings);

      case register:
        return _buildRegisterRoute(settings);

      case otpVerification:
        return _buildOtpVerificationRoute(settings);

      case secretCodeSetup:
        return _buildSecretCodeSetupRoute(settings);

      // Écran principal
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      // Route par défaut
      default:
        return null;
    }
  }

  // Méthodes de construction des routes avec arguments
  static MaterialPageRoute _buildLoginRoute(RouteSettings settings) {
    final phone = settings.arguments as String?;
    return MaterialPageRoute(
      builder: (context) => LoginScreen(phone: phone ?? ''),
    );
  }

  static MaterialPageRoute _buildRegisterRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>?;
    return MaterialPageRoute(
      builder: (context) => RegisterScreen(
        name: args?['name'] ?? '',
        phone: args?['phone'] ?? '',
        email: args?['email'] ?? '',
      ),
    );
  }

  static MaterialPageRoute _buildOtpVerificationRoute(RouteSettings settings) {
    final phoneNumber = settings.arguments as String?;
    return MaterialPageRoute(
      builder: (context) => OtpVerificationScreen(phoneNumber: phoneNumber ?? ''),
    );
  }

  static MaterialPageRoute _buildSecretCodeSetupRoute(RouteSettings settings) {
    final phone = settings.arguments as String?;
    return MaterialPageRoute(
      builder: (context) => SecretCodeSetupScreen(phone: phone ?? ''),
    );
  }

  // Nouvelle méthode pour récupérer toutes les routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      ...getSimpleRoutes(), // Inclut les routes simples
    };
  }
}

// Extension pour faciliter la navigation
extension NavigatorStateExtension on NavigatorState {
  Future<T?> pushLoginScreen<T extends Object?>({
    required String phone,
  }) {
    return pushNamed<T>(
      AppRoutes.login,
      arguments: phone,
    );
  }

  Future<T?> pushRegisterScreen<T extends Object?>({
    required String name,
    required String phone,
    required String email,
  }) {
    return pushNamed<T>(
      AppRoutes.register,
      arguments: {
        'name': name,
        'phone': phone,
        'email': email,
      },
    );
  }

  Future<T?> pushSecretCodeSetup<T extends Object?>({
    required String phone,
  }) {
    return pushNamed<T>(
      AppRoutes.secretCodeSetup,
      arguments: phone,
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Wave App',
      home: const WelcomeScreen(), // L'écran de bienvenue est défini ici comme 'home'
      routes: AppRoutes.getRoutes(), // Utilisez 'getRoutes' pour toutes les routes
      onGenerateRoute: AppRoutes.onGenerateRoute, // Gestion des routes dynamiques
    ),
  );
}

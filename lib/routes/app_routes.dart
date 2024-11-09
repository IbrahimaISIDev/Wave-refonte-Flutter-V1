import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/auth/login_screen.dart';
import 'package:wave_app/presentation/screens/auth/register_screen.dart';
import 'package:wave_app/presentation/screens/home_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_screen.dart';
import 'package:wave_app/presentation/screens/transfer/merchant_scanner_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_history_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String transfer = '/transfer';
  static const String transferHistory = '/transfer-history';
  static const String merchantScanner = '/merchant';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      transfer: (context) => const TransferScreen(),
      transferHistory: (context) => const TransferHistoryScreen(),
      merchantScanner: (context) => const MerchantScannerScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Vous pouvez ajouter ici une logique pour gérer les routes dynamiques
    // ou les routes avec des paramètres
   if (settings.name == login) {
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    } else if (settings.name == register) {
      return MaterialPageRoute(builder: (context) => const RegisterScreen());
    } else if (settings.name == home) {
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    } else if (settings.name == transfer) {
      return MaterialPageRoute(builder: (context) => const TransferScreen());
    } else if (settings.name == transferHistory) {
      return MaterialPageRoute(builder: (context) => const TransferHistoryScreen());
    } else if (settings.name == merchantScanner) {
      return MaterialPageRoute(builder: (context) => const MerchantScannerScreen());
    }
    return null;
  }
}

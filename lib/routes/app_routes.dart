import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/auth/login_screen.dart';
import 'package:wave_app/presentation/screens/auth/register_screen.dart';
import 'package:wave_app/presentation/screens/auth/otp-verification.dart';
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
  static const String otpVerification =
      '/otp-verification'; // Correct variable name

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      transfer: (context) => const TransferScreen(),
      transferHistory: (context) => const TransferHistoryScreen(),
      merchantScanner: (context) => const MerchantScannerScreen(),
      otpVerification: (context) => OtpVerificationScreen(
            phoneNumber: ModalRoute.of(context)!.settings.arguments as String,
          ),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case transfer:
        return MaterialPageRoute(builder: (context) => const TransferScreen());
      case transferHistory:
        return MaterialPageRoute(
            builder: (context) => const TransferHistoryScreen());
      case merchantScanner:
        return MaterialPageRoute(
            builder: (context) => const MerchantScannerScreen());
      case otpVerification:
        final phoneNumber = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: phoneNumber),
        );
      default:
        return null;
    }
  }
}

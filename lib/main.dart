import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/data/repositories/auth_repository.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'package:wave_app/presentation/screens/auth/welcome_screen.dart';
import 'package:wave_app/presentation/screens/auth/login_screen.dart';
import 'package:wave_app/presentation/screens/auth/register_screen.dart';
import 'package:wave_app/presentation/screens/home_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => TransferRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<TransferBloc>(
            create: (context) => TransferBloc(
              context.read<TransferRepository>(),
              context.read<AuthBloc>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Wave App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
              primary: Colors.deepPurple,
              secondary: Colors.purpleAccent.shade200,
              surface: Colors.white,
              background: Colors.grey[100]!,
              error: Colors.red.shade400,
            ),
            useMaterial3: true,
            
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              headlineLarge: TextStyle(
                color: Colors.deepPurple.shade900,
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
              headlineMedium: TextStyle(
                color: Colors.deepPurple.shade800,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 16,
              ),
              bodyMedium: TextStyle(color: Colors.grey.shade700),
              bodySmall: TextStyle(color: Colors.grey.shade600),
            ),
            
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white.withOpacity(0.85),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.deepPurple.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
            
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple.shade900,
                backgroundColor: Colors.purpleAccent.shade100,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            
            iconTheme: IconThemeData(
              color: Colors.deepPurple.shade700,
            ),
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const HomeScreen();
              }
              return const WelcomeScreen();
            },
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/transfer': (context) => const TransferScreen(),
            '/transfer-history': (context) => const TransferHistoryScreen(),
          },
        ),
      ),
    );
  }
}
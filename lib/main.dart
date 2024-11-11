import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; // Ajoutez le package provider
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/bloc/transaction/transaction_event.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transaction/transaction_bloc.dart';
import 'package:wave_app/data/repositories/auth_repository.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'package:wave_app/data/repositories/transaction_repository.dart';
import 'package:wave_app/presentation/screens/auth/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wave_app/presentation/screens/home_screen.dart';
import 'package:wave_app/routes/app_routes.dart';
import 'package:wave_app/providers/auth_provider.dart'; // Importer votre provider

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider pour AuthProvider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Fournisseurs de dépôt
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => TransferRepository(),
        ),
        RepositoryProvider(
          create: (context) => TransactionRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Fournisseurs de blocs
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
          BlocProvider<TransactionBloc>(
            create: (context) => TransactionBloc(
              context.read<TransactionRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr', 'FR'),
          ],
          locale: const Locale('fr', 'FR'),
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
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.deepPurple,
              headerForegroundColor: Colors.white,
              surfaceTintColor: Colors.deepPurple.shade50,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.deepPurple;
                }
                return null;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.deepPurple.shade900;
              }),
              yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.deepPurple;
                }
                return null;
              }),
              yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.deepPurple.shade900;
              }),
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
                borderSide:
                    BorderSide(color: Colors.deepPurple.shade300, width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple.shade900,
                backgroundColor: Colors.purpleAccent.shade100,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                return BlocProvider.value(
                  value: context.read<TransactionBloc>()..add(LoadTransactions()),
                  child: const HomeScreen(),
                );
              }
              return const WelcomeScreen();
            },
          ),
          routes: AppRoutes.getRoutes(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      ),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:wave_app/bloc/auth/auth_bloc.dart';
// import 'package:wave_app/bloc/auth/auth_state.dart';
// import 'package:wave_app/bloc/transaction/transaction_event.dart';
// import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
// import 'package:wave_app/bloc/transaction/transaction_bloc.dart';
// import 'package:wave_app/config/theme/app_theme.dart';
// import 'package:wave_app/data/repositories/auth_repository.dart';
// import 'package:wave_app/data/repositories/transfer_repository.dart'
//     as transfer_repo;
// import 'package:wave_app/data/repositories/transaction_repository.dart'
//     as transaction_repo;
// import 'package:wave_app/presentation/screens/auth/welcome_screen.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:wave_app/presentation/screens/home_screen.dart';
// import 'package:wave_app/routes/app_routes.dart';
// import 'package:wave_app/providers/auth_provider.dart';
// import 'package:wave_app/services/dio_service.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DioService.instance.init();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         RepositoryProvider(
//           create: (context) => AuthRepository(),
//         ),
//         RepositoryProvider(
//           create: (context) => transfer_repo.TransferRepository(),
//         ),
//         RepositoryProvider(
//           create: (context) => transaction_repo.TransactionRepository(),
//         ),
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<AuthBloc>(
//             create: (context) => AuthBloc(
//               authRepository: context.read<AuthRepository>(),
//             ),
//           ),
//           BlocProvider<TransferBloc>(
//             create: (context) => TransferBloc(
//               context.read<transfer_repo.TransferRepository>(),
//               context.read<AuthBloc>(),
//             ),
//           ),
//           BlocProvider<TransactionBloc>(
//             create: (context) => TransactionBloc(
//               context.read<transaction_repo.TransactionRepository>(),
//             ),
//           ),
//         ],
//         child: MaterialApp(
//           localizationsDelegates: const [
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//           supportedLocales: const [
//             Locale('fr', 'FR'),
//           ],
//           locale: const Locale('fr', 'FR'),
//           title: 'Wave App',
//           debugShowCheckedModeBanner: false,
//           theme: AppTheme.getThemeData(),
//           home: BlocBuilder<AuthBloc, AuthState>(
//             builder: (context, state) {
//               if (state is AuthSuccess) {
//                 return BlocProvider.value(
//                   value: context.read<TransactionBloc>()
//                     ..add(LoadTransactions()),
//                   child: const HomeScreen(),
//                 );
//               }
//               return const WelcomeScreen();
//             },
//           ),
//           routes: AppRoutes.getRoutes(),
//           onGenerateRoute: AppRoutes.onGenerateRoute,
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/bloc/transaction/transaction_event.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transaction/transaction_bloc.dart';
import 'package:wave_app/config/theme/app_theme.dart';
import 'package:wave_app/data/repositories/auth_repository.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'package:wave_app/data/repositories/transaction_repository.dart';
import 'package:wave_app/presentation/screens/auth/welcome_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wave_app/presentation/screens/home_screen.dart';
import 'package:wave_app/routes/app_routes.dart';
import 'package:wave_app/providers/auth_provider.dart';
import 'package:wave_app/services/dio_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider(create: (_) => DioService.instance),
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => TransferRepository()),
        RepositoryProvider(create: (_) => TransactionRepository()),
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
          BlocProvider<TransactionBloc>(
            create: (context) => TransactionBloc(
              context.read<TransactionRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      theme: AppTheme.getThemeData(),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
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
    );
  }
}


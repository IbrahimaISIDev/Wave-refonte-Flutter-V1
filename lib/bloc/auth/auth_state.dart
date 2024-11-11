// lib/bloc/auth/auth_state.dart

import 'package:wave_app/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthOtpVerified extends AuthState {
  final String phone;
  
  AuthOtpVerified(this.phone);
}

class AuthNeedsSecretCode extends AuthState {
  final UserModel user;
  
  AuthNeedsSecretCode(this.user);
}

class AuthError extends AuthState {
  final String message;
  
  AuthError(this.message);
}
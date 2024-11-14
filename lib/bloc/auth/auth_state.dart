// lib/bloc/auth/auth_state.dart

import 'package:wave_app/data/models/user_model.dart';

abstract class AuthState {
  get user => null;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthOtpVerified extends AuthState {
  final String phone;
  
  AuthOtpVerified(this.phone);
}

class AuthNeedsSecretCode extends AuthState {
  @override
  final UserModel user;
  
  AuthNeedsSecretCode(this.user);
}

class AuthError extends AuthState {
  final String message;
  
  AuthError(this.message);
}

class AuthSuccess extends AuthState {
  @override
  final UserModel user;

  AuthSuccess(this.user);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSuccess &&
          runtimeType == other.runtimeType &&
          user == other.user;

  @override
  int get hashCode => user.hashCode;
}

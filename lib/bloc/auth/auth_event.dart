// lib/bloc/auth/auth_event.dart

abstract class AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String phone;
  final String secretCode;

  AuthLoginRequested({
    required this.phone,
    required this.secretCode,
  });
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String email;

  AuthRegisterRequested({
    required this.name,
    required this.phone,
    required this.email,
  });
}

class AuthOtpSubmitted extends AuthEvent {
  final String otp;
  final String phone;

  AuthOtpSubmitted({
    required this.otp,
    required this.phone,
  });
}

class AuthSecretCodeSubmitted extends AuthEvent {
  final String secretCode;
  final String phone;

  AuthSecretCodeSubmitted({
    required this.secretCode,
    required this.phone,
  });
}

class AuthLogoutRequested extends AuthEvent {}
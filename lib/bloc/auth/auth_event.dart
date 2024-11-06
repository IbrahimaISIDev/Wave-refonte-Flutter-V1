// lib/bloc/auth/auth_event.dart
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  LoginEvent(this.phone, this.password);
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;

  RegisterEvent(this.name, this.phone, this.email, this.password);
}

class LogoutEvent extends AuthEvent {}
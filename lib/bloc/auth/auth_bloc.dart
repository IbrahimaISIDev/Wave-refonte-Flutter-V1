import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_event.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckStatus>(_handleCheckStatus);
    on<AuthLoginRequested>(_handleLogin);
    on<AuthRegisterRequested>(_handleRegister);
    on<AuthOtpSubmitted>(_handleOtpSubmission);
    on<AuthSecretCodeSubmitted>(_handleSecretCodeSubmission);
    on<AuthLogoutRequested>(_handleLogout);
  }

  Future<void> _handleCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        if (!user.hasSetSecretCode) {
          emit(AuthNeedsSecretCode(user));  // L'utilisateur doit définir un code secret
        } else {
          emit(AuthAuthenticated(user));  // Utilisateur authentifié
        }
      } else {
        emit(AuthUnauthenticated());  // Utilisateur non authentifié
      }
    } catch (e) {
      emit(AuthError('Erreur lors de la vérification de l\'état de l\'utilisateur: $e'));
    }
  }

  Future<void> _handleLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
        phone: event.phone,
        code: event.secretCode,  // Utilisez secretCode au lieu de code
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Erreur lors de la connexion: $e'));
    }
  }

  Future<void> _handleRegister(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.register(
        name: event.name,
        phone: event.phone,
        email: event.email,
        password: '',  // La gestion du mot de passe sera ajoutée plus tard
      );
      emit(AuthOtpVerified(event.phone));  // L'utilisateur peut maintenant vérifier son OTP
    } catch (e) {
      emit(AuthError('Erreur lors de l\'inscription: $e'));
    }
  }

  Future<void> _handleOtpSubmission(AuthOtpSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.verifyOtp(
        phone: event.phone,
        otp: event.otp,
      );
      emit(AuthNeedsSecretCode(user));  // L'utilisateur doit définir un code secret après avoir vérifié l'OTP
    } catch (e) {
      emit(AuthError('Erreur lors de la soumission de l\'OTP: $e'));
    }
  }

  Future<void> _handleSecretCodeSubmission(AuthSecretCodeSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.setSecretCode(
        phone: event.phone,
        secretCode: event.secretCode,
      );
      emit(AuthAuthenticated(user));  // Utilisateur authentifié après avoir défini le code secret
    } catch (e) {
      emit(AuthError('Erreur lors de la soumission du code secret: $e'));
    }
  }

  Future<void> _handleLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());  // Utilisateur déconnecté
    } catch (e) {
      emit(AuthError('Erreur lors de la déconnexion: $e'));
    }
  }
}

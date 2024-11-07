import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:wave_app/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository}) : 
    _authRepository = authRepository,
    super(AuthInitial()) {
    on<LoginEvent>(_handleLogin);
    on<RegisterEvent>(_handleRegister);
    on<LogoutEvent>(_handleLogout);
  }

  Future<void> _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.phone, event.password);
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _handleRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(
        event.name,
        event.phone,
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
  }
}
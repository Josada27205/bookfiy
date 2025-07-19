import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final AuthRepository authRepository;

  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthUpdateProfileRequested>(_onAuthUpdateProfileRequested);

    // Listen to auth state changes
    _authStateSubscription = authRepository.authStateChanges.listen(
      (user) => add(AuthStateChanged(user)),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signUpUseCase(
      SignUpParams(
        email: event.email,
        password: event.password,
        username: event.username,
        fullName: event.fullName,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signOutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.resetPassword(email: event.email);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthPasswordResetSent()),
    );
  }

  Future<void> _onAuthUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      emit(AuthLoading());

      final result = await authRepository.updateProfile(
        fullName: event.fullName,
        bio: event.bio,
        website: event.website,
        photoUrl: event.photoUrl,
        favoriteGenres: event.favoriteGenres,
      );

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) => emit(AuthAuthenticated(user: user)),
      );
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}

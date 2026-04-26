import 'package:employee_app/domain/usecases/auth/login_usecase.dart';
import 'package:employee_app/domain/usecases/auth/logout_usecase.dart';
import 'package:employee_app/domain/usecases/auth/verify_usecase.dart';
import 'package:employee_app/features/auth/bloc/auth_event.dart';
import 'package:employee_app/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final VerifyUseCase verifyUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc(this.loginUseCase, this.verifyUseCase, this.logoutUseCase) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final msg = await loginUseCase(event.email);
        emit(LoginSuccess(msg));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await verifyUseCase(event.token);
        emit(VerifySuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await logoutUseCase();
        emit(AuthLogout());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
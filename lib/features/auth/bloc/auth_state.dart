abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class LoginSuccess extends AuthState {
  final String message;
  LoginSuccess(this.message);
}
class VerifySuccess extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class AuthLogout extends AuthState {}
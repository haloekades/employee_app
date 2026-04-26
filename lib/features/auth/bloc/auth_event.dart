abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  LoginEvent(this.email);
}

class VerifyEvent extends AuthEvent {
  final String token;
  VerifyEvent(this.token);
}

class LogoutEvent extends AuthEvent {
  LogoutEvent();
}

import 'package:employee_app/domain/repositories/auth/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repo;
  LogoutUseCase(this.repo);

  Future<void> call() => repo.logout();
}
import 'package:employee_app/domain/repositories/auth/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repo;
  LoginUseCase(this.repo);

  Future<String> call(String email) => repo.login(email);
}
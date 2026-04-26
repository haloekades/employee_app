import 'package:employee_app/domain/repositories/auth/auth_repository.dart';

class VerifyUseCase {
  final AuthRepository repo;
  VerifyUseCase(this.repo);

  Future<String> call(String token) => repo.verify(token);
}
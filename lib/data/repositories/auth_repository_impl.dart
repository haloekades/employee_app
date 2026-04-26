import 'package:employee_app/core/storage/local_storage.dart';
import 'package:employee_app/data/services/auth_services.dart';
import 'package:employee_app/domain/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final LocalStorage storage;

  AuthRepositoryImpl(this.service, this.storage);

  @override
  Future<String> login(String email) {
    return service.login(email);
  }

  @override
  Future<String> verify(String token) async {
    final session = await service.verify(token);
    await storage.saveToken(session);
    return session;
  }

  @override
  Future<void> logout() async {
    await storage.clearToken();
  }
}
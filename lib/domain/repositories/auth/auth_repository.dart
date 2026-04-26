abstract class AuthRepository {
  Future<String> login(String email);
  Future<String> verify(String token);
  Future<void> logout();
}
import 'package:dio/dio.dart';
import 'package:employee_app/core/constans/api_constants.dart';
import 'package:employee_app/core/network/api_client.dart';

class AuthService {
  final ApiClient api;

  AuthService(this.api);


  Future<String> login(String email) async {
    final res = await api.post(
      "/app-users/login",
      data: {
        "email": email,
        "project_slug": ApiConstants.projectSlug,
        "project_id": ApiConstants.projectId,
      },
    );

    return res.data["data"]["message"];
  }

  Future<String> verify(String token) async {
    final res = await api.post(
      "/app-users/verify",
      data: {"token": token},
    );

    return res.data["data"]["session_token"];
  }
}
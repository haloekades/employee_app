import 'package:dio/dio.dart';
import 'package:employee_app/core/constans/api_constants.dart';

import '../di/injection.dart';
import '../storage/local_storage.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers.addAll(ApiConstants.defaultHeaders);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sl<LocalStorage>().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return dio.put(path, data: data);
  }

  Future<Response> get(String path) {
    return dio.get(path);
  }

  Future<Response> delete(String path) {
    return dio.delete(path);
  }

  void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }
}
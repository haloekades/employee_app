import 'package:employee_app/data/repositories/employee_repository_impl.dart';
import 'package:employee_app/domain/repositories/auth/auth_repository.dart';
import 'package:employee_app/domain/repositories/employee/employee_repository.dart';
import 'package:employee_app/domain/usecases/auth/logout_usecase.dart';
import 'package:employee_app/domain/usecases/employee/add_employee_usecase.dart';
import 'package:employee_app/domain/usecases/employee/delete_employee_usecase.dart';
import 'package:employee_app/domain/usecases/employee/get_employee_usecase.dart';
import 'package:employee_app/domain/usecases/employee/update_employee_usecase.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/auth_services.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../../data/services/employee_service.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/verify_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  final dio = Dio();
  sl.registerLazySingleton(() => dio);

  // core
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => LocalStorage(sl()));

  // services
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerLazySingleton(() => EmployeeService(sl()));

  // repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(sl()),
  );

  // use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => VerifyUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => AddEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEmployeeUseCase(sl()));

  sl.registerFactory(() => EmployeeFormBloc(sl(), sl()));
}

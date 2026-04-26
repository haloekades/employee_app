import 'package:employee_app/features/employee/list/bloc/employee_bloc.dart';
import 'package:employee_app/features/employee/list/screens/employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart' as di;
import 'core/storage/local_storage.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/screens/login_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF16499c);

    final token = di.sl<LocalStorage>().getToken();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            di.sl(),
            di.sl(),
            di.sl()
          ),
        ),
        BlocProvider(
          create: (_) => EmployeeBloc(
            di.sl(),
            di.sl(),
            di.sl()
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        ),

        home: (token != null && token.isNotEmpty)
            ? const EmployeeScreen()
            : const LoginScreen(),
      ),
    );
  }
}
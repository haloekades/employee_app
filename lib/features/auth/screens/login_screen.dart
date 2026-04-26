import 'package:employee_app/core/constans/app_colors.dart';
import 'package:employee_app/features/auth/bloc/auth_bloc.dart';
import 'package:employee_app/features/auth/bloc/auth_event.dart';
import 'package:employee_app/features/auth/bloc/auth_state.dart';
import 'package:employee_app/features/employee/list/screens/employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool showCodeField = false;

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final email = emailController.text.trim();
    final code = codeController.text.trim();

    if (!showCodeField) {
      if (email.isEmpty) {
        _showToast("Email is required");
        return;
      }

      context.read<AuthBloc>().add(LoginEvent(email));
    } else {
      if (code.isEmpty) {
        _showToast("Verification code is required");
        return;
      }

      context.read<AuthBloc>().add(VerifyEvent(code));
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            _showToast(state.message);

            setState(() {
              showCodeField = true;
            });
          }

          if (state is VerifySuccess) {
            _showToast("Login success");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const EmployeeScreen()),
            );
          }

          if (state is AuthError) {
            _showToast(state.message);
          }
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Employee App",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 40),

                      TextField(
                        controller: emailController,
                        enabled: !showCodeField,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (showCodeField)
                        TextField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Verification Code",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading ? null : _onSubmit,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  showCodeField ? "Verify" : "Login",
                                  style: const TextStyle(fontSize: 16, color: AppColors.white),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (showCodeField)
                        const Text(
                          "Enter the verification code sent to your email",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

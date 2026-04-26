import 'package:employee_app/core/constans/app_colors.dart';
import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/features/auth/bloc/auth_bloc.dart';
import 'package:employee_app/features/auth/bloc/auth_event.dart';
import 'package:employee_app/features/auth/bloc/auth_state.dart';
import 'package:employee_app/features/auth/screens/login_screen.dart';
import 'package:employee_app/features/employee/list/screens/employee_detail.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_bloc.dart';
import 'package:employee_app/features/employee/form/screens/employee_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {

  final TextEditingController searchController = TextEditingController();

  List<Employee> allEmployees = [];
  List<Employee> filteredEmployees = [];

  @override
  void initState() {
    super.initState();

    context.read<EmployeeBloc>().add(FetchEmployees());

    searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredEmployees = allEmployees.where((e) {
        return e.name.toLowerCase().contains(query) ||
            e.phone.toLowerCase().contains(query);
      }).toList();
    });
  }

  String _getInitial(String name) {
    final parts = name.split(" ");
    if (parts.length == 1) return parts[0][0];

    return parts.take(2).map((e) => e[0]).join();
  }

  void _onLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm == true) {
      context.read<AuthBloc>().add(LogoutEvent());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogout) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("Employees", style: TextStyle(color: AppColors.white)),
          actions: [
            IconButton(icon: const Icon(Icons.logout, color: AppColors.white), onPressed: _onLogout),
          ],
        ),

        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmployeeLoaded) {
              allEmployees = state.employees;

              final query = searchController.text.toLowerCase();

              if (query.isEmpty) {
                filteredEmployees = allEmployees;
              } else {
                filteredEmployees = allEmployees.where((e) {
                  return e.name.toLowerCase().contains(query) ||
                      e.phone.toLowerCase().contains(query);
                }).toList();
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search name or phone",
                        prefixIcon: const Icon(Icons.search, color: AppColors.darkGrey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<EmployeeBloc>().add(FetchEmployees());
                      },
                      child: filteredEmployees.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  query.isEmpty?
                                  "Employee is empty, please click add button to add new employee" :
                                  "$query not found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredEmployees.length,
                              itemBuilder: (context, index) {
                                final e = filteredEmployees[index];
                                return _buildItem(e);
                              },
                            ),
                    ),
                  ),
                ],
              );
            }

            if (state is EmployeeError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () async {
            final employeeBloc = context.read<EmployeeBloc>();

            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => sl<EmployeeFormBloc>(),
                  child: const EmployeeFormScreen(),
                ),
              ),
            );

            if (updated != null) {
              employeeBloc.add(FetchEmployees());
            }
          },
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildItem(Employee e) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EmployeeDetailScreen(employee: e)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                _getInitial(e.name),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(e.phone, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            IconButton(
              icon: Icon(
                Icons.star,
                color: e.isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: () {
                final updated = Employee(
                  id: e.id,
                  name: e.name,
                  phone: e.phone,
                  email: e.email,
                  job: e.job,
                  isFavorite: !e.isFavorite,
                );

                context.read<EmployeeBloc>().add(
                  UpdateEmployee(updated, true),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

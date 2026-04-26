import 'package:employee_app/core/constans/app_colors.dart';
import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_bloc.dart';
import 'package:employee_app/features/employee/form/screens/employee_form_screen.dart';
import 'package:employee_app/features/employee/list/bloc/employee_bloc.dart';
import 'package:employee_app/features/employee/list/bloc/employee_event.dart';
import 'package:employee_app/features/employee/list/bloc/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {

  String _getInitial(String name) {
    final parts = name.split(" ");
    if (parts.length == 1) return parts[0][0];
    return parts.take(2).map((e) => e[0]).join();
  }

  void _onDelete(Employee employee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete"),
        content: Text("Are you sure want to delete ${employee.name}?"),
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
      context.read<EmployeeBloc>().add(DeleteEmployee(employee));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          Employee currentEmployee =  widget.employee;

          if (state is EmployeeLoaded) {
            final found = state.employees.firstWhere(
                  (e) => e.id == currentEmployee.id,
              orElse: () => currentEmployee,
            );

            currentEmployee = found;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text("Employee Detail", style: TextStyle(color: AppColors.white)),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: currentEmployee.isFavorite
                        ? Colors.amber
                        : Colors.white,
                  ),
                  onPressed: () {
                    final updated = currentEmployee.copyWith(
                      isFavorite: !currentEmployee.isFavorite,
                    );

                    context.read<EmployeeBloc>().add(
                      UpdateEmployee(updated, true),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit,
                    color: Colors.white,),
                  onPressed: () async {
                    final employeeBloc = context.read<EmployeeBloc>();

                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => sl<EmployeeFormBloc>(),
                          child: EmployeeFormScreen(employee: currentEmployee),
                        ),
                      ),
                    );

                    if (updated != null) {
                      employeeBloc.add(UpdateEmployee(updated, false));
                    }
                  },
                ),

                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _onDelete(currentEmployee);
                  },
                ),
              ],
            ),

            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    color: AppColors.primary,
                    child: Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          _getInitial(currentEmployee.name),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildCard(
                    icon: Icons.person,
                    label: "Name",
                    value: currentEmployee.name,
                  ),
                  _buildCard(
                    icon: Icons.phone,
                    label: "Phone",
                    value: currentEmployee.phone,
                  ),
                  _buildCard(
                    icon: Icons.email,
                    label: "Email",
                    value: currentEmployee.email,
                  ),
                  _buildCard(
                    icon: Icons.work,
                    label: "Job",
                    value: currentEmployee.job,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
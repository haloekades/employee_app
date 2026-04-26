import 'package:employee_app/core/constans/app_colors.dart';
import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_bloc.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_event.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormScreen({super.key, this.employee});

  @override
  State<EmployeeFormScreen> createState() =>
      _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final emailC = TextEditingController();
  final jobC = TextEditingController();

  bool isFavorite = false;

  bool get isEdit => widget.employee != null;

  @override
  void initState() {
    super.initState();

    final e = widget.employee;

    if (e != null) {
      nameC.text = e.name;
      phoneC.text = e.phone;
      emailC.text = e.email;
      jobC.text = e.job;
      isFavorite = e.isFavorite;
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    phoneC.dispose();
    emailC.dispose();
    jobC.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final employee = Employee(
      id: isEdit ? widget.employee!.id : "",
      name: nameC.text,
      phone: phoneC.text,
      email: emailC.text,
      job: jobC.text,
      isFavorite: isFavorite,
    );

    context
        .read<EmployeeFormBloc>()
        .add(SubmitEmployeeEvent(employee));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(isEdit ? "Edit Employee" : "Add Employee", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: BlocListener<EmployeeFormBloc, EmployeeFormState>(
        listener: (context, state) {
          if (state is EmployeeFormSuccess) {
            Navigator.pop(context, state.employee);
          }

          if (state is EmployeeFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _input(nameC, "Name"),
                _input(phoneC, "Phone"),
                _input(emailC, "Email"),
                _input(jobC, "Job"),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text("Favorite"),
                    Switch(
                      value: isFavorite,
                      onChanged: (v) => setState(() {
                        isFavorite = v;
                      }),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                BlocBuilder<EmployeeFormBloc, EmployeeFormState>(
                  builder: (context, state) {
                    if (state is EmployeeFormLoading) {
                      return const CircularProgressIndicator();
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(
                          isEdit ? "Update" : "Save",
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: c,
        validator: (v) =>
        v == null || v.isEmpty ? "$hint required" : null,
        decoration: InputDecoration(
          labelText: hint,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
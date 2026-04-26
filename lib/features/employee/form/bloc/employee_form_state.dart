import '../../../../data/models/employee_model.dart';

abstract class EmployeeFormState {}

class EmployeeFormInitial extends EmployeeFormState {}

class EmployeeFormLoading extends EmployeeFormState {}

class EmployeeFormSuccess extends EmployeeFormState {
  final Employee employee;

  EmployeeFormSuccess(this.employee);
}

class EmployeeFormError extends EmployeeFormState {
  final String message;

  EmployeeFormError(this.message);
}
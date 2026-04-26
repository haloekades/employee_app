import 'package:employee_app/data/models/employee_model.dart';

abstract class EmployeeEvent {}

class FetchEmployees extends EmployeeEvent {
  FetchEmployees();
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;
  final bool isNeedCallApi;

  UpdateEmployee(this.employee, this.isNeedCallApi);
}

class DeleteEmployee extends EmployeeEvent {
  final Employee employee;

  DeleteEmployee(this.employee);
}
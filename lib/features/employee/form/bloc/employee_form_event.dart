import '../../../../data/models/employee_model.dart';

abstract class EmployeeFormEvent {}

class SubmitEmployeeEvent extends EmployeeFormEvent {
  final Employee employee;

  SubmitEmployeeEvent(this.employee);
}
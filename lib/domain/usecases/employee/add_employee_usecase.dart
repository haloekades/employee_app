import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/domain/repositories/employee/employee_repository.dart';

class AddEmployeeUseCase {
  final EmployeeRepository repo;
  AddEmployeeUseCase(this.repo);

  Future<Employee> call(Employee employee) => repo.addEmployee(employee);
}
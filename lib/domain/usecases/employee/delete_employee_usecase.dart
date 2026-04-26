import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/domain/repositories/employee/employee_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeeRepository repo;
  DeleteEmployeeUseCase(this.repo);

  Future<void> call(Employee employee) => repo.deleteEmployee(employee);
}
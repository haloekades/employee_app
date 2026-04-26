import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/domain/repositories/employee/employee_repository.dart';

class GetEmployeeUseCase {
  final EmployeeRepository repo;
  GetEmployeeUseCase(this.repo);

  Future<List<Employee>> call() => repo.getEmployeeList();
}
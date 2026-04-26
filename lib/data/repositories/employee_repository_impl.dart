import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/data/services/employee_service.dart';
import 'package:employee_app/domain/repositories/employee/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeService service;

  EmployeeRepositoryImpl(this.service);

  @override
  Future<List<Employee>> getEmployeeList() async {
    final result = await service.getEmployees();
    return result;
  }

  @override
  Future<Employee> addEmployee(Employee employee) async {
    final result = await service.addEmployee(employee);
    return result;
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    final result = await service.updateEmployee(employee);
    return result;
  }

  @override
  Future<void> deleteEmployee(Employee employee) async {
    await service.deleteEmployee(employee);
  }
}
import 'package:employee_app/data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployeeList();
  Future<Employee> addEmployee(Employee employee);
  Future<Employee> updateEmployee(Employee employee);
  Future<void> deleteEmployee(Employee employee);
}
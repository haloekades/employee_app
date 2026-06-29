import 'package:employee_app/data/models/employee_model.dart';

abstract class LocalDatabaseService {
  Future<List<Employee>> getAllEmployees();
  Future<Employee> saveEmployee(Employee employee);
  Future<void> removeEmployee(String id);
}
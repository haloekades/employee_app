import 'package:employee_app/data/local/local_database_service.dart';
import 'package:employee_app/data/models/employee_model.dart';
import 'package:employee_app/data/services/employee_service.dart';
import 'package:employee_app/domain/repositories/employee/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeService service;
  final LocalDatabaseService localDatabaseService;

  EmployeeRepositoryImpl(this.service, this.localDatabaseService);

  @override
  Future<List<Employee>> getEmployeeList() async {
    final result = await service.getEmployees();
    return result;
  }

  @override
  Future<List<Employee>> getEmployeeListFromApiAndLocal() async {
    final resultApi = await service.getEmployees();
    final resultLocal = await localDatabaseService.getAllEmployees();
    final Map<String, Employee> mergedEmployees = {};
    for (var employee in resultLocal) {
      mergedEmployees[employee.id] = employee;
    }
    for (var employee in resultApi) {
      mergedEmployees[employee.id] = employee;
    }
    return mergedEmployees.values.toList();
  }

  @override
  Future<Employee> addEmployee(Employee employee) async {
    /* -- use it if will update data from api */
    // final result = await service.addEmployee(employee);

    final result = await localDatabaseService.saveEmployee(employee);
    return result;
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    /* -- use it if will update data from api */
    // final result = await service.updateEmployee(employee);

    final result = await localDatabaseService.saveEmployee(employee);
    return result;
  }

  @override
  Future<void> deleteEmployee(Employee employee) async {
    /* -- use it if will update data from api */
    // await service.deleteEmployee(employee);
    
    await localDatabaseService.removeEmployee(employee.id);
  }
}
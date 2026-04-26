import 'package:employee_app/core/constans/api_constants.dart';
import 'package:employee_app/core/network/api_client.dart';
import 'package:employee_app/data/models/employee_model.dart';

class EmployeeService {
  final ApiClient api;

  EmployeeService(this.api);

  Future<List<Employee>> getEmployees() async {
    final res = await api.get(
      "/collections/employee/records?project_id=${ApiConstants.projectId}",
    );

    return (res.data["data"] as List)
        .map((e) => Employee.fromJson(e))
        .toList();
  }

  Future<Employee> updateEmployee(Employee employee) async {
    final res = await api.put(
      "/collections/employee/records/${employee.id}?project_id=${ApiConstants.projectId}",
      data: employee.toJson(),
    );

    return Employee.fromJson(res.data["data"]);
  }

  Future<Employee> addEmployee(Employee employee) async {
    final res = await api.post(
      "/collections/employee/records?project_id=${ApiConstants.projectId}",
      data:  employee.toJson(),
    );

    return Employee.fromJson(res.data["data"]);
  }

  Future<void> deleteEmployee(Employee employee) async {
    await api.delete(
      "/collections/employee/records/${employee.id}?project_id=${ApiConstants.projectId}"
    );
  }
}
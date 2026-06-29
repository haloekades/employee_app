import 'package:employee_app/data/local/local_database_service.dart';
import 'package:employee_app/data/models/employee_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabaseService implements LocalDatabaseService {
  static const String _boxName = 'employee_box';

  @override
  Future<List<Employee>> getAllEmployees() async {
    final box = await Hive.openBox(_boxName);

    return box.values.map((dynamic item) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(item as Map);
      return Employee.fromMap(map);
    }).toList();
  }

  @override
  Future<Employee> saveEmployee(Employee employee) async {
    final box = await Hive.openBox(_boxName);

    await box.put(employee.id, employee.toMap());
    return employee;
  }

  @override
  Future<void> removeEmployee(String id) async {
    final box = await Hive.openBox(_boxName);

    await box.delete(id);
  }
}
import 'package:employee_app/domain/usecases/employee/delete_employee_usecase.dart';
import 'package:employee_app/domain/usecases/employee/get_employee_usecase.dart';
import 'package:employee_app/domain/usecases/employee/update_employee_usecase.dart';
import 'package:employee_app/features/employee/list/bloc/employee_event.dart';
import 'package:employee_app/features/employee/list/bloc/employee_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployeeUseCase getEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployee;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;

  EmployeeBloc(this.getEmployeeUseCase, this.updateEmployee, this.deleteEmployeeUseCase)
    : super(EmployeeInitial()) {
    on<FetchEmployees>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final data = await getEmployeeUseCase();
        emit(EmployeeLoaded(data));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      if (state is EmployeeLoaded) {
        final current = (state as EmployeeLoaded).employees;
        final updatedList = current.map((e) {
          return e.id == event.employee.id ? event.employee : e;
        }).toList();
        emit(EmployeeLoaded(updatedList));

        if (event.isNeedCallApi) {
          try {
            await updateEmployee(event.employee);
          } catch (e) {
            emit(EmployeeLoaded(current));
            emit(EmployeeError(e.toString()));
          }
        }
      }
    });

    on<DeleteEmployee>((event, emit) async {
      if (state is EmployeeLoaded) {
        await deleteEmployeeUseCase(event.employee);
        final currentList = (state as EmployeeLoaded).employees;
        currentList.removeWhere((e) => e.id == event.employee.id);
        emit(EmployeeLoaded(currentList));
      }
    });
  }
}

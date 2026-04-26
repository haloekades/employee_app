import 'package:employee_app/domain/usecases/employee/add_employee_usecase.dart';
import 'package:employee_app/domain/usecases/employee/update_employee_usecase.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_event.dart';
import 'package:employee_app/features/employee/form/bloc/employee_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeFormBloc
    extends Bloc<EmployeeFormEvent, EmployeeFormState> {
  final AddEmployeeUseCase addUseCase;
  final UpdateEmployeeUseCase updateUseCase;

  EmployeeFormBloc(this.addUseCase, this.updateUseCase)
      : super(EmployeeFormInitial()) {
    on<SubmitEmployeeEvent>((event, emit) async {
      emit(EmployeeFormLoading());

      try {
        final employee = event.employee;

        final result = employee.id.isEmpty
            ? await addUseCase(employee)
            : await updateUseCase(employee);

        emit(EmployeeFormSuccess(result));
      } catch (e) {
        emit(EmployeeFormError(e.toString()));
      }
    });
  }
}
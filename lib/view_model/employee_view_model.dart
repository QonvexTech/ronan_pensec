import 'package:ronan_pensec/global/templates/employee_template.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';

class EmployeeViewModel{
  final EmployeeTemplate template = EmployeeTemplate.instance;
  final EmployeeDataControl employeeDataControl = EmployeeDataControl.instance;
  late final EmployeeService _service = EmployeeService.instance(employeeDataControl);
  EmployeeService get service => _service;
  bool _isTable = true;
  bool get isTable => _isTable;
  set setTable(bool b) => _isTable = b;
}
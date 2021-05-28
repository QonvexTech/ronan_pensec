import 'package:ronan_pensec_web/global/template/employee_template.dart';
import 'package:ronan_pensec_web/models/pagination_model.dart';
import 'package:ronan_pensec_web/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec_web/services/data_controls/employee_data_control.dart';

class EmployeeViewModel{
  EmployeeViewModel._privateConstructor();
  static final EmployeeViewModel _instance = EmployeeViewModel._privateConstructor();
  late PaginationModel paginationModel;
  static EmployeeViewModel get instance{
    return _instance;
  }

  final EmployeeTemplate template = EmployeeTemplate.instance;
  static final EmployeeDataControl _employeeDataControl = EmployeeDataControl.instance;
  EmployeeDataControl get employeeDataControl => _employeeDataControl;
  final EmployeeService _service= EmployeeService.instance(_employeeDataControl);
  EmployeeService get service => _service;
  bool _isTable = true;
  bool get isTable => _isTable;
  set setTable(bool b) => _isTable = b;

}



import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';

class EmployeeAttendanceViewModel {
  EmployeeAttendanceViewModel._singleton();
  static final EmployeeAttendanceViewModel _instance = EmployeeAttendanceViewModel._singleton();
  static final EmployeeDataControl _control = EmployeeDataControl.instance;
  static final EmployeeService _service = EmployeeService.instance(_control);
  EmployeeService get service => _service;


  static EmployeeAttendanceViewModel get instance => _instance;
  final Auth _auth = Auth.instance;
  Auth get auth => _auth;

  bool _isAdd = true;
  bool get isAdd => _isAdd;
  set setAdd(bool a) => _isAdd = a;


  DateTime? _chosenDate;
  DateTime? get chosenDate => _chosenDate;
  set setDate(DateTime? dd) => _chosenDate = dd;

  bool showComponents = false;

  int type = 0;

  // List<String> dropDownData = [
  //   "Absent", // 0
  //   "En retard" // 1
  // ];

}
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_demand_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';

class EmployeeDemandsViewModel {
  EmployeeDemandsViewModel._singleton();
  static final EmployeeDemandsViewModel _instance = EmployeeDemandsViewModel._singleton();
  static final EmployeeDataControl _employeeDataControl = EmployeeDataControl.instance;
  static final EmployeeService _service = EmployeeService.instance(_employeeDataControl);
  EmployeeService get service => _service;
  static EmployeeDemandsViewModel get instance{
    return _instance;
  }

  /// Instance of List of holidays
  List<HolidayDemandModel>? _holidays;
  List<HolidayDemandModel>? get holidays => _holidays;
  set setHolidays(List<HolidayDemandModel>? update) => _holidays = update;

  /// instance of List of RTT
  List<RTTModel>? _rtts;
  List<RTTModel>? get rtts => _rtts;
  set setRtts(List<RTTModel>? nRtts) => _rtts = nRtts;

  /// Instance of List of Attendance
  List<AttendanceModel>? _attendance;
  List<AttendanceModel>? get attendance => _attendance;
  set setAttendance(List<AttendanceModel>? attendances) => _attendance = attendances;

}
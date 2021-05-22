class EmployeeAttendanceViewModel {
  EmployeeAttendanceViewModel._singleton();
  static final EmployeeAttendanceViewModel _instance = EmployeeAttendanceViewModel._singleton();
  static EmployeeAttendanceViewModel get instance => _instance;


}
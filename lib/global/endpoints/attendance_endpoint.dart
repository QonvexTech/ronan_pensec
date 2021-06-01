class AttendanceEndpoint {
  static final String _baseEndpoint = "api/attendances";

  static String get base => _baseEndpoint;

  ///Methdd DELETE
  static String delete({required int attendanceId}) =>
      "$_baseEndpoint/$attendanceId";

  static String userAttendance({required int employeeId}) =>
      "$_baseEndpoint/$employeeId";

  /// METHOD PUT
  static String update({required int attendanceId}) =>
      delete(attendanceId: attendanceId);
}

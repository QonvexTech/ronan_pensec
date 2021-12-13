class RTTEndpoint {
  static final String _baseEndpoint = "api/rtts";

  static String update() => "$_baseEndpoint/update";

  static String getEmployeeRTT({required employeeId}) =>
      "$_baseEndpoint/user_requests/$employeeId";

  static String get getAll => "$_baseEndpoint";

  static String viewRttInfo({required rttId}) => "$_baseEndpoint/$rttId";
  static String adminCreate = "$_baseEndpoint/admin_create_rtt";
  static String approveRTT({required rttId}) =>
      "$_baseEndpoint/approve_request/$rttId";
  static String decline = "$_baseEndpoint/decline_request";
  static String get base => _baseEndpoint;

  static String pending = "$_baseEndpoint/all_pending";
}

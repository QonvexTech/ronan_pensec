class RTTEndpoint {
  static final String _baseEndpoint = "api/rtts";

  static String getEmployeeRTT({required employeeId}) => "$_baseEndpoint/user_requests/$employeeId";

  static String get getAll => "$_baseEndpoint";

  static String viewRttInfo({required rttId}) => "$_baseEndpoint/$rttId";

  static String approveRTT({required rttId}) => "$_baseEndpoint/$rttId";

  static String get base => _baseEndpoint;
}
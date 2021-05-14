class LeaveRequestEndpoint{
  static final String _baseEndpoint = "api/leave_requests";
  static final String getAll = "$_baseEndpoint";
  static String delete({required int requestId}) => "$_baseEndpoint/$requestId";
}
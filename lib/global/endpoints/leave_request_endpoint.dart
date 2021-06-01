class LeaveRequestEndpoint{
  static final String _baseEndpoint = "api/demands";
  static final String getAll = "$_baseEndpoint";
  static String delete({required int requestId}) => "$_baseEndpoint/$requestId";
}
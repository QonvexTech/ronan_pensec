class HolidayDemandEndpoint{
  static final String _baseEndpoint = "api/demands";
  static String get base => _baseEndpoint;
  static String byUser({required int userId}) => "$base/$userId";
}
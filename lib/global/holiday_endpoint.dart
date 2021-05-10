class HolidayEndpoint {
  static final String _baseEndpoint = "api/holidays";
  static final String getAll = "$_baseEndpoint";
  static String approveRequest({required int holidayId}) => "$_baseEndpoint/approve_request/$holidayId";
  static final String create = "$_baseEndpoint/request_holiday";
  static String deleteHoliday({required int holidayId}) => "$_baseEndpoint/decline_holiday";
}
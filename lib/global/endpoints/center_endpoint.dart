class CenterEndpoint {
  static final String _baseEndpoint = "api/centers";

  /// Method : GET
  static final String viewAll = "$_baseEndpoint";

  static String get base => _baseEndpoint;

  /// Method : GET
  static String showCenterInfo({required int centerId}) =>
      "$_baseEndpoint/$centerId";

  /// Method : DELETE
  static String deleteCenter({required int centerId}) =>
      "$_baseEndpoint/$centerId";

  static String getMyCenters({required int userId}) =>
      "$_baseEndpoint/assigned_centers/$userId";

  /// Method : POST
  static String get assignUsersToCenter => "$_baseEndpoint/add_users";
  static String removeAssignedUser(int centerId) =>
      "$_baseEndpoint/delete_users/$centerId";

  /// Method : POST
  static final String create = "$_baseEndpoint";

  /// Method : PUT
  static String update({required int centerId}) => "$_baseEndpoint/$centerId";

  ///Method: POST
  static final String assignManager = "$_baseEndpoint/assign_manager";

  static String updateRegion({required int centerId}) =>
      "$_baseEndpoint/update_region/$centerId";
}

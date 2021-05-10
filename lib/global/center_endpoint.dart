class CenterEndpoint {
  static final String _baseEndpoint = "api/centers";

  /// Method : GET
  static final String viewAll = "$_baseEndpoint";

  /// Method : GET
  static String showCenterInfo({required int centerId}) =>
      "$_baseEndpoint/$centerId";

  /// Method : DELETE
  static String deleteCenter({required int centerId}) =>
      "$_baseEndpoint/$centerId";

  /// Method : POST
  static final String create = "$_baseEndpoint";

  /// Method : PUT
  static String update({required int centerId}) => "$_baseEndpoint/$centerId";
}

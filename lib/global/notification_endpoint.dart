class NotificationEndpoint {
  static final String _baseEndpoint = "api/notifications";

  /// Method : GET
  static final String get = "$_baseEndpoint";

  /// Method : GET
  static String showNotificationInfo({required int id}) => "$_baseEndpoint/$id";

  /// Method : DELETE
  static String deleteNotification({required int id}) => "$_baseEndpoint/$id";

  /// Method : POST
  static final String create = "$_baseEndpoint";

  /// Method : GET
  static String markAsRead({required int id}) => "$_baseEndpoint/mark_read/$id";

  /// Method : GET
  static String markAsUnread({required int id}) => "$_baseEndpoint/mark_unread/$id";
}

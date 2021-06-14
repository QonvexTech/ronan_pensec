class NotificationEndpoint{
  static final String base = "api/notifications";
  static String delete(int id) => "$base/$id";
  static  String markAsRead(int id) => "/mark_read/$id";
  static String markAsUnread(int id) => "/mark_unread/$id";
  static String get markAllAsRead => "/mark_all_as_read";
}
import 'package:ronan_pensec/global/auth.dart';

class UserEndpoint {
  static final String _baseSubDomain = "api/users";
  /// instance of auth
  static final Auth _auth = Auth.instance;
  /// Method : PUT
  static String update(int userId) => "$_baseSubDomain/$userId";

  /// Method : GET
  static final String viewAllUsers = "$_baseSubDomain";
  static String get base => _baseSubDomain;
  ///Method : GET
  static String paginated(String sub) => "$_baseSubDomain/$sub";

  /// Method : GET
  static final String getMessages = "api/user_messages";

  /// Method : GET
  static String showUserInfo({required int userId}) =>
      "$_baseSubDomain/$userId";

  /// Method : DELETE
  static String deleteUser({required int userId}) => "$_baseSubDomain/$userId";
}

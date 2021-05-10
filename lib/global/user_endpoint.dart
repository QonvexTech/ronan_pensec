import 'package:ronan_pensec/global/auth.dart';

class UserEndpoint {
  static final String _baseSubDomain = "api/users";
  static final String update = "$_baseSubDomain/${loggedUser!.id}";

  /// Method : PUT
  static final String viewAllUsers = "$_baseSubDomain";

  /// Method : GET
  static final String getMessages = "api/user_messages";

  /// Method : GET
  static String showUserInfo({required int userId}) =>
      "$_baseSubDomain/$userId";

  /// Method : GET
  static String deleteUser({required int userId}) => "$_baseSubDomain/$userId";

  /// Method : DELETE
}

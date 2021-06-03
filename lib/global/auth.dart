import 'package:ronan_pensec/models/user_model.dart';

class Auth {
  Auth._singleton();
  static final Auth _instance = Auth._singleton();
  static Auth get instance => _instance;
  String? _token;
  UserModel? _loggedUser;

  String? get token => _token;
  set setToken(String? __token) => _token = __token;

  UserModel? get loggedUser => _loggedUser;
  set setUser(UserModel user) => _loggedUser = user;
}
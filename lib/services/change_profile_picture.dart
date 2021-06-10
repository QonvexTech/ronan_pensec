import 'dart:isolate';

import 'package:ronan_pensec/global/auth.dart';

class ChangeProfilePicture {
  ChangeProfilePicture._singleton();
  static final ChangeProfilePicture _instance = ChangeProfilePicture._singleton();
  static ChangeProfilePicture get instance {
    _instance._userData = _auth.loggedUser!.updateToJson();
    return _instance;
  }
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  late Map _userData;
  Map get userData => _userData;
  set appendData(Map data) => _instance.userData.addAll(data);
}
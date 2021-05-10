import 'package:flutter/cupertino.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';

class UserViewModel {
  UserViewModel._private();
  static final UserViewModel _instance = UserViewModel._private();
  static UserViewModel get instance => _instance;
  
  ImageProvider get imageProvider {
    if(loggedUser!.image == null){
      return AssetImage("assets/images/icon.png");
    }
    return NetworkImage("${loggedUser!.image}");
  }
}
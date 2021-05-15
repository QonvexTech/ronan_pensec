import 'package:flutter/cupertino.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';

class UserDataControl {
  UserDataControl._private();
  static final UserDataControl _instance = UserDataControl._private();
  static UserDataControl get instance => _instance;
  
  ImageProvider get imageProvider {
    if(loggedUser!.image == null){
      return AssetImage("assets/images/icon.png");
    }
    return NetworkImage("${loggedUser!.image}");
  }
  ImageProvider imageViewer({required String? imageUrl}) {
    if(imageUrl == null){
      return AssetImage("assets/images/icon.png");
    }
    return NetworkImage("$imageUrl");
  }
}
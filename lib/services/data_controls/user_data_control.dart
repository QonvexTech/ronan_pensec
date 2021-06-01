import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';

class UserDataControl {
  UserDataControl._private();
  static final UserDataControl _instance = UserDataControl._private();
  static UserDataControl get instance => _instance;
  static final Auth _auth = Auth.instance;
  ImageProvider get imageProvider {
    if(_auth.loggedUser!.image == null){
      return AssetImage("assets/images/icon.png");
    }
    return NetworkImage("${_auth.loggedUser!.image}");
  }
  ImageProvider imageViewer({required String? imageUrl}) {
    if(imageUrl == null){
      return AssetImage("assets/images/icon.png");
    }
    return NetworkImage("$imageUrl");
  }
}
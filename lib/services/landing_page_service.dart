import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/route/credential_route.dart';
import 'package:ronan_pensec/route/landing_page_route.dart';
import 'package:ronan_pensec/services/credentials_preferences.dart';
import 'package:ronan_pensec/services/firebase_messaging_service.dart';

class LandingPageService {
  LandingPageService._privateConstructor();
  static final LandingPageService _instance = LandingPageService._privateConstructor();
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  static LandingPageService instance(BuildContext context) {
    if(_instance._credentialsPreferences == null ){
      _instance._credentialsPreferences = CredentialsPreferences.instance;
    }
    return _instance;
  }

  CredentialsPreferences? _credentialsPreferences;

  Future<void> profileIconOnChoose(context,int value) async {
    if(value == 0){
      Navigator.push(context, landingPageRoute.profilePage);
    }else if(value == 1){
      print("GO TO SETTINGS");
    }else{
      Navigator.pushReplacement(context, CredentialRoute.login);
      await _credentialsPreferences!.removeCredentials;
      _instance.auth.setToken = null;
      await firebaseMessagingService.removeToken;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/services/credentials_preferences.dart';
import 'package:ronan_pensec/services/firebase_messaging_service.dart';
import 'package:ronan_pensec/views/login_view/login_view.dart';

class LandingPageService {
  LandingPageService._privateConstructor();
  static final LandingPageService _instance = LandingPageService._privateConstructor();
  static LandingPageService get instance => _instance;
  final CredentialsPreferences _credentialsPreferences = CredentialsPreferences.instance;

  Future<void> profileIconOnChoose(context,int value) async {
    if(value == 0){
      print("GO TO PROFILE");
    }else if(value == 1){
      print("GO TO SETTINGS");
    }else{
      Navigator.pushReplacement(context, PageTransition(child: LoginView(), type: PageTransitionType.leftToRightWithFade));
      await _credentialsPreferences.removeCredentials;
      await firebaseMessagingService.removeToken;
    }
  }
}
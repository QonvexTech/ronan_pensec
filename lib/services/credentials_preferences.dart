import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/services/login_service.dart';
import 'package:ronan_pensec/views/login_view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsPreferences {
  CredentialsPreferences._privateConstructor();

  static final CredentialsPreferences _instance =
      CredentialsPreferences._privateConstructor();
  static CredentialsPreferences get instance => _instance;
  late final SharedPreferences _preferences;
  /// save username/email and password
  void saveCredentials(
      {required String email, required String password}) async {
    _preferences.setString("email", email);
    _preferences.setString("password", password);
  }

  /// remove saved credential details
  Future<void> get removeCredentials async {
    _preferences.remove("email");
    _preferences.remove("password");
  }

  /// check if you had a saved credential
  Future<void>  getCredentials(context) async {
    _preferences = await SharedPreferences.getInstance();
    String? password = _preferences.getString('password');
    String? email = _preferences.getString('email');
    if (password != null && email != null) {
      await loginService.login(context, email: email, password: password, isRemembered: true, showNotif: false);
    }else{
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacement(context, PageTransition(child: LoginView(), type: PageTransitionType.fade));
    }
    return null;
  }

}

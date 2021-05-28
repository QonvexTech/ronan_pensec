import 'package:flutter/material.dart';
import 'package:ronan_pensec_web/route/credential_route.dart';
import 'package:ronan_pensec_web/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsPreferences {
  CredentialsPreferences._privateConstructor();
  final LoginService _service = LoginService.instance;
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
    try{
      _preferences = await SharedPreferences.getInstance();
      String? password = _preferences.getString('password');
      String? email = _preferences.getString('email');
      if (password != null && email != null) {
        await _service.login(context, email: email, password: password, isRemembered: true, showNotif: false);
      }else{
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(context, CredentialRoute.login);
      }
      return null;
    }catch(e){
      print("ERROR : $e");
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacement(context, CredentialRoute.login);
      return null;
    }
  }
}

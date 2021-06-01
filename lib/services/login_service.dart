import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/auth_endpoint.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/route/credential_route.dart';
import 'package:ronan_pensec/services/dashboard_services/region_service.dart';
import 'package:ronan_pensec/services/http_request.dart';
import 'dart:convert';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/views/landing_page.dart';
import 'credentials_preferences.dart';

class LoginService {
  LoginService._singleton();
  final ToastNotifier _notifier = ToastNotifier.instance;

  ToastNotifier? get notifier => _notifier;
  static final LoginService _instance = LoginService._singleton();
  static LoginService get instance => _instance;
  final HttpRequest _rqst = HttpRequest.instance;
  static final Auth _auth = Auth.instance;
  late final CredentialsPreferences _credentialsPreferences = CredentialsPreferences.instance;
  Future<bool> login(context,
      {required String email,
      required String password,
      required bool isRemembered,
      bool showNotif = true}) async {
    try {
      return await http.post(Uri.parse("${BaseEnpoint.URL}${AuthEndpoint.login}"),
          headers: _rqst.defaultHeader,
          body: {"email": email, "password": password}).then((respo) async {
        var data = json.decode(respo.body);
        if (respo.statusCode == 200 || respo.statusCode == 201) {
          if(showNotif){
            _notifier.showContextedBottomToast(context,msg: "Login Successful");
          }

          _auth.setToken = data['access_token'];
          // _auth.setToken = data['access_token'].toString().replaceAll("\n", ""); /// LIVE
          _auth.setUser = UserModel.fromJson(parsedJson: data['user']);
          if (isRemembered) {
            _credentialsPreferences.saveCredentials(
                email: email, password: password);
          }

          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: LandingPageScreen(),
                  type: PageTransitionType.fade));
          return true;
        }
        if(showNotif){
          if (data['errors'] != null) {
            _notifier.showContextedBottomToast(context,
                msg:
                "Showing ${data['errors'].length} error(s), ${data['errors']}");
            return false;
          }
          if (data['message'] != null) {
            _notifier.showContextedBottomToast(context,
                msg: "${data['message']}");
            return false;
          }
          _notifier.showContextedBottomToast(context,
              msg: "Error ${respo.statusCode}, ${respo.reasonPhrase}");
        }else{
          Navigator.pushReplacement(context, CredentialRoute.login);
          _credentialsPreferences.removeCredentials;
        }
        return false;
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context,
          msg: "An error has occurred, please contact the administrator.");
      if(!showNotif){
        Navigator.pushReplacement(context, CredentialRoute.login);
        _credentialsPreferences.removeCredentials;
      }
      return false;
    }
  }
}
// LoginService loginService = LoginService.instance;

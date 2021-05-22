import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/credentials_preferences.dart';
import 'package:ronan_pensec/services/http_request.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/views/landing_page_screen/landing_page_screen.dart';

class RegisterService {
  RegisterService._singleton();

  final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;

  static final RegisterService _instance = RegisterService._singleton();
  final HttpRequest _rqst = HttpRequest.instance;
  late final CredentialsPreferences _credentialsPreferences = CredentialsPreferences.instance;
  static RegisterService get instance => _instance;
  static final Auth _auth = Auth.instance;
  Future<bool> register(Map body, context) async {
    try {
      return await http
          .post(Uri.parse("${BaseEnpoint.URL}${AuthEndpoint.register}"), headers: _rqst.defaultHeader,body: body)
          .then((respo) {
        var data = json.decode(respo.body);
        print(data);
        if (respo.statusCode == 200 || respo.statusCode == 201) {
          _notifier.showContextedBottomToast(context,
              msg: "Registration Successful");
          _auth.setToken = data['access_token'];
          _auth.setUser = UserModel.fromJson(parsedJson: data['user']);
          _credentialsPreferences.saveCredentials(email: body['email'], password: body['password']);
          Navigator.pushReplacement(context, PageTransition(child: LandingPageScreen(), type: PageTransitionType.topToBottom));
          return true;
        }
        if(data['errors'] != null){
          _notifier.showContextedBottomToast(context,msg: "Showing ${data['errors'].length} error(s), ${data['errors']}");
          return false;
        }
        _notifier.showContextedBottomToast(context, msg: "Error ${respo.statusCode}, ${respo.reasonPhrase}");
        return false;
      });
    } catch (e) {
      print("ERROR REGISTER : $e");
      _notifier.showContextedBottomToast(context,
          msg: "An error has occurred, please contact the administrator.");
      return false;
    }
  }
}

import 'dart:convert';

import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/auth_endpoint.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  ForgotPasswordService._pri();
  static final ForgotPasswordService _instance = ForgotPasswordService._pri();
  static ForgotPasswordService get instance => _instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;

  Future<bool> sendCode({required String email}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${AuthEndpoint.forgotPassword}"),body: {
        "email" : email
      }).then((response) {
        var data = json.decode(response.body);
        _notifier.showUnContextedBottomToast(msg: data['message']);
        return response.statusCode == 200;
      });
    }catch(e){
      print("Errreur : $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
      return false;
    }
  }

  Future<bool> resetPassword({required String newPassword, required token}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${AuthEndpoint.resetPassword}"),body: {
        "password" : newPassword,
        "token" : token
      },headers: {
        "accept" : "application/json"
      }).then((response) {
        var data = json.decode(response.body);
        print("DATA RESET : $data, ${response.statusCode}");
        _notifier.showUnContextedBottomToast(msg: data['message']);
        return response.statusCode == 200;
      });
    }catch(e){
      print("Errreur : $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
      return false;
    }
  }
}
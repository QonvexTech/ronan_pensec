import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/user_endpoint.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class ChangeEmailService{
  ChangeEmailService._singleton();
  static final ChangeEmailService _instance = ChangeEmailService._singleton();
  static ChangeEmailService get instance => _instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  static final Auth _auth = Auth.instance;

  Future<bool> initiate({required String newEmail}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}/change_email"),headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      },body: {
        "email" : newEmail
      }).then((res) {
        var data = json.decode(res.body);
        if(res.statusCode == 200){
          _notifier.showUnContextedBottomToast(msg: "Mise a jour reussie");
          return true;
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return false;
      });
    }catch(e){
      print(e);
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
      return false;
    }
  }

  Future<String?> confirmCode({required String verificationCode}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}/update_new_email"),headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      },body: {
        "token" : verificationCode
      }).then((res) {
        var data =json.decode(res.body);

        if(res.statusCode == 200){
          _notifier.showUnContextedBottomToast(msg: "Mise a jour reussie");
          return data['data'];
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return null;
      });
    }catch(e){
      print("CONFIRMATION CODE ERROR : $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
      return null;
    }
  }
}
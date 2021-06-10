import 'dart:convert';
import 'dart:io';

import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/user_endpoint.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:http/http.dart' as http;
class ChangePasswordService{
  ChangePasswordService._privateConstructor();
  static final ChangePasswordService _instance = ChangePasswordService._privateConstructor();
  static ChangePasswordService get instance => _instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  static final Auth _auth = Auth.instance;
  Future<bool> loggedUser({required String newPassword}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}/change_password"),headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      },body: {
        "password" : newPassword
      }).then((respo) {
        if(respo.statusCode == 200){
          _notifier.showUnContextedBottomToast(msg: "Misé a jour reussie");
          return true;
        }
        _notifier.showUnContextedBottomToast(msg: "Erreur ${respo.statusCode}, ${respo.reasonPhrase}");
        return false;
      });
    }catch(e){
      print(e);
      _notifier.showUnContextedBottomToast(msg: "Erreru $e");
      return false;
    }
  }

  Future<bool> superAdmin({required String newPassword}) async {
    try{
      return await http.put(Uri.parse("${BaseEnpoint.URL}api/superadmin/update_password"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }, body: {
        "new_password" : newPassword
      }).then((res) {
        var data = json.decode(res.body);
        if(res.statusCode == 200){
          _notifier.showUnContextedBottomToast(msg: "Misé a jour reussie");
          return true;
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return false;
      });
    }catch(e){
      print("ERREUR $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
      return false;
    }
  }
}
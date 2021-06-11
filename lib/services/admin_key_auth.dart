import 'dart:convert';
import 'dart:io';

import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:http/http.dart' as http;

class AdminKeyAuth {
  AdminKeyAuth._private();
  static final AdminKeyAuth _instance = AdminKeyAuth._private();
  static AdminKeyAuth get instance => _instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final Auth _auth = Auth.instance;

  Future<bool> check({required String key}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}api/superadmin"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      },body: {
        "password" : key
      }).then((res) {
        var data = json.decode(res.body);
        print(data);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        if(res.statusCode == 200){
          return true;
        }
        return false;
      });
    }catch(e){
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
      return false;
    }
  }
}
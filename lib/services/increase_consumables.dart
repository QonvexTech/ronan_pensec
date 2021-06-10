import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/user_endpoint.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class IncreaseConsumables{
  IncreaseConsumables._private();
  static final IncreaseConsumables _instance = IncreaseConsumables._private();
  static IncreaseConsumables get instance => _instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  static final Auth _auth = Auth.instance;

  Future<void> all({required Map body}) async{
    try{
      await http.post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}/increase_users_holidays"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }, body: body).then((res) {
        var data = json.decode(res.body);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
      });
    }catch(e){
      print("ERROR $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
    }
  }
  Future<void> singleEmployee({required int userId, required double toAdd}) async {
    try{
      await http.post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}/update_user_consumable"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }, body: {
        "user_id" : userId.toString(),
        "to_add" : toAdd.toString()
      }).then((res) {
        var data = json.decode(res.body);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
      });
    }catch(e){
      print("ERROR $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
    }
  }
}
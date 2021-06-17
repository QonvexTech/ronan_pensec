import 'dart:convert';
import 'dart:io';

import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:http/http.dart' as http;

class AnnouncementService {
  AnnouncementService._private();
  static final AnnouncementService _instance = AnnouncementService._private();
  static AnnouncementService get instance => _instance;
  static final Auth _auth = Auth.instance;

  static final ToastNotifier _notifier = ToastNotifier.instance;

  Future<bool> send({required Map body}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}api/notice"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      },body: body).then((res) {
        var data = json.decode(res.body);
        print("DATA : $data");
        if(res.statusCode == 200){
          _notifier.showUnContextedBottomToast(msg: "Annonce publiée!");
          return true;
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return false;
      });
    }catch(e){
      print("Erreur sending $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur sending $e");
      return false;
    }
  }
}
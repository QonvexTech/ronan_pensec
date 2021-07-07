import 'dart:convert';
import 'dart:io';

import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/notification_endpoint.dart';
import 'package:ronan_pensec/services/data_controls/notification_active_badge_control.dart';
import 'package:ronan_pensec/services/data_controls/notification_data_control.dart';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/services/toast_notifier.dart';
class NotificationService {
  NotificationService._private();
  static final NotificationService _instance = NotificationService._private();
  static NotificationService get instance => _instance;
  static final NotificationDataControl _dataControl = NotificationDataControl.instance;
  static Uri _base({String? subDomain}) => subDomain == null ? Uri.parse("${BaseEnpoint.URL}${NotificationEndpoint.base}") : Uri.parse("${BaseEnpoint.URL}${NotificationEndpoint.base}$subDomain");
  static final Auth _auth = Auth.instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  static final NotificationActiveBadgeControl _activeBadgeControl = NotificationActiveBadgeControl.instance;
  Future<void> get all async {
    try{
      await http.get(_base(),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((res) {
        var data = json.decode(res.body);
        if(res.statusCode == 200){
          _dataControl.populateAll(data);
        }
      });
    }catch(e){
      print("ERROR FETCH ALL $e");
    }
  }
  Future<void> markAsRead(int id) async {
    try{
      await http.get(_base(subDomain: "${NotificationEndpoint.markAsRead(id)}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((res) {
        var data = json.decode(res.body);
        if(res.statusCode == 200){
          _notifier.showUnContextedBottomToast(msg: "${data['message']}");
          _dataControl.markAsRead(id);
        }
      });
    }catch(e){
      print("ERROR Mark as Read $e");
    }
  }
  Future<void> markAsUnread(int id) async {
    try{
      await http.get(_base(subDomain: "${NotificationEndpoint.markAsRead(id)}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((res) {
        if(res.statusCode == 200){
          _dataControl.markAsUnread(id);
        }
      });
    }catch(e){
      print("ERROR Mark as Unread $e");
    }
  }

  Future<void> get markAllAsRead async {
    try{
      await http.put(_base(subDomain: "${NotificationEndpoint.markAllAsRead}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((res) {
        var data = json.decode(res.body);
        print("MARK ALL AS READ $data");
        if(res.statusCode == 200){
          _notifier.showUnContextedBottomToast(msg: "${data['message']}");
          _dataControl.markAllAsRead();

        }
      });
    }catch(e){
      print("ERROR Mark All as Read $e");
    }
  }
  Future<void> delete(int id) async {
    try{
      await http.delete(_base(subDomain: "/$id"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((res) {
        if(res.statusCode == 200){
          _dataControl.delete(id);
        }
      });
    }catch(e){
      print("ERROR Notification Delete $e");
    }
  }
}
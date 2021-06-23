import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/services/data_controls/legal_holiday_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class LegalHolidayService{
  LegalHolidayService._private();
  static final LegalHolidayService _instance = LegalHolidayService._private();
  static final LegalHolidayDataControl _dataControl = LegalHolidayDataControl.instance;
  static LegalHolidayService get instance => _instance;
  static final Auth _auth = Auth.instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  static final String _url = 'api/national_holidays';

  Future<void> get fetch async {
    try{
      await http.get(Uri.parse("${BaseEnpoint.URL}$_url"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          _dataControl.populate(data);
          return;
        }
        _notifier.showUnContextedBottomToast(msg: "Erreur ${response.statusCode}, ${data['message']}");
        return;
      });
    }catch(e){
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
      return;
    }
  }

  Future<void> add({required Map body}) async {
    try{
      await http.post(Uri.parse("${BaseEnpoint.URL}$_url"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      },body: body).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          _dataControl.append(data);
          _notifier.showUnContextedBottomToast(msg: "Ajouter reussie");
          return;
        }
        _notifier.showUnContextedBottomToast(msg: "Erreur ${response.statusCode}, ${data['message']}");
        return;
      });
    }catch(e){
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
      return ;
    }
  }
}
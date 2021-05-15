import 'dart:convert';
import 'dart:io';

import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/region_endpoint.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:http/http.dart' as http;

class RegionService {
  late RegionDataControl _regionDataControl;
  RegionService._internal();

  static final RegionService _instance = RegionService._internal();

  static RegionService instance(RegionDataControl control) {
    _instance._regionDataControl = control;
    return _instance;
  }
  final ToastNotifier _notifier = ToastNotifier.instance;

  Future<bool> fetch(context) async {
    try {
      return await http.get(Uri.parse("$baseUrl${RegionEndpoint.base}"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        List data = json.decode(response.body);
        if (response.statusCode == 200) {
          _regionDataControl.populateAll(data);
          return true;
        }else {
          _notifier.showContextedBottomToast(context,
              msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
          return false;
        }
      });
    } catch (e) {
      print("Erreur : $e");
      _notifier.showContextedBottomToast(context,msg:"Erreur $e");
      return false;
    }
  }

  Future create(context,Map body) async {
    try {
      await http.post(Uri.parse("$baseUrl${RegionEndpoint.base}"),headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },body: body).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200 || response.statusCode == 201){
          _regionDataControl.append(data);
        }else{
          _notifier.showContextedBottomToast(context, msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        }
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context,msg:"Erreur $e");
    }
  }
}

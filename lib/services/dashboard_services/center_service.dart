import 'dart:io';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/center_endpoint.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CenterService {
  late CenterDataControl _centerDataControl;
  CenterService._singleton();

  static final CenterService _instance = CenterService._singleton();
  final ToastNotifier _notifier = ToastNotifier.instance;

  static CenterService instance(CenterDataControl control){
    _instance._centerDataControl = control;
    return _instance;
  }

  Future<bool> fetch(context) async {
    try {
      return await http.get(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.viewAll}"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _centerDataControl.populateAll(data);
          return true;
        } else {
          _notifier.showContextedBottomToast(context,
              msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
          return false;
        }
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      return false;
    }
  }
  Future delete(context, {required int centerId}) async {
    try{
      await http.delete(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.deleteCenter(centerId: centerId)}"),headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        if(response.statusCode == 200){
          _centerDataControl.remove(centerId);
        }
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
    }
  }
  Future create(context, Map body) async {
    try{
      await http.post(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.create}"),headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }, body: body).then((response) {
        var data = json.decode(response.body);
        print("Created Center $data");
        _centerDataControl.append(data);
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
    }
  }
}
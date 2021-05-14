import 'dart:io';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/center_endpoint.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/view_model/center_view_model.dart';

class CenterService {
  CenterService._singleton();

  static final CenterService _instance = CenterService._singleton();
  final ToastNotifier _notifier = ToastNotifier.instance;

  static CenterService get instance => _instance;

  Future<bool> fetch(context) async {
    try {
      return await http.get(Uri.parse("$baseUrl${CenterEndpoint.viewAll}"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          centerViewModel.populateAll(data);
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
  Future create(context, Map body) async {
    try{
      await http.post(Uri.parse("$baseUrl${CenterEndpoint.create}"),headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }, body: body).then((response) {
        var data = json.decode(response.body);
        print("Created Center $data");
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
    }
  }
}
CenterService centerService = CenterService.instance;
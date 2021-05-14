import 'dart:convert';
import 'dart:io';

import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/region_endpoint.dart';
import 'package:ronan_pensec/services/http_request.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:http/http.dart' as http;

class RegionService {
  RegionService._internal();

  static final RegionService _instance = RegionService._internal();

  static RegionService get instance => _instance;
  final ToastNotifier _notifier = ToastNotifier.instance;

  Future<void> fetch(context) async {
    try {
      await http.get(Uri.parse("$baseUrl${RegionEndpoint.base}"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        List data = json.decode(response.body);
        if (response.statusCode == 200) {
          regionViewModel.populateAll(data);
        }else {
          _notifier.showContextedBottomToast(context,
              msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        }
      });
    } catch (e) {
      print("Erreur : $e");
      _notifier.showContextedBottomToast(context,msg:"Erreur $e");
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
          regionViewModel.append(data);
        }else{
          _notifier.showContextedBottomToast(context, msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        }
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context,msg:"Erreur $e");
    }
  }


}

RegionService regionService = RegionService.instance;

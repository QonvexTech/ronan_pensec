import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/controllers/raw_region_controller.dart';
import 'package:ronan_pensec/global/endpoints/region_endpoint.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class RegionService {
  late RegionDataControl _regionDataControl;
  RegionService._internal();
  static final Auth _auth = Auth.instance;

  static final RegionService _instance = RegionService._internal();
  static final RawRegionController _regionController =
      RawRegionController.instance;
  RawRegionController get rawRegionController => _regionController;
  // ignore: non_constant_identifier_names
  static RegionService instance(RegionDataControl control) {
    _instance._regionDataControl = control;
    return _instance;
  }

  late final ToastNotifier _notifier = ToastNotifier.instance;

  Future<void> get fetchRaw async {
    try {
      await http.get(Uri.parse("${BaseEnpoint.URL}${RegionEndpoint.base}/raw"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          rawRegionController.regionData.populateRegions = data;
          return;
        }
        print("ERROR ${response.statusCode}");
        return;
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<bool> fetch(context) async {
    try {
      String url = "${BaseEnpoint.URL}${RegionEndpoint.base}";
      return await http.get(Uri.parse("$url"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (data is List) {
            _regionDataControl.populateAll(data);
          } else {
            _regionDataControl.populateAll(data['']);
          }
          return true;
        } else {
          _notifier.showContextedBottomToast(context,
              msg:
                  "REGION Erreur ${response.statusCode}, ${response.reasonPhrase}");
          return false;
        }
      });
    } catch (e) {
      print("ERRErreur : $e");
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      return false;
    }
  }

  Future create(context, Map body) async {
    try {
      await http
          .post(Uri.parse("${BaseEnpoint.URL}${RegionEndpoint.base}"),
              headers: {
                "Accept": "application/json",
                HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
              },
              body: body)
          .then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          _regionDataControl.append(data);
        } else {
          _notifier.showContextedBottomToast(context,
              msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        }
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
    }
  }
}

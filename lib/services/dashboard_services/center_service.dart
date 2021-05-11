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

  Future<void> fetch(context) async {
    try {
      await http.get(Uri.parse("$baseUrl${CenterEndpoint.viewAll}"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        List data = json.decode(response.body);
        print("CENTER DATA : $data");
        if (response.statusCode == 200) {
          centerViewModel.populateAll(data);
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

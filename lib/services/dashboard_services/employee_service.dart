import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/user_endpoint.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:http/http.dart' as http;
class EmployeeService {
  late EmployeeDataControl _model;
  EmployeeService._privateConstructor();
  static final EmployeeService _instance = EmployeeService._privateConstructor();
  final ToastNotifier _notifier= ToastNotifier.instance;
  static final Auth _auth = Auth.instance;
  static EmployeeService instance(EmployeeDataControl model){
    _instance._model = model;
    return _instance;
  }

  Future fetchAll(context, {required String subDomain}) async {
    try{
      print("FETCHING $subDomain");
      return await http.get(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.paginated(subDomain)}"), headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((res) {
        var data = json.decode(res.body);

        if(res.statusCode == 200){
          _model.populateAll(data['data']);
          return data;
        }
        return null;
      });
    }catch(e){
      _notifier.showContextedBottomToast(context,msg: "Erreur : $e");
      return null;
    }
  }

  Future<List<UserModel>> getData(context, {required String subDomain}) async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.paginated(subDomain)}"), headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        List<UserModel> _lst = [];
        if(response.statusCode == 200 && data['data'] != null){
          for(var item in data['data']){
            _lst.add(UserModel.fromJson(parsedJson: item));
          }
        }
        return _lst;
      });
    }catch(e){
      print(e);
      _notifier.showContextedBottomToast(context,msg: "Erreur : $e");
      return [];
    }
  }
}
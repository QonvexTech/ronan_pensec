import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/user_endpoint.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';
import 'package:http/http.dart' as http;
class EmployeeService {
  late EmployeeViewModel _model;
  EmployeeService._privateConstructor();
  static final EmployeeService _instance = EmployeeService._privateConstructor();
  final ToastNotifier _notifier = ToastNotifier.instance;
  static EmployeeService instance(EmployeeViewModel model){
    _instance._model = model;
    return _instance;
  }

  Future<bool> fetchAll(context) async {
    try{
      return await http.get(Uri.parse("$baseUrl${UserEndpoint.viewAllUsers}"), headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer $authToken"
      }).then((res) {
        var data = json.decode(res.body);
        if(res.statusCode == 200 && data is List){
          _model.populateAll(data);
          return true;
        }
        return false;
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }
}
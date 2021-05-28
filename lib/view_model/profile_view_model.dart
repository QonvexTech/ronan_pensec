import 'package:flutter/material.dart';
import 'package:ronan_pensec_web/global/auth.dart';
import 'package:ronan_pensec_web/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec_web/services/data_controls/employee_data_control.dart';

class ProfileViewModel {
  final Auth _auth = Auth.instance;

  Auth get auth => _auth;

  ProfileViewModel._singleton();

  static final ProfileViewModel _instance = ProfileViewModel._singleton();
  static final EmployeeDataControl _control = EmployeeDataControl.instance;
  static final EmployeeService _service = EmployeeService.instance(_control);
  EmployeeService get service => _service;
  static ProfileViewModel get instance {
    _instance.firstName.text = _instance.auth.loggedUser!.first_name;
    _instance.lastName.text = _instance.auth.loggedUser!.last_name;
    _instance.address.text = _instance.auth.loggedUser!.address;
    _instance.zipCode.text = _instance.auth.loggedUser!.zip_code;
    _instance.city.text = _instance.auth.loggedUser!.city;
    _instance.mobile.text = _instance.auth.loggedUser!.mobile;

    _instance.firstName.addListener(() {
      if(_instance.firstName.text.isNotEmpty){
        _instance.appendToBody = {"first_name" : _instance.firstName.text};
      }else{
        _instance.appendToBody = {"first_name" : _instance.auth.loggedUser!.first_name};
      }
    });
    _instance.lastName.addListener(() {
      if(_instance.lastName.text.isNotEmpty){
        _instance.appendToBody = {"last_name" : _instance.lastName.text};
      }else{
        _instance.appendToBody = {"last_name" : _instance.auth.loggedUser!.last_name};
      }
    });

    _instance.address.addListener(() {
      if(_instance.address.text.isNotEmpty){
        _instance.appendToBody = {"address" : _instance.address.text};
      }else{
        _instance.appendToBody = {"address" : _instance.auth.loggedUser!.address};
      }
    });

    _instance.zipCode.addListener(() {
      if(_instance.zipCode.text.isNotEmpty){
        _instance.appendToBody = {"zip_code" : _instance.zipCode.text};
      }else{
        _instance.appendToBody = {"zip_code" : _instance.auth.loggedUser!.zip_code};
      }
    });

    _instance.city.addListener(() {
      if(_instance.city.text.isNotEmpty){
        _instance.appendToBody = {"city" : _instance.city.text};
      }else{
        _instance.appendToBody = {"city" : _instance.auth.loggedUser!.city};
      }
    });
    _instance.mobile.addListener(() {
      if(_instance.mobile.text.isNotEmpty){
        _instance.appendToBody = {"mobile" : _instance.mobile.text};
      }else{
        _instance.appendToBody = {"mobile" : _instance.auth.loggedUser!.mobile};
      }
    });

    return _instance;
  }

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController address = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();
  final TextEditingController zipCode = new TextEditingController();
  final TextEditingController city = new TextEditingController();

  Map _body = {};
  Map get body => _body;
  set appendToBody(Map toAppend) => _body.addAll(toAppend);
  set fullChangeBody(Map map) => _body = map;

  Future<bool> update(context) async {
    return await _instance.service.update(context, body: _instance.body, userId: _instance.auth.loggedUser!.id);
  }
}

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';

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
  late final List extras = [
    {
      "name": "Jours de travail",
      "value": "${_instance.auth.loggedUser!.workDays ?? 0}"
    },
    {
      "name": "Consumable congés",
      "value": "${_instance.auth.loggedUser!.consumableHolidays ?? 0}"
    },
    {
      "name": "Solde RTT",
      "value": "${_instance.auth.loggedUser!.rttRemainingBalance ?? 0}"
    },
  ];
  late final List userDetails = [
    {
      "label" : "Nom et prénom",
      "value" : "${_instance.auth.loggedUser!.full_name}",
      "icon" : Icons.person
    },
    {
      "label" : "Prénom",
      "value" : "${_instance.auth.loggedUser!.first_name}",
      "icon" : Icons.drive_file_rename_outline
    },
    {
      "label" : "Nom de famille",
      "value" : "${_instance.auth.loggedUser!.last_name}",
      "icon" : Icons.drive_file_rename_outline
    },
    {
      "label" : "Addressé",
      "value" : "${_instance.auth.loggedUser!.address}",
      "icon" : Icons.location_on_outlined
    },
    {
      "label" : "Villé",
      "value" : "${_instance.auth.loggedUser!.city}",
      "icon" : Icons.location_city_outlined
    },
    {
      "label" : "Code de postal",
      "value" : "${_instance.auth.loggedUser!.zip_code}",
      "icon" : Icons.local_post_office_outlined
    },
    {
      "label" : "Numéro de portable",
      "value" : "${_instance.auth.loggedUser!.mobile}",
      "icon" : Icons.phone_outlined
    },
  ];
}
